# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr140.4gl
# Descriptions...: 客戶逾期應收帳款彙總表
# Date & Author..: 98/07/06 By Danny
# Modify.........: 98/08/04 By Jimmy(增加報表可選擇輸出內容)
# 990420 Ivy 加上 sdate 功能
# 990420 Ivy 拿掉 授信與業務功能,(因其數字不正確,授信又不用)
# 990420 Ivy 加上關係人的加總
# Modify.........: No.FUN-4C0100 05/03/01 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-580010 05/08/03 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.TQC-5C0086 05/12/19 By Carrier AR月底重評修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/11 By xufeng 修改報表
# Modify.........: NO.FUN-810010 08/01/30 By zhaijie報表輸出改為Crystal Report
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件
# Modify.........: No:FUN-BB0173 12/01/12 by pauline 增加跨法人抓取資料
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                  # Print condition RECORD
              wc      STRING,                         # Where condition
              rdate   LIKE type_file.dat,             #No.FUN-680123 DATE
              sdate   LIKE type_file.dat,             # 990420 #No.FUN-680123 DATE
              base    LIKE type_file.dat,             #No.FUN-680123 DATE
              more    LIKE type_file.chr1,            # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              a       LIKE type_file.chr1,            # 990506 #No.FUN-680123 VARCHAR(01)
              s       LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(01)
              plant_1 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_2 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_3 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_4 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_5 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_6 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_7 LIKE azw_file.azw01,            #FUN-BB0173 add
              plant_8 LIKE azw_file.azw01,            #FUN-BB0173 add
              s1      LIKE type_file.chr1             #FUN-BB0173 add
              END RECORD,
#         plant   ARRAY[12]  OF LIKE azp_file.azp01,   #工廠編號 #No.FUN-680123 VARCHAR(12) #FUN-A10098
         plant   ARRAY[8]  OF LIKE azp_file.azp01,     #FUN-BB0173 add\
         g_sql   STRING,             
         g_atot  LIKE type_file.num5,                 #No.FUN-680123 SMALLINT
         g_p1 LIKE type_file.chr1000,                 #No.FUN-680123 VARCHAR(300)
         g_p2 LIKE type_file.chr1000                  #No.FUN-680123 VARCHAR(300)
 
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i               LIKE type_file.num5          #No.FUN-680123 SMALLINT
#No.FUN-580010--start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5           #No.FUN-680123 SMALLINT
END GLOBALS
 
#No.FUN-580010--end
DEFINE   g_str          STRING                        #NO.FUN-810010
DEFINE   l_table        STRING                        #NO.FUN-810010
#FUN-BB0173 add START
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
           plant      LIKE azw_file.azw01           #plant
           END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1         #記錄是否為流通
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
#NO.FUN-810010--------------START------------
   LET g_sql = "type.type_file.chr1,",
               "plant.azp_file.azp01,",
               "oma00.oma_file.oma00,",
               "oma01.oma_file.oma01,",
               "oma02.oma_file.oma02,",
               "oma03.oma_file.oma03,",
               "oma16.oma_file.oma16,",
               "oma23.oma_file.oma23,",
               "amt1.oma_file.oma55,",
               "amt2.oma_file.oma55,",
               "amta.type_file.num20_6,",
               "amtb.type_file.num20_6,",
               "amtc.type_file.num20_6,",
               "amtd.type_file.num20_6,",
               "occ37.occ_file.occ37,",
               "l_occ02.occ_file.occ02,",
               "t_azi04.azi_file.azi04"  
   LET l_table = cl_prt_temptable('axrr140',g_sql)
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF 
     
#NO.FUN-810010------------------END-----------
    #No.FUN-680123  begin
   CREATE TEMP TABLE r140m_tmp
     (plant LIKE azp_file.azp01,
      cust LIKE oma_file.oma03,
      curr LIKE azi_file.azi01,
      oma02 LIKE oma_file.oma02,
      occ37 LIKE occ_file.occ37,
      amt1 LIKE type_file.num20_6,
      amt2 LIKE type_file.num20_6,
      amt3 LIKE type_file.num20_6,
      amt4 LIKE type_file.num20_6,
      amta LIKE type_file.num20_6,
      amtb LIKE type_file.num20_6,
      amtc LIKE type_file.num20_6,
      amtd LIKE type_file.num20_6)
           #No.FUN-680123 end
   IF STATUS THEN CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----TQC-610059---------
   LET tm.s = ARG_VAL(8)
  #LET tm.rdate = ARG_VAL(9)  #FUN-BB0173 mark
  #LET tm.sdate = ARG_VAL(10) #FUN-BB0173 mark
  #LET tm.base = ARG_VAL(11)  #FUN-BB0173 mark
#FUN-BB0173 add START
   LET tm.s1 = ARG_VAL(9)
   LET tm.rdate = ARG_VAL(10)
   LET tm.sdate = ARG_VAL(11)
   LET tm.base = ARG_VAL(12)
   LET plant[1] = ARG_VAL(13)
   LET plant[2] = ARG_VAL(14)
   LET plant[3] = ARG_VAL(15)
   LET plant[4] = ARG_VAL(16)
   LET plant[5] = ARG_VAL(17)
   LET plant[6] = ARG_VAL(18)
   LET plant[7] = ARG_VAL(19)
   LET plant[8] = ARG_VAL(20)
   FOR g_i = 1 TO 8
      IF NOT cl_null(plant[g_i])THEN
         CALL chk_plant(plant[g_i]) RETURNING g_p1
         IF NOT cl_null(g_p1) THEN
            IF cl_null(g_p2) THEN
               LET g_p2 = "'",g_p1,"'"
            ELSE
               LET g_p2 = g_p2,"'",g_p1,"'"
            END IF
         END IF
      END IF
   END FOR
   IF NOT cl_null(g_p2) THEN
      CALL r140_legal_db(g_p2)
   END IF
