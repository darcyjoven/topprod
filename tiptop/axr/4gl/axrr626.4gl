# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr626.4gl
# Descriptions...: 客戶帳齡明細表列印(依預計收款日)
# Date & Author..: 98/11/11 by Jimmy
# Modify.........: No:9017 03/12/13 By Kitty 改長度
# Modify.........: No:B064 04/05/14 By Kitty l_curr除去
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-570038 05/07/08 By Nicola 此表末包括折讓
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-580010 05/08/11 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-5C0069 05/12/14 By Carrier ooz07='N'-->oma56t-oma57
#                                                    ooz07='Y'-->oma61
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680022 06/08/09 By Tracy 多帳期修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/19 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-690144 06/12/06 By Smapmin 抓取g_title的值應於cl_outnam之後
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  修改報表格式                       
# Modify.........: No.MOd-720047 07/03/11 by TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-760027 07/06/14 By Smapmin 增加傳遞本國幣別參數
# Modify.........: No.FUN-740002 07/07/09 By xufeng 帳齡修改為六段
# Modify.........: No.TQC-790101 07/09/17 By Judy "帳齡分段"為控管
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
#                                                       若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-8C0019 08/12/14 By jan
# Modify.........: No.MOD-920257 09/02/23 By Sarah 增加ooa_file回溯已沖金額
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.TQC-A50082 10/05/24 By Carrier MAIN中结构调整 & CHI-970019追单
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70084 10/07/22 By lutingting 拿掉INPUT 營運中心,原本跨庫寫法改為不跨庫 
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_oma24應給予預設值'',抓不到值不應給'1'
# Modify.........: No.FUN-B20033 11/02/17 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.MOD-BA0182 11/10/25 By Polly 已沖帳戶(已收款項)，不需印
# Modify.........: No:FUN-BB0173 12/01/16 by pauline 增加跨法人抓取資料
# Modify.........: No:MOD-C10118 12/01/06 By Polly 多帳期資料多串omc_file，以免重複計算金額
# Modify.........: No:CHI-C30008 12/04/11 By Lori  日期欄位(num_7)金額計算有誤，應統計應收款日小於為預計收款截止日期-容允天數者為應收未收款
# Modify.........: No.FUN-C40001 12/04/13 By SunLM 增加開窗功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                   # Print condition RECORD
              wc      LIKE type_file.chr1000,          #No.FUN-680123 VARCHAR(1000),             # Where condition
                      choice LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(01),
                      a       LIKE omi_file.omi01,     #No.FUN-740002
                      a1      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
                      a2      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
                      a3      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
                      a4      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
                      a5      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,   #No.FUN-740002
                      a6      LIKE type_file.num5,     #No.FUN-680123 SMALLINT,   #No.FUN-740002
                      b       LIKE type_file.num5,     #No.FUN-680123 SMALLINT,   # 允容天數 default 7
                     #FUN-A70084--mark--str--
                     #p1      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p2      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p3      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p4      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p5      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p6      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p7      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #p8      LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10),
                     #FUN-A70084--mark--end
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
                      type    LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(01),
                      edate   LIKE type_file.dat,      #No.FUN-680123 DATE,
                      e       LIKE type_file.chr1,     # Prog. Version..: '5.30.06-13.03.12(01),      #No.FUN-570038
                     #d       LIKE type_file.chr1,     #No.FUN-8C0019   #FUN-A70084
                      s       LIKE type_file.chr3,     #No.FUN-8C0019 VARCHAR(3)
                      t       LIKE type_file.chr3,     #No.FUN-8C0019 VARCHAR(3)
                      u       LIKE type_file.chr3,     #No.FUN-8C0019 VARCHAR(3) 
                      more    LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
     DEFINE     g_title  LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(160)
DEFINE   g_i             LIKE type_file.num5     #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE l_table     STRING                        #FUN-710080 add
DEFINE g_sql       STRING                        #FUN-710080 add
DEFINE g_str       STRING                        #FUN-710080 add
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0019 ARRAY[10] OF VARCHAR(20)   #FUN-A80074
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
 
   #No.TQC-A50082  --Begin
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)
   LET tm.type = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)   #No.FUN-740002
   LET tm.a1 = ARG_VAL(11)
   LET tm.a2 = ARG_VAL(12)
   LET tm.a3 = ARG_VAL(13)
   LET tm.a4 = ARG_VAL(14)
   LET tm.a5 = ARG_VAL(15)   #No.FUN-740002
   LET tm.a6 = ARG_VAL(16)   #No.FUN-740002
   LET tm.edate = ARG_VAL(17)
   LET tm.b = ARG_VAL(18)
   LET tm.e = ARG_VAL(19)
#FUN--A70084--mod--str--
#  LET tm.p1 = ARG_VAL(20)
#  LET tm.p2 = ARG_VAL(21)
#  LET tm.p3 = ARG_VAL(22)
#  LET tm.p4 = ARG_VAL(23)
#  LET tm.p5 = ARG_VAL(24)
#  LET tm.p6 = ARG_VAL(25)
#  LET tm.p7 = ARG_VAL(26)
#  LET tm.p8 = ARG_VAL(27)
#  LET g_rep_user = ARG_VAL(28)
#  LET g_rep_clas = ARG_VAL(29)
#  LET g_template = ARG_VAL(30)
#  LET g_rpt_name = ARG_VAL(31)  #No.FUN-7C0078
#  LET tm.d     = ARG_VAL(32)
#  LET tm.s     = ARG_VAL(33)
#  LET tm.t     = ARG_VAL(34)
#  LET tm.u     = ARG_VAL(35)   
#FUN-BB0173 mark START
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)
   LET tm.s     = ARG_VAL(24)
   LET tm.t     = ARG_VAL(25)
   LET tm.u     = ARG_VAL(26)
