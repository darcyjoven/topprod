# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr222.4gl
# Descriptions...: 料件需求表
# Date & Author..: 04/03/15 By Elva
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/17 By Elva 將變數用Like方式定義
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No:TQC-5B0045 05/11/08 By Smapmin 調整報表
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/14 By xumin 報表表頭格式修改
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,   #No.FUN-680108 VARCHAR(500)
           ada01   LIKE ada_file.ada01,
           a       LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(01)
           bdate   LIKE type_file.num10,      #No.FUN-680108 INTEGER
           edate   LIKE type_file.num10,     #No.FUN-680108 INTEGER
           b       LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(01)
           more    LIKE type_file.chr1       #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE    g_yy           LIKE type_file.num5,    #No.FUN-680108 SMALLINT 
          g_mm           LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          g_wk           LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          g_xx           LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE    g_azp01  LIKE azp_file.azp01
DEFINE    g_azp02  LIKE azp_file.azp02
DEFINE    g_azp03  LIKE azp_file.azp03
DEFINE    g_azp03o LIKE azp_file.azp03
DEFINE    g_sql    string    #No:FUN-580092 HCN   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT
#--------------No:TQC-610088 mark
   #INITIALIZE tm.* TO NULL
   #LET tm.more  = 'N'
   #LET tm.ada01 = g_plant
   #LET tm.a     = '1'
   #LET tm.b     = 'N'
#--------------No:TQC-610088 end
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.ada01 = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
#--------------No:TQC-610088 modify
   LET tm.bdate = ARG_VAL(10)
   LET tm.edate = ARG_VAL(11)
   LET tm.b     = ARG_VAL(12)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No:FUN-570264 ---end---
#--------------No:TQC-610088 end
#   LET g_azp01=g_plant
#   LET g_azp03=g_dbs
#   LET g_azp03o = g_azp03
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
  SELECT azp01,azp03 INTO g_azp01,g_azp03 FROM azp_file WHERE azp01 = g_plant
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
     EXIT PROGRAM
  END IF
  LET g_azp03o = g_azp03

   IF NOT cl_null(tm.wc) THEN
      CALL r222()
   ELSE
      CALL r222_tm(0,0)
   END IF
END MAIN

FUNCTION r222_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(1000)
DEFINE l_obc021       LIKE obc_file.obc021    #No.FUN-680108 VARCHAR(8)

      LET p_row = 5 LET p_col = 13
   OPEN WINDOW r222_w AT p_row,p_col
        WITH FORM "axd/42f/axdr222"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.ada01 = g_azp01
   LET tm.a     = '1'
   LET tm.b     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   CALL r222_obc021()
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON obc01
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