#FUN-BB0173 add END
#FUN-A10098---BEGIN
#   LET plant[1] = ARG_VAL(12)
#   LET plant[2] = ARG_VAL(13)
#   LET plant[3] = ARG_VAL(14)
#   LET plant[4] = ARG_VAL(15)
#   LET plant[5] = ARG_VAL(16)
#   LET plant[6] = ARG_VAL(17)
#   LET plant[7] = ARG_VAL(18)
#   LET plant[8] = ARG_VAL(19)
#   LET plant[9] = ARG_VAL(20)
#   LET plant[10] = ARG_VAL(21)
#   LET plant[11] = ARG_VAL(22)
#   LET plant[12] = ARG_VAL(23)
#   FOR i = 1 TO 12
#       IF NOT cl_null(ARG_VAL(i+11)) THEN
#          LET g_atot = g_atot + 1
#       END IF
#   END FOR
#   #-----END TQC-610059-----
#FUN-BB0173 mark START
#  LET g_rep_user = ARG_VAL(12)
#  LET g_rep_clas = ARG_VAL(13)
#  LET g_template = ARG_VAL(14)
#  LET g_rpt_name = ARG_VAL(15) 
#FUN-BB0173 mark END
#FUN-BB0173 add START
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
#FUN-BB0173 add END
#   #No.FUN-570264 --start--
#   LET g_rep_user = ARG_VAL(24)
#   LET g_rep_clas = ARG_VAL(25)
#   LET g_template = ARG_VAL(26)
#   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
#   #No.FUN-570264 ---end---
#FUN-A10098---END
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL axrr140_tm(0,0)        # Input print condition
      ELSE CALL axrr140()              # Read data and create out-file
   END IF
   DROP TABLE r140m_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr140_tm(p_row,p_col)
  DEFINE  p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_ac           LIKE type_file.num10,         #No.FUN-680123 INTEGER
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(400)
  DEFINE  l_cnt          LIKE type_file.num5           #FUN-BB0173 add
  DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01           #FUN-BB0173 add
  DEFINE  l_string       STRING                        #FUN-BB0173 add
  DEFINE  l_plant        LIKE azw_file.azw01           #FUN-BB0173 add
 
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 4 LET p_col = 20
    ELSE LET p_row = 4 LET p_col = 10
    END IF
 
   OPEN WINDOW axrr140_w AT p_row,p_col
        WITH FORM "axr/42f/axrr140"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL r140_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
#   LET plant[1]=g_plant  #預設現行工廠   #FUN-A10098
   LET tm.plant_1 = g_plant   #FUN-BB0173 add
   LET tm.rdate = g_today
   LET tm.sdate = g_today
   LET tm.base  = g_today
   LET tm.more = 'N'
   LET tm.s = '1'
   LET tm.s1 = '3'  #FUN-BB0173 add
 # LET tm.a = '3'  # 990506
WHILE TRUE
   DELETE FROM r140m_tmp
   CONSTRUCT BY NAME tm.wc ON oma03
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
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr140_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-A10098---BEGIN
#   #----- 工廠編號 -B---#
#   CALL SET_COUNT(1)    # initial array argument
#   INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.*
#       BEFORE ROW               #No.FUN-560239
#          LET l_ac = ARR_CURR()
 
#       AFTER FIELD plant
#        # LET l_ac = ARR_CURR()   #No.FUN-560239 Mark
#          IF NOT cl_null(plant[l_ac]) THEN
#             SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
#             IF STATUS THEN
##               CALL cl_err('sel azp',STATUS,1)   #No.FUN-660116
#                CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660116
#                NEXT FIELD plant  
#             END IF
#             FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                 IF plant[i] = plant[l_ac] THEN
#                    CALL cl_err('','aom-492',1) NEXT FIELD plant
#                 END IF
#             END FOR
#             #No.FUN-940102--begin    
#             IF NOT s_chk_demo(g_user,plant[l_ac]) THEN              
#                NEXT FIELD plant         
#             END IF            
#             #No.FUN-940102--end 
#          END IF
#       AFTER INPUT                    # 檢查至少輸入一個工廠
#          IF INT_FLAG THEN EXIT INPUT END IF
#          LET g_atot = ARR_COUNT()
#          FOR i = 1 TO g_atot
#              IF NOT cl_null(plant[i]) THEN EXIT INPUT END IF
#          END FOR
#          IF i = g_atot+1 THEN
#             CALL cl_err('','aom-423',1) NEXT FIELD plant
#          END IF
# 
#       #-----No.FUN-560239-----
#       ON ACTION CONTROLP
#          CALL cl_init_qry_var()
#         #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#          LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#          LET g_qryparam.arg1 = g_user                #No.FUN-940102
#          LET g_qryparam.default1 = plant[l_ac]
#          CALL cl_create_qry() RETURNING plant[l_ac]
#          CALL FGL_DIALOG_SETBUFFER(plant[l_ac])
#       #-----No.FUN-560239 END-----
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#   END INPUT
#   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr140_w RETURN END IF
#FUN-A10098---END 
#  INPUT BY NAME tm.rdate,tm.sdate,tm.base,tm.a,tm.more WITHOUT DEFAULTS
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
         CALL r140_legal_db(l_string)

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
      CLOSE WINDOW r140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

#FUN-BB0173 add END

   INPUT BY NAME tm.s,tm.s1,tm.rdate,tm.sdate,tm.base,tm.more WITHOUT DEFAULTS   #FUN-BB0173 add tm.s1
      AFTER FIELD rdate
         IF cl_null(tm.rdate) THEN NEXT FIELD rdate END IF
      AFTER FIELD sdate
         IF cl_null(tm.sdate) THEN NEXT FIELD sdate END IF
      AFTER FIELD base
         IF cl_null(tm.base) THEN NEXT FIELD base END IF
{
      AFTER FIELD a
         IF tm.a MATCHES'[123]' THEN
         ELSE
            ERROR "請輸入[1,2,3]!"
            NEXT FIELD a
         END IF
}
      AFTER FIELD s
         IF tm.s!='1' AND tm.s!='2' AND tm.s!='3' THEN
 #No.MOD-580325-begin
            CALL cl_err('','mfg0051',0)