#FUN-BB0173 mark END
#FUN-A70084--mod--end
#FUN-BB0173 add START
   LET plant[1] = ARG_VAL(20)
   LET plant[2] = ARG_VAL(21)
   LET plant[3] = ARG_VAL(22)
   LET plant[4] = ARG_VAL(23)
   LET plant[5] = ARG_VAL(24)
   LET plant[6] = ARG_VAL(25)
   LET plant[7] = ARG_VAL(26)
   LET plant[8] = ARG_VAL(27)
   LET g_rep_user = ARG_VAL(28)
   LET g_rep_clas = ARG_VAL(29)
   LET g_template = ARG_VAL(30)
   LET g_rpt_name = ARG_VAL(31)
   LET tm.s     = ARG_VAL(32)
   LET tm.t     = ARG_VAL(33)
   LET tm.u     = ARG_VAL(34)
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
      CALL r626_legal_db(g_azw01_2)
   END IF
#FUN-BB0173 add END

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma14.oma_file.oma14,",  
               "gen02.gen_file.gen02," , 
               "oma15.oma_file.oma15,"  ,
               "oma03.oma_file.oma03,"  ,
               "oma032.oma_file.oma032," ,
               "oma02.oma_file.oma02,"  ,
               "oma01.oma_file.oma01,",
               "omc02.omc_file.omc02, ", 
               "oma11.oma_file.oma11,",
               "occ18.occ_file.occ18,",
               "oag02.oag_file.oag02,",
               "num0.type_file.num20_6,", 
               "num.type_file.num20_6, ",
               "num1.type_file.num20_6, ",
               "num2.type_file.num20_6, ",
               "num3.type_file.num20_6, ",
               "num4.type_file.num20_6, ",
               "num5.type_file.num20_6, ",
               "num6.type_file.num20_6, ",   #No.FUN-740002
               "num7.type_file.num20_6, ",   #No.FUN-740002
               "num_c.type_file.num20_6, ",
               "num_7.type_file.num20_6, ",
               "oma23.oma_file.oma23,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "plant.azp_file.azp01"        #No.FUN-8C0019
 
   LET l_table = cl_prt_temptable('axrr626',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"  #FUN-8C0019 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   DROP TABLE curr_tmp
    CREATE TEMP TABLE curr_tmp
    (curr LIKE azi_file.azi01,
     oma14 LIKE oma_file.oma14,
     oma03 LIKE oma_file.oma03,
     amt1 LIKE type_file.num20_6,
     amt2 LIKE type_file.num20_6,
     amt3 LIKE type_file.num20_6,
     amt4 LIKE type_file.num20_6,
     amt5 LIKE type_file.num20_6,
     amt6 LIKE type_file.num20_6,  #No.FUN-740002 
     amt7 LIKE type_file.num20_6,  #No.FUN-740002
     amtc LIKE type_file.num20_6,
     amt7 LIKE type_file.num20_6)
   #No.TQC-A50082  --End  
   IF cl_null(tm.wc)
      THEN CALL r626_tm(0,0)             # Input print condition
   ELSE 
      CALL r626()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r626_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
          l_cmd          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
#FUN-BB0173 add START
   DEFINE  l_cnt          LIKE type_file.num5
   DEFINE  l_string       STRING
   DEFINE  l_plant        LIKE azw_file.azw01
   DEFINE  l_ac           LIKE type_file.num5
#FUN-BB0173 add END 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r626_w AT p_row,p_col
        WITH FORM "axr/42f/axrr626"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL r626_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a1 = 15
   LET tm.a2 = 30
   LET tm.a3 = 45
   LET tm.a4 = 60
  #LET tm.p1 = g_plant   #FUN-A70084
   LET tm.plant_1 = g_plant   #FUN-BB0173 add
   LET tm.b = 7
   LET tm.choice = '2'
   LET tm.type = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.edate=g_today
   LET tm.e = 'Y'      #No.FUN-570038
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
  #FUN-A70084--mark--str--
  #LET tm.d ='N  '     
  #LET tm.p1=g_plant  
  #CALL p626_set_entry_1()               
  #CALL p626_set_no_entry_1()
  #CALL r626_set_comb()
  #FUN-A70084--mark--end
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma03,oma14,oma15,oma00,oma18
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)#部門
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma03)#賬款客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
            WHEN INFIELD(oma14)#人員編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            WHEN INFIELD(oma18)#科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma18
                 NEXT FIELD oma18
            END CASE
      #No.FUN-C40001  --End   
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r626_w 
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
         CALL r626_legal_db(l_string)

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
      CLOSE WINDOW r626_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#FUN-BB0173 add END

   INPUT BY NAME
         tm.choice,tm.type,tm.a,tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,tm.edate,tm.b,tm.e,   #No.FUN-570038
        #tm.d,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                            #No;FUN-8C0019 add tm.d   #FUN-A70084
         tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,                  #No.FUN-8C0019
         tm.more
                WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
          AFTER FIELD a
             IF NOT cl_null(tm.a) THEN
                SELECT omi11,omi12,omi13,omi14,omi15,omi16
                   INTO tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
                   FROM omi_file
                 WHERE omi01=tm.a
                IF status THEN
                   CALL cl_err3("sel","omi_file",tm.a,"","axr-256","","a",1) 
                   NEXT FIELD a    
                END IF
                DISPLAY BY NAME tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
             END IF
      AFTER FIELD a1
         IF NOT cl_null(tm.a1) THEN 
            IF tm.a1 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a1
            END IF
         END IF
 
      AFTER FIELD a2
         IF NOT cl_null(tm.a2) THEN 
            IF tm.a2 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a2
            END IF
            IF NOT cl_null(tm.a1) THEN
               IF tm.a2 <= tm.a1 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a2
               END IF
            END IF
         END IF
 
      AFTER FIELD a3
         IF NOT cl_null(tm.a3) THEN 
            IF tm.a3 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a3
            END IF
            IF NOT cl_null(tm.a2) THEN
               IF tm.a3 <= tm.a2 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a3
               END IF
            END IF
         END IF
 
      AFTER FIELD a4
         IF NOT cl_null(tm.a4) THEN 
            IF tm.a4 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a4
            END IF
            IF NOT cl_null(tm.a3) THEN
               IF tm.a4 <= tm.a3 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a4
               END IF
            END IF
         END IF
 
      AFTER FIELD a5
         IF NOT cl_null(tm.a5) THEN 
            IF tm.a5 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a5
            END IF
            IF NOT cl_null(tm.a4) THEN
               IF tm.a5 <= tm.a4 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a5
               END IF
            END IF
         END IF
 
      AFTER FIELD a6
         IF NOT cl_null(tm.a6) THEN 
            IF tm.a6 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a6
            END IF
            IF NOT cl_null(tm.a5) THEN
               IF tm.a6 <= tm.a5 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a6
               END IF
            END IF
         END IF
 
      AFTER FIELD choice
         IF tm.choice IS NULL THEN NEXT FIELD choice END IF
         IF tm.choice NOT MATCHES '[12]' THEN NEXT FIELD choice END IF
 
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF   
      
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
         