#No.FUN-570243  --start-
      ON ACTION CONTROLP
            IF INFIELD(obc01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obc01
               NEXT FIELD obc01
            END IF
#No.FUN-570243 --end--

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
      CLOSE WINDOW r222_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r222_w
      EXIT PROGRAM
   END IF

   DISPLAY BY NAME tm.ada01,tm.a,tm.bdate,tm.edate,tm.b,tm.more
   INPUT tm.ada01,tm.a,tm.bdate,tm.edate,tm.b,tm.more WITHOUT DEFAULTS
       FROM ada01,FORMONLY.a,FORMONLY.bdate,FORMONLY.edate,
         FORMONLY.b,FORMONLY.more HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD ada01
         IF cl_null(tm.ada01) THEN NEXT FIELD ada01 END IF
         SELECT UNIQUE adb01 FROM adb_file WHERE adb01=tm.ada01
         IF SQLCA.sqlcode THEN
            SELECT UNIQUE adb02 FROM adb_file WHERE adb02=tm.ada01
            IF SQLCA.sqlcode THEN
               CALL cl_err('ada_file',STATUS,0)
               NEXT FIELD ada01
            END IF
         END IF

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
         CALL r222_obc021()
         DISPLAY tm.edate to edate

      AFTER FIElD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         IF tm.a MATCHES '[12]' THEN
                IF tm.bdate > 999999 OR tm.bdate < 100001 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD bdate
                END IF
                LET g_yy = tm.bdate/100
                IF tm.a = '1' THEN
                    LET g_mm = tm.bdate-g_yy*100
                    IF g_mm = 0 THEN
                       CALL cl_err('','axd-085',g_lang)
                       NEXT FIELD bdate
                    END IF
                ELSE LET g_wk = tm.bdate-g_yy*100
                     IF g_wk = 0 THEN
                        CALL cl_err('','axd-085',g_lang)
                        NEXT FIELD bdate
                     END IF
                END IF
         END IF
         IF tm.a = '3' THEN
                IF tm.bdate > 99999999 OR tm.bdate < 10000001 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD bdate
                END IF
                LET g_yy = tm.bdate/10000
                LET g_xx = tm.bdate - g_yy*10000
                LET g_mm = g_xx/100
                LET g_xx = g_xx - g_mm * 100
                IF  g_mm = 0 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD bdate
                END IF
                IF  g_xx = 0 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD bdate
                END IF
 
         END IF
         IF g_mm > 12 OR g_wk > 53 OR g_xx > 3 THEN
                 CALL cl_err('','axd-085',g_lang)
                 NEXT FIELD bdate
         END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.a MATCHES '[12]' THEN
                IF tm.edate > 999999 OR tm.edate < 100001 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD bdate
                END IF
                LET g_yy = tm.edate/100
                IF tm.a = '1' THEN
                    LET g_mm = tm.edate-g_yy*100
                    IF g_mm = 0 THEN
                       CALL cl_err('','axd-085',g_lang)
                       NEXT FIELD edate
                    END IF
                ELSE LET g_wk = tm.edate-g_yy*100
                     IF g_wk = 0 THEN
                        CALL cl_err('','axd-085',g_lang)
                        NEXT FIELD edate
                     END IF
                END IF
         END IF
         IF tm.a = '3' THEN
                IF tm.edate > 99999999 OR tm.edate < 10000001 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD edate
                END IF
                LET g_yy = tm.edate/10000
                LET g_xx = tm.edate - g_yy*10000
                LET g_mm = g_xx/100
                LET g_xx = g_xx - g_mm * 100
                IF  g_mm = 0 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD edate
                END IF
                IF  g_xx = 0 THEN
                    CALL cl_err('','axd-085',g_lang)
                    NEXT FIELD edate
                END IF
         END IF
         IF g_mm > 12 OR g_wk > 53 OR g_xx > 3 THEN
                 CALL cl_err('','axd-085',g_lang)
                 NEXT FIELD edate
         END IF
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
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

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(ada01)
#            CALL q_azp(4,20,tm.ada01) RETURNING tm.ada01
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_azp'
             LET g_qryparam.default1 = tm.ada01
             CALL cl_create_qry() RETURNING tm.ada01
             DISPLAY BY NAME tm.ada01
             NEXT FIELD ada01
         OTHERWISE
             EXIT CASE
      END CASE

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
      CLOSE WINDOW r222_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr222'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr222','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",           #No:TQC-610088 add
                         " '",tm.ada01    CLIPPED,"'",        #No:TQC-610088 add 
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr222',g_time,l_cmd)
      END IF
      CLOSE WINDOW r222_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r222()
   ERROR ""
END WHILE
   CLOSE WINDOW r222_w
END FUNCTION

FUNCTION r222()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name         #No.FUN-680108 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT                   #No.FUN-680108 VARCHAR(800)
 DEFINE l_za05    LIKE za_file.za05      #NO.MOD-4B0067
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                     ada01    LIKE ada_file.ada01,
                     azp02    LIKE azp_file.azp02,
                     l_desc   LIKE type_file.chr8,     #No.FUN-680108 VARCHAR(08)
                     obc021   LIKE obc_file.obc021,
                     obc01    LIKE obc_file.obc01,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ima25    LIKE ima_file.ima25,
                     obd03    LIKE obd_file.obd03,
                     obd04    LIKE obd_file.obd04,
                     obd08    LIKE obd_file.obd08,
                     obd10    LIKE obd_file.obd10,
                     obd11    LIKE obd_file.obd11
                 END RECORD
DEFINE sr1       RECORD
                     ada01    LIKE ada_file.ada01,
                     azp02    LIKE azp_file.azp02,
                     l_desc   LIKE type_file.chr8,     #No.FUN-680108 VARCHAR(08)
                     obc021   LIKE obc_file.obc021,
                     obc01    LIKE obc_file.obc01,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ima25    LIKE ima_file.ima25,
                     obd03    LIKE obd_file.obd03,
                     obd04    LIKE obd_file.obd04,
                     obd08    LIKE obd_file.obd08,
                     obd10    LIKE obd_file.obd10,
                     obd11    LIKE obd_file.obd11,
                     obh04    LIKE obh_file.obh04,
                     l_azp02  LIKE azp_file.azp02,
                     obh05    LIKE obh_file.obh05,
                     obh06    LIKE obh_file.obh06
                 END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05
       FROM zz_file WHERE zz01 = 'axdr222'

     SELECT azp02,azp03 INTO g_azp02,g_azp03 FROM azp_file
       WHERE azp01 = tm.ada01
     IF SQLCA.sqlcode THEN
        CALL cl_err(tm.ada01,SQLCA.sqlcode,0)
        RETURN
     END IF
 
     DATABASE g_azp03
 
     IF g_priv2='4' THEN                           #只能使用自己的資料
        LET tm.wc = tm.wc clipped," AND adduser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET tm.wc = tm.wc clipped," AND addgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET tm.wc = tm.wc clipped," AND addgrup IN ",cl_chk_tgrup_list()
     END IF

     IF tm.b = 'N' THEN
        LET l_sql = " SELECT '','','',obc021,obc01, ",
                    "        ima02,ima021,ima25,obd03,obd04,obd08, ",
                    "        obd10,obd11 ",
                    "   FROM obc_file,obd_file,",
                    "  OUTER ima_file ",
                    " WHERE obc01 = obd01 ",
                    "   AND obc02 = obd02 ",
                    "   AND obc021 = obd021 ",
                    "   AND obc01 = ima_file.ima01 ",
                    "   AND obcacti = 'Y' AND obcconf = 'Y'",
                    "   AND obc021 BETWEEN ",tm.bdate CLIPPED,
                    "   AND ",tm.edate CLIPPED,
                    "   AND obc02 =",tm.a,
                    "   AND ", tm.wc CLIPPED,
                    " ORDER BY obc021,obc01,obd03,obd04"
     ELSE
        LET l_sql = " SELECT '','','',obc021,obc01,ima02,ima021,ima25,obd03,",
                    "        obd04,obd08,obd10,obd11,obh04,obh05,obh06",
                    "   FROM obc_file,obd_file,OUTER obh_file,",
                    "  OUTER ima_file ",
                    " WHERE obc01  = obd01 AND obd01 = obh_file.obh01 ",
                    "   AND obc02  = obd02 AND obd02 = obh_file.obh02 ",
                    "   AND obc021 = obd021 AND obd021 = obh_file.obh021 ",
                    "   AND obd03 = obh_file.obh03 AND obc01 = ima_file.ima01 ",
                    "   AND obcacti = 'Y'  AND obcconf = 'Y'  ",
                    "   AND obc021 BETWEEN ",tm.bdate CLIPPED,
                    "   AND ",tm.edate CLIPPED,
                    "   AND obc02 =",tm.a,
                    "   AND ",tm.wc CLIPPED,
                    " ORDER BY obc021,obc01,obd03,obd04,obh_file.obh04"
       END IF
       PREPARE r222_prepare1 FROM l_sql
       IF SQLCA.sqlcode !=0 THEN
           CALL cl_err('prepare1:',SQLCA.sqlcode,1)
           EXIT PROGRAM
       END IF
       DECLARE r222_curs1 CURSOR FOR r222_prepare1
       CALL cl_outnam('axdr222') RETURNING l_name
#      IF tm.b = 'N' THEN LET g_len = 165 ELSE LET g_len = 184 END IF #NO.MOD-4B0067   #TQC-5B0045
      IF tm.b = 'N' THEN LET g_len = 175 ELSE LET g_len = 194 END IF #NO.MOD-4B0067   #TQC-5B0045
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
       IF tm.b = 'N' THEN
           START REPORT r222_rep1 TO l_name
           LET g_pageno = 0
           FOREACH r222_curs1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              LET sr.ada01 = tm.ada01
              LET sr.azp02 = g_azp02
              CASE tm.a
                 WHEN  '1' CALL cl_getmsg('axm-024',g_lang) RETURNING sr.l_desc
                 WHEN  '2' CALL cl_getmsg('axm-025',g_lang) RETURNING sr.l_desc
                 WHEN  '3' CALL cl_getmsg('axm-026',g_lang) RETURNING sr.l_desc
                 OTHERWISE  LET sr.l_desc = ''
              END CASE
              IF cl_null(sr.obd08) THEN LET sr.obd08 = 0 END IF
              IF cl_null(sr.obd10) THEN LET sr.obd10 = 0 END IF
              IF cl_null(sr.obd11) THEN LET sr.obd11 = 0 END IF
              OUTPUT TO REPORT r222_rep1(sr.*)
           END FOREACH
           FINISH REPORT r222_rep1
       ELSE
           START REPORT r222_rep2 TO l_name
           LET g_pageno = 0
           FOREACH r222_curs1 INTO sr1.*
              IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              LET sr1.ada01 = tm.ada01
              LET sr1.azp02 = g_azp02
              SELECT azp02 INTO sr1.l_azp02 FROM azp_file
                     WHERE azp01 = sr1.obh04
              CASE tm.a
                 WHEN  '1' CALL cl_getmsg('axm-024',g_lang) RETURNING sr1.l_desc
                 WHEN  '2' CALL cl_getmsg('axm-025',g_lang) RETURNING sr1.l_desc
                 WHEN  '3' CALL cl_getmsg('axm-026',g_lang) RETURNING sr1.l_desc
                 OTHERWISE  LET sr1.l_desc = ''
              END CASE
              IF cl_null(sr1.obh05) THEN LET sr1.obh05 = 0 END IF
              IF cl_null(sr1.obh06) THEN LET sr1.obh06 = 0 END IF
              IF cl_null(sr1.obd08) THEN LET sr1.obd08 = 0 END IF
              IF cl_null(sr1.obd10) THEN LET sr1.obd10 = 0 END IF
              IF cl_null(sr1.obd11) THEN LET sr1.obd11 = 0 END IF
              OUTPUT TO REPORT r222_rep2(sr1.*)
           END FOREACH
           FINISH REPORT r222_rep2
     END IF

     DATABASE g_azp03o

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r222_rep1(sr)
DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680108 VARCHAR(1) 
DEFINE sr           RECORD
                     ada01    LIKE ada_file.ada01,
                     azp02    LIKE azp_file.azp02,
                     l_desc   LIKE type_file.chr8,  #No.FUN-680108 VARCHAR(08)
                     obc021   LIKE obc_file.obc021,
                     obc01    LIKE obc_file.obc01,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ima25    LIKE ima_file.ima25,
                     obd03    LIKE obd_file.obd03,
                     obd04    LIKE obd_file.obd04,
                     obd08    LIKE obd_file.obd08,
                     obd10    LIKE obd_file.obd10,
                     obd11    LIKE obd_file.obd11
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.obc021,sr.obc01,sr.obd03,sr.obd04
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-6A0095
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]   #TQC-6A0095
#      PRINT ' '   #TQC-6A0095
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 37,g_x[9] CLIPPED,sr.ada01 CLIPPED,' ',sr.azp02,
#            COLUMN 75,g_x[11] CLIPPED,'(',sr.l_desc CLIPPED,')',sr.obc021 USING '<<<<<<<<',
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'  #TQC-6A0095
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]  #TQC-6A0095
      PRINT g_x[9] CLIPPED,sr.ada01 CLIPPED,' ',sr.azp02,   #TQC-6A0095
            COLUMN 38,g_x[11] CLIPPED,'(',sr.l_desc CLIPPED,')',sr.obc021 USING '<<<<<<<<'  #TQC-6A0095
      PRINT ' '  #TQC-6A0095
      PRINT g_dash[1,g_len]
      PRINT COLUMN  01,g_x[12] CLIPPED,
 #MOD-4B0067  --begin
            COLUMN  53,g_x[19] CLIPPED,
            COLUMN  84,g_x[13] CLIPPED,
            COLUMN 109,g_x[14] CLIPPED,
            COLUMN  155,g_x[15] CLIPPED
