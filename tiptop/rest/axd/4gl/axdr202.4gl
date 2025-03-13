# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr202.4gl
# Descriptions...: 集團間調撥數量稽核表
# Date & Author..: 04/01/13 By Carrier
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY 將變數用Like方式定義,放寬ima02
# Modify.........: No:FUN-520024 05/02/24 By Day 修改報表中制表日期顯示錯誤
# Modify.........: No.FUN-550026 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No:MOD-630001 06/03/02 By Vivien 工廠修改為營運中心
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 By zhuying 欄位形態定義為LIKE 
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/14 By xumin 報表表頭格式修改
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,     #No.FUN-680108 VARCHAR(500)
           ada01   LIKE ada_file.ada01,        #MOD-4B0067
           a       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(01)
           b       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(01)
           c       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(01)
           d       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(01)
           e       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(01)
           more    LIKE type_file.chr1         #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE    g_azp01  LIKE azp_file.azp01
DEFINE    g_azp02  LIKE azp_file.azp02
DEFINE    g_azp03  LIKE azp_file.azp03
DEFINE    g_azp03o LIKE azp_file.azp03
DEFINE    g_amount LIKE ade_file.ade15
DEFINE    g_sql    STRING   #No:FUN-580091 HCN    
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680108 SMALLINT

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
   LET tm.ada01 = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
   LET tm.c     = ARG_VAL(11)
   LET tm.d     = ARG_VAL(12)
   LET tm.e     = ARG_VAL(13)
#---------------No:TQC-610088 modify
  #LET tm.more  = ARG_VAL(14)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No:FUN-570264 ---end---
#---------------No:TQC-610088 end
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   LET g_azp01=g_plant
   LET g_azp03=g_dbs
   LET g_azp03o = g_azp03
   IF NOT cl_null(tm.wc) THEN
      CALL r202()
   ELSE
      CALL r202_tm(0,0)
   END IF
END MAIN