#FUN-A70084--mark--str--
#     AFTER FIELD d
#        IF NOT cl_null(tm.b)  THEN
#           IF tm.d NOT MATCHES "[YN]" THEN
#              NEXT FIELD d       
#           END IF
#        END IF
#                   
#        ON CHANGE  d
#           LET tm.p1=g_plant
#           LET tm.p2=NULL
#           LET tm.p3=NULL
#           LET tm.p4=NULL
#           LET tm.p5=NULL
#           LET tm.p6=NULL
#           LET tm.p7=NULL
#           LET tm.p8=NULL
#           DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#           CALL p626_set_entry_1()      
#           CALL p626_set_no_entry_1()
#           CALL r626_set_comb()
#           
#     AFTER FIELD p1
#        IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#        SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#        IF STATUS THEN 
#           CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#           NEXT FIELD p1 
#        END IF
#        IF NOT cl_null(tm.p1) THEN 
#           IF NOT s_chk_demo(g_user,tm.p1) THEN              
#              NEXT FIELD p1
#           END IF  
#        END IF              
#
#     AFTER FIELD p2
#        IF NOT cl_null(tm.p2) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p2 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p2) THEN
#              NEXT FIELD p2
#           END IF            
#        END IF
#
#     AFTER FIELD p3
#        IF NOT cl_null(tm.p3) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p3 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p3) THEN
#              NEXT FIELD p3
#           END IF            
#        END IF
#
#     AFTER FIELD p4
#        IF NOT cl_null(tm.p4) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p4 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p4) THEN
#              NEXT FIELD p4
#           END IF            
#        END IF
#
#     AFTER FIELD p5
#        IF NOT cl_null(tm.p5) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#              NEXT FIELD p5 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p5) THEN
#              NEXT FIELD p5
#           END IF            
#        END IF
#
#     AFTER FIELD p6
#        IF NOT cl_null(tm.p6) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p6 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p6) THEN
#              NEXT FIELD p6
#           END IF            
#        END IF
#
#     AFTER FIELD p7
#        IF NOT cl_null(tm.p7) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#              NEXT FIELD p7 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p7) THEN
#              NEXT FIELD p7
#           END IF            
#        END IF
#
#     AFTER FIELD p8
#        IF NOT cl_null(tm.p8) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p8 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p8) THEN
#              NEXT FIELD p8
#           END IF            
#        END IF        
#FUN-A70084--mark--end
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form= 'q_omi01'
               LET g_qryparam.default1=tm.a
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
#FUN-A70084--mark--str--
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.TQC-A50082
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#FUN-A70084--mark--end
         END CASE
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3   
      
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
      LET INT_FLAG = 0 CLOSE WINDOW r626_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr626'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr626','9031',1)
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
                         " '",tm.choice CLIPPED,"'" ,
                         " '",tm.type CLIPPED,"'" ,   #TQC-610059
                         " '",tm.a CLIPPED,"'" ,    #No.FUN-740002
                         " '",tm.a1 CLIPPED,"'" ,
                         " '",tm.a2 CLIPPED,"'" ,
                         " '",tm.a3 CLIPPED,"'" ,
                         " '",tm.a4 CLIPPED,"'" ,
                         " '",tm.a5 CLIPPED,"'" ,   #No.FUN-740002
                         " '",tm.a6 CLIPPED,"'" ,   #No.FUN-740002
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.e CLIPPED,"'" ,     #No.FUN-570038
                        #FUN-A70084--mark--str--
                        #" '",tm.p1 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p2 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p3 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p4 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p5 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p6 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p7 CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.p8 CLIPPED,"'" ,   #TQC-610059
                        #FUN-A70084--mark--end
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
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                        #" '",tm.d CLIPPED,"'" ,    #FUN-8C0019   #FUN-A70084
                         " '",tm.s CLIPPED,"'" ,    #FUN-8C0019
                         " '",tm.t CLIPPED,"'" ,    #FUN-8C0019
                         " '",tm.u CLIPPED,"'"      #FUN-8C0019
         CALL cl_cmdat('axrr626',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r626_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r626()
   ERROR ""
END WHILE
   CLOSE WINDOW r626_w
END FUNCTION
 
FUNCTION r626()
   DEFINE l_name      LIKE type_file.chr20,    #No.FUN-680123 VARCHAR(20),  # External(Disk) file name
          l_time      LIKE type_file.chr8,     #No.FUN-680123 VARCHAR(8),   # Used time for running the job
         #l_sql       LIKE type_file.chr1000,  #No.FUN-680123 VARCHAR(1000),  #FUN-BB0173 mark
          l_sql       STRING,                  #FUN-BB0173 add 
          amt1,amt2   LIKE type_file.num20_6,  #No.FUN-680123 DEC(20,6),
          l_za05      LIKE type_file.chr1000,  #No.FUN-680123 VARCHAR(40),
          l_omavoid   LIKE oma_file.omavoid,
          l_omaconf   LIKE oma_file.omaconf,
          l_bucket    LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
          l_day       LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
          l_order     ARRAY[5] OF LIKE cre_file.cre08,    #No.FUN-680123 VARCHAR(10),
          sr          RECORD
                        oma14     LIKE oma_file.oma14,    #業務員編號
                        gen02     LIKE gen_file.gen02,    #業務員name
                        oma15     LIKE oma_file.oma15,    #部門
                        oma03     LIKE oma_file.oma03,    #客戶
                        oma032    LIKE oma_file.oma032,   #簡稱
                        oma02     LIKE oma_file.oma02,    #Date
                        oma01     LIKE oma_file.oma01,
                        omc02     LIKE omc_file.omc02,    #No.FUN-680022
                        oma11     LIKE oma_file.oma11,
                        occ18     LIKE occ_file.occ18,
                        oag02     LIKE oag_file.oag02,
                        num0      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num       LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num1      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num2      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num3      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num4      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num5      LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num6      LIKE type_file.num20_6, #No.FUN-740002
                        num7      LIKE type_file.num20_6, #No.FUN-740002
                        num_c     LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        num_7     LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
                        oma23     LIKE oma_file.oma23,
                        azi03     LIKE azi_file.azi03,    #No.FUN-8C0019
                        azi04     LIKE azi_file.azi04,    #No.FUN-8C0019
                        azi05     LIKE azi_file.azi05     #No.FUN-8C0019 
                      END RECORD
   DEFINE l_i         LIKE type_file.num5   #No.FUN-680123 SMALLINT
   DEFINE l_p         LIKE azp_file.azp01   #No.FUN-680123 VARCHAR(10)
   DEFINE l_plant     LIKE type_file.chr20  #No.FUN-680123 VARCHAR(20)    #No:9017
   DEFINE l_azi03     LIKE azi_file.azi03 
   DEFINE l_azi04     LIKE azi_file.azi04 
   DEFINE l_azi05     LIKE azi_file.azi05
   DEFINE l_oma00     LIKE oma_file.oma00   #No.FUN-570038
   DEFINE l_oox01     STRING                #CHI-830003 add
   DEFINE l_oox02     STRING                #CHI-830003 add
   DEFINE l_sql_1     STRING                #CHI-830003 add
   DEFINE l_sql_2     STRING                #CHI-830003 add
   DEFINE l_omb03_1   LIKE omb_file.omb03   #CHI-830003 add
   DEFINE l_count     LIKE type_file.num5   #CHI-830003 add
   DEFINE l_oma24     LIKE oma_file.oma24   #CHI-830003 add  
   DEFINE l_dbs       LIKE azp_file.azp03   #No.FUN-8C0019
   DEFINE l_azp03     LIKE azp_file.azp03   #No.FUN-8C0019
   DEFINE l_occ37     LIKE occ_file.occ37   #No.FUN-8C0019 
   DEFINE l_sql1      STRING                #No.FUN-8C0019  
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
 
   DELETE FROM curr_tmp;  #no.5196
 
   CASE
      WHEN tm.type='1' LET g_title = g_x[1]
      WHEN tm.type='2' LET g_title = g_x[20]
      OTHERWISE        LET g_title = g_x[21]
   END CASE
 
   LET g_pageno = 0
 
#FUN-A70084--mark--str--
#  FOR l_i = 1 to 8
#     CASE
#        WHEN l_i=1  LET l_p=tm.p1
#        WHEN l_i=2  LET l_p=tm.p2
#        WHEN l_i=3  LET l_p=tm.p3
#        WHEN l_i=4  LET l_p=tm.p4
#        WHEN l_i=5  LET l_p=tm.p5
#        WHEN l_i=6  LET l_p=tm.p6
#        WHEN l_i=7  LET l_p=tm.p7
#        WHEN l_i=8  LET l_p=tm.p8
#     END CASE
#     LET l_plant=''
#     IF cl_null(l_p) THEN CONTINUE FOR END IF
#     SELECT azp03 INTO l_plant FROM azp_file WHERE azp01=l_p
#     IF STATUS THEN CONTINUE FOR END IF
#     LET l_plant = s_dbstring(l_plant CLIPPED) #TQC-950020    
#FUN-A70084--mark--end
#FUN-BB0173 add START
    LET l_i = 1
    FOR l_i = 1 TO g_ary_i
       IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END
      IF g_ooz.ooz07 = 'N' THEN
         LET l_sql="SELECT oma14, gen02, oma15, ",
                   "       oma03, oma032,oma02, oma01,omc02,omc04,occ18,oag02,",  #No.FUN-680022
                   "       omc08-omc10,omc09-omc11,0,0,0,0,0,0,0,0,0,oma23,",  #No.FUN-680022
                   "       '','','',oma00 ",  #MOD-920257 mod
#" FROM ",l_plant CLIPPED,"oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",l_plant CLIPPED,"occ_file, ", 
#                            l_plant CLIPPED,"omc_file ",    #No.FUN-680022
                  #FUN-A70084--mod--str--跨庫改為不跨庫
                  #"  FROM ",cl_get_target_table(l_p,'oma_file'), #FUN-A50102
                  #"  LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",
                  #          cl_get_target_table(l_p,'occ_file'),",", #FUN-A50102
                  #          cl_get_target_table(l_p,'omc_file'),     #FUN-A50102 
#                 #" WHERE oma14=gen_file.gen01(+) AND occ01=oma03 AND oag_file.oag01(+)=oma32",  #No.TQC-A50082
                  #"  FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01, ",  #FUN-BB0173 mark
                  #"       occ_file,omc_file ",  #FUN-BB0173 mark
                   "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                   "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'gen_file'),  #FUN-BB0173 add
                   "      ON oma_file.oma14 = gen_file.gen01 ",  #FUN-BB0173 add
                   "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'oag_file'),  #FUN-BB0173 add
                   "      ON oma_file.oma32 = oag_file.oag01, ",  #FUN-BB0173 add
                   "  ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  #FUN-BB0173 add
                   " ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),  #FUN-BB0173 add
                   " WHERE occ01 = oma03 ",
                  #FUN-A70084--mod--end
                   "   AND ",tm.wc CLIPPED,
                   "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                   "   AND oma02 <= '",tm.edate,"'",
                   "   AND omc01=oma01 "                  #No.FUN-680022  #MOD-920257
      ELSE
         LET l_sql="SELECT oma14, gen02, oma15, ",
                   "       oma03, oma032,oma02, oma01,omc02,omc04,occ18,oag02,",  #No.FUN-680022
                   "       omc08-omc10,omc13,0,0,0,0,0,0,0,0,0,oma23,",   #No.FUN-680022
                   "       '','','',oma00 ",  #MOD-920257 mod
