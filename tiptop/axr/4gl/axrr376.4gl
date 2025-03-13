# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr376.4gl
# Descriptions...: 應收帳款明細帳
# Date & Author..: 98/12/23 By Billy
# Modify.........: No.FUN-4C0100 04/12/28 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550071 05/05/27 By yoyo單據編號格式放大
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.FUN-5B0139 05/12/06 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: No.TQC-5C0126 05/12/30 By Smapmin 報表修改
# Modify.........: No.MOD-630116 06/03/30 By Smapmin 修正TQC-5C0126
# Modify.........: No.FUN-660116 06/06/20 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表         
# Modify.........: No.FUN-710058 07/02/07 By jamie 放寬項次位數
# Modify.........: No.TQC-730076 07/04/17 By Smapmin 發票待抵的資料應以負數呈現
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期的位置在報表名之上
# Modify.........: NO.FUN-7B0026 07/11/20 By zhaijie改報表輸出為Crystal Report
# Modify.........: No.CHI-7C0027 07/12/24 By Smapmin 增加是否列印餘額為零的選項
# Modify.........: No.MOD-830172 08/04/15 By Smapmin 增加2*的資料抓取
# Modify.........: No.MOD-840141 08/04/18 By Smapmin 加回截止日期之後的沖帳金額,僅針對借方待抵或貸方應收
# Modify.........: No.MOD-8A0153 08/10/17 Bt Sarah 此報表可選多營運中心,故抓oob_file,ooa_file資料時需依多營運中心抓取
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
 
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0014 09/11/03 By lilingyu Sql改成標準寫法
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:CHI-A50016 10/05/17 BY Summer 當oma00= '21',若單身的銷退單對應ohb30只有一筆時則呈現,若為多筆則維持空白
# Modify.........: No:TQC-A50082 10/05/20 By Carrier TQC-950121追单
# Modify.........: No.FUN-A60056 10/07/09 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-B10029 11/01/20 By Summer INPUT選項增加應扣除折讓資料
# Modify.........: No:TQC-B10083 11/01/20 By yinhy l_oma24默認預設值為''，抓不到值不應為'1'
# Modify.........: No:FUN-B20019 11/02/11 By yinhy SQL增加ooa37='1'的条件
# Modify.........: No:TQC-B30003 11/03/01 By yinhy ooz07為Y時，查詢條件有誤
# Modify.........: No:MOD-B40123 11/04/18 By Dido 當無出貨單時,料號應改用 omb04 
# Modify.........: No:FUN-BB0173 12/01/13 by pauline 增加跨法人抓取資料 
# Modify.........: No.FUN-C40001 12/04/12 By yinhy 增加開窗功能
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                              # Print condition RECORD
            wc     LIKE type_file.chr1000,     # Where condition #No.FUN-680123 VARCHAR(1000)
            bdate  LIKE type_file.dat,         #No.FUN-680123 DATE
            edate  LIKE type_file.dat,         #No.FUN-680123 DATE
            type   LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
            sort   LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
            b      LIKE type_file.chr1,        #CHI-7C0027
            c      LIKE type_file.chr1,        #CHI-B10029 add
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#            p1     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p2     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p3     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p4     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10) 
#            p5     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p6     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p7     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
#            p8     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
             #FUN-BB0173 add START
              plant_1 LIKE azw_file.azw01,
              plant_2 LIKE azw_file.azw01,
              plant_3 LIKE azw_file.azw01,
              plant_4 LIKE azw_file.azw01,
              plant_5 LIKE azw_file.azw01,
              plant_6 LIKE azw_file.azw01,
              plant_7 LIKE azw_file.azw01,
              plant_8 LIKE azw_file.azw01,
             #FUN-BB0173 add END
            more   LIKE type_file.chr1         # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
           END RECORD 
DEFINE g_yy,g_mm   LIKE type_file.num5         #No.FUN-680123 SMALLINT
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-680123 ARRAY[10] OF VARCHAR(20)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
DEFINE g_title     LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(160)
DEFINE g_i         LIKE type_file.num5         #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE i           LIKE type_file.num5         #No.FUN-680123 SMALLINT
DEFINE g_sql       STRING                      #NO.FUN-7B0026
DEFINE g_str       STRING                      #NO.FUN-7B0026
DEFINE l_table     STRING                      #NO.FUN-7B0026
#FUN-BB0173 add START
DEFINE plant   ARRAY[8]  OF LIKE azp_file.azp01
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
           plant      LIKE azw_file.azw01           #plant
           END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1         #記錄是否為流通
DEFINE   g_azw01_1      LIKE azw_file.azw01
DEFINE   g_azw01_2      LIKE azw_file.azw01
#FUN-BB0173 add END
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   LET g_sql = "oma00.oma_file.oma00,oma01.oma_file.oma01,",
               "oma03.oma_file.oma03,oma032.oma_file.oma032,",
               "oma08.oma_file.oma08,oma10.oma_file.oma10,",
               "oma14.oma_file.oma14,oma23.oma_file.oma23,",
               "oma24.oma_file.oma24,oma39.oma_file.oma39,",
               "oma40.oma_file.oma40,omaconf.oma_file.omaconf,",
               "omavoid.oma_file.omavoid,occ37.occ_file.occ37,",
               "oma02.oma_file.oma02,oma54t.oma_file.oma54t,",
               "oma55.oma_file.oma55,oma56t.oma_file.oma56t,",
               "oma57.oma_file.oma57,oob09.oob_file.oob09,",
               "oob10.oob_file.oob10,azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,azi07.azi_file.azi07,",
               "l_gen02.gen_file.gen02,oga02.oga_file.oga02,",
               "omb31.omb_file.omb31,omb32.omb_file.omb32,",
               "ogb04.ogb_file.ogb04,l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,l_amt7.type_file.num20_6,",
               "l_amt8.type_file.num20_6"
   LET l_table = cl_prt_temptable('axrr376',g_sql) CLIPPED
   IF  l_table = -1  THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type  = ARG_VAL(10)
   LET tm.sort  = ARG_VAL(11)  
   LET tm.b     = ARG_VAL(12)   #CHI-7C0027
   LET tm.c     = ARG_VAL(13) #CHI-B10029 add
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   LET tm.p1    = ARG_VAL(13)
#   LET tm.p2    = ARG_VAL(14)
#   LET tm.p3    = ARG_VAL(15)
#   LET tm.p4    = ARG_VAL(16)
#   LET tm.p5    = ARG_VAL(17)
#   LET tm.p6    = ARG_VAL(18)
#   LET tm.p7    = ARG_VAL(19)
#   LET tm.p8    = ARG_VAL(20)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
   #CHI-B10029 mod +1 --start--