FUNCTION r202_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680108 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

   LET p_row = 5 LET p_col = 13
   OPEN WINDOW r202_w AT p_row,p_col
        WITH FORM "axd/42f/axdr202"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.ada01 = g_azp01
   LET tm.a     = '4'
   LET tm.b     = 'N'
   LET tm.c     = 'N'
   LET tm.d     = 'N'
   LET tm.e     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON add01,add02,add03,ade03
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
            IF INFIELD(ade03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ade03
               NEXT FIELD ade03
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
      CLOSE WINDOW r202_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.ada01,tm.a,tm.b,tm.c,tm.d,tm.e,tm.more

   INPUT tm.ada01,tm.a,tm.b,tm.c,tm.d,tm.e,tm.more WITHOUT DEFAULTS
         FROM ada01,FORMONLY.a,FORMONLY.b,FORMONLY.c,
         FORMONLY.d,FORMONLY.e,FORMONLY.more HELP 1

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL r202_set_entry()
         CALL r202_set_no_entry()
         LET g_before_input_done = TRUE
         #No:FUN-580031 --start--
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
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN
            NEXT FIELD a
         END IF

      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF

      BEFORE FIELD c
         CALL r202_set_entry()

      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
         CALL r202_set_no_entry()
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF

      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
            NEXT FIELD e
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
      CLOSE WINDOW r202_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr202'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr202','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",       #No:TQC-610088 add
                         " '",tm.ada01 CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.c     CLIPPED,"'",
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.e     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr202',g_time,l_cmd)
      END IF
      CLOSE WINDOW r202_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r202()
   ERROR ""
END WHILE
   CLOSE WINDOW r202_w
END FUNCTION

FUNCTION r202()
DEFINE l_name    LIKE type_file.chr20        # External(Disk) file name     #No.FUN-680108 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT     #No.FUN-680108 VARCHAR(1000)
DEFINE l_za05    LIKE za_file.za05           #MOD-4B0067
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                     add00    LIKE add_file.add00,
                     ade01    LIKE ade_file.ade01,
                     ade02    LIKE ade_file.ade02,
                     ade06    LIKE ade_file.ade06,
                     ade03    LIKE ade_file.ade03,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ade04    LIKE ade_file.ade04,
                     ade05    LIKE ade_file.ade05,
                     ade12    LIKE ade_file.ade12,
                     ade15    LIKE ade_file.ade15,
                     sale_ret LIKE ade_file.ade15
                 END RECORD
DEFINE sr1       RECORD
                     add00    LIKE add_file.add00,
                     ade06    LIKE ade_file.ade06,
                     ade03    LIKE ade_file.ade03,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ade01    LIKE ade_file.ade01,
                     ade02    LIKE ade_file.ade02,
                     ade07    LIKE ade_file.ade07,
                     ade04    LIKE ade_file.ade04,
                     ade05    LIKE ade_file.ade05,
                     ade12    LIKE ade_file.ade12,
                     ade15    LIKE ade_file.ade15,
                     s_t_ret  LIKE ade_file.ade15,
                     amount1  LIKE ade_file.ade15,
                     amount2  LIKE ade_file.ade15,
                     ade13    LIKE ade_file.ade13,
                     adg01    LIKE adg_file.adg01,
                     adg02    LIKE adg_file.adg02,
                     adg06    LIKE adg_file.adg06,
                     adg07    LIKE adg_file.adg07,
                     adg08    LIKE adg_file.adg08,
                     adg12    LIKE adg_file.adg12,
                     adg17    LIKE adg_file.adg17,
                     s_s_ret  LIKE ade_file.ade15,
                     amount3  LIKE ade_file.ade15
                 END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

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

     IF tm.a = '1' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '1'" END IF
     IF tm.a = '2' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '2'" END IF
     IF tm.a = '3' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '3'" END IF
     IF tm.b = 'N' THEN LET tm.wc = tm.wc CLIPPED," AND ade13 = 'N'" END IF

     IF tm.e = 'N' THEN
        LET l_sql = " SELECT add00,ade01,ade02,ade06,ade03,ima02,ima021,ade04,",
                    "        ade05,ade12,ade15,0",
                    "   FROM ade_file,add_file,OUTER ima_file ",
                    " WHERE ade03 = ima_file.ima01  AND add01 = ade01  ",
                    "   AND addacti = 'Y'  AND addconf = 'Y'  ",
                    "   AND ", tm.wc CLIPPED,
                    " ORDER BY add00,ade06,ade03,ade04"
     ELSE
        LET l_sql = " SELECT add00,ade06,ade03,ima02,ima021,ade01,ade02,ade07,",
                    "        ade04,ade05,ade12,ade15,0,ade05-ade12,",
                    "        ade12-ade15,ade13,",
                    "        adg01,adg02,adg06,adg07,adg08,adg12,adg17,",
                    "        0,adg12-adg17 ",
                    "   FROM ade_file,add_file,OUTER (adg_file,adf_file),",
                    "        OUTER ima_file ",
                    " WHERE ade01 = add01  AND adg03 = ade01 ",
                    "   AND adg_file.adg04 = ade02  AND ade03 = ima01 ",
                    "   AND addacti = 'Y'  AND addconf = 'Y' ",
                    "   AND adf_file.adfacti = 'Y'  AND adf_file.adfconf = 'Y' ",
                    "   AND adf_file.adfpost = 'Y'  ",
                    "   AND adf_file.adf01 = adg_file.adg01  AND ", tm.wc CLIPPED,
                    " ORDER BY add00,ade06,ade03,ade01,ade02,adg01,adg02"
     END IF
     PREPARE r202_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)
         EXIT PROGRAM
     END IF
     DECLARE r202_curs1 CURSOR FOR r202_prepare1

     CALL cl_outnam('axdr202') RETURNING l_name

     IF tm.e = 'N' THEN LET g_len = 230 ELSE LET g_len = 314 END IF #MOD-4B0067   #MOD-630001
                                                                    #No.FUN-550026
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     IF tm.e = 'N' THEN
        START REPORT r202_rep1 TO l_name
        LET g_pageno = 0
        FOREACH r202_curs1 INTO sr.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            IF cl_null(sr.ade05) THEN LET sr.ade05 = 0 END IF
            IF cl_null(sr.ade12) THEN LET sr.ade12 = 0 END IF
            IF cl_null(sr.ade15) THEN LET sr.ade15 = 0 END IF
            IF sr.ade12 = sr.ade15 THEN
               IF tm.c = 'N' THEN CONTINUE FOREACH END IF
            END IF
            IF sr.ade05 = sr.ade12 THEN
               IF tm.d = 'N' THEN CONTINUE FOREACH END IF
            END IF
            IF sr.add00 = '2' THEN
               CALL r202_sale_ret_ade(sr.ade01,sr.ade02,sr.ade06)
                    RETURNING sr.sale_ret
            END IF
            IF cl_null(sr.sale_ret) THEN LET sr.sale_ret=0 END IF
            OUTPUT TO REPORT r202_rep1(sr.*)
        END FOREACH
        FINISH REPORT r202_rep1
     ELSE
        START REPORT r202_rep2 TO l_name
        LET g_pageno = 0
        FOREACH r202_curs1 INTO sr1.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            IF cl_null(sr1.ade05) THEN LET sr1.ade05  = 0 END IF
            IF cl_null(sr1.ade12) THEN LET sr1.ade12  = 0 END IF
            IF cl_null(sr1.ade15) THEN LET sr1.ade15  = 0 END IF
            IF sr1.ade12 = sr1.ade15 THEN
               IF tm.c = 'N' THEN CONTINUE FOREACH END IF
            END IF
            IF sr1.ade05 = sr1.ade12 THEN
               IF tm.d = 'N' THEN CONTINUE FOREACH END IF
            END IF
            IF cl_null(sr1.amount1) THEN LET sr1.amount1=sr1.ade05-sr1.ade12 END IF
            IF cl_null(sr1.amount2) THEN LET sr1.amount2=sr1.ade12-sr1.ade15 END IF
            IF cl_null(sr1.adg12)   THEN LET sr1.adg12 = 0 END IF
            IF cl_null(sr1.adg17)   THEN LET sr1.adg17 = 0 END IF
            IF cl_null(sr1.amount3) THEN LET sr1.amount3=sr1.adg12-sr1.adg17 END IF
            OUTPUT TO REPORT r202_rep2(sr1.*)
        END FOREACH
        FINISH REPORT r202_rep2
     END IF

     DATABASE g_azp03o

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r202_rep1(sr)
DEFINE l_last_sw    LIKE type_file.chr1000              #No.FUN-680108 VARCHAR(1) 
DEFINE l_flag1,l_flag2,l_flag3  LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE l_ade05,l_ade12,l_ade15,l_sale_ret LIKE ade_file.ade05
DEFINE sr           RECORD
                     add00    LIKE add_file.add00,
                     ade01    LIKE ade_file.ade01,
                     ade02    LIKE ade_file.ade02,
                     ade06    LIKE ade_file.ade06,
                     ade03    LIKE ade_file.ade03,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ade04    LIKE ade_file.ade04,
                     ade05    LIKE ade_file.ade05,
                     ade12    LIKE ade_file.ade12,
                     ade15    LIKE ade_file.ade15,
                     sale_ret LIKE ade_file.ade15
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.add00,sr.ade06,sr.ade03,sr.ade04
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[11]))/2 SPACES,g_x[11]
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[11]))/2 SPACES,g_x[11]
      PRINT g_x[13] CLIPPED,tm.ada01 CLIPPED,' ',g_azp02
      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[13] CLIPPED,tm.ada01 CLIPPED,' ',g_azp02,