#" FROM ",l_plant CLIPPED,"oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",l_plant CLIPPED,"occ_file, ", 
#                            l_plant CLIPPED,"omc_file ",    #No.FUN-680022
                  #FUN-A70084--mod--str--跨庫改為不跨庫
                  #" FROM ",cl_get_target_table(l_p,'oma_file'), #FUN-A50102
                  #" LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",
                  #         cl_get_target_table(l_p,'occ_file'),",", #FUN-A50102
                  #         cl_get_target_table(l_p,'omc_file'),     #FUN-A50102 
                  #" FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",  #FUN-BB0173 mark
                  #"      occ_file,omc_file ",  #FUN-BB0173 mark
                  #FUN-A70084--mod--end
                   " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                   "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'gen_file'),   #FUN-BB0173 add
                   "      ON oma_file.oma14 = gen_file.gen01 ",   #FUN-BB0173 add
                   "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'oag_file'),  #FUN-BB0173 add
                   "      ON oma_file.oma32 = oag_file.oag01 ,",  #FUN-BB0173 add
                   "   ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  #FUN-BB0173 add
                   "  ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),  #FUN-BB0173 add
                   " WHERE  occ01=oma03 ",
                   "   AND ",tm.wc CLIPPED,
                   "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                   "   AND oma02 <= '",tm.edate,"'",
                   "   AND omc01=oma01 "                #No.FUN-680022  #MOD-920257
      END IF
      IF tm.type ='1' THEN
         LET l_sql = l_sql CLIPPED," AND occ37 = 'Y' "
      END IF
      IF tm.type ='2' THEN
         LET l_sql = l_sql CLIPPED," AND occ37 = 'N' "
      END IF
 
      IF tm.e = "Y" THEN
         IF g_ooz.ooz07 = 'N' THEN
            LET l_sql = l_sql CLIPPED," UNION ",
                        "SELECT oma14, gen02, oma15, ",
                        "       oma03, oma032,oma02, oma01,omc02,omc04,occ18,oag02,",  #No.FUN-680022
                        "       omc08-omc10,omc09-omc11,0,0,0,0,0,0,0,0,0,oma23,",  #No.FUN-680022
                        "       '','','',oma00 ",  #MOD-920257 mod