#FUN-BB0173 mark START
  #LET g_rep_user = ARG_VAL(14)
  #LET g_rep_clas = ARG_VAL(15)
  #LET g_template = ARG_VAL(16)
  #LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #CHI-B10029 mod +1 --end--
#FUN-BB0173 mark END
#FUN-BB0173 add START
   LET plant[1] = ARG_VAL(14)
   LET plant[2] = ARG_VAL(15)
   LET plant[3] = ARG_VAL(16)
   LET plant[4] = ARG_VAL(17)
   LET plant[5] = ARG_VAL(18)
   LET plant[6] = ARG_VAL(19)
   LET plant[7] = ARG_VAL(20)
   LET plant[8] = ARG_VAL(21)
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)
   FOR g_i = 1 TO 8
      IF NOT cl_null(plant[g_i])THEN
         CALL chk_plant(plant[g_i]) RETURNING g_azw01_1
         IF NOT cl_null(g_azw01_1) THEN
            IF cl_null(g_azw01_2) THEN
               LET g_azw01_2 = "'",g_azw01_1,"'"
            ELSE
               LET g_azw01_2 = g_azw01_2,"'",g_azw01_1,"'"
            END IF
         END IF
      END IF
   END FOR
   IF NOT cl_null(g_azw01_2) THEN
      CALL r376_legal_db(g_azw01_2)
   END IF
#FUN-BB0173 add END
    DROP TABLE curr_tmp
    CREATE TEMP TABLE curr_tmp
     (curr LIKE azi_file.azi01,
      amt1 LIKE type_file.num20_6,
      amt2 LIKE type_file.num20_6,
      amt3 LIKE type_file.num20_6,
      amt4 LIKE type_file.num20_6,
      oma03 LIKE oma_file.oma03,
      oma14 LIKE oma_file.oma14)
 
   IF cl_null(tm.wc)
      THEN CALL r376_tm(0,0)             # Input print condition
   ELSE 
      CALL r376()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r376_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(1000)
   DEFINE l_n            LIKE type_file.num5       #No.FUN-680123 SMALLINT
   DEFINE  l_cnt         LIKE type_file.num5       #FUN-BB0173 add
   DEFINE  l_string      STRING                    #FUN-BB0173 add
   DEFINE  l_plant       LIKE azw_file.azw01       #FUN-BB0173 add
   DEFINE  l_ac          LIKE type_file.num5       #FUN-BB0173 add 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 18
   ELSE
      LET p_row = 2 LET p_col = 10
   END IF
 
   OPEN WINDOW r376_w AT p_row,p_col WITH FORM "axr/42f/axrr376"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r376_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.bdate = TODAY    #FUN-BB0173 add
   LET tm.edate = today