#           ERROR "請輸入[1,2,3]!"
 #No.MOD-580325-end
            NEXT FIELD s
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#990420
      AFTER INPUT
         IF  tm.rdate < tm.sdate  THEN
             ERROR "InvoDate < DataDate --> Error"
             NEXT FIELD  rdate
         ENd IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr140_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr140'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr140','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         #-----TQC-610059---------
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.rdate CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                         " '",tm.base CLIPPED,"'",
                  #FUN-A10098---BEGIN
                         #" '",plant[1] CLIPPED,"'",
                         #" '",plant[2] CLIPPED,"'",
                         #" '",plant[3] CLIPPED,"'",
                         #" '",plant[4] CLIPPED,"'",
                         #" '",plant[5] CLIPPED,"'",
                         #" '",plant[6] CLIPPED,"'",
                         #" '",plant[7] CLIPPED,"'",
                         #" '",plant[8] CLIPPED,"'",
                         #" '",plant[9] CLIPPED,"'",
                         #" '",plant[10] CLIPPED,"'",
                         #" '",plant[11] CLIPPED,"'",
                         #" '",plant[12] CLIPPED,"'",
                         #-----END TQC-610059-----
                  #FUN-A10098---END
                  #FUN-BB0173 add START
                         " '",tm.s1 CLIPPED,"'" ,
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
         CALL cl_cmdat('axrr140',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr140()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr140_w
END FUNCTION
 
FUNCTION axrr140()
   DEFINE 
          l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)  #FUN-BB0173 mark
          l_sql     STRING,         #FUN-BB0173 add 
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_i,l_j,i LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_dbs     LIKE type_file.chr21,         #No.FUN-680123 VARCHAR(22)
          l_amt1,l_amt2 LIKE oma_file.oma55,
         #l_amt3,l_amt4 LIKE oma_file.oma55,      #FUN-A60056
          l_zaa02       LIKE zaa_file.zaa02,
          sr        RECORD
                    type    LIKE type_file.chr1,   #No.FUN-680123 VARCHAR(01)
                    plant   LIKE azp_file.azp01,   #No.FUN-680123 VARCHAR(10)
                    oma00   LIKE oma_file.oma00,
                    oma01   LIKE oma_file.oma01,
                    oma02   LIKE oma_file.oma02,
                    oma03   LIKE oma_file.oma03,
                    oma16   LIKE oma_file.oma16,
                    oma23   LIKE oma_file.oma23,
                    amt1    LIKE oma_file.oma55,   #外幣
                    amt2    LIKE oma_file.oma55,   #本幣
                    amta    LIKE type_file.num20_6,#已確認外幣 #No.FUN-680123 DEC(20,6)
                    amtb    LIKE type_file.num20_6,#已確認本幣 #No.FUN-680123 DEC(20,6)
                    amtc    LIKE type_file.num20_6,#未收外幣 #No.FUN-680123 DEC(20,6)
                    amtd    LIKE type_file.num20_6,#未收本幣 #No.FUN-680123 DEC(20,6)
                    occ37   LIKE occ_file.occ37    #關係人否 990420
                    END RECORD
   DEFINE l_sql2    STRING          #FUN-BB0173 add
#NO.FUN-810010------------------start---------------
DEFINE     l_occ02          LIKE occ_file.occ02
 
     CALL cl_del_data(l_table)
    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr140'
#NO.FUN-810010---------------end---------  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
 
#     CALL cl_outnam('axrr140') RETURNING l_name           #NO.FUN-810010
#NO.FUN-810010---------------------START--MARK-----
#No.FUN-580010--start
#CASE WHEN tm.s='1'
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#      LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="N"
#      LET g_zaa[35].zaa06="N"
#      LET g_zaa[36].zaa06="N"
#      LET g_zaa[37].zaa06="N"
#      LET g_zaa[38].zaa06="N"
#      LET g_zaa[44].zaa06="N"
#      LET g_zaa[43].zaa06="Y"
#      LET g_zaa[45].zaa06="Y"
#      LET g_zaa[39].zaa06="Y"
#      LET g_zaa[40].zaa06="Y"
#      LET g_zaa[41].zaa06="Y"
#      LET g_zaa[42].zaa06="Y"
#     WHEN tm.s='2'
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#      LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="N"
#      LET g_zaa[35].zaa06="N"
#      LET g_zaa[36].zaa06="N"
#      LET g_zaa[37].zaa06="N"
#      LET g_zaa[38].zaa06="Y"
#      LET g_zaa[44].zaa06="Y"
#      LET g_zaa[43].zaa06="N"
#      LET g_zaa[45].zaa06="N"
#      LET g_zaa[39].zaa06="N"
#      LET g_zaa[40].zaa06="N"
#      LET g_zaa[41].zaa06="Y"
#      LET g_zaa[42].zaa06="Y"
#    OTHERWISE
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#     LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="Y"
#      LET g_zaa[35].zaa06="Y"
#      LET g_zaa[36].zaa06="Y"
#      LET g_zaa[37].zaa06="Y"
#      LET g_zaa[38].zaa06="Y"
#      LET g_zaa[44].zaa06="Y"
#      LET g_zaa[43].zaa06="Y"
#      LET g_zaa[45].zaa06="Y"
#      LET g_zaa[39].zaa06="N"
#      LET g_zaa[40].zaa06="N"
#      LET g_zaa[41].zaa06="N"
#      LET g_zaa[42].zaa06="N"
#END CASE
#     CALL cl_prt_pos_len()
     LET g_dash=NULL
     LET g_dash2=NULL
     FOR i=1 TO g_len LET g_dash[i,i]='='  END FOR
     FOR i=1 TO g_len LET g_dash2[i,i]='-'  END FOR
#No.FUN-580010--end
#     START REPORT axrr140_rep TO l_name
#     LET g_pageno = 0
 
#NO.FUN-810010------------END----MARK--------------
#NO.FUN-810010-----------------START---------------
IF g_flag = TRUE  THEN   #流通   #FUN-BB0173 add
   CASE WHEN tm.s='1'    LET l_name = 'axrr140'
        WHEN tm.s='2'    LET l_name = 'axrr140_1'
        OTHERWISE        LET l_name = 'axrr140_2'
   END CASE     
#FUN-BB0173 add START
ELSE
   CASE WHEN tm.s='1'    LET l_name = 'axrr140_3'
        WHEN tm.s='2'    LET l_name = 'axrr140_4'
        OTHERWISE        LET l_name = 'axrr140_5'
   END CASE
END IF
#FUN-BB0173 add END
#NO.FUN-810010---------------END-------------
 
#     LET l_i = 1               #FUN-A10098
#     FOR l_i = 1 TO g_atot     #FUN-A10098
#         IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF  #FUN-A10098  
#         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i] #FUN-A10098
#         LET l_dbs = s_dbstring(l_dbs CLIPPED)  #FUN-A10098
         #No.TQC-5C0086  --Begin                                                                                                    