#" FROM ",l_plant CLIPPED,"oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",l_plant CLIPPED,"occ_file, ", 
#                                 l_plant CLIPPED,"omc_file ",    #No.FUN-680022
                       #FUN-A70084--mod--str--跨庫改為不跨庫
                       #" FROM ",cl_get_target_table(l_p,'oma_file'), #FUN-A50102
                       #" LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",
                       #         cl_get_target_table(l_p,'occ_file'),",", #FUN-A50102
                       #         cl_get_target_table(l_p,'omc_file'),     #FUN-A50102 
                       #" FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",  #FUN-BB0173 mark
                       #"      occ_file,omc_file ",  #FUN-BB0173 mark
                        " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                        "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'gen_file'),  #FUN-BB0173 add
                        "       ON oma_file.oma14 = gen_file.gen01 ",    #FUN-BB0173 add
                        "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'oag_file'),  #FUN-BB0173 add
                        "       ON oma_file.oma32 = oag_file.oag01, ",   #FUN-BB0173 add
                        "   ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),   #FUN-BB0173 add
                        "  ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),   #FUN-BB0173 add
                       #FUN-A70084--mod--end
                        " WHERE  occ01=oma03 ",
                        "   AND ",tm.wc CLIPPED,
                        "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                        "   AND oma02 <= '",tm.edate,"'",
                        "   AND omc01=oma01 "                       #No.FUN-680022  #MOD-920257
         ELSE
            LET l_sql = l_sql CLIPPED," UNION ",
                        "SELECT oma14, gen02, oma15, ",
                        "       oma03, oma032,oma02, oma01,omc02,omc04,occ18,oag02,",  #No.FUN-680022
                        "       omc08-omc10,omc13,0,0,0,0,0,0,0,0,0,oma23,",   #No.FUN-680022
                        "       '','','',oma00 ",  #MOD-920257 mod