#  LET tm.p1    = g_plant   ###GP5.2  #NO.FUN-A10098 dxfwo mark
   LET tm.plant_1 = g_plant   #FUN-BB0173 add 
   LET tm.type  = '3'
   LET tm.sort  = '1'
   LET tm.b     = 'N'   #CHI-7C0027
   LET tm.c='Y'  #CHI-B10029 add
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma01,oma00,oma18, oma10,  oma03,    #TQC-5C0126
                              omauser,oma14
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
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
      ON ACTION CONTROLP
         #No.FUN-C40001  --Begin
         CASE
              WHEN INFIELD(oma01)  #genero要改查單據單(未改)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_oma6'
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry()  RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma01
                   NEXT FIELD oma01
              WHEN INFIELD(oma03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma03
                   NEXT FIELD oma03
              WHEN INFIELD(ogb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb04
                   NEXT FIELD ogb04
              WHEN INFIELD(oma18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ='q_aag'
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma18
                   NEXT FIELD oma18
              WHEN INFIELD(oma14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14
              END CASE
         #IF INFIELD(ogb04) THEN
         #   CALL cl_init_qry_var()
         #   LET g_qryparam.form = "q_ima"
         #   LET g_qryparam.state = "c"
         #   CALL cl_create_qry() RETURNING g_qryparam.multiret
         #   DISPLAY g_qryparam.multiret TO ogb04
         #   NEXT FIELD ogb04
         #END IF
         #No.FUN-C40001  --End

 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r376_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF

#FUN-BB0173 add START
   INPUT BY NAME tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8

   WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_1
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_1
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_1) THEN
               NEXT FIELD plant_1
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_1 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_1 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_1 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_1 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_1 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_1 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_1 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
         END IF

      AFTER FIELD plant_2
         IF NOT cl_null(tm.plant_2) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_2
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_2
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_2) THEN
               NEXT FIELD plant_2
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_2 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_2 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_2 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_2 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_2 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_2 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_2 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
         END IF

      AFTER FIELD plant_3
         IF NOT cl_null(tm.plant_3) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_3
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_3
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_3) THEN
               NEXT FIELD plant_3
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_3 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_3 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_3 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_3 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_3 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_3 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_3 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
         END IF

      AFTER FIELD plant_4
         IF NOT cl_null(tm.plant_4) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_4
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_4
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_4) THEN
               NEXT FIELD plant_4
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_4 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_4 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_4 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_4 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_4 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_4 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_4 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
         END IF

      AFTER FIELD plant_5
         IF NOT cl_null(tm.plant_5) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_5
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_5
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_5) THEN
               NEXT FIELD plant_5
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_5 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_5 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_5 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_5 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_5 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_5 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_5 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
         END IF

      AFTER FIELD plant_6
         IF NOT cl_null(tm.plant_6) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_6
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_6
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_6) THEN
               NEXT FIELD plant_6
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_6 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_6 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_6 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_6 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_6 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_6 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_6 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
         END IF

      AFTER FIELD plant_7
         IF NOT cl_null(tm.plant_7) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_7
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_7
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_7) THEN
               NEXT FIELD plant_7
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_7 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_7 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_7 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_7 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_7 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_7 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_7 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
         END IF

      AFTER FIELD plant_8
         IF NOT cl_null(tm.plant_8) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_8
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_8
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_8) THEN
               NEXT FIELD plant_8
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_8 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_8 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_8 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_8 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_8 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_8 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_8 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
         END IF

      AFTER INPUT
         LET l_string = ''
         IF NOT cl_null(tm.plant_1) THEN
            CALL chk_plant(tm.plant_1) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_2) THEN
            CALL chk_plant(tm.plant_2) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_3) THEN
            CALL chk_plant(tm.plant_3) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_4) THEN
            CALL chk_plant(tm.plant_4) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_5) THEN
            CALL chk_plant(tm.plant_5) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_6) THEN
            CALL chk_plant(tm.plant_6) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_7) THEN
            CALL chk_plant(tm.plant_7) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_8) THEN
            CALL chk_plant(tm.plant_8) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF
          #營運中心不可為空
         IF cl_null(l_string) THEN
            CALL cl_err('','aom-423',0)
            NEXT FIELD plant_1
         END IF
         CALL r376_legal_db(l_string)

      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(plant_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_1
                CALL cl_create_qry() RETURNING tm.plant_1
                DISPLAY BY NAME tm.plant_1
                NEXT FIELD plant_1

             WHEN INFIELD(plant_2)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_2
                CALL cl_create_qry() RETURNING tm.plant_2
                DISPLAY BY NAME tm.plant_2
                NEXT FIELD plant_2

             WHEN INFIELD(plant_3)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_3
                CALL cl_create_qry() RETURNING tm.plant_3
                DISPLAY BY NAME tm.plant_3
                NEXT FIELD plant_3

             WHEN INFIELD(plant_4)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_4
                CALL cl_create_qry() RETURNING tm.plant_4
                DISPLAY BY NAME tm.plant_4
                NEXT FIELD plant_4

             WHEN INFIELD(plant_5)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_5
                CALL cl_create_qry() RETURNING tm.plant_5
                DISPLAY BY NAME tm.plant_5
                NEXT FIELD plant_5

             WHEN INFIELD(plant_6)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_6
                CALL cl_create_qry() RETURNING tm.plant_6
                DISPLAY BY NAME tm.plant_6
                NEXT FIELD plant_6

             WHEN INFIELD(plant_7)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_7
                CALL cl_create_qry() RETURNING tm.plant_7
                DISPLAY BY NAME tm.plant_7
                NEXT FIELD plant_7

             WHEN INFIELD(plant_8)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zxy"
                  LET g_qryparam.arg1 = g_user
                  LET g_qryparam.default1 = tm.plant_8
                  CALL cl_create_qry() RETURNING tm.plant_8
                  DISPLAY BY NAME tm.plant_8
                  NEXT FIELD plant_8
         END CASE

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r376_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

#FUN-BB0173 add END
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.sort,tm.b,tm.c, #CHI-B10029 add tm.c
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.p1,tm.p2,tm.p3,   #CHI-7C0027
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,
                 tm.more WITHOUT DEFAULTS
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF
 
      AFTER FIELD sort
         IF cl_null(tm.sort) OR tm.sort NOT MATCHES '[12]' THEN
            NEXT FIELD sort
         END IF

      #CHI-B10029 add --start--
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
      #CHI-B10029 add --end--
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)    #No.FUN-660116
#            NEXT FIELD p1 
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
# 
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
# 
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
# 
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p6 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
# 
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p7 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p8 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#         CASE
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r376_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axrr376'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr376','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'" ,
                     " '",tm.bdate CLIPPED,"'",
                     " '",tm.edate CLIPPED,"'",
                     " '",tm.type CLIPPED,"'" ,
                     " '",tm.sort CLIPPED,"'" ,   
                     " '",tm.b CLIPPED,"'" ,    #CHI-7C0027
                     " '",tm.c CLIPPED,"'" ,    #CHI-B10029 add
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                     " '",tm.p1 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p2 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p3 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p4 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p5 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p6 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p7 CLIPPED,"'" ,   #TQC-610059
#                     " '",tm.p8 CLIPPED,"'" ,   #TQC-610059
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
            #FUN-BB0173 add START
                      " '",plant[1] CLIPPED,"'",
                      " '",plant[2] CLIPPED,"'",
                      " '",plant[3] CLIPPED,"'",
                      " '",plant[4] CLIPPED,"'",
                      " '",plant[5] CLIPPED,"'",
                      " '",plant[6] CLIPPED,"'",
                      " '",plant[7] CLIPPED,"'",
                      " '",plant[8] CLIPPED,"'",
            #FUN-BB0173 add END
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                     " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr376',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r376_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r376()
   ERROR ""