#FUN-BB0173 add START
      LET l_i = 1
      FOR l_i = 1 TO g_ary_i
          IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END
         IF g_ooz.ooz07 = 'N' THEN
            LET l_sql="SELECT '1','',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",
                     #--modi by kitty bug NO:A057
                      "       oma56t-oma57,0,0,0,0,occ37 ",
                     #"       oma61       ,0,0,0,0,occ37 ",
   #                  "       oma56t-oma57,0,0,0,0 ",
              #        "  FROM ",l_dbs CLIPPED,"oma_file ",   #FUN-A10098
              #                 "LEFT OUTER JOIN ",l_dbs CLIPPED,"occ_file ON occ_file.occ01 = oma_file.oma03",  #990420  #FUN-A10098
                    #"  FROM oma_file ",        #FUN-A10098  #FUN-BB0173 mark
                    #          "LEFT OUTER JOIN occ_file ON occ_file.occ01 = oma_file.oma03",  #990420 #FUN-A10098  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),                #FUN-BB0173 add
                      "    LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),   #FUN-BB0173 add
                      "      ON occ_file.occ01 = oma_file.oma03 ",                                   #FUN-BB0173 add
                      " WHERE oma02 <='",tm.rdate,"'",
                      "   AND oma11 < '",tm.base,"'",
                      "   AND oma00 MATCHES '1*' ",     # 應收
                     #--modi by kitty bug NO:A057
                     #"   AND (oma56t>oma57 OR oma54t>oma55 OR ",
                      "   AND (oma61>0      OR oma54t>oma55 OR ",
                    # "   AND (oma56t>oma57 OR ", # Thomas 98/12/04
                    #  "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,  #FUN-A10098
                    #  "        ooa_file,",l_dbs CLIPPED,"oob_file",     #FUN-A10098
                      "        oma01 IN (SELECT oob06 FROM ",  #FUN-A10098
                     #"        ooa_file,oob_file",     #FUN-A10098  #FUN-BB0173 mark
                      " ",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),  #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'oob_file'),  #FUN-BB0173 add
                      "        WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增
                      "          AND ooa37='1' ",               #FUN-B20020
                      "          AND ooa02 > '", tm.rdate,"'))",
                      " AND ",tm.wc CLIPPED,
             #         " AND occ_file.occ01(+) = oma03",                          # 990420
                      "   AND omaconf = 'Y' AND omavoid = 'N' "
                     #" UNION ",  #FUN-BB0173 mark
        LET l_sql2 =  "SELECT '2','',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",  #FUN-BB0173 add LET l_sql2 =
                 #--modi by kitty Bug NO:A057
                 #    "       oma56t-oma57,0,0,0,0,occ37 ",
                      "       oma61       ,0,0,0,0,occ37 ",