#      PRINT '-------------------- ------------------------------ ',   #TQC-5B0045
      PRINT '------------------------------ ------------------------------ ',   #TQC-5B0045
            '------------------------------ -------- ---- -------- ',
            '-------------- -------------- -------------- --------------'
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.obc021
      SKIP TO TOP OF PAGE

   BEFORE GROUP OF sr.obc01
      PRINT COLUMN 01,sr.obc01 CLIPPED,  #TQC-6A0095
#TQC-5B0045
#           COLUMN 22,sr.ima02,  #MOD-4A0238
#           COLUMN 53,sr.ima021,
#           COLUMN 84,sr.ima25;
            COLUMN 32,sr.ima02 CLIPPED,  #MOD-4A0238  #TQC-6A0095
            COLUMN 63,sr.ima021 CLIPPED,  #TQC-6A0095
            COLUMN 94,sr.ima25 CLIPPED;   #TQC-6A0095
#END TQC-5B0045
   ON EVERY ROW
#TQC-5B0045
#     PRINT COLUMN 93,sr.obd03 USING '<<<',
#           COLUMN 98,sr.obd04 USING '########',
#           COLUMN 107,sr.obd08 USING '---------&.&&&',
#           COLUMN 123,sr.obd10 USING '---------&.&&&',
#           COLUMN 137,sr.obd11 USING '---------&.&&&',
#           COLUMN 152,sr.obd08+sr.obd10+sr.obd11 USING '---------&.&&&'
#      PRINT COLUMN 103,sr.obd03 CLIPPED USING '<<<',  #TQC-6A0095
      PRINT COLUMN 103,cl_numfor(sr.obd03,3,0),  #TQC-6A0095
            COLUMN 108,sr.obd04 USING '########',
            COLUMN 117,sr.obd08 USING '---------&.&&&',
            COLUMN 132,sr.obd10 USING '---------&.&&&',
            COLUMN 147,sr.obd11 USING '---------&.&&&',
            COLUMN 162,sr.obd08+sr.obd10+sr.obd11 USING '---------&.&&&'