END WHILE
   CLOSE WINDOW r376_w
END FUNCTION
 
FUNCTION r376()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name  #No.FUN-680123 VARCHAR(20)
          l_sql     STRING,                     # No.TQC-A50082
          l1_sql    LIKE type_file.chr1000,     # No.FUN-5B0139 RDSQL condition #No.FUN-680123 VARCHAR(200)
          l1_i      LIKE type_file.num5,        # No.FUN-5B0139 #No.FUN-680123 SMALLINT
          l1_cnt    LIKE type_file.num5,        # No.FUN-5B0139 #No.FUN-680123 SMALLINT
          l_omb04   LIKE omb_file.omb04,        #No.FUN-5B0139
          l_za05    LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(40)
          l_dbs     LIKE azp_file.azp03,
          l_oob09   LIKE oob_file.oob09,
          l_oob10   LIKE oob_file.oob10,
          l_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          sr        RECORD
                    order1   LIKE oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
                    order2   LIKE cre_file.cre08,        #No.FUN-680123 VARCHAR(10)
                    oma00    LIKE   oma_file.oma00,          #帳款類別
                    oma01    LIKE   oma_file.oma01,          #帳款單號
                    oma03    LIKE   oma_file.oma03,          #帳款客戶編號
                    oma032   LIKE   oma_file.oma032,         #客戶簡稱
                    oma08    LIKE   oma_file.oma08,          #內外銷
                    oma10    LIKE   oma_file.oma10,          #發票號碼
                    oma14    LIKE   oma_file.oma14,          #業務員
                    oma23    LIKE   oma_file.oma23,          #幣別
                    oma24    LIKE   oma_file.oma24,          #匯率
                    oma39    LIKE   oma_file.oma39,          #INVOICE
                    oma40    LIKE   oma_file.oma40,          #非,關係人
                    omaconf  LIKE   oma_file.omaconf,        #確認否
                    omavoid  LIKE   oma_file.omavoid,        #作廢否
                    occ37    LIKE   occ_file.occ37,
                    oma02    LIKE   oma_file.oma02,           #立帳日
                    oma54t    LIKE   oma_file.oma54t,
                    oma55     LIKE   oma_file.oma55,
                    oma56t    LIKE   oma_file.oma56t,
                    oma57     LIKE   oma_file.oma57,
                    oob09     LIKE   oob_file.oob09,   #MOD-630116
                    oob10     LIKE   oob_file.oob10    #MOD-630116
                    END RECORD
   DEFINE sr2       RECORD
                    oga02      LIKE   oga_file.oga02,
                    omb31      LIKE   omb_file.omb31,
                    omb32      LIKE   omb_file.omb32,
                    ogb04      LIKE   ogb_file.ogb04,
                    omb14t     LIKE   omb_file.omb14t,
                    omb34      LIKE   omb_file.omb34,
                    omb16t     LIKE   omb_file.omb16t,
                    omb35      LIKE   omb_file.omb35,
                    omb03      LIKE   omb_file.omb03,   
                    oob09      LIKE   oob_file.oob09,   
                    oob10      LIKE   oob_file.oob10,
                    omb44      LIKE   omb_file.omb44     #FUN-A60056    
                    END RECORD
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_amt7    LIKE type_file.num20_6             
   DEFINE l_amt8    LIKE type_file.num20_6             
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_oox01   STRING                 #CHI-830003 add
   DEFINE l_oox02   STRING                 #CHI-830003 add
   DEFINE l_str_1   STRING                 #CHI-830003 add
   DEFINE l_sql_1   STRING                 #CHI-830003 add
   DEFINE l_sql_2   STRING                 #CHI-830003 add
   DEFINE l_omb03_1 LIKE omb_file.omb03    #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5    #CHI-830003 add
   DEFINE l_oma24   LIKE oma_file.oma24    #CHI-830003 add                   
   DEFINE l_wc      STRING                 #CHI-B10029 add
   DEFINE l_oox01_02  LIKE type_file.chr10 #TQC-B30003 add
 
   CALL  cl_del_data(l_table)                        #FUN-7B0026
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr376'      #FUN-7B0026 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
 
   DELETE FROM curr_tmp;
 
   LET g_yy = YEAR(tm.bdate)
   LET g_mm = MONTH(tm.bdate)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
 
 
   IF g_ooz.ooz62='N' THEN
      LET g_zaa[47].zaa06='Y'
      LET g_zaa[48].zaa06='Y'
      LET g_zaa[49].zaa06='Y'
      LET g_zaa[50].zaa06='Y'
      LET g_zaa[51].zaa06='Y'
      LET g_zaa[52].zaa06='Y'
      LET g_zaa[53].zaa06='Y'
   ELSE
      LET g_zaa[47].zaa06='N'
      LET g_zaa[48].zaa06='N'
      LET g_zaa[49].zaa06='N'
      LET g_zaa[50].zaa06='N'
      LET g_zaa[51].zaa06='N'
      LET g_zaa[52].zaa06='N'
      LET g_zaa[53].zaa06='N'
   END IF
   CALL cl_prt_pos_len()

   #CHI-B10029 add --start--
   #讀取折讓金額
   IF tm.c = 'Y' THEN
      LET l_wc = " (oma00 like '1%' OR oma00 like '2%')"
   ELSE
      LET l_wc = " oma00 like '1%' "
   END IF
   #CHI-B10029 add --end--
 
   LET g_pageno = 0