#                     "       oma56t-oma57,0,0,0,0 ",
               #       " FROM ",l_dbs CLIPPED,"oma_file ",    #FUN-A10098
               #                "LEFT OUTER JOIN ",l_dbs CLIPPED,"occ_file ON occ_file.occ01 = oma_file.oma03",  #990420  #FUN-A10098
                     #" FROM oma_file ",    #FUN-A10098  #FUN-BB0173 mark
                     #         "LEFT OUTER JOIN occ_file ON occ_file.occ01 = oma_file.oma03",  #990420  #FUN-A10098  #FUN-BB0173 mark
                      " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),                    #FUN-BB0173 add
                      "         LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'occ_file'), #FUN-BB0173 add
                      "          ON occ_file.occ01 = oma_file.oma03 ",                                  #FUN-BB0173 add
                      " WHERE oma02 <='",tm.rdate,"'",
                      "   AND oma00 ='24'",            # 預收
                 #--modi by kitty Bug NO:A057
                    # "   AND (oma56t>oma57 OR oma54t>oma55 OR ",
                      "   AND (oma61 > 0    OR oma54t>oma55 OR ",
                      # "   AND (oma56t>oma57 OR ",
                #      "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,  #FUN-A10098
                #      "        ooa_file,",l_dbs CLIPPED,"oob_file",        #FUN-A10098
                      "        oma01 IN (SELECT oob06 FROM ",  #FUN-A10098
                     #"        ooa_file,oob_file",        #FUN-A10098  #FUN-BB0173 mark
                      " ",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),  #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'oob_file'),  #FUN-BB0173 add
                      "        WHERE ooa01=oob01  AND ooaconf !='X' ", #010804增
                      "          AND ooa37='1' ",               #FUN-B20020
                      "          AND ooa02 > '", tm.rdate,"'))",
                      "   AND ",tm.wc CLIPPED,
          #            " AND occ_file.occ01(+) = oma03",                          # 990420
                      "   AND omaconf = 'Y' AND omavoid = 'N' "
         ELSE                                                                                                                       
            LET l_sql="SELECT '1','',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",                                                    
                      "       oma61       ,0,0,0,0,occ37 ",                                                                         
              #        "  FROM ",l_dbs CLIPPED,"oma_file ",       #FUN-A10098                                                                   
              #                 "LEFT OUTER JOIN ",l_dbs CLIPPED,"occ_file ON occ_file.occ01 = oma_file.oma03",  #990420      #FUN-A10098                                                  
                     #"  FROM oma_file ",        #FUN-A10098   #FUN-BB0173 mark   
                     #         "LEFT OUTER JOIN occ_file ON occ_file.occ01 = oma_file.oma03",  #990420   #FUN-A10098      #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),          #FUN-BB0173 add
                      "         LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),   #FUN-BB0173 add
                      "           ON occ_file.occ01 = oma_file.oma03 " ,        #FUN-BB0173 add
                      " WHERE oma02 <='",tm.rdate,"'",                                                                              
                      "   AND oma11 < '",tm.base,"'",                                                                               
                      "   AND oma00 MATCHES '1*' ",     # 應收                                                                      
                      "   AND (oma61>0      OR oma54t>oma55 OR ",                                                                   
              #        "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,            #FUN-A10098                                              
              #        "        ooa_file,",l_dbs CLIPPED,"oob_file",        #FUN-A10098                                                           
                      "        oma01 IN (SELECT oob06 FROM ",            #FUN-A10098                                              
                     #"        ooa_file,oob_file",        #FUN-A10098    #FUN-BB0173 mark                                                       
                      " ",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'oob_file'),    #FUN-BB0173 add
                      "        WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增  
                      "          AND ooa37='1' ",               #FUN-B20020                                                   
                      "          AND ooa02 > '", tm.rdate,"'))",                                                                    
                      " AND ",tm.wc CLIPPED,                                                                                        
                      "   AND omaconf = 'Y' AND omavoid = 'N' "                                                                    
                     #" UNION ",       #FUN-BB0173 mark 
        LET l_sql2 =  "SELECT '2','',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",  #FUN-BB0173 add LET l_sql2 = 
                      "       oma61       ,0,0,0,0,occ37 ",                                                                         
              #        " FROM ",l_dbs CLIPPED,"oma_file ",  #FUN-A10098                                                                           
              #                 "LEFT OUTER JOIN ",l_dbs CLIPPED,"occ_file ON occ_file.occ01 = oma_file.oma03",  #990420 #FUN-A10098                                                       
                     #" FROM oma_file ",  #FUN-A10098      #FUN-BB0173 mark 
                     #         "LEFT OUTER JOIN occ_file ON occ_file.occ01 = oma_file.oma03",  #990420 #FUN-A10098      #FUN-BB0173 mark
                      " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file') ,  #FUN-BB0173 add
                      "         LEFT OUTER JOIN ",cl_get_target_table(g_ary[l_i].plant,'occ_file'),  #FUN-BB0173 add 
                      "           ON occ_file.occ01 = oma_file.oma01 ",   #FUN-BB0173 add
                      " WHERE oma02 <='",tm.rdate,"'",                                                                              
                      "   AND oma00 ='24'",            # 預收
                      "   AND (oma61 > 0    OR oma54t>oma55 OR ",                                                                   
              #        "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,       #FUN-A10098                                                  
              #        "        ooa_file,",l_dbs CLIPPED,"oob_file",               #FUN-A10098                                                  
                      "        oma01 IN (SELECT oob06 FROM ",       #FUN-A10098                                                  
                     #"        ooa_file,oob_file",               #FUN-A10098      #FUN-BB0173 mark 
                      " ",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),        #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'oob_file'),        #FUN-BB0173 add
                      "        WHERE ooa01=oob01  AND ooaconf !='X' ", #010804增   
                      "          AND ooa37='1' ",               #FUN-B20020                                                 
                      "          AND ooa02 > '", tm.rdate,"'))",                                                                    
                      "   AND ",tm.wc CLIPPED,                                                                                      
                      "   AND omaconf = 'Y' AND omavoid = 'N' "                                                                     
         END IF                                                                                                                     
         #No.TQC-5C0086  --End 
      #FUN-BB0173 add START   #判斷是否加入關係人條件
         IF tm.s1 = 1 THEN
            LET l_sql = l_sql," AND occ37 = 'Y' "
            LET l_sql2 = l_sql2," AND occ37 = 'Y' "
         END IF
         IF tm.s1 = 2 THEN
            LET l_sql = l_sql," AND occ37 = 'N' "
            LET l_sql2 = l_sql2," AND occ37 = 'N' "
         END IF
         LET l_sql = l_sql," UNION ALL ", l_sql2
      #FUN-BB0173 add END
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr140_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr140_curs1 CURSOR FOR axrr140_prepare1
 
         FOREACH axrr140_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
{
# 990506 Ivy
           CASE tm.a
                WHEN  "1"   # 關係人
                      IF  sr.occ37  !=  "Y"  THEN
                          CONTINUE  FOREACH
                      END IF
                WHEN  "2"
                      IF  sr.occ37  =  "Y"  THEN
                          CONTINUE  FOREACH
                      END IF
           END  CASE
}
           IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
           IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
#           LET sr.plant = plant[l_i]  #FUN-A10098
           LET l_amt1 = 0
           LET l_amt2 = 0
          #LET l_amt3 = 0   #FUN-A60056
          #LET l_amt4 = 0   #FUN-A60056
           CASE WHEN sr.type='1'    #----- 應收合計
                  LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                  #           "  FROM ",l_dbs CLIPPED,"oob_file,",   #FUN-A10098
                  #                     l_dbs CLIPPED,"ooa_file",    #FUN-A10098
                            #"  FROM oob_file,",   #FUN-A10098  #FUN-BB0173 mark
                            #          "ooa_file",    #FUN-A10098  #FUN-BB0173 mark
                             "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),   #FUN-BB0173 add
                             "      ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add
                             " WHERE oob06='",sr.oma01,"'",
                             "   AND oob03='2' AND oob04='1' ",
                             "   AND ooa37='1' ",               #FUN-B20020
                             "   AND ooaconf='Y' AND ooa01=oob01 ",
                             "   AND ooa02 > '",tm.rdate,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  PREPARE ooa_pre1 FROM l_sql
                  IF STATUS THEN
                     CALL cl_err('ooa_pre1',STATUS,1) 
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                     EXIT PROGRAM
                        
                  END IF
                  DECLARE ooa_curs1 CURSOR FOR ooa_pre1
                  OPEN ooa_curs1
                  FETCH ooa_curs1 INTO l_amt1,l_amt2
                  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
                  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
                  LET sr.amt1 = sr.amt1 + l_amt1 # 外幣
                  LET sr.amt2 = sr.amt2 + l_amt2 # 本幣
 
                  LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",  #已收未確認
                        #     "  FROM ",l_dbs CLIPPED,"oob_file,",  #FUN-A10098
                        #               l_dbs CLIPPED,"ooa_file",   #FUN-A10098
                            #"  FROM oob_file,",  #FUN-A10098  #FUN-BB0173 mark
                            #        "ooa_file",   #FUN-A10098  #FUN-BB0173 mark
                             "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),   #FUN-BB0173 add
                             "      ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add
                             " WHERE oob06='",sr.oma01,"'",
                             "   AND oob03='2' AND oob04='1' ",
                             "   AND ooa37='1' ",               #FUN-B20020
                             "   AND ooaconf='N' AND ooa01=oob01 " ,
                             "   AND ooa02 <= '",tm.rdate,"'" # Thomas 980925
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  PREPARE ooa_pre3 FROM l_sql
                  IF STATUS THEN
                     CALL cl_err('ooa_pre3',STATUS,1) 
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                     EXIT PROGRAM
                        
                  END IF
                  DECLARE ooa_curs3 CURSOR FOR ooa_pre3
                  OPEN ooa_curs3
                  FETCH ooa_curs3 INTO l_amt1,l_amt2
                  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
                  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
                  LET sr.amta = l_amt1 # 外幣
                  LET sr.amtb = l_amt2 # 本幣
 