#            COLUMN (g_len-FGL_WIDTH(g_x[2])-16)/2,g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#TQC-6A0095--END
      PRINT g_dash[1,g_len]
 #MOD-4B0067(BEGIN)
      PRINT COLUMN  01, g_x[14] CLIPPED,
#MOD-630001 --start
            COLUMN  45, g_x[27] CLIPPED,
            COLUMN  106,g_x[28] CLIPPED,
            COLUMN  167,g_x[15] CLIPPED,
            COLUMN  202,g_x[16] CLIPPED
#MOD-630001 --end  
      PRINT '------------ ------------------------------ ------------------------------------------------------------',   #MOD-630001
            ' ------------------------------------------------------------',    #MOD-630001
            ' ---- -------------- -------------- -------------- --------------'
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.ade06
      LET l_flag1=0

   BEFORE GROUP OF sr.ade03
      LET l_flag2=0

   AFTER GROUP OF sr.ade04
      LET l_ade05    = GROUP SUM(sr.ade05)
      LET l_ade12    = GROUP SUM(sr.ade12)
      LET l_ade15    = GROUP SUM(sr.ade15)
      LET l_sale_ret = GROUP SUM(sr.sale_ret)
      LET l_flag3=1
      IF l_ade12 = l_ade15 AND l_ade12<>0 THEN
         IF tm.c = 'N' THEN LET l_flag3=0 END IF
      END IF
      IF l_ade05 = l_ade12 THEN
         IF tm.d = 'N' THEN LET l_flag3=0 END IF
      END IF
      IF l_flag3=1 THEN
         IF l_flag1=0 THEN
            PRINT COLUMN 01,sr.ade06;
         END IF
         LET l_flag1=1
         IF l_flag2=0 THEN