#   FOR l_i = 1 to 8
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-BB0173 add START
    LET l_i = 1
    FOR l_i = 1 TO g_ary_i
       IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END
       LET l_sql = " SELECT ' ',' ',oma00,oma01, ",
                   " oma03, oma032, oma08,oma10, oma14,oma23, oma24,oma39, ",
                   " oma40,omaconf, omavoid,occ37,",
                   " oma02,oma54t,oma55,oma56t,oma57,0,0 ",    #MOD-630116
#                  " FROM ",l_dbs CLIPPED,"oma_file,",
#                           l_dbs CLIPPED,"occ_file ",
                  #" FROM oma_file,occ_file", #FUN-BB0173 mark
                   " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),   #FUN-BB0173 add
                   " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),       #FUN-BB0173 add
                   " WHERE oma03 = occ01",
                  #" AND (oma00 LIKE '1%' OR oma00 LIKE '2%')",   #MOD-830172   #CHI-B10029 mark
                   " AND ",l_wc CLIPPED,                                        #CHI-B10029 add
                   " AND omaconf = 'Y' AND omavoid = 'N' ",
                   " AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   " AND ",tm.wc CLIPPED
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE r376_prepare1 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM 
       END IF
  
       DECLARE r376_curs1 CURSOR FOR r376_prepare1
       FOREACH r376_curs1 INTO sr.*
          IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
             EXIT PROGRAM 
          END IF
          
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(tm.edate)
         LET l_oox02 = MONTH(tm.edate)                      	 
         LET l_oma24 = ''    #TQC-B10083 add
         WHILE cl_null(l_oma24)
            LET l_oox02 = l_oox02 USING '&&'
            LET l_oox01_02 = l_oox01*12 + l_oox02
            IF g_ooz.ooz62 = 'N' THEN
               LET l_sql_2 = "SELECT COUNT(*) ",
                            #"  FROM oox_file",  #FUN-BB0173 mark
                             "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                            #" WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",  #TQC-B30003 mark
                            #"   AND oox02 <= '",l_oox02,"'",                   #TQC-B30003 mark
                             " WHERE oox00 = 'AR' ",                             #TQC-B30003
                             "   AND (oox01*12+oox02) <= '",l_oox01_02,"'",      #TQC-B30003
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2    #FUN-BB0173 add 
               PREPARE r376_prepare7 FROM l_sql_2
               DECLARE r376_oox7 CURSOR FOR r376_prepare7
               OPEN r376_oox7
               FETCH r376_oox7 INTO l_count
               CLOSE r376_oox7                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'    #TQC-B10083 mark 
                  EXIT WHILE            #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 ",
                               #" FROM oox_file",  #FUN-BB0173 mark  
                                " FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
               LET l_sql_2 = "SELECT COUNT(*) ", 
                             " FROM oox_file",  #FUN-BB0173 mark
                             " FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                             #" WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",  #TQC-B30003 mark
                             #"   AND oox02 <= '",l_oox02,"'",                   #TQC-B30003 mark
                             " WHERE oox00 = 'AR' ",                             #TQC-B30003
                             "   AND (oox01*12+oox02) <= '",l_oox01_02,"'",      #TQC-B30003
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2   #FUN-BB0173 add
               PREPARE r376_prepare8 FROM l_sql_2
               DECLARE r376_oox8 CURSOR FOR r376_prepare8
               OPEN r376_oox8
               FETCH r376_oox8 INTO l_count
               CLOSE r376_oox8                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'    #TQC-B10083 mark 
                  EXIT WHILE            #TQC-B10083 add
               ELSE            
                  SELECT MIN(omb03) INTO l_omb03_1 FROM omb_file
                   WHERE omb01 = sr.oma01
                  IF cl_null(l_omb03_1) THEN
                     LET l_omb03_1 = 0
                  END IF       
                  LET l_sql_1 = "SELECT oox07 ",
                               #"  FROM oox_file",   #FUN-BB0173 mark 
                                " FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03_1,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r376_prepare07 FROM l_sql_1
               DECLARE r376_oox07 CURSOR FOR r376_prepare07
               OPEN r376_oox07
               FETCH r376_oox07 INTO l_oma24
               CLOSE r376_oox07
            END IF              
         END WHILE              
      END IF
          
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oma14
          IF STATUS THEN LET l_gen02=' ' END IF
 
          SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07  #�  劊    
            FROM azi_file
           WHERE azi01=sr.oma23
          LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",
