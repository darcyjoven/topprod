# Prog. Version..: '5.10.00-08.01.04(00005)'     #
# Pattern name...: axdr201.4gl
# Descriptions...: 集團間調撥在途量統計表
# Date & Author..: 04/01/12 By Carrier
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/17 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-520024 05/02/28 報表轉XML By wujie
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 BY zhuying 欄位形態定義為LIKE 
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 項次問題更改
# Modify.........: No:FUN-740082 07/05/23 By TSD.Achick報表改寫由Crystal Report產出

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,        #No.FUN-680108 VARCHAR(500) 
           ada01   LIKE ada_file.ada01,           #No.FUN-680108 VARCHAR(10)
           a       LIKE type_file.chr1,           #No.FUN-680108 VARCHAR(01)
           b       LIKE type_file.chr1,           #No.FUN-680108 VARCHAR(03)
           more    LIKE type_file.chr1            #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE    g_azp01  LIKE azp_file.azp01
DEFINE    g_azp02  LIKE azp_file.azp02
DEFINE    g_azp03  LIKE azp_file.azp03
DEFINE    g_azp03o LIKE azp_file.azp03

DEFINE   g_i       LIKE type_file.num5          #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg     LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(72)

DEFINE l_table     STRING                       ### FUN-740082 add ###
DEFINE g_sql       STRING                       ### FUN-740082 add ###
DEFINE g_str       STRING                       ### FUN-740082 add ###

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
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF

   #str FUN-740082 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740082 *** ##
   LET g_sql = "adg09.adg_file.adg09,",
               "azp02.azp_file.azp02,",
               "adf00.adf_file.adf00,",
               "adf01.adf_file.adf01,",
               "adg02.adg_file.adg02,",
               "adf07.adf_file.adf07,",
               "adg05.adg_file.adg05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "adg06.adg_file.adg05,",
               "adg07.adg_file.adg07,",
               "adg08.adg_file.adg08,",
               "adg12.adg_file.adg12,",
               "adg17.adg_file.adg17,",
               "amount.ade_file.ade15,",
               "adg11.adg_file.adg11"

   LET l_table = cl_prt_temptable('axdr201',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?)"

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#


   SELECT azp01,azp03 INTO g_azp01,g_azp03 FROM azp_file WHERE azp01 = g_plant
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      EXIT PROGRAM
   END IF
   LET g_azp03o = g_azp03
   IF NOT cl_null(tm.wc) THEN
      CALL r201()
   ELSE
      CALL r201_tm(0,0)
   END IF
END MAIN

FUNCTION r201_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680108 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

      LET p_row = 5 LET p_col = 13
   OPEN WINDOW r201_w AT p_row,p_col
        WITH FORM "axd/42f/axdr201"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.ada01 = g_azp01
   LET tm.a     = '4'
   LET tm.b     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON adf01,adg05,adf07,adg06,adg07
              HELP 1

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

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

      ON ACTION CONTROLP
            IF INFIELD(adg05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO adg05
               NEXT FIELD adg05
            END IF
      
      ON ACTION qbe_select
         CALL cl_qbe_select()
     

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r201_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.ada01,tm.a,tm.b,tm.more

      INPUT BY NAME tm.ada01,tm.a,tm.b,tm.more WITHOUT DEFAULTS HELP 1
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

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
      CLOSE WINDOW r201_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr201'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr201','9031',1)
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
                         " '",tm.ada01 CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",      #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",      #No:FUN-570264
                         " '",g_template CLIPPED,"'"       #No:FUN-570264
         CALL cl_cmdat('axdr201',g_time,l_cmd)
      END IF
      CLOSE WINDOW r201_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r201()
   ERROR ""
END WHILE
   CLOSE WINDOW r201_w
END FUNCTION

FUNCTION r201()
DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name     #No.FUN-680108 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT     #No.FUN-680108 VARCHAR(1000)
DEFINE l_za05    LIKE za_file.za05            #NO.MOD-4B0067
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                     adg09    LIKE adg_file.adg09,
                     azp02    LIKE azp_file.azp02,
                     adf00    LIKE adf_file.adf00,
                     adf01    LIKE adf_file.adf01,
                     adg02    LIKE adg_file.adg02,
                     adf07    LIKE adf_file.adf07,
                     adg05    LIKE adg_file.adg05,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     adg06    LIKE adg_file.adg05,
                     adg07    LIKE adg_file.adg07,
                     adg08    LIKE adg_file.adg08,
                     adg12    LIKE adg_file.adg12,
                     adg17    LIKE adg_file.adg17,
                     amount   LIKE ade_file.ade15,
                     adg11    LIKE adg_file.adg11
                 END RECORD

   #str FUN-740082  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740082 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-740082  add

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740082 add ###

     SELECT azp02,azp03 INTO g_azp02,g_azp03 FROM azp_file
      WHERE azp01 = tm.ada01
     IF SQLCA.sqlcode THEN
        CALL cl_err(tm.ada01,SQLCA.sqlcode,0)
        RETURN
     END IF

     DATABASE g_azp03

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND adfuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND adfgrup IN ",cl_chk_tgrup_list()
     END IF


     LET l_sql = " SELECT adg09,azp02,adf00,adf01,adg02,adf07,adg05,",
                 "        ima02,ima021,adg06,adg07,adg08,adg12,adg17,0,adg11",
                 "   FROM adg_file,adf_file,ade_file,",
                 "        OUTER azp_file,OUTER ima_file ",
                 " WHERE adg01 = adf01  AND adg03 = ade01 ",
                 "   AND adg04 = ade02  AND adfpost = 'Y' ",
                 "   AND adfacti = 'Y'  AND ade13 = 'N'",
                 "   AND ima_file.ima01 = adg05  AND azp_file.azp01 = adg09",
                 "   AND ", tm.wc CLIPPED
     IF tm.a = '1' THEN LET l_sql = l_sql CLIPPED," AND adf00 = '1'" END IF
     IF tm.a = '2' THEN LET l_sql = l_sql CLIPPED," AND adf00 = '2'" END IF
     IF tm.a = '3' THEN LET l_sql = l_sql CLIPPED," AND adf00 = '3'" END IF
     LET l_sql = l_sql CLIPPED," ORDER BY adg09,adf00,adf01,adg02"
     PREPARE r201_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         EXIT PROGRAM
     END IF
     DECLARE r201_curs1 CURSOR FOR r201_prepare1

     LET g_pageno = 0
     FOREACH r201_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr.adg12) THEN LET sr.adg12 = 0 END IF
          IF cl_null(sr.adg17) THEN LET sr.adg17 = 0 END IF
          LET sr.amount = sr.adg12 - sr.adg17

       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740082 *** ##
         EXECUTE insert_prep USING 
         sr.adg09, sr.azp02, sr.adf00, sr.adf01,  sr.adg02,
         sr.adf07, sr.adg05, sr.ima02, sr.ima021, sr.adg06,
         sr.adg07, sr.adg08, sr.adg12, sr.adg17,  sr.amount,
         sr.adg11
       #------------------------------ CR (3) ------------------------------#
       #end FUN-740082 add 
     END FOREACH

     DATABASE g_azp03o

   #str FUN-740082 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740082 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'adf01,adg05,adf07,adg06,adg07')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.b,";",tm.ada01,";",g_azp02
   CALL cl_prt_cs3('axdr201','axdr201',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740082 add 

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 

END FUNCTION