#END TQC-5B0045

   AFTER GROUP OF sr.obc01
      PRINT '                                                                                             ',
            '---------------------------------------------------------',
#TQC-5B0045
#            '---------------'
            '-------------------------'
#     PRINT COLUMN 91,g_x[18] CLIPPED,
#           COLUMN 107,GROUP SUM(sr.obd08) USING '---------&.&&&',
#           COLUMN 122,GROUP SUM(sr.obd10) USING '---------&.&&&',
#           COLUMN 137,GROUP SUM(sr.obd11) USING '---------&.&&&',
#           COLUMN 152,GROUP SUM(sr.obd08+sr.obd10+sr.obd11)
#                                USING '---------&.&&&'
      PRINT COLUMN 101,g_x[18] CLIPPED,
            COLUMN 117,GROUP SUM(sr.obd08) USING '---------&.&&&',
            COLUMN 132,GROUP SUM(sr.obd10) USING '---------&.&&&',
            COLUMN 147,GROUP SUM(sr.obd11) USING '---------&.&&&',
            COLUMN 162,GROUP SUM(sr.obd08+sr.obd10+sr.obd11)
                                 USING '---------&.&&&'
#END TQC-5B0045
 #MOD-4B0067  --end
      PRINT
 

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

REPORT r222_rep2(sr)
DEFINE l_last_sw    LIKE type_file.chr1              #No.FUN-680108 VARCHAR(1) 
 #MOD-4B0067  --begin