#                     "  FROM ",l_dbs CLIPPED,"oob_file,",
#                               l_dbs CLIPPED,"ooa_file ",
                     #"  FROM oob_file,ooa_file",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),     #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),          #FUN-BB0173 add  
                      " WHERE oob01=ooa01",
                      "   AND oob06=?",
                      "   AND ooa02>?",
                      "   AND ooa37 = '1'",                  #FUN-B20019 add
                      "   AND ooaconf='Y'",
                      "   AND ((oob03='1' AND oob04='3') OR ",
                      "        (oob03='2' AND oob04='1')) "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE r376_prepare3 FROM l_sql
          DECLARE r376_c3  CURSOR FOR r376_prepare3
          OPEN r376_c3 USING sr.oma01,tm.edate
          FETCH r376_c3 INTO sr.oob09,sr.oob10
          IF cl_null(sr.oob09) THEN
             LET sr.oob09 = 0
          END IF
          
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN            #TQC-B10083 mark
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN     #TQC-B10083 mod
             LET sr.oob10 = sr.oob09 * l_oma24
             LET sr.oma56t = sr.oma54t * l_oma24
             LET sr.oma57 = sr.oma55 * l_oma24
          END IF    
          
          IF cl_null(sr.oob10) THEN
             LET sr.oob10 = 0
          END IF
 
          IF tm.b = 'N' AND 
             sr.oma56t-sr.oma57+sr.oob10 = 0 THEN
             CONTINUE FOREACH
          END IF
 
          LET sr.oma40 = sr.occ37
          IF cl_null(sr.oma40) THEN LET sr.occ37 = 'N' END IF
          IF tm.type = '1' THEN
             IF sr.occ37  = 'N' THEN  CONTINUE FOREACH END IF
          END IF
          IF tm.type = '2' THEN   #非關係人
             IF sr.occ37  = 'Y' THEN  CONTINUE FOREACH END IF
          END IF
          #依何種方式排序
          IF tm.sort = '1' THEN
             LET sr.order1 = sr.oma03
             LET sr.order2 = sr.oma14
          ELSE
             IF tm.sort = '2' THEN
                LET sr.order1 = sr.oma14
                LET sr.order2 = sr.oma03
            END IF
          END IF
          IF g_ooz.ooz62 = 'Y' THEN
            #LET l_sql = " SELECT '',omb31,omb32,'',omb14t,",      #MOD-B40123 mark
             LET l_sql = " SELECT '',omb31,omb32,omb04,omb14t,",   #MOD-B40123
                    "        omb34,omb16t,omb35,omb03,0,0,omb44",    #FUN-A60056 add omb44
#                   " FROM ",l_dbs CLIPPED,"oma_file,",l_dbs CLIPPED,"omb_file LEFT OUTER JOIN (SELECT ogb01,ogb03 FROM ",l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ogb_file WHERE ogb01 = oga01 ) tmp ON omb_file.omb31=tmp.ogb01 AND omb_file.omb32=tmp.ogb03, ",l_dbs CLIPPED,"occ_file",
                   #" FROM  oma_file,omb_file,occ_file",   #FUN-BB0173 mark 
                    " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),      #FUN-BB0173 add
                    " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),          #FUN-BB0173 add
                    " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),          #FUN-BB0173 add  
                       " WHERE oma03 = occ01",        #FUN-9B0014
                      " AND oma01 = omb01 ",
                     #" AND (oma00 LIKE '1%' OR oma00 LIKE '2%')",  #CHI-B10029 mark
                      " AND ",l_wc CLIPPED,                         #CHI-B10029 add
                      " AND omaconf = 'Y' AND omavoid = 'N' ",
                      " AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                      " AND oma01 = '",sr.oma01,"'",
                      " AND ",tm.wc CLIPPED
 
             IF g_aza.aza26 = '2' THEN
                FOR l1_i = 1 TO (LENGTH(tm.wc CLIPPED)-4)
                   IF tm.wc[l1_i,l1_i+4] = 'ogb04' THEN
                      LET tm.wc[l1_i,l1_i+4] = 'omb04'
                   END IF
                END FOR
                LET l_sql = l_sql CLIPPED,
                            " UNION ",
                           #" SELECT '',omb31,omb32,'',omb14t,",       #MOD-B40123 mark
                            " SELECT '',omb31,omb32,omb04,omb14t,",    #MOD-B40123
                            "        omb34,omb16t,omb35,omb03,0,0,omb44",     #FUN-A60056 add omb44  
#                           "  FROM ",l_dbs CLIPPED,"oma_file,",
#                                    l_dbs CLIPPED,"omb_file,",
#                                    l_dbs CLIPPED,"oot_file,",
#                                    l_dbs CLIPPED,"occ_file ",
                           #"  FROM oma_file,omb_file,oot_file,occ_file ",  #FUN-BB0173 mark
                            "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),   #FUN-BB0173 add
                            "  ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),       #FUN-BB0173 add
                            "  ,",cl_get_target_table(g_ary[l_i].plant,'oot_file'),       #FUN-BB0173 add
                            "  ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),       #FUN-BB0173 add
                            " WHERE oma03 = occ01 ",
                           #"   AND (oma00 LIKE '1%' OR oma00 LIKE '2%')",   #MOD-830172 #CHI-B10029 mark
                            "   AND ",l_wc CLIPPED,                                      #CHI-B10029 add
                            "   AND omaconf = 'Y' AND omavoid = 'N' ",
                            "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                            "   AND oma01 = oot03  ",
                            "   AND oot01 = omb01  ",
                            "   AND omb01 IN (SELECT DISTINCT oot01 ",
                           #"  FROM oot_file ",  #FUN-BB0173 mark
                            "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oot_file'),    #FUN-BB0173 add
                            " WHERE oot03 IN (SELECT DISTINCT oma01 ",
#                           "  FROM ",l_dbs CLIPPED,"oma_file,",
#                                    l_dbs CLIPPED,"omb_file",
                           #"  FROM oma_file,omb_file ",  #FUN-BB0173 mark
                            "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),    #FUN-BB0173 add
                            "  ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),        #FUN-BB0173 add
                           #" WHERE (oma00 LIKE '1%' OR oma00 LIKE '2%')",   #MOD-830172 #CHI-B10029 mark
                            " WHERE ",l_wc CLIPPED,                                      #CHI-B10029 add
                            "   AND omaconf = 'Y' AND omavoid = 'N' ",
                            "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                            "   AND oma01 = omb01 ",
                            "   AND ",tm.wc CLIPPED, "))"
             END IF
 
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             PREPARE r376_prepare2 FROM l_sql
             DECLARE r376_curs2 CURSOR FOR r376_prepare2
             FOREACH r376_curs2 INTO sr2.*
                LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",
