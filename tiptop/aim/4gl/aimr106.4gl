# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr106.4gl
# Descriptions...: 庫存數量表列印
# Date & Author..: 2002/07/22 By Mandy
# Modify.........: No:9314 By Melody 1.資料是錯誤的 ,以前期的期末當初始值 ,但是tlf_file 又是抓上期的
#                                    2.sr.imk09 未塞值 ,所以算出來也有問題
# Modify.........: No.MOD-4C0105 04/12/16 By Mandy imk 有同月份資料時，會抓到當月底而不會抓到前月底
# Modify.........: No.MOD-510083 05/01/12 By ching 邏輯錯誤處理
# Modify.........: No.FUN-510017 05/02/17 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580027 05/12/15 By Pengu 1.應該抓取本期異動資料而不是前期異動資料
                                          #        2.異動數量img10應乘上單位轉換率
# Modify.........: No.MOD-620087 06/03/01 By Claire 發料單位與庫存單位不同的料號會有問題
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-710183 07/02/08 By pengu 調整庫存數量的計算邏輯
# Modify.........: No.FUN-770006 07/08/03 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.MOD-8C0015 08/12/02 By clover l_sql VARCHAR(1000)不夠,改為String
# Modify.........: No.MOD-970290 09/08/03 By sherry 計算tlf中的數量的時候，沒有乘上tlf60（與庫存單位的轉換率）
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40108 10/04/20 By Sarah 目前g_yy與g_mm是抓出e_date的年月,應改成抓出年期
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:MOD-B40005 11/04/01 By sabrina 在計算異動單據數量時已轉換成庫存單位。不需再乘轉換率

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
              wc      STRING,                  #MOD-8C0015
              edate   LIKE type_file.dat,     #No.FUN-690026 DATE
              a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              more    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
              END RECORD,
          i           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          g_yy        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          g_mm        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          last_y      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          last_m      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cnt       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          m_bdate     LIKE type_file.dat,     #No.FUN-690026 DATE
          m_edate     LIKE type_file.dat,     #No.FUN-690026 DATE
          l_imk09     LIKE imk_file.imk09,    #No:9314 #MOD-530179
          l_flag      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
DEFINE   g_chr        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_sql        STRING                  #No.FUN-770006
DEFINE   g_str        STRING                  #No.FUN-770006
DEFINE   l_table      STRING                  #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-770006 --start--
   LET g_sql="img01.img_file.img01,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,img02.img_file.img02,",
             "img03.img_file.img03,img04.img_file.img04,img10.img_file.img10,",
             "imk09.imk_file.imk09,ima25.ima_file.ima25"
 
   LET l_table = cl_prt_temptable('aimr106',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770006 --end--
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)   #TQC-610072 順序下推 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r106_tm(0,0)
   ELSE
       CALL r106()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r106_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r106_w AT p_row,p_col
        WITH FORM "aim/42f/aimr106"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end
 
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
         CLOSE WINDOW r106_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.edate,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF  cl_null(tm.edate) THEN NEXT FIELD edate END IF
        #LET g_yy = YEAR(tm.edate)                #MOD-A40108 mark
        #LET g_mm = MONTH(tm.edate)               #MOD-A40108 mark
         CALL s_yp(tm.edate) RETURNING g_yy,g_mm  #MOD-A40108

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF  INT_FLAG THEN EXIT INPUT END IF
         LET l_flag = 'N'
         IF  cl_null(tm.edate) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.edate
         END IF
         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD edate
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
   IF  INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW r106_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
       EXIT PROGRAM
   END IF
 
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aimr106'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr106','9031',1)
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
                         " '",tm.edate CLIPPED,"'",             #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr106',g_time,l_cmd)
      END IF
      CLOSE WINDOW r106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r106()
   ERROR ""
END WHILE
   CLOSE WINDOW r106_w
END FUNCTION
 