DEFINE l_tot        LIKE obd_file.obd08
DEFINE l_sum        LIKE obd_file.obd08
 #MOD-4B0067  --end
DEFINE sr           RECORD
                    ada01    LIKE ada_file.ada01,
                    azp02    LIKE azp_file.azp02,
                    l_desc   LIKE type_file.chr8,    #No.FUN-680108 VARCHAR(08)
                    obc021   LIKE obc_file.obc021,
                    obc01    LIKE obc_file.obc01,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    obd03    LIKE obd_file.obd03,
                    obd04    LIKE obd_file.obd04,
                    obd08    LIKE obd_file.obd08,
                    obd10    LIKE obd_file.obd10,
                    obd11    LIKE obd_file.obd11,
                    obh04    LIKE obh_file.obh04,
                    l_azp02  LIKE azp_file.azp02,
                    obh05    LIKE obh_file.obh05,
                    obh06    LIKE obh_file.obh06
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.obc021,sr.obc01,sr.obd03,sr.obd04
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED   #TQC-6A0095
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]   #TQC-6A0095
#      PRINT ' '   #TQC-6A0095
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[11]))/2 ,g_x[11] CLIPPED,
            '(',sr.l_desc CLIPPED,')',sr.obc021 USING '<<<<<<<<',
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'  #TQC-6A0095
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]   #TQC-6A0095
      PRINT ' '    #TQC-6A0095
      PRINT g_dash[1,g_len]