#FUN-A60056--mark--str--
#                 #No.TQC-5C0086  --Begin                                                                                           
#                 IF g_ooz.ooz07 = 'N' THEN
#               # modi by kitty Bug NO:A057
#                    LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma56t-oma57) ",
#                   #LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma61) ",
#                           #     "  FROM ",l_dbs CLIPPED,"oma_file,",   #FUN-A10098
#                           #     "  FROM ",l_dbs CLIPPED,"oma_file,",   #FUN-A10098
#                                "  FROM oma_file,",   #FUN-A10098
#                                        "oha_file",    #FUN-A10098
#                                " WHERE oha16 = '",sr.oma16,"'",
#                                "   AND oma01 = oha10 AND oma00 = '21' ",
#                                "   AND oma02 <='",tm.rdate,"'" ,
#                                "   AND ohaconf != 'X' " #01/08/17 mandy
#                 ELSE                                                                                                              
#                    LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma61) ",                                                           
#                         #       "  FROM ",l_dbs CLIPPED,"oma_file,",      #FUN-A10098                                                         
#                         #                 l_dbs CLIPPED,"oha_file",       #FUN-A10098                                                         
#                                "  FROM oma_file,",      #FUN-A10098                                                         
#                                        "oha_file",       #FUN-A10098                                                         
#                                " WHERE oha16 = '",sr.oma16,"'",                                                                   
#                                "   AND oma01 = oha10 AND oma00 = '21' ",                                                          
#                                "   AND oma02 <='",tm.rdate,"'" ,                                                                  
#                                "   AND ohaconf != 'X' " #01/08/17 mandy                                                           
#                 END IF                                                                                                            
#                 #No.TQC-5C0086  --End 
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#                 PREPARE oma_pre FROM l_sql
#                 IF STATUS THEN
#                    CALL cl_err('oma_pre',STATUS,1) 
#                    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#                    EXIT PROGRAM
#                       
#                 END IF
#                 DECLARE oma_curs CURSOR FOR oma_pre
#                 OPEN oma_curs
#                 FETCH oma_curs INTO l_amt3,l_amt4
#                 IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#                 IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#                  # Thomas 98/09/25 如果是雜項應收就不能再找折讓單
#                 IF sr.oma00 = '14' THEN
#                    LET l_amt3 = 0
#                    LET l_amt4 = 0
#                 END IF
#FUN-A60056--mark--end
                  # Thomas End #
#                 LET sr.amt1 = sr.amt1 - l_amt3  # 折讓己含在己沖中
#                 LET sr.amt2 = sr.amt2 - l_amt4
                  IF sr.amt1 > 0 OR sr.amt2 > 0 THEN # Thomas 98/10/08
                     LET sr.amtc=sr.amt1-sr.amta   #未收外幣 (amt1 - amta)
                     LET sr.amtd=sr.amt2-sr.amtb   #未收本幣 (amt2 - amtb)
                  ELSE
                     CONTINUE FOREACH
                  END IF # Thomas 98/10/08
                WHEN sr.type='2'    #----- 預收合計
                  LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                         #   "  FROM ",l_dbs CLIPPED,"oob_file,", #FUN-A10098
                         #              l_dbs CLIPPED,"ooa_file", #FUN-A10098
                           #"  FROM oob_file,", #FUN-A10098  #FUN-BB0173 mark
                           #        "ooa_file", #FUN-A10098  #FUN-BB0173 mark
                             "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oob_file'),   #FUN-BB0173 add
                             "      ,",cl_get_target_table(g_ary[l_i].plant,'ooa_file'),    #FUN-BB0173 add
                             " WHERE oob06='",sr.oma01,"'",
                             "   AND oob03='1' AND oob04='3' ",
                             "   AND ooa37='1' ",               #FUN-B20020
                             "   AND ooaconf='Y' AND ooa01=oob01 ",
                             "   AND ooa02 > '",tm.rdate,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  PREPARE ooa_pre2 FROM l_sql
                  IF STATUS THEN
                     CALL cl_err('ooa_pre2',STATUS,1) 
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                     EXIT PROGRAM
                        
                  END IF
                  DECLARE ooa_curs2 CURSOR FOR ooa_pre2
                  OPEN ooa_curs2
                  FETCH ooa_curs2 INTO l_amt1,l_amt2
                  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
                  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
                  LET sr.amt1 = sr.amt1 + l_amt1 # 外幣
                  LET sr.amt2 = sr.amt2 + l_amt2 # 本幣
           END CASE
#           OUTPUT TO REPORT axrr140_rep(sr.*)             #NO.FUN-810010
 
#NO.FUN-810010------------------start-----------------------
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    
             FROM azi_file
               WHERE azi01=sr.oma23
 
          SELECT occ02
            INTO l_occ02
               FROM occ_file
           WHERE occ01 = sr.oma03
          LET sr.plant = g_ary[l_i].plant         #FUN-BB0173 add 
          EXECUTE insert_prep USING
             sr.type,sr.plant,sr.oma00,sr.oma01,sr.oma02,sr.oma03,sr.oma16,
             sr.oma23, sr.amt1,sr.amt2,sr.amta,sr.amtb,sr.amtc,sr.amtd,
             sr.occ37,l_occ02,t_azi04
#NO.FUN-810010------------------end-----------------------
         END FOREACH
      END FOR   #FUN-BB0173 add
#     END FOR   #FUN-A10098
#     FINISH REPORT axrr140_rep                            #NO.FUN-810010
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-810010
#NO.FUN-810010--------------start-------------
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'oma03') 
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.rdate,";",tm.base,";",tm.sdate,";",
                 tm.s,";",g_azi04
     CALL cl_prt_cs3('axrr140',l_name,l_sql,g_str)
#NO.FUN-810010--------------end-------------
END FUNCTION

#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r140_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group03",FALSE)
     LET g_flag = TRUE  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION r140_legal_db(p_string)
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
 