#" FROM ",l_plant CLIPPED,"oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",l_plant CLIPPED,"occ_file, ", 
#                                 l_plant CLIPPED,"omc_file ",    #No.FUN-680022
                       #FUN-A70084--mod--str--跨庫改為不跨庫
                       #" FROM ",cl_get_target_table(l_p,'oma_file'), #FUN-A50102
                       #" LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,",
                       #         cl_get_target_table(l_p,'occ_file'),",", #FUN-A50102
                       #         cl_get_target_table(l_p,'omc_file'),     #FUN-A50102 
                       #" FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 LEFT OUTER JOIN oag_file ON oma_file.oma32 = oag_file.oag01,", #FUN-BB0173 mark 
                       #"      occ_file,omc_file ",  #FUN-BB0173 mark
                       #FUN-A70084--mod--end
                        " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),   #FUN-BB0173 add
                        "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'gen_file'),  #FUN-BB0173 add
                        "        ON oma_file.oma14 = gen_file.gen01 ",  #FUN-BB0173 add
                        "   LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'oag_file'),  #FUN-BB0173 add
                        "        ON oma_file.oma32 = oag_file.oag01 ,",  #FUN-BB0173 add
                        "  ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),    #FUN-BB0173 add
                        " ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),    #FUN-BB0173 add
                        " WHERE  occ01=oma03 ",
                        "   AND ",tm.wc CLIPPED,
                        "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                        "   AND oma02 <= '",tm.edate,"'",
                        "   AND omc01=oma01 "                #No.FUN-680022  #MOD-920257
         END IF
         IF tm.type ='1' THEN
            LET l_sql = l_sql CLIPPED," AND occ37 = 'Y' "
         END IF
         IF tm.type ='2' THEN
            LET l_sql = l_sql CLIPPED," AND occ37 = 'N' "
         END IF
      END IF
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102     #FUN-A70084							
	 #CALL cl_parse_qry_sql(l_sql,l_p) RETURNING l_sql          #FUN-A50102 #FUN-A70084	
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-BB0173 add
      PREPARE r626_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM 
      END IF
      DECLARE r626_curs1 CURSOR FOR r626_prepare1
 
      FOREACH r626_curs1 INTO sr.*,l_oma00    #No.FUN-570038
         IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM 
         END IF
       
         IF g_ooz.ooz07 = 'Y' THEN
            LET l_oox01 = YEAR(tm.edate)
            LET l_oox02 = MONTH(tm.edate)                      	 
            LET l_oma24 = ''    #TQC-B10083 add
            WHILE cl_null(l_oma24)
               IF g_ooz.ooz62 = 'N' THEN
                  #LET l_sql_2 = "SELECT COUNT(*) FROM ",l_plant CLIPPED,"oox_file",   #FUN-8C0019
                 #LET l_sql_2 = "SELECT COUNT(*) FROM ",cl_get_target_table(l_p,'oox_file'), #FUN-A50102  #FUN-A70084
                 #LET l_sql_2 = "SELECT COUNT(*) FROM oox_file ",   #FUN-A70084  #FUN-BB0173 mark
                  LET l_sql_2 = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                                " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                                "   AND oox02 <= '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
                 #CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2              #FUN-A50102     #FUN-A70084							
	             #CALL cl_parse_qry_sql(l_sql_2,l_p) RETURNING l_sql_2          #FUN-A50102        #FUN-A70084      
                  CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2   #FUN-BB0173 add
                  PREPARE r626_prepare7 FROM l_sql_2
                  DECLARE r626_oox7 CURSOR FOR r626_prepare7
                  OPEN r626_oox7
                  FETCH r626_oox7 INTO l_count
                  CLOSE r626_oox7                       
                  IF l_count = 0 THEN
                     #LET l_oma24 = '1'    #TQC-B10083 mark 
                     EXIT WHILE            #TQC-B10083 add
                  ELSE                  
                     #LET l_sql_1 = "SELECT oox07 FROM ",l_plant CLIPPED,"oox_file",   #FUN-8C0019
                    #LET l_sql_1 = "SELECT oox07 FROM ",cl_get_target_table(l_p,'oox_file'), #FUN-A50102  #FUN-A70084
                    #LET l_sql_1 = "SELECT oox07 FROM oox_file ", #FUN-A70084  #FUN-BB0173 mark
                     LET l_sql_1 = "SELECT oox07 FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'), #FUN-BB0173 add
                                   " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                   "   AND oox02 = '",l_oox02,"'",
                                   "   AND oox03 = '",sr.oma01,"'",
                                   "   AND oox04 = '0'"
                  END IF                 
               ELSE
                  #LET l_sql_2 = "SELECT COUNT(*) FROM ",l_plant CLIPPED,"oox_file", #FUN-8C0019
                 #LET l_sql_2 = "SELECT COUNT(*) FROM ",cl_get_target_table(l_p,'oox_file'), #FUN-A50102  #FUN-A70084
                 #LET l_sql_2 = "SELECT COUNT(*) FROM oox_file ",  #FUN-BB0173 mark
                  LET l_sql_2 = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add
                                " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                                "   AND oox02 <= '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 <> '0'"
                 #CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2              #FUN-A50102      #FUN-A70084							
	             #CALL cl_parse_qry_sql(l_sql_2,l_p) RETURNING l_sql_2          #FUN-A50102  #FUN-A70084            
                  CALL cl_replace_sqldb(l_sql_2) RETURNING l_sql_2     #FUN-BB0173 add
                  PREPARE r626_prepare8 FROM l_sql_2
                  DECLARE r626_oox8 CURSOR FOR r626_prepare8
                  OPEN r626_oox8
                  FETCH r626_oox8 INTO l_count
                  CLOSE r626_oox8                       
                  IF l_count = 0 THEN
                     #LET l_oma24 = '1'     #TQC-B10083 mark 
                     EXIT WHILE             #TQC-B10083 add
                  ELSE
                      #LET l_sql1 = "SELECT MIN(omb03) FROM ",l_plant CLIPPED,"omb_file",
                     #LET l_sql1 = "SELECT MIN(omb03) FROM ",cl_get_target_table(l_p,'omb_file'), #FUN-A50102  #FUN-A70084
                     #LET l_sql1 = "SELECT MIN(omb03) FROM omb_file",   #FUN-A70084  #FUN-BB0173 mark
                      LET l_sql1 = "SELECT MIN(omb03) FROM ",cl_get_target_table(g_ary[l_i].plant,'omb_file'),  #FUN-BB0173 add 
                                   " WHERE omb01='",sr.oma01,"'"
                     #CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-A50102      #FUN-A70084							
	                 #CALL cl_parse_qry_sql(l_sql1,l_p) RETURNING l_sql1          #FUN-A50102  #FUN-A70084 
                      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1  #FUN-BB0173 add
                      PREPARE r626_prepare10 FROM l_sql1
                      DECLARE r626_omb03 CURSOR FOR r626_prepare10
                      OPEN r626_omb03
                      FETCH r626_omb03 INTO l_omb03_1
                     IF cl_null(l_omb03_1) THEN
                        LET l_omb03_1 = 0
                     END IF       
                     #LET l_sql_1 = "SELECT oox07 FROM ",l_plant CLIPPED,"oox_file", #FUN-8C0019
                    #LET l_sql_1 = "SELECT oox07 FROM ",cl_get_target_table(l_p,'oox_file'), #FUN-A50102 #FUN-A70084         
                    #LET l_sql_1 = "SELECT oox07 FROM oox_file ", #FUN-A70084  #FUN-BB0173 mark
                     LET l_sql_1 = "SELECT oox07 FROM ",cl_get_target_table(g_ary[l_i].plant,'oox_file'),  #FUN-BB0173 add 
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
                 #CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1              #FUN-A50102            #FUN-A70084							
	             #CALL cl_parse_qry_sql(l_sql_1,l_p) RETURNING l_sql_1          #FUN-A50102        #FUN-A70084 
                  CALL cl_replace_sqldb(l_sql_1) RETURNING l_sql_1        #FUN-BB0173 add
                  PREPARE r626_prepare07 FROM l_sql_1
                  DECLARE r626_oox07 CURSOR FOR r626_prepare07
                  OPEN r626_oox07
                  FETCH r626_oox07 INTO l_oma24
                  CLOSE r626_oox07
               END IF              
            END WHILE                       
         END IF
         
         IF cl_null(l_oma24) THEN LET l_oma24 = 1 END IF    #TQC-B10083 mark  #CHI-C30008
      
         #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN           #TQC-B10083 mark
         IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN    #TQC-B10083 mod
            LET sr.num = sr.num0 * l_oma24
         END IF    
 
         IF l_oma00 MATCHES '1*' THEN
            LET amt1=0 LET amt2=0
            LET l_sql= "SELECT SUM(oob09),SUM(oob10) ",
                      #"  FROM ",l_plant CLIPPED,"oob_file,",
                      #          l_plant CLIPPED,"ooa_file",
                      #FUN-A70084--mod--str--
                      #"  FROM ",cl_get_target_table(l_p,'oob_file'),",", #FUN-A50102
                      #          cl_get_target_table(l_p,'ooa_file'),     #FUN-A50102
                      #"  FROM oob_file,ooa_file ",  
                       "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),    #FUN-BB0173 add
                       "      ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add
                       "      ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),    #MOD-C10118 add
                      #FUN-A70084--mod--end
                       " WHERE oob06='",sr.oma01,"'",
                       "   AND oob03='2' AND oob04='1' ",
                       "   AND ooaconf='Y' ",
                       "   AND ooa37 = '1'",          #FUN-B20033
                       "   AND ooa01=oob01 AND ooa02 >'", tm.edate,"'",
                       "   AND oob06 = omc01 AND oob19 = omc02 ",                     #MOD-C10118 add
                       "   AND oob19 = '",sr.omc02,"'"                                #MOD-C10118 add
           #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102     #FUN-A70084							
	   #CALL cl_parse_qry_sql(l_sql,l_p) RETURNING l_sql          #FUN-A50102 #FUN-A70084          
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-BB0173 add
            PREPARE r626_prepare2 FROM l_sql
            DECLARE r626_curs2 CURSOR FOR r626_prepare2
            OPEN r626_curs2
            FETCH r626_curs2 INTO amt2,amt1       #amt2:原幣  amt1:本幣
            IF amt1 IS NULL THEN LET amt1=0 END IF
            IF amt2 IS NULL THEN LET amt2=0 END IF
            #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
            IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
               LET amt1 = amt2 * l_oma24
            END IF
            IF tm.choice='1' THEN   #原幣: amt2(sum(oob09)),num0(oma54t-oma55)
               LET sr.num=sr.num0+amt2
            ELSE                    #本幣: amt1(sum(oob10)),num0(oma61)
               LET sr.num=sr.num +amt1
               LET sr.oma23 = g_aza.aza17
               LET g_azi03=t_azi03
               LET g_azi04=t_azi04
               LET g_azi05=t_azi05
            END IF
         ELSE
            LET amt1=0 LET amt2=0
            LET l_sql="SELECT SUM(oob09),SUM(oob10) ",
                     #"  FROM ",l_plant CLIPPED,"oob_file,",
                     #          l_plant CLIPPED,"ooa_file",
                     #FUN-A70084--mod--str--
                     #"  FROM ",cl_get_target_table(l_p,'oob_file'),",", #FUN-A50102
                     #          cl_get_target_table(l_p,'ooa_file'),     #FUN-A50102
                     #"  FROM oob_file,ooa_file ",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),    #FUN-BB0173 add
                      "      ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add           
                      "      ,",cl_get_target_table(g_ary[l_i].plant,'omc_file'),    #MOD-C10118 add
                     #FUN-A70084--mod--end
                      " WHERE oob06='",sr.oma01,"'",
                      "   AND oob03='1' AND oob04='3' ",
                      "   AND ooaconf='Y' ",
                      "   AND ooa37 = '1'",       #FUN-B20033
                      "   AND ooa01=oob01 AND ooa02 >'", tm.edate,"'",
                      "   AND oob06 = omc01 AND oob19 = omc02 ",         #MOD-C10118 add
                      "   AND oob19 = '",sr.omc02,"'"                    #MOD-C10118 add
           #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102     #FUN-A70084							
	       #CALL cl_parse_qry_sql(l_sql,l_p) RETURNING l_sql          #FUN-A50102       #FUN-A70084       
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-BB0173 add
            PREPARE r626_prepare3 FROM l_sql
            DECLARE r626_curs3 CURSOR FOR r626_prepare3
            OPEN r626_curs3
            FETCH r626_curs3 INTO amt2,amt1       #amt2:原幣  amt1:本幣
            IF amt1 IS NULL THEN LET amt1=0 END IF
            IF amt2 IS NULL THEN LET amt2=0 END IF
            #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
            IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
               LET amt1 = amt2 * l_oma24
            END IF
            IF tm.choice='1' THEN   #原幣: amt2(sum(oob09)),num0(oma54t-oma55)
               LET sr.num=sr.num0+amt2
            ELSE                    #本幣: amt1(sum(oob10)),num0(oma61)
               LET sr.num=sr.num +amt1
               LET sr.oma23 = g_aza.aza17
               LET g_azi03=t_azi03
               LET g_azi04=t_azi04
               LET g_azi05=t_azi05
            END IF
            LET sr.num = sr.num * -1
         END IF

         IF cl_null(sr.num) OR sr.num = 0 THEN           #MOD-BA0182 add
            CONTINUE FOREACH                             #MOD-BA0182 add
         END IF                                          #MOD-BA0182 add
 
         #IF sr.oma11 < tm.edate THEN   # 應收未收已逾期        #No.CHI-C30008 mark
         IF sr.oma11 < (tm.edate-tm.b) THEN   # 應收未收已逾期  #No.CHI-C30008
            LET l_day = tm.edate - sr.oma11
            CASE WHEN l_day   <=tm.a1 LET sr.num1= sr.num
                 WHEN l_day   <=tm.a2 LET sr.num2= sr.num
                 WHEN l_day   <=tm.a3 LET sr.num3= sr.num
                 WHEN l_day   <=tm.a4 LET sr.num4= sr.num
                 WHEN l_day   <=tm.a5 LET sr.num5= sr.num  #No.FUN-740002 
                 WHEN l_day   <=tm.a6 LET sr.num6= sr.num  #No.FUN-740002
                 OTHERWISE            LET sr.num7= sr.num
            END CASE
         ELSE
            #IF sr.oma11 >= tm.edate AND sr.oma11 <= (tm.edate+tm.b) THEN  #No.CHI-C30008 mark
            IF sr.oma11 >= (tm.edate-tm.b) AND sr.oma11 < tm.edate THEN   #No.CHI-C30008
               LET sr.num_7= sr.num       # 應收未逾期 tm.b 天內
            END IF
            LET sr.num_c= sr.num          # 應收未逾期
         END IF
 
         #重捉收款條件,以客戶主檔為主
         SELECT oag02 INTO sr.oag02 from occ_file,oag_file
          WHERE occ01=sr.oma03 AND occ45=oag01

        #str TQC-A50082 add                                                     
         IF sr.oma03='MISC' THEN                                                
            LET sr.occ18 = sr.oma032                                            
         END IF                                                                 
        #end TQC-A50082 add 

         INSERT INTO curr_tmp VALUES
         (sr.oma23,sr.oma14,sr.oma03,sr.num1,sr.num2,sr.num3,sr.num4,sr.num5,
          sr.num6,sr.num7,sr.num_c,sr.num_7) #No.FUN-740002
 
         LET l_sql = "SELECT azi03,azi04,azi05 ",  #TQC-A50082 add azi05                                                 
                     #"  FROM ",l_plant CLIPPED,"azi_file",
                    #"  FROM ",cl_get_target_table(l_p,'azi_file'),     #FUN-A50102  #FUN-A70084
                    #"  FROM azi_file ",     #FUN-A50102  #FUN-BB0173 mark
                     "  FROM ",cl_get_target_table(g_ary[l_i].plant,'azi_file'),  #FUN-BB0173 add
                    #" WHERE azi01='",g_aza.aza17,"'"  #TQC-A50082 mark         
                     " WHERE azi01=?"                  #TQC-A50082
        #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102   #FUN-A70084							
	    #CALL cl_parse_qry_sql(l_sql,l_p) RETURNING l_sql          #FUN-A50102 #FUN-A70084 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-BB0173 add
         PREPARE azi_prepare2 FROM l_sql                                                                                          
         DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
        #str TQC-A50082 mod                                                     
        #OPEN azi_c2
         IF tm.choice='1' THEN   #原币                                          
            OPEN azi_c2 USING sr.oma23                                          
         ELSE                    #本币                                          
            OPEN azi_c2 USING g_aza.aza17                                       
         END IF                                                                 
        #No:FUN-8C0019--END--                                                   
         FETCH azi_c2 INTO sr.azi03,sr.azi04,sr.azi05   #TQC-A50082 add sr.azi05
        #SELECT azi05 INTO sr.azi05 FROM azi_file WHERE azi01=g_aza.aza17   #TQC-A50082 mark
 
        #EXECUTE insert_prep USING sr.*,l_P                      #FUN-8C0019
         EXECUTE insert_prep USING sr.*,g_ary[l_i].plant         #FUN-BB0173 mark
      END FOREACH
  #END FOR      #FUN-A70084
   END FOR      #FUN-BB0173 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma03,oma14,oma15,oma00,oma18')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF  
   IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF  
   IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF  
  #FUN-A70084--mark--str--
  #IF tm.d = 'Y' THEN                                     
  #   LET l_name = 'axrr626_1'                            
  #ELSE                                                   
  #FUN-A70084--mark--end
     #LET l_name = 'axrr626'    #FUN-BB0173 mark 
  #END IF    #FUN-A70084