#                           "  FROM ",l_dbs CLIPPED,"oob_file,",
#                                     l_dbs CLIPPED,"ooa_file ",
                           #"  FROM oob_file,ooa_file",   #FUN-BB0173 mark
                            "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),   #FUN-BB0173 add
                            "  ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),       #FUN-BB0173 add
                            " WHERE oob01=ooa01",
                            "   AND oob06=?",
                            "   AND oob15=?",
                            "   AND ooa02>?",
                            "   AND ooa37 = '1'",                  #FUN-B20019 add
                            "   AND ooaconf='Y'",
                            "   AND ((oob03='1' AND oob04='3') OR ",
                            "        (oob03='2' AND oob04='1')) "
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                PREPARE r376_prepare4 FROM l_sql
                DECLARE r376_c4  CURSOR FOR r376_prepare4
                OPEN r376_c4 USING sr.oma01,sr2.omb03,tm.edate
                FETCH r376_c4 INTO sr2.oob09,sr2.oob10
                IF cl_null(sr2.oob09) THEN
                   LET sr2.oob09 = 0
                END IF
                #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
                IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
                   LET sr2.oob10 = sr2.oob09 * l_oma24
                   LET sr2.omb16t = sr2.omb14t * l_oma24
                   LET sr2.omb35 = sr2.omb34 * l_oma24
                END IF    
                IF cl_null(sr2.oob10) THEN
                   LET sr2.oob10 = 0
                END IF
               #-MOD-B40123-add-
                LET l_ima02 = ''
                LET l_ima021 = ''
                SELECT ima02,ima021 INTO l_ima02,l_ima021
                  FROM ima_file
                 WHERE ima01=sr2.ogb04
               #-MOD-B40123-end-
                LET l_cnt = 0
               #FUN-A60056--mod--str--
               #SELECT COUNT(*) INTO l_cnt FROM oga_file
               # WHERE oga01=sr2.omb31
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(sr2.omb44,'oga_file'),
                            " WHERE oga01='",sr2.omb31,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                PREPARE sel_cou_oga FROM g_sql
                EXECUTE sel_cou_oga INTO l_cnt
               #FUN-A60056--mod--end
                IF l_cnt > 0 THEN
                   LET sr2.ogb04 = '' #MOD-B40123
                  #FUN-A60056--mod--str--
                  #SELECT oga02 INTO sr2.oga02 FROM oga_file WHERE oga01=sr2.omb31
                  #SELECT ogb04 INTO sr2.ogb04 FROM ogb_file
                  # WHERE ogb01 = sr2.omb31
                  #   AND ogb03 = sr2.omb32
                   LET l_sql = "SELECT oga02 FROM ",cl_get_target_table(sr2.omb44,'oga_file'),
                               " WHERE oga01='",sr2.omb31,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                   PREPARE sel_oga02_pre FROM l_sql
                   EXECUTE sel_oga02_pre INTO sr2.oga02

                   LET l_sql = "SELECT ogb04 FROM ",cl_get_target_table(sr2.omb44,'ogb_file'),
                               " WHERE ogb01 = '",sr2.omb31,"' AND ogb03 = '",sr2.omb32,"'" 
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                   PREPARE sel_ogb04 FROM l_sql
                   EXECUTE sel_ogb04 INTO sr2.ogb04
                  #FUN-A60056--mod--end
                   LET l_ima02=' '
                   LET l_ima021=' '
                   SELECT ima02,ima021 INTO l_ima02,l_ima021
                     FROM ima_file
                    WHERE ima01=sr2.ogb04
                ELSE
                   LET l_cnt = 0
                  #FUN-A60056--mod--str-- 
                  #SELECT COUNT(*) INTO l_cnt FROM oha_file
                  # WHERE oha01 = sr2.omb31
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(sr2.omb44,'oha_file'),
                               " WHERE oha01 = '",sr2.omb31,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                   PREPARE sel_cou_oha FROM l_sql
                   EXECUTE sel_cou_oha INTO l_cnt
                  #FUN-A60056--mod--end
                   IF l_cnt > 0 THEN 
                      LET sr2.ogb04 = '' #MOD-B40123
                     #FUN-A60056--mod--str--
                     #SELECT oha02 INTO sr2.oga02 FROM oha_file WHERE oha01=sr2.omb31
                     #SELECT ohb04 INTO sr2.ogb04 FROM ohb_file
                     # WHERE ohb01 = sr2.omb31
                     #   AND ohb03 = sr2.omb32
                      LET l_sql = "SELECT oha02 FROM ",cl_get_target_table(sr2.omb44,'oha_file'),
                                  " WHERE oha01='",sr2.omb31,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                      CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                      PREPARE sel_oha02_pre FROM l_sql
                      EXECUTE sel_oha02_pre INTO sr2.oga02

                      LET l_sql = "SELECT ohb04 FROM ",cl_get_target_table(sr2.omb44,'ohb_file'),
                                  " WHERE ohb01 = '",sr2.omb31,"'",
                                  "   AND ohb03 = '",sr2.omb32,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                      CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                      PREPARE sel_ohb04_pre FROM l_sql
                      EXECUTE sel_ohb04_pre INTO sr2.ogb04 
                     #FUN-A60056--mod--end
                      LET l_ima02=' '
                      LET l_ima021=' '
                      SELECT ima02,ima021 INTO l_ima02,l_ima021
                        FROM ima_file
                       WHERE ima01=sr2.ogb04
                   END IF   #MOD-830172
                END IF
                LET l_amt7 = sr2.omb14t-sr2.omb34+sr2.oob09   #MOD-830172
                LET l_amt8 = sr2.omb16t-sr2.omb35+sr2.oob10   #MOD-830172
                IF sr.oma00 LIKE '2%' THEN
                   LET sr.oma54t = sr.oma54t * -1
                   LET sr.oma55  = sr.oma55  * -1
                   LET sr.oob09  = sr.oob09  * -1
                   LET sr.oma56t = sr.oma56t * -1
                   LET sr.oma57  = sr.oma57  * -1
                   LET sr.oob10  = sr.oob10  * -1
                   LET l_amt7 = l_amt7 * -1
                   LET l_amt8 = l_amt8 * -1
                END IF
                #CHI-A50016 add --start--
                LET l_cnt = 0 
                IF sr.oma00 = '21' THEN
                  #FUN-A60056--mod--str--
                  #SELECT COUNT(*) INTO l_cnt FROM ohb_file 
                  # WHERE ohb01 = sr2.omb31
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(sr2.omb44,'ohb_file'),
                               " WHERE ohb01 = '",sr2.omb31,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                   PREPARE sel_cou_ohb FROM l_sql
                   EXECUTE sel_cou_ohb INTO l_cnt
                  #FUN-A60056--mod--end
                   IF l_cnt = 1 THEN
                     #FUN-A60056--mod--str--
                     #SELECT ohb30 INTO sr.oma10 FROM ohb_file
                     # WHERE ohb01 = sr2.omb31
                     #   AND ohb03 = sr2.omb32
                      LET l_sql = "SELECT ohb30 FROM ",cl_get_target_table(sr2.omb44,'ohb_file'),
                                  " WHERE ohb01 = '",sr2.omb31,"'",
                                  "   AND ohb03 = '",sr2.omb32,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                      CALL cl_parse_qry_sql(l_sql,sr2.omb44) RETURNING l_sql
                      PREPARE sel_ohb30_pre FROM l_sql
                      EXECUTE sel_ohb30_pre INTO sr.oma10
                     #FUN-A60056--mod--end
                   ELSE
                      LET sr.oma10 = ' '
                   END IF
                END IF 
                #CHI-A50016 add --end--

                EXECUTE insert_prep USING
                   sr.oma00, sr.oma01,  sr.oma03,  sr.oma032,sr.oma08,
                   sr.oma10, sr.oma14,  sr.oma23,  sr.oma24, sr.oma39,
                   sr.oma40, sr.omaconf,sr.omavoid,sr.occ37, sr.oma02,
                   sr.oma54t,sr.oma55,  sr.oma56t, sr.oma57, sr.oob09,
                   sr.oob10, t_azi04,   t_azi05,   t_azi07,  l_gen02,
                   sr2.oga02,sr2.omb31, sr2.omb32, sr2.ogb04,l_ima02,
                   l_ima021, l_amt7,    l_amt8
             END FOREACH
 
          ELSE
             LET sr2.oga02 = ''
             LET sr2.omb31 = ''
             LET sr2.omb32 = 0
             LET sr2.ogb04 = ''
             LET l_ima02   = ''
             LET l_ima021  = ''
             LET l_amt7    = 0
             LET l_amt8    = 0
             IF sr.oma00 LIKE '2%' THEN
                LET sr.oma54t = sr.oma54t * -1
                LET sr.oma55  = sr.oma55  * -1
                LET sr.oob09  = sr.oob09  * -1
                LET sr.oma56t = sr.oma56t * -1
                LET sr.oma57  = sr.oma57  * -1
                LET sr.oob10  = sr.oob10  * -1
             END IF
             EXECUTE insert_prep USING
                sr.oma00, sr.oma01,  sr.oma03,  sr.oma032,sr.oma08,
                sr.oma10, sr.oma14,  sr.oma23,  sr.oma24, sr.oma39,
                sr.oma40, sr.omaconf,sr.omavoid,sr.occ37, sr.oma02,
                sr.oma54t,sr.oma55,  sr.oma56t, sr.oma57, sr.oob09,
                sr.oob10, t_azi04,   t_azi05,   t_azi07,  l_gen02,
                sr2.oga02,sr2.omb31, sr2.omb32, sr2.ogb04,l_ima02,
                l_ima021, l_amt7,    l_amt8
          END IF  
       END FOREACH