FUNCTION r106()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          #l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_sql     STRING,                 #MOD-8C0015
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                    img01 LIKE img_file.img01,   #--料號
                    img02 LIKE img_file.img02,   #--倉
                    img03 LIKE img_file.img03,   #--儲
                    img04 LIKE img_file.img04,   #--批
                    img10 LIKE img_file.img10,   #--出入庫量
                    ima25 LIKE ima_file.ima25,   #--料件主檔單位
                    imk09 LIKE imk_file.imk09,   #--上期期末庫存
                    tmp01 LIKE imk_file.imk05,   #--上期期末年度  #No.FUN-690026 SMALLINT
                    tmp02 LIKE imk_file.imk06    #--上期期末期別  #No.FUN-690026 SMALLINT
                    END RECORD,
          l_img09       LIKE img_file.img09,     #--來源單位
          l_img2ima_fac LIKE ima_file.ima31_fac  #--轉換率 #MOD-530179
   DEFINE l_ima02   LIKE ima_file.ima02,         #No.FUN-770006
          l_ima021  LIKE ima_file.ima021         #No.FUN-770006 
 
     CALL cl_del_data(l_table)                   #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                        #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                         #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     DROP TABLE aimr106_tmp
     #CREATE TEMP TABLE aimr106_tmp
     #    ( img01 VARCHAR(40),              #--料號    #FUN-560011
     #      img02 VARCHAR(10),              #--倉
     #      img03 VARCHAR(10),              #--儲
     #      img04 VARCHAR(24),              #--批
     #      img10 DEC(15,3),             #--出入庫量
     # Prog. Version..: '5.30.06-13.03.12(04),              #--料件主檔單位
     #      imk09 DEC(15,3),             #--上期期末庫存
     #      tmp01 smallint,              #--上期期末年度
     #      tmp02 smallint)              #--上期期末期別
     CREATE TEMP TABLE aimr106_tmp(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06)
     DELETE FROM aimr106_tmp
 
     #No:9314
     DROP TABLE aimr106_tmp2
     #CREATE TEMP TABLE aimr106_tmp2
     #    ( img01 VARCHAR(40),              #--料號    #FUN-560011
     #      img02 VARCHAR(10),              #--倉
     #      img03 VARCHAR(10),              #--儲
     #      img04 VARCHAR(24),              #--批
     #      img10 DEC(15,3),             #--出入庫量
     # Prog. Version..: '5.30.06-13.03.12(04),              #--料件主檔單位
     #      imk09 DEC(15,3),             #--上期期末庫存
     #      tmp01 smallint,              #--上期期末年度
     #      tmp02 smallint)              #--上期期末期別
     CREATE TEMP TABLE aimr106_tmp2(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06)
     DELETE FROM aimr106_tmp2
     #No:9314
 
 
     IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF
 
     LET l_sql = "SELECT img01, img02, img03, img04, imk05, imk06",
                 "  FROM img_file LEFT OUTER JOIN imk_file",
                 "    ON img01 = imk01 AND img02 = imk02",
                 "   AND img03 = imk03 AND img04 = imk04",
                 "   AND imk05 =",last_y,
                 "   AND imk06 =",last_m,
                 " WHERE img10>0 AND ", tm.wc CLIPPED
 
     PREPARE r106_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r106_curs1 CURSOR FOR r106_prepare1
 
     LET g_success = 'Y'
     BEGIN WORK
     FOREACH r106_curs1 INTO sr.img01,sr.img02,sr.img03,sr.img04,
                             sr.tmp01,sr.tmp02
         SELECT COUNT(*) INTO l_cnt FROM aimr106_tmp  #--己存在不覆蓋
             WHERE img01 = sr.img01 AND img02 = sr.img02
             AND   img03 = sr.img03 AND img04 = sr.img04
         IF  NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
             CONTINUE FOREACH
         END IF
          #MOD-4C0105
         IF sr.tmp02 = g_mm  THEN
            LET sr.tmp02 = sr.tmp02 - 1
              IF sr.tmp02 = 0 THEN
                 LET sr.tmp02 = 12
                 LET sr.tmp01 = sr.tmp01 - 1
              END IF
         END IF
          #MOD-4C0105(end)
         LET sr.img10 = 0
SELECT imk09,img09 INTO sr.imk09,l_img09 FROM img_file LEFT OUTER JOIN imk_file
    ON img01 = imk01 AND img02 = imk02
   AND img03 = imk03 AND img04 = imk04
   AND imk05 = sr.tmp01 AND imk06 = sr.tmp02
   WHERE img01 = sr.img01 AND img02 = sr.img02
     AND img03 = sr.img03 AND img04 = sr.img04
         IF  SQLCA.sqlcode THEN
             LET g_success = 'N'