#FUN-BB0173 add START
   IF g_flag = 'Y' THEN  #流通
      LET l_name = 'axrr626'
   ELSE
      LET l_name = 'axrr626_1'
   END IF
#FUN-BB0173 add END
   LET g_str = g_str CLIPPED,";",
               tm.a1,";",tm.a2,";",tm.a3,";",tm.a4,";",tm.a5,";",tm.a6,";",
               tm.type,";",tm.edate,";",tm.b,";",tm.choice,";",g_aza.aza17,";",   #TQC-760027
              #tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",tm.d   #No.FUN-8C0019   #FUN-A70084
               tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u            #FUN-A70084
   CALL cl_prt_cs3('axrr626',l_name,l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#FUN-A70084--mark--str--
#FUNCTION p626_set_entry_1()
#   CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
 
#FUNCTION p626_set_no_entry_1()
#   IF tm.d = 'N' THEN
#     CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#     IF tm2.s1 = '5' THEN                                                                                                         
#        LET tm2.s1 = ' '                                                                                                          
#     END IF                                                                                                                       
#     IF tm2.s2 = '5' THEN                                                                                                         
#        LET tm2.s2 = ' '                                                                                                          
#     END IF                                                                                                                       
#     IF tm2.s3 = '5' THEN                                                                                                         
#        LET tm2.s2 = ' '                                                                                                          
#     END IF
#  END IF
#END FUNCTION
 
#FUNCTION r626_set_comb()                                                                                                            
#   DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                   
#  IF tm.d ='N' THEN                                                                                                         
#     LET comb_value = '1,2,3'                                                                                                   
#     SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#      WHERE ze01='axr-386' AND ze02=g_lang                                                                                      
#  ELSE                                                                                                                            
#     LET comb_value = '1,2,3,4'                                                                                                   
#     SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#      WHERE ze01='axr-387' AND ze02=g_lang                                                                                       
#  END IF                                                                                                                          
#  CALL cl_set_combo_items('s1',comb_value,comb_item)
#  CALL cl_set_combo_items('s2',comb_value,comb_item)
#  CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-A70084
#No.FUN-9C0072 精簡程式碼
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r626_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("Group1",FALSE)
     LET g_flag = 'Y'  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION r626_legal_db(p_string)
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