#  END FOR
   END FOR           #FUN-BB0173 add 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'oma01,oma00,oma18,oma10,oma03,omauser,oma14')
            RETURNING tm.wc
   END IF
   LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",tm.type,";",tm.sort,";",
               g_azi04,";",g_aza.aza34,";",g_azi05
   IF g_ooz.ooz62 = 'N' THEN
      CALL cl_prt_cs3('axrr376','axrr376',g_sql,g_str)
   ELSE
      CALL cl_prt_cs3('axrr376','axrr376_1',g_sql,g_str)
   END IF
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
END FUNCTION
#NO.FUN-9C0072 精簡程式碼
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r376_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("Group1",FALSE)
     LET g_flag = TRUE  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION r376_legal_db(p_string)
DEFINE p_string  STRING
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw09   LIKE azw_file.azw09
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_sql     STRING
   IF cl_null(p_string) THEN
      LET p_string = g_plant
   END IF
   LET g_ary_i = 1
   LET g_errno = ' '

   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
               "  WHERE azw01 IN ( ",p_string," ) "
   PREPARE r140_azw01_pre FROM l_sql
   DECLARE r140_azw01_cs CURSOR FOR r140_azw01_pre
   FOREACH r140_azw01_cs INTO g_ary[g_ary_i].plant
      LET g_ary_i = g_ary_i + 1
   END FOREACH
   LET g_ary_i = g_ary_i - 1

END FUNCTION
#FUN-BB0173 add END