#      PRINT COLUMN  07,g_x[12] CLIPPED,   #TQC-5B0045
      PRINT COLUMN  01,g_x[12] CLIPPED,   #TQC-5B0045
 #MOD-4B0067  --begin
            COLUMN 53,g_x[19] CLIPPED,
            COLUMN 84,g_x[13] CLIPPED,
#            COLUMN  98,g_x[16] CLIPPED,   #TQC-5B0045
            COLUMN  117,g_x[16] CLIPPED,   #TQC-5B0045
#            COLUMN 142,g_x[17] CLIPPED   #TQC-5B0045
            COLUMN 152,g_x[17] CLIPPED
#      PRINT '-------------------- ------------------------------ ',   #TQC-5B0045
      PRINT '------------------------------ ------------------------------ ',   #TQC-5B0045
            '------------------------------ -------- ---- -------- ',
#            '---------- -------------------- -------------- ',   #TQC-5B0045
            '------------ -------------------- -------------- ',   #TQC-5B0045
            '-------------- --------------'
      LET l_last_sw = 'n'
      LET l_tot = 0

   BEFORE GROUP OF sr.obc021
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.obc01
      LET l_tot = 0
      LET l_sum = 0
      PRINT COLUMN 01,sr.obc01 CLIPPED,
#TQC-5B0045
#           COLUMN 22,sr.ima02,  #MOD-4A0238
#           COLUMN 53,sr.ima021,
#           COLUMN 84,sr.ima25 CLIPPED;
            COLUMN 32,sr.ima02 CLIPPED,  #MOD-4A0238  #TQC-6A0095
            COLUMN 63,sr.ima021 CLIPPED,  #TQC-6A0095
            COLUMN 94,sr.ima25 CLIPPED;   #TQC-6A0095
#END TQC-5B0045
   BEFORE GROUP OF sr.obd03
#TQC-5B0045
#      PRINT COLUMN 93,sr.obd03 USING '<<<<',
#            COLUMN 98,sr.obd04 USING '########';
#      PRINT COLUMN 103,sr.obd03 USING '<<<<',
      PRINT COLUMN 103,cl_numfor(sr.obd03,4,0),  #TQC-6A0095
            COLUMN 108,sr.obd04 USING '########';