#MOD-630001 --start
            PRINT COLUMN   14,sr.ade03 CLIPPED,
                  COLUMN   45,sr.ima02,  #MOD-4A0238
                  COLUMN  106,sr.ima021;
#MOD-630001 --end  
         END IF
         LET l_flag2=1
#MOD-630001 --start
         PRINT COLUMN   167,sr.ade04 CLIPPED,
               COLUMN   172,l_ade05    USING "---------&.&&&",
               COLUMN   187,l_ade12    USING "---------&.&&&",
               COLUMN   202,l_ade15    USING "---------&.&&&",
               COLUMN   217,l_sale_ret USING "---------&.&&&"
#MOD-630001 --end  
      END IF
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

REPORT r202_rep2(sr)
DEFINE l_last_sw    LIKE type_file.chr1                 #No.FUN-680108 VARCHAR(1) 
DEFINE l_ade05      LIKE ade_file.ade05
DEFINE l_ade12      LIKE ade_file.ade12
DEFINE l_ade15      LIKE ade_file.ade15
DEFINE l_s_t_ret    LIKE ade_file.ade15
DEFINE l_amount1    LIKE ade_file.ade15
DEFINE l_amount2    LIKE ade_file.ade15
DEFINE sr           RECORD
                     add00    LIKE add_file.add00,
                     ade06    LIKE ade_file.ade06,
                     ade03    LIKE ade_file.ade03,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     ade01    LIKE ade_file.ade01,
                     ade02    LIKE ade_file.ade02,
                     ade07    LIKE ade_file.ade07,
                     ade04    LIKE ade_file.ade04,
                     ade05    LIKE ade_file.ade05,
                     ade12    LIKE ade_file.ade12,
                     ade15    LIKE ade_file.ade15,
                     s_t_ret  LIKE ade_file.ade15,
                     amount1  LIKE ade_file.ade15,
                     amount2  LIKE ade_file.ade15,
                     ade13    LIKE ade_file.ade13,
                     adg01    LIKE adg_file.adg01,
                     adg02    LIKE adg_file.adg02,
                     adg06    LIKE adg_file.adg06,
                     adg07    LIKE adg_file.adg07,
                     adg08    LIKE adg_file.adg08,
                     adg12    LIKE adg_file.adg12,
                     adg17    LIKE adg_file.adg17,
                     s_s_ret  LIKE ade_file.ade15,
                     amount3  LIKE ade_file.ade15
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ade06,sr.ade03,sr.ade01,sr.ade02,sr.adg01,sr.adg02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[12]))/2 SPACES,g_x[12]
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[12]))/2 SPACES,g_x[12]
      PRINT g_x[13] CLIPPED,tm.ada01 CLIPPED,' ',g_azp02
      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[13] CLIPPED,tm.ada01 CLIPPED,' ',g_azp02,