#            CALL cl_err(sr.img01,SQLCA.sqlcode,1) #No.FUN-660156
             CALL cl_err3("sel","imk_file",sr.img01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
         END IF
         IF  cl_null(sr.imk09) THEN LET sr.imk09 = 0  END IF
         IF  cl_null(l_img09)  THEN LET l_img09 = ' ' END IF
         SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
         LET l_img2ima_fac  = 1
         IF  l_img09 <> sr.ima25 THEN
             CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                  RETURNING g_i,l_img2ima_fac
             IF  g_i = 1 THEN
                 LET l_img2ima_fac = 1
                 CALL cl_err(sr.img01,'mfg3075',0)
             END IF
         END IF
         LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
         INSERT INTO aimr106_tmp VALUES(sr.*)
         IF  SQLCA.sqlcode THEN
             LET g_success = "N"
#            CALL cl_err('ins r106_tmp 1:',SQLCA.sqlcode,1)
             CALL cl_err3("ins","aimr106_tmp",sr.img01,"",SQLCA.sqlcode,"",
                          "ins r106_tmp 1",1)   #NO.FUN-640266 #No.FUN-660156
         END IF
     END FOREACH
 
     LET l_sql = " SELECT tlf01,tlf902,tlf903,tlf904, ",
                       # " (tlf907*tlf10),' ',0,0,0,tlf11 ",        #MOD-620087  #No.MOD-710183 delete mark #MOD-970290 mark 
                        " (tlf907*tlf10*tlf60),' ',0,0,0,tlf11 ",        #MOD-620087  #No.MOD-710183 delete mark #MOD-970290 add
                       #" (tlf907*tlf10*tlf60),' ',0,0,0,tlf11 ",  #MOD-620087  #No.MOD-710183 mark
                 " FROM img_file,tlf_file",
                 " WHERE img01 = tlf01 ",
                 " AND (img02 = tlf902 AND img03 = tlf903 AND img04 = tlf904) ",
                 " AND img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? ",
                 " AND tlf06 BETWEEN ? AND '",tm.edate,"'",
                 " AND tlf907 IN (1,-1)"   #入出庫碼 (1:入庫 -1:出庫 0:其它
     PREPARE r106_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) LET g_success = 'N' END IF
     DECLARE r106_curs2 CURSOR WITH HOLD FOR r106_prepare2
 
     DECLARE r106_cur3 CURSOR FOR
     SELECT * FROM aimr106_tmp
 
     FOREACH r106_cur3 INTO sr.*
         # CALL s_azm(sr.tmp01,sr.tmp02)     #MOD-510083   #No.MOD-580027 mark
          CALL s_azm(g_yy,g_mm)              #No.MOD-580027 抓取本期的起始日期
         RETURNING g_chr,m_bdate,m_edate
         LET l_imk09 = sr.imk09
         INSERT INTO aimr106_tmp2 VALUES(sr.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('ins r106 tmp2:',SQLCA.SQLCODE,0)
            CALL cl_err3("ins","aimr106_tmp2",sr.img01,"",SQLCA.sqlcode,"",
                         "ins r106 tmp2",0)   #NO.FUN-640266
            LET g_success='N'
         END IF
     #No:9314
 
         FOREACH r106_curs2 USING sr.img01,sr.img02,sr.img03,sr.img04,m_bdate
                            INTO sr.*,l_img09
             IF  SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
             SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
             LET l_img2ima_fac  = 1
             IF  l_img09 <> sr.ima25 THEN
                 CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                      RETURNING g_i,l_img2ima_fac
                 IF  g_i = 1 THEN
                      LET l_img2ima_fac = 1
                      CALL cl_err(sr.img01,'mfg3075',0)
                 END IF
             END IF
             LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
            #LET sr.img10 = sr.img10 * l_img2ima_fac #No:MOD-580027 期間異動數量(轉換後)   #MOD-B40005 mark
             INSERT INTO aimr106_tmp2 VALUES(sr.*)
             IF  SQLCA.sqlcode THEN
                 LET g_success = 'N'
#                CALL cl_err('ins r106_tmp 1:',SQLCA.sqlcode,1)
                 CALL cl_err3("ins","aimr106_tmp2",sr.img01,"",SQLCA.sqlcode,
                              "ins r106_tmp 1","",1)   #NO.FUN-640266 #No.FUN-660156
             END IF
         END FOREACH
     END FOREACH
     IF g_success = 'Y' THEN
         CALL cl_cmmsg(1) COMMIT WORK
     ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK RETURN
     END IF
 
#     CALL cl_outnam('aimr106') RETURNING l_name      #No.FUN-770006
#     START REPORT r106_rep TO l_name                 #No.FUN-770006
     DECLARE aimr106_tmp_cur CURSOR FOR
      SELECT * FROM aimr106_tmp2   #MOD-510083
     FOREACH aimr106_tmp_cur INTO sr.*
        IF  SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
#       OUTPUT TO REPORT r106_rep(sr.*)               #No.FUN-770006
        #No.FUN-770006 --start--
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                   
              WHERE ima01 = sr.img01                                                
        IF SQLCA.sqlcode THEN                                                     
           LET l_ima02 = ' '                                                     
           LET l_ima021 = ' '                                                    
        END IF 
        EXECUTE insert_prep USING sr.img01,l_ima02,l_ima021,sr.img02,sr.img03,
                                  sr.img04,sr.img10,sr.imk09,sr.ima25
        #No.FUN-770006 --end--
     END FOREACH
#    FINISH REPORT r106_rep                           #No.FUN-770006
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
      
     LET g_str = g_str
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aimr106','aimr106',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r106_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr          RECORD
                      img01 LIKE img_file.img01,   #--料號
                      img02 LIKE img_file.img02,   #--倉
                      img03 LIKE img_file.img03,   #--儲
                      img04 LIKE img_file.img04,   #--批
                      img10 LIKE img_file.img10,   #--出入庫量
                      ima25 LIKE ima_file.ima25,   #--料件主檔單位
                      imk09 LIKE imk_file.imk09,   #--上期期末庫存
                      tmp01 LIKE imk_file.imk05,   #--上期期末年度  #No.FUN-690026 SMALLINT
                      tmp02 LIKE imk_file.imk06    #--上期期末期別  #No.FUN-690026 SMALLINT
                      END RECORD,
          l_ima02     LIKE ima_file.ima02,
          l_ima021    LIKE ima_file.ima021 #FUN-510017
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.img01,sr.img02,sr.img03,sr.img04
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT ' '
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.img01
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01 = sr.img01
      IF SQLCA.sqlcode THEN
          LET l_ima02 = ' '
          LET l_ima021 = ' '
      END IF
      PRINT COLUMN g_c[31],sr.img01 ,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021;
      LET l_imk09 = 0 #MOD-580027
 
   AFTER GROUP OF sr.img04
     #-------------No.MOD-710183 mark
     ##MOD-580027................begin
     #SELECT imk09 INTO sr.imk09 FROM img_file,imk_file
     # WHERE img01 = imk_file.imk01    AND img02 = imk_file.imk02
     #   AND img03 = imk03    AND img04 = imk04
     #   AND img01 = sr.img01 AND img02 = sr.img02
     #   AND img03 = sr.img03 AND img04 = sr.img04
     #   AND imk_file.imk05 = last_y   AND imk_file.imk06 = last_m
     # #MOD-580027................end
     #-------------No.MOD-710183 mark
 
     #IF tm.a = 'Y' THEN
     #    PRINT COLUMN  53,sr.img02,"/",sr.img03,"/",sr.img04,
     #          COLUMN 100,GROUP SUM(sr.imk09+sr.img10) USING "------------&.&&&",' ',sr.ima25
     #END IF
      PRINT COLUMN g_c[34],sr.img02,
            COLUMN g_c[35],sr.img03,
            COLUMN g_c[36],sr.img04,
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09+sr.img10),37,3), #No.MOD-710183
           #COLUMN g_c[37],cl_numfor(sr.imk09+GROUP SUM(sr.img10),37,3), #MOD-580027 #No.MOD-710183 mark
            COLUMN g_c[38],sr.ima25
   #No:9314
   #  LET l_imk09=l_imk09=sr.imk09
      LET l_imk09=l_imk09+sr.imk09
 
   AFTER GROUP OF sr.img01
          PRINT g_dash2
          PRINT COLUMN g_c[36],g_x[19] CLIPPED,
                COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09+sr.img10),37,3) #No.MOD-710183
               #COLUMN g_c[37],cl_numfor(l_imk09+GROUP SUM(sr.img10),37,3)  #MOD-580027  #No.MOD-710183 mark
          PRINT
 
   ON LAST ROW
 #    PRINT COLUMN  85,g_x[20] CLIPPED,
 #          COLUMN 100, SUM(sr.imk09+sr.img10) USING "------------&.&&&" ,' ',sr.ima25
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF  l_last_sw = 'n' THEN
          PRINT g_dash
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770006  --end--