#END TQC-5B0045
 # BEFORE GROUP OF sr.ada01
      LET l_tot = l_tot+sr.obd08+sr.obd10+sr.obd11
      LET l_sum = l_sum+sr.obd08
#TQC-5B0045
#     PRINT COLUMN 107,sr.ada01 CLIPPED,
#           COLUMN 118,sr.azp02 CLIPPED,
#           COLUMN  139,sr.obd08 USING "---------&.&&&",
#           COLUMN 169,sr.obd08+sr.obd10+sr.obd11 USING "---------&.&&&"
      PRINT COLUMN 117,sr.ada01 CLIPPED,
            COLUMN 130,sr.azp02 CLIPPED,
            COLUMN 151,sr.obd08 USING "---------&.&&&",
            COLUMN 181,sr.obd08+sr.obd10+sr.obd11 USING "---------&.&&&"
#END TQC-5B0045

   ON EVERY ROW
   IF not cl_null(sr.obh04) THEN
      LET l_sum = l_sum+sr.obh05
#TQC-5B0045
#     PRINT COLUMN 107,sr.obh04 CLIPPED,
#           COLUMN 118,sr.l_azp02 CLIPPED,
#           COLUMN 139,sr.obh05 USING "---------&.&&&",
#           COLUMN 154,sr.obh06 USING "---------&.&&&"
      PRINT COLUMN 117,sr.obh04 CLIPPED,
            COLUMN 130,sr.l_azp02 CLIPPED,
            COLUMN 151,sr.obh05 USING "---------&.&&&",
            COLUMN 181,sr.obh06 USING "---------&.&&&"
#END TQC-5B0045
   END IF
 
   AFTER GROUP OF sr.obc01
#TQC-5B0045
#      PRINT '                                                             ',
#            '                              -----------------',
#            '--------------------------------------------------------------------------'
      PRINT COLUMN 117, '-----------------------------------------------------------------',
                        '-------------'
#     PRINT COLUMN  133,g_x[18] CLIPPED,
#           COLUMN  139,l_sum USING '---------&.&&&',
#           COLUMN 154,GROUP SUM(sr.obh06) USING '---------&.&&&',
#           COLUMN 169,l_tot USING '---------&.&&&'
      PRINT COLUMN 133,g_x[18] CLIPPED,
            COLUMN 151,l_sum USING '---------&.&&&',
            COLUMN 166,GROUP SUM(sr.obh06) USING '---------&.&&&',
            COLUMN 181,l_tot USING '---------&.&&&'
#END TQC-5B0045
 #MOD-4B0067  --end
      PRINT

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

FUNCTION r222_obc021()
DEFINE l_yy  LIKE type_file.num5,     #No.FUN-680108 SMALLINT
       l_mm  LIKE type_file.num5,     #No.FUN-680108 SMALLINT
       l_xx  LIKE type_file.num5,     #No.FUN-680108 SMALLINT
       l_wk  LIKE type_file.num5      #No.FUN-680108 SMALLINT

LET l_yy = YEAR(g_today)
LET l_mm = MONTH(g_today)
LET l_xx = DAY(g_today)
LET l_wk = 1
IF l_xx < 11 THEN LET l_xx = 1
   ELSE
       IF l_xx < 21 THEN LET l_xx = 2
          ELSE LET l_xx = 3
       END IF
END IF
CASE tm.a
     WHEN  '1' LET tm.bdate = l_yy*100+l_mm
               LET tm.edate = l_yy*100+l_mm
     WHEN  '2' LET tm.bdate = l_yy*100+l_wk
               LET tm.edate = l_yy*100+l_wk
     WHEN  '3' LET tm.bdate = (l_yy*100+l_mm)*100+l_xx
               LET tm.edate = (l_yy*100+l_mm)*100+l_xx
     OTHERWISE  LET tm.bdate = ' '
                LET tm.edate = ' '
END CASE

END FUNCTION