#            COLUMN (g_len-FGL_WIDTH(g_x[2])-16)/2,g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#TQC-6A0095--END
      PRINT g_dash[1,g_len]
 #MOD-4B0067(BEGIN)
      PRINT COLUMN  01,g_x[17] CLIPPED,
#MOD-630001 --start
            COLUMN  45,g_x[27] CLIPPED,
            COLUMN 106,g_x[28] CLIPPED,
#No.FUN-550026 --start--
            COLUMN 167,g_x[18] CLIPPED,
            COLUMN 207,g_x[19] CLIPPED,
            COLUMN 237,g_x[20] CLIPPED,
            COLUMN 267,g_x[21] CLIPPED
#MOD-630001 --end  
       PRINT '------------ ------------------------------ ------------------------------------------------------------',   #MOD-630001
            ' ------------------------------------------------------------',                                               #MOD-630001
            ' ---------------- ---- ---------- ------ -------------- ',
            '-------------- -------------- -------------- --------------- ---------------   -'
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.ade06
      PRINT COLUMN 01,sr.ade06 CLIPPED;

   BEFORE GROUP OF sr.ade03
#MOD-630001 --start
      PRINT COLUMN 14,sr.ade03 CLIPPED,
            COLUMN 45,sr.ima02,  #MOD-4A0238
            COLUMN 106,sr.ima021; #MOD-4A0238
#MOD-630001 --end  

   BEFORE GROUP OF sr.ade01
      PRINT COLUMN 167,sr.ade01 CLIPPED;    #MOD-630001
      LET l_ade05  = 0
      LET l_ade12  = 0
      LET l_ade15  = 0
      LET l_s_t_ret= 0
      LET l_amount1= 0
      LET l_amount2= 0

   BEFORE GROUP OF sr.ade02
      IF sr.add00 = '2' THEN
         CALL r202_sale_ret_ade(sr.ade01,sr.ade02,sr.ade06)
              RETURNING sr.s_t_ret
         IF cl_null(sr.s_t_ret) THEN LET sr.s_t_ret=0 END IF
         LET sr.amount2=sr.ade12-sr.ade15+sr.s_t_ret
      END IF
#MOD-630001 --start
      PRINT COLUMN 184,sr.ade02   USING "<<<<",
            COLUMN 189,sr.ade07   CLIPPED,
            COLUMN 200,sr.ade04   CLIPPED,
            COLUMN 207,sr.ade05   USING "---------&.&&&",
            COLUMN 222,sr.ade12   USING "---------&.&&&",
            COLUMN 237,sr.ade15   USING "---------&.&&&",
            COLUMN 252,sr.s_t_ret USING "---------&.&&&",
            COLUMN 267,sr.amount1 USING "----------&.&&&",
            COLUMN 283,sr.amount2 USING "----------&.&&&",
            COLUMN 301,sr.ade13
#MOD-630001 --end  
      PRINT
#MOD-630001 --start
      PRINT COLUMN 189,g_x[22] CLIPPED,
            COLUMN 206,g_x[29] CLIPPED,
            COLUMN 233,g_x[23] CLIPPED,
            COLUMN 269,g_x[24] CLIPPED,
            COLUMN 301,g_x[25] CLIPPED
#MOD-630001 --end  
      PRINT '                                                                                           ',           #MOD-630001
            '                                                                       ',                               #MOD-630001
            '                          ---------------- ---- ---------- ---------- ',
            '-------------------- -------------- --------------- ',
            '-------------- ---------------'
      LET l_ade05  = l_ade05 + sr.ade05
      LET l_ade12  = l_ade12 + sr.ade12
      LET l_ade15  = l_ade15 + sr.ade15
      LET l_s_t_ret= l_s_t_ret + sr.s_t_ret
      LET l_amount1= l_amount1 + sr.amount1
      LET l_amount2= l_amount2 + sr.amount2
 
   BEFORE GROUP OF sr.adg01