#NO.FUN-810010------------------start-----mark------------------
#REPORT axrr140_rep(sr)
#   DEFINE 
#          l_last_sw LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
#          sr        RECORD
#                    type    LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(01)
#                    plant   LIKE azp_file.azp01,    #No.FUN-680123 VARCHAR(10)
#                    oma00   LIKE oma_file.oma00,
#                    oma01   LIKE oma_file.oma01,
#                    oma02   LIKE oma_file.oma02,
#                    oma03   LIKE oma_file.oma03,
#                    oma16   LIKE oma_file.oma16,
#                    oma23   LIKE oma_file.oma23,
#                    amt1    LIKE oma_file.oma55,    #外幣
#                    amt2    LIKE oma_file.oma55,    #本幣
#                    amta    LIKE type_file.num20_6, #已確認外幣 #No.FUN-680123 DEC(20,6)
#                    amtb    LIKE type_file.num20_6, #已確認本幣 #No.FUN-680123 DEC(20,6)
#                    amtc    LIKE type_file.num20_6, #未收外幣 #No.FUN-680123 DEC(20,6)
#                    amtd    LIKE type_file.num20_6, #未收本幣 #No.FUN-680123 DEC(20,6)
#                    occ37   LIKE occ_file.occ37     #關係人否 990420
#                    END RECORD,
#          l_plant_o LIKE azp_file.azp01,            #No.FUN-680123 VARCHAR(10)
#          l_plant   LIKE azp_file.azp01,            #No.FUN-680123 VARCHAR(10)
#         #l_curr    VARCHAR(04),
#          l_curr    LIKE azi_file.azi01,            #No.FUN-680123 VARCHAR(04)
#          l_occ02   LIKE occ_file.occ02,
#          l_i       LIKE type_file.num5,            #No.FUN-680123 SMALLINT
#          l_amt1,l_amt2,l_amt3,l_amt4  LIKE oma_file.oma55,
#          l_amta,l_amtb,l_amtc,l_amtd  LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)
#  DEFINE
#          l_s_plant        LIKE azp_file.azp01      #No.FUN-680123 VARCHAR(10)
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.occ37 DESC,sr.oma03,sr.plant,sr.oma23         #990420
## ORDER BY sr.oma03,sr.plant,sr.oma23
#  FORMAT
#   PAGE HEADER
##NO.FUN-580010--start
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_x[14] CLIPPED,tm.rdate,'      ',
#            g_x[18] CLIPPED,tm.base
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[44],g_x[43],g_x[45],g_x[39],g_x[40],g_x[41],g_x[42]
#      PRINT g_dash1
##NO.FUN-580010--end
#      LET l_last_sw = 'n'
#
#    BEFORE GROUP OF sr.oma03
#       PRINT COLUMN g_c[31],sr.oma03 CLIPPED;   #No.FUN-580010
#
#    BEFORE GROUP OF sr.plant
#       PRINT COLUMN g_c[32],sr.plant CLIPPED;                   #No.FUN-580010
#
#    BEFORE GROUP OF sr.oma23
#       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#         FROM azi_file
#        WHERE azi01=sr.oma23
#
#    AFTER GROUP OF sr.oma23
#       LET l_amt1= GROUP SUM(sr.amt1) WHERE sr.type = '1'   #應收外幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amt2= GROUP SUM(sr.amt2) WHERE sr.type = '1'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amt3= GROUP SUM(sr.amt1) WHERE sr.type = '2'   #預收外幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amt4= GROUP SUM(sr.amt2) WHERE sr.type = '2'   #預收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amta= GROUP SUM(sr.amta) WHERE sr.type = '1'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amtb= GROUP SUM(sr.amtb) WHERE sr.type = '1'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amtc= GROUP SUM(sr.amtc) WHERE sr.type = '1'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       LET l_amtd= GROUP SUM(sr.amtd) WHERE sr.type = '1'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate   #990420
#       IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#       IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#       IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#       IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#       IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#       IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#       IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#       IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#       INSERT INTO r140m_tmp
#              VALUES(sr.plant,sr.oma03,sr.oma23,sr.oma02,sr.occ37,
#                     l_amt1,l_amt2,l_amt3,l_amt4,
#                     l_amta,l_amtb,l_amtc,l_amtd)
#       PRINT COLUMN g_c[33],sr.oma23;                         #No.FUN-580010
##No.FUN-580010--start
# 
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04);
#                   IF tm.s='1' THEN
#                        PRINT COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                              COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04);
#                      ELSE
#                        PRINT COLUMN g_c[36],cl_numfor(l_amt3-l_amta,36,t_azi04),
#                              COLUMN g_c[37],cl_numfor(l_amt4-l_amtb,37,g_azi04);
#                   END IF
#             PRINT COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3-l_amta,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4-l_amtb,42,g_azi04)
##No.FUN-580010--end
# 
## Thomas 98/10/09
#    AFTER GROUP OF sr.oma03
#       SELECT occ02
#         INTO l_occ02
#         FROM occ_file
#        WHERE occ01 = sr.oma03
#No.FUN-580010--start
#       PRINT COLUMN 01,l_occ02[1,10] CLIPPED;
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE tot_curs CURSOR FOR
#            SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                        SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#            FROM r140m_tmp
#            WHERE cust = sr.oma03
#            GROUP BY curr ORDER BY curr
#       PRINT sr.oma03 CLIPPED;
#       PRINTX name=S1 COLUMN g_c[32],g_x[15] CLIPPED;       #No.FUN-580010
#       FOREACH tot_curs INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                    l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM  azi_file
#           WHERE azi01=l_curr
##NO.FUN-580010--start
#          PRINT COLUMN g_c[33],l_curr;
#{ Thomas 98/11/24
#                PRINT l_amta USING '----,###,##&.&&',
#                      l_amtb USING '---,###,###,##&',
#                      (l_amt3-l_amtc) USING '----,###,##&.&&',
#                      (l_amt4-l_amtd) USING '---,###,###,##&'
#}
##          END CASE
#       PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#             COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04);
#             IF tm.s='1' THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                        COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04);
#             ELSE
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3-l_amta,36,t_azi04),
#                  COLUMN g_c[37],cl_numfor(l_amt4-l_amtb,37,g_azi04);
#             END IF
#       PRINT COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#             COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#             COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#             COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#             COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#             COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#             COLUMN g_c[41],cl_numfor(l_amt3-l_amta,41,t_azi04),
#             COLUMN g_c[42],cl_numfor(l_amt4-l_amtb,42,g_azi04)
##No.FUN-580010--end
#
#       END FOREACH
#       PRINT ' '
# 
##990420 Ivy
#    AFTER GROUP OF sr.occ37
#       IF sr.occ37 MATCHES '[nN]' THEN
#         PRINT 'Non-Affiliate';#No.TQC-6B0051
#          PRINT g_x[10];        #No.TQC-6B0051
#       ELSE
##         PRINT 'Affiliate    ';#No.TQC-6B0051
#          PRINT g_x[9]          #No.TQC-6B0051
#       END IF
##NoFUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE sub_curs2 CURSOR FOR
#            SELECT r140m_tmp.plant,curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                        SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#                   FROM r140m_tmp
#                   WHERE occ37= sr.occ37
#                   GROUP BY r140m_tmp.plant,curr ORDER BY r140m_tmp.plant,curr
## 990506 Ivy
#       OPEN sub_curs2
#       FETCH  sub_curs2  INTO  l_plant
#       LET  l_s_plant  =  l_plant
#       CLOSE  sub_curs2
##
#       PRINT g_x[15] CLIPPED;
#       FOREACH sub_curs2 INTO l_plant,l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                             l_amta,l_amtb,l_amtc,l_amtd
##990506 Ivy
#          IF  l_plant  !=  l_s_plant  THEN
#              LET  l_s_plant  =  l_plant
##No.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#          END IF
##
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
#NO.FUN-580010--start
#          PRINT COLUMN g_c[32],l_plant,COLUMN g_c[33],l_curr;
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##NOo.FUN-580010--end
#       END FOREACH
##  End
## 990506 Ivy
##No.FUN-580010--start
#          PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
#                COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE sub2_curs2 CURSOR FOR
#            SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                   SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#                   FROM r140m_tmp
#                   WHERE occ37= sr.occ37
#                   GROUP BY curr ORDER BY curr
#       FOREACH sub2_curs2 INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                               l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
##No.FUN-580010--start
#             PRINT COLUMN g_c[33],l_curr;
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#       END FOREACH
#       PRINT g_dash1
#
#    ON LAST ROW
#{ 990506
#       PRINT COLUMN 23;
#       IF tm.s='2' THEN
#          PRINT '---- ------------------ ------------------ ------------------ ',
#                '------------------ ------------------ ------------------ ------------------ ',
#                '------------------'
#       ELSE
#          IF tm.s = '3' THEN
#             PRINT '---- ------------------ ------------------ ------------------ ',
#             '------------------'
#          ELSE
#             PRINT '---- ------------------ ------------------ ------------------ ',
#                '------------------ ------------------ ------------------'
#          END IF
#       END IF
#}
       #工廠總計