#      PRINT COLUMN 111,sr.adg01 CLIPPED;
      PRINT COLUMN 189,sr.adg01 CLIPPED;    #MOD-630001

   ON EVERY ROW
      IF sr.add00 = '2' THEN
         IF NOT cl_null(sr.adg01) AND NOT cl_null(sr.adg02) THEN
            CALL r202_sale_ret_adg(sr.adg01,sr.adg02,sr.ade06)
                 RETURNING sr.s_s_ret
            IF cl_null(sr.s_s_ret) THEN LET sr.s_s_ret=0 END IF
            LET sr.amount3=sr.adg12-sr.adg17+sr.s_s_ret
         END IF
      END IF
#MOD-630001 --start
      PRINT COLUMN  206,sr.adg02   USING "<<<<",
            COLUMN  211,sr.adg06   CLIPPED,
            COLUMN  222,sr.adg07   CLIPPED,
            COLUMN  233,sr.adg08   CLIPPED,
            COLUMN  254,sr.adg12   USING "---------&.&&&",
            COLUMN  269,sr.adg17   USING "----------&.&&&",
            COLUMN  284,sr.s_s_ret USING "----------&.&&&",
            COLUMN  300,sr.amount3 USING "----------&.&&&"
#MOD-630001 --end  
#No.FUN-550026 --end--
 #MOD-4B0067(END)
   AFTER GROUP OF sr.ade01
 {     PRINT '                                                     ',
            '------------------------------------------------',
            '----------------------------------------------',
            '------------------------------------------'
      PRINT COLUMN   82,g_x[26]   CLIPPED,
            COLUMN   88,l_ade05   USING "---------&.&&&",
            COLUMN  103,l_ade12   USING "---------&.&&&",
            COLUMN  118,l_ade15   USING "---------&.&&&",
            COLUMN  133,l_s_t_ret USING "---------&.&&&",
            COLUMN  148,l_amount1 USING "----------&.&&&",
            COLUMN  164,l_amount2 USING "----------&.&&&"
}
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