#       DECLARE tot_curs2 CURSOR FOR
#        SELECT r140m_tmp.plant,curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                                    SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r140m_tmp
#               GROUP BY r140m_tmp.plant,curr ORDER BY r140m_tmp.plant,curr
#       LET l_plant_o = ' '
#       FOREACH tot_curs2 INTO l_plant,l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                             l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          IF l_plant_o != l_plant THEN
#             PRINT l_plant CLIPPED;
#             PRINTX name=S2 COLUMN g_c[32],g_x[16] CLIPPED;                #No.FUN-580010
#          END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
##NoFUN-580010--start
#          PRINT COLUMN g_c[33],l_curr;
#       PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#             COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04);
#             IF tm.s='1' THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                        COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04);
#             ELSE
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3-l_amta,36,t_azi04),
#                        COLUMN g_c[37],cl_numfor(l_amt4-l_amtb,37,g_azi04);
#             END IF
#       PRINT COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#             COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#             COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#             COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#             COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#             COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#             COLUMN g_c[41],cl_numfor(l_amt3-l_amta,41,t_azi04),
#             COLUMN g_c[42],cl_numfor(l_amt4-l_amtb,42,g_azi04)
##No.FUN-580010--end
#          LET l_plant_o = l_plant
#       END FOREACH
#No.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       #公司總計
#       DECLARE tot_curs3 CURSOR FOR
#               SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                           SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r140m_tmp
#               GROUP BY curr ORDER BY curr
#       PRINTX name=S3 COLUMN g_c[32],g_x[17] CLIPPED;      #No.FUN-580010
#       FOREACH tot_curs3 INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                     l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
#No.FUN-580010--start
#         PRINT COLUMN 23,l_curr;
#       PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#             COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04);
#             IF tm.s='1' THEN
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                        COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04);
#             ELSE
#                  PRINT COLUMN g_c[36],cl_numfor(l_amt3-l_amta,36,t_azi04),
#                        COLUMN g_c[37],cl_numfor(l_amt4-l_amtb,37,g_azi04);
#             END IF
#       PRINT COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#             COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#             COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#             COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#             COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#             COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#             COLUMN g_c[41],cl_numfor(l_amt3-l_amta,41,t_azi04),
#             COLUMN g_c[42],cl_numfor(l_amt4-l_amtb,42,g_azi04)
##No.FUN-580010--end
#       END FOREACH
#       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#          CALL cl_wcchp(tm.wc,'oma03') RETURNING tm.wc
#          PRINT g_dash[1,g_len]
#          #TQC-630166
#          #IF tm.s = '2' THEN
          #   IF tm.wc[001,120] > ' ' THEN            # for 132
          #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
          #   IF tm.wc[121,240] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
          #   IF tm.wc[241,300] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
          #ELSE
          #   IF tm.wc[001,070] > ' ' THEN            # for 80
          #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
          #   IF tm.wc[071,140] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
          #   IF tm.wc[141,210] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
          #   IF tm.wc[211,280] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          #END IF
#          CALL cl_prt_pos_wc(tm.wc)
          #END TQC-630166
 
#       END IF
#       LET l_last_sw = 'y'
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#    PAGE TRAILER
#       IF l_last_sw = 'n'
#          THEN PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE SKIP 2 LINE
#       END IF
#END REPORT
#NO.FUN-810010------------------end-----mark------------------
##Patch....NO.TQC-610037 <> #