FUNCTION r202_sale_ret_ade(p_ade01,p_ade02,p_ade06)
DEFINE   p_ade01      LIKE ade_file.ade01,
         p_ade02      LIKE ade_file.ade02,
         p_ade06      LIKE ade_file.ade06,
         l_adg01      LIKE adg_file.adg01,
         l_adg02      LIKE adg_file.adg02,
         l_tot,l_tot1 LIKE ohb_file.ohb12,
         l_adg      ARRAY[60] OF RECORD
                    adg01  LIKE adg_file.adg01,
                    adg02  LIKE adg_file.adg02
                    END RECORD,
         l_cnt,l_i  LIKE type_file.num5          #No.FUN-680108 SMALLINT

    LET l_tot=0
    DECLARE r202_sale_ret1 CURSOR WITH HOLD FOR
     SELECT adg01,adg02 FROM adg_file,adf_file
      WHERE adg03=p_ade01 AND adg04=p_ade02
        AND adf01=adg01   AND adfacti='Y'
        AND adfconf='Y'   AND adfpost='Y'
        AND adf00='2'
    IF SQLCA.sqlcode THEN
       CALL cl_err('r202_sale_ret1',SQLCA.sqlcode,0)
       RETURN
    END IF
    LET l_cnt=1
    FOREACH r202_sale_ret1 INTO l_adg01,l_adg02
       IF SQLCA.sqlcode THEN
          CALL cl_err('for r202_sale_ret1',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET l_adg[l_cnt].adg01=l_adg01
       LET l_adg[l_cnt].adg02=l_adg02
       LET l_cnt=l_cnt+1
       IF l_cnt > 60 THEN
          CALL cl_err('','9035',0)
          EXIT FOREACH
       END IF
    END FOREACH
    LET l_cnt=l_cnt-1
    FOR l_i=1 TO l_cnt
       CALL r202_sale_ret_adg(l_adg[l_i].adg01,l_adg[l_i].adg02,p_ade06)
            RETURNING l_tot1
       LET l_tot=l_tot+l_tot1
    END FOR
    RETURN l_tot     #當前申請單的SUM(銷退量)
END FUNCTION

FUNCTION r202_sale_ret_adg(p_adg01,p_adg02,p_ade06)
DEFINE   p_adg01    LIKE adg_file.adg01,
         p_adg02    LIKE adg_file.adg02,
         p_ade06    LIKE ade_file.ade06,
         l_adi01    LIKE adi_file.adi01,
         l_adi02    LIKE adi_file.adi02,
         l_ogb01    LIKE ogb_file.ogb01,
         l_ogb03    LIKE ogb_file.ogb03,
         l_adi      ARRAY[60] OF RECORD
                    adi01  LIKE adi_file.adi01,
                    adi02  LIKE adi_file.adi02
                    END RECORD,
         l_cnt,l_i  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_ohb12    LIKE ohb_file.ohb12,
         l_tot      LIKE ohb_file.ohb12,
         l_azp03    LIKE azp_file.azp03

    IF cl_null(p_adg01) OR cl_null(p_adg02) THEN RETURN END IF
    LET l_tot=0
    SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=p_ade06
    IF SQLCA.sqlcode THEN
       CALL cl_err('select azp03',SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_sql=" SELECT adi01,adi02 FROM ",l_azp03 CLIPPED,".adi_file,",
                l_azp03 CLIPPED,".adh_file",
              "  WHERE adi03='",p_adg01,"' AND adi04=",p_adg02,
              "    AND adh01=adi01   AND adh00='2'",
              "    AND adhconf='Y' AND adhacti='Y' AND adhpost='Y'"
    PREPARE r202_prepare3 FROM g_sql
    IF SQLCA.sqlcode !=0 THEN
       CALL cl_err('prepare3:',SQLCA.sqlcode,1)
       EXIT PROGRAM
    END IF
    DECLARE r202_sale_ret2 CURSOR FOR r202_prepare3
    LET l_cnt=1
    FOREACH r202_sale_ret2 INTO l_adi01,l_adi02
       IF SQLCA.sqlcode THEN
          CALL cl_err('for r202_sale_ret2',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET l_adi[l_cnt].adi01=l_adi01
       LET l_adi[l_cnt].adi02=l_adi02
       LET l_cnt=l_cnt+1
       IF l_cnt > 60 THEN
          CALL cl_err('','9035',0)
          EXIT FOREACH
       END IF
    END FOREACH
    LET l_cnt=l_cnt-1
    FOR l_i=1 TO l_cnt
        SELECT ogb01,ogb03 INTO l_ogb01,l_ogb03 FROM ogb_file
         WHERE ogb31=l_adi[l_i].adi01 AND ogb32=l_adi[l_i].adi02
        IF SQLCA.sqlcode= 0 THEN
           SELECT SUM(ohb12) INTO l_ohb12 FROM ohb_file
            WHERE ohb31=l_ogb01 AND ohb32=l_ogb03
           IF cl_null(l_ohb12) THEN LET l_ohb12=0 END IF
           LET l_tot=l_tot+l_ohb12
        END IF
    END FOR
    RETURN l_tot     #當前撥出單的SUM(銷退量)
END FUNCTION
FUNCTION r202_set_entry()
 
   CALL cl_set_comp_entry("d",TRUE)
 
END FUNCTION

FUNCTION r202_set_no_entry()
 
   IF INFIELD(c) THEN
        IF tm.c = 'N' THEN
           LET tm.d='N'
           CALL cl_set_comp_entry("d",FALSE)
        END IF
   END IF
 
END FUNCTION

