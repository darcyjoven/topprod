# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr160.4gl
# Descriptions...: 廠商進貨金額排行表
# Date & Author..: 00/07/31 by Brendan
# Modify.........: No.FUN-4C0097 04/12/27 By Nicola 報表架構修改
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-590456 05/09/29 By Smapmin 將ARRAY大小設為10
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.FUN-710080 07/01/30 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-8A0182 08/10/21 By Sarah 調整UNION改為UNION ALL
# Modify.........: No.FUN-8B0026 08/12/02 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8C0041 08/12/10 By xiaofeizhu SQL語句抓取字段增加apa01,apa36
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.CHI-930004 09/05/13 By jan 程式中原本計算金額的部份搬回4gl處理，將金額當做GROUP加入第一個排序的鍵值
# Modify.........: No.MOD-960018 09/06/13 By baofei FOR l_i = 1 TO length(l_wc)改為FOR l_i = 1 TO length(l_wc)-4                    
# Modify.........: No.MOD-970132 09/07/15 By baofei 增加關系人判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB，去掉報裱中的營運中心
# Modify.........: No.TQC-A40116 10/04/23 By fumk 修改sql语句  
# Modify.........: No:MOD-B10018 11/01/04 By sabrina 將aapr160_prepare2的sql的"00"拿掉
# Modify.........: No:MOD-B40116 11/04/15 By Sarah 調整傳到cl_prt_cs3()的l_sql
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:CHI-B80010 11/10/04 By Dido 增加原物料與費用及暫估帳款 
# Modify.........: No.MOD-BA0141 11/10/19 By Polly 將QBE的apa00調整到INPUT段
# Modify.........: No.MOD-BB0062 11/11/04 By Polly 調整aapr160_prepare1條件，增加退貨暫估
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:FUN-BB0173 12/01/17 by pauline 增加跨法人抓取資料
# Modify.........: No:MOD-C30741 12/03/15 By Polly 增加外購金額抓取條件
# Modify.........: No:MOD-C60046 12/06/08 By Elise 報表撈取折讓金額，應排除apa58=1的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
           wc       STRING,             # Where condition   #TQC-630166
         # plant   ARRAY[10] OF LIKE zx_file.zx08,      # No.FUN-690028 VARCHAR(10), #NO.FUN-A10098 mark                 #FUN-660117
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
           bdate   LIKE type_file.dat,     #No.FUN-690028 DATE
           edate   LIKE type_file.dat,     #No.FUN-690028 DATE
           apa00   LIKE apa_file.apa00,        #No.MOD-BA0141
           prno    LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
           pramt   LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
           misc    LIKE type_file.chr1,        #CHI-B80010
           type    LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           type_1  LIKE type_file.chr1,        # No.FUN-8B0026 VARCHAR(1)
           more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
       END RECORD,
       g_rank      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,              # Rank
       g_atot      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,              # total array
       g_i         LIKE type_file.num5,    #count/index for any purpose  #No.FUN-690028 SMALLINT
       i           LIKE type_file.num5     #TQC-610053  #No.FUN-690028 SMALLINT
DEFINE l_table        STRING                   ### CR11 add ###
DEFINE g_sql          STRING                   ### CR11 add ###
DEFINE g_str          STRING                   ### CR11 add ###
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
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "apa06.apa_file.apa06,",  #CHI-930004 mod
               "apa07.apa_file.apa07,",
               "apa311.apa_file.apa31,",
               "apa312.apa_file.apa31,",
               "plant.azp_file.azp01,",  #FUN-8B0026   #NO.FUN-A10098 mark
               "apa31.apa_file.apa31 "   #CHI-930004 add 
 
   LET l_table = cl_prt_temptable('aapr160',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  # LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,          #TQC-A40116 mark 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40116 modify
             " VALUES(?,?,?,?,?, ?)"      #CHI-930004 拿掉二個?                     #FUN-8B0026 Add ?,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   INITIALIZE tm.* TO NULL                # Default condition
  LET g_pdate = ARG_VAL(1)
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
#NO.FUN-A10098 ----start---mark
# LET tm.plant[1] = ARG_VAL(8)
# LET tm.plant[2] = ARG_VAL(9)
# LET tm.plant[3] = ARG_VAL(10)
# LET tm.plant[4] = ARG_VAL(11)
# LET tm.plant[5] = ARG_VAL(12)
# LET tm.plant[6] = ARG_VAL(13)
# LET tm.plant[7] = ARG_VAL(14)
# LET tm.plant[8] = ARG_VAL(15)
# LET tm.plant[9] = ARG_VAL(16)
# LET tm.plant[10] = ARG_VAL(17)
# LET tm.bdate = ARG_VAL(18)
# LET tm.edate = ARG_VAL(19)
# LET tm.prno = ARG_VAL(20)
# LET tm.pramt = ARG_VAL(21)
# LET tm.type = ARG_VAL(22)    
# FOR i = 1 TO 10
#     IF NOT cl_null(ARG_VAL(i+12)) THEN
#        LET g_atot = g_atot + 1
#     END IF
# END FOR
#  LET g_rep_user = ARG_VAL(23)
#  LET g_rep_clas = ARG_VAL(24)
#  LET g_template = ARG_VAL(25)
#  LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
#  LET tm.type_1= ARG_VAL(27)   
#FUN-BB0173 mark START
#  LET tm.bdate = ARG_VAL(8)
#  LET tm.edate = ARG_VAL(9)
#  LET tm.prno = ARG_VAL(10)
#  LET tm.pramt = ARG_VAL(11)
#  LET tm.type = ARG_VAL(12)
#  LET g_rep_user = ARG_VAL(13)
#  LET g_rep_clas = ARG_VAL(14)
#  LET g_template = ARG_VAL(15)
#  LET g_rpt_name = ARG_VAL(16) 
#  LET tm.type_1= ARG_VAL(17)
#  LET tm.misc= ARG_VAL(18)      #CHI-B80010
#  LET tm.apa00 = ARG_VAL(19)    #MOD-BA0141
#FUN-BB0173 mark END
#NO.FUN-A10098  ----end---
#FUN-BB0173 add START
   LET plant[1] = ARG_VAL(8)
   LET plant[2] = ARG_VAL(9)
   LET plant[3] = ARG_VAL(10)
   LET plant[4] = ARG_VAL(11)
   LET plant[5] = ARG_VAL(12)
   LET plant[6] = ARG_VAL(13)
   LET plant[7] = ARG_VAL(14)
   LET plant[8] = ARG_VAL(15)
   LET tm.bdate = ARG_VAL(16)
   LET tm.edate = ARG_VAL(17)
   LET tm.prno = ARG_VAL(18)
   LET tm.pramt = ARG_VAL(19)
   LET tm.type = ARG_VAL(20)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
   LET tm.type_1= ARG_VAL(25)
   LET tm.misc= ARG_VAL(26)
   LET tm.apa00 = ARG_VAL(27)
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
      CALL r160_legal_db(g_azw01_2)
   END IF
#FUN-BB0173 add END 
   IF cl_null(tm.wc) THEN
      CALL aapr160_tm(0,0)               # Input print condition
   ELSE
      CALL aapr160()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION aapr160_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          i            LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_ac         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5     #No.FUN-940102 
#FUN-BB0173 add START
   DEFINE l_string       STRING
   DEFINE l_plant        LIKE azw_file.azw01
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE l_cnt          LIKE type_file.num5
#FUN-BB0173 add END
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW aapr160_w AT p_row,p_col WITH FORM "aap/42f/aapr160"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r160_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.misc = 'N'      #CHI-B80010
   LET tm.type = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET tm.plant_1 = g_plant   #FUN-BB0173 add
   LET g_copies = '1'

   LET tm.type_1  = '3'        
 
   WHILE TRUE
     #CONSTRUCT BY NAME tm.wc ON apa01,apa06,apa36,apa00    #MOD-BA0141 mark
      CONSTRUCT BY NAME tm.wc ON apa01,apa06,apa36          #MOD-BA0141 拿掉apa00
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         LET INT_FLAG = 0
         CLOSE WINDOW aapr160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF

   #NO.FUN-A10098  ----start---mark 
   #  #----- 工廠編號 -B---#
   #  CALL SET_COUNT(1)    # initial array argument
   #  LET tm.plant[1] = g_plant
 
   #  INPUT ARRAY tm.plant WITHOUT DEFAULTS FROM s_plant.*
   #     AFTER FIELD plant
   #        LET l_ac = ARR_CURR()
   #        IF NOT cl_null(tm.plant[l_ac]) THEN
   #           SELECT azp01 FROM azp_file
   #            WHERE azp01 = tm.plant[l_ac]
   #           IF STATUS THEN
   #              CALL cl_err3("sel","azp_file",tm.plant[l_ac],"",STATUS,"","sel azp",1)  #No.FUN-660122
   #              NEXT FIELD plant
   #           END IF
 
   #           FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
   #              IF tm.plant[i] = tm.plant[l_ac] THEN
   #                 CALL cl_err('','aom-492',1)
   #                 NEXT FIELD plant
   #              END IF
   #           END FOR
   #           CALL s_chk_demo(g_user,tm.plant[l_ac]) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD plant
   #             END IF 
 
   #           IF NOT s_chkdbs(g_user,tm.plant[l_ac],g_rlang) THEN
   #              NEXT FIELD plant
   #           END IF
   #        END IF
 
   #     AFTER INPUT                    # 檢查至少輸入一個工廠
   #        IF INT_FLAG THEN EXIT INPUT END IF
   #        LET g_atot = ARR_COUNT()
   #        FOR i = 1 TO g_atot
   #           IF NOT cl_null(tm.plant[i]) THEN
   #              EXIT INPUT
   #           END IF
   #        END FOR
 
   #        IF i = g_atot+1 THEN
   #           CALL cl_err('','aom-423',1)
   #           NEXT FIELD plant
   #        END IF
 
   #     ON IDLE g_idle_seconds
   #        CALL cl_on_idle()
   #        CONTINUE INPUT
 
   #     ON ACTION about         #MOD-4C0121
   #        CALL cl_about()      #MOD-4C0121
 
   #     ON ACTION help          #MOD-4C0121
   #        CALL cl_show_help()  #MOD-4C0121
 
   #     ON ACTION controlg      #MOD-4C0121
   #        CALL cl_cmdask()     #MOD-4C0121
 
   #     ON ACTION exit
   #        LET INT_FLAG = 1
   #        EXIT INPUT
 
   #  END INPUT
 
   #  IF INT_FLAG THEN
   #     LET INT_FLAG = 0
   #     CLOSE WINDOW aapr160_w
   #     RETURN
   #  END IF
 
   #  #----- 工廠編號 -E---#
   #NO.FUN-A10098  ---end----

      LET g_rank = 0

#FUN-BB0173 add START
   INPUT BY NAME tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8

   WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      LET g_rank = 0

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
         CALL r160_legal_db(l_string)

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
      CLOSE WINDOW r160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#FUN-BB0173 add END

      INPUT BY NAME tm.bdate,tm.edate,tm.apa00,tm.prno,tm.pramt,    #MOD-BA0141 add apa00
                    tm.misc,tm.type,tm.type_1,tm.more             #CHI-B80010 add misc
                   WITHOUT DEFAULTS
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               NEXT FIELD edate
            END IF
            IF tm.bdate > tm.edate THEN
               NEXT FIELD edate
            END IF
 
         AFTER FIELD prno
            IF NOT cl_null(tm.prno) AND tm.prno < 0 THEN
               NEXT FIELD prno
            END IF
 
         AFTER FIELD type
            IF tm.type NOT MATCHES '[123]' THEN
               NEXT FIELD type
            END IF
            
         ON CHANGE  type
        
            CALL r160_set_entry_1()      
            CALL r160_set_no_entry_1()       
            
         AFTER FIELD type_1                                                            
            IF cl_null(tm.type_1) OR tm.type_1 NOT MATCHES '[123]' THEN             
               NEXT FIELD type_1                                                      
            END IF                                                                     
 
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' THEN
               NEXT FIELD more
            END IF
 
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
            

 
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
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aapr160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd
           FROM zz_file                         #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr160'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr160','9031',1)
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
                    #NO.FUN-A10098  ---start---mark
                    #  " '",tm.plant[1] CLIPPED,"'" ,
                    #  " '",tm.plant[2] CLIPPED,"'" ,
                    #  " '",tm.plant[3] CLIPPED,"'" ,
                    #  " '",tm.plant[4] CLIPPED,"'" ,
                    #  " '",tm.plant[5] CLIPPED,"'" ,
                    #  " '",tm.plant[6] CLIPPED,"'" ,
                    #  " '",tm.plant[7] CLIPPED,"'" ,
                    #  " '",tm.plant[8] CLIPPED,"'" ,
                    #  " '",tm.plant[9] CLIPPED,"'" ,
                    #  " '",tm.plant[10] CLIPPED,"'" ,
                    #NO.FUN-A10098  ---end---
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
                       " '",tm.bdate CLIPPED,"'",
                       " '",tm.edate CLIPPED,"'",
                       " '",tm.prno CLIPPED,"'",
                       " '",tm.pramt CLIPPED,"'",
                       " '",tm.type CLIPPED,"'",
                       " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                       " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                       " '",g_template CLIPPED,"'",           #No.FUN-570264
                       " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                       " '",tm.type_1 CLIPPED,"'",            #FUN-8B0026                        
                       " '",tm.misc CLIPPED,"'",              #CHI-B80010
                        " ,",tm.apa00 CLIPPED, ","            #MOD-BA0141                       
                         
            CALL cl_cmdat('aapr160',g_time,l_cmd)  # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr160()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr160_w
 
END FUNCTION
 
FUNCTION aapr160()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     STRING,
          l_sql1    STRING,                 #CHI-B80010
          l_sql2    STRING,                 #MOD-BA0141
          l_dbs     LIKE azp_file.azp03,    # No.FUN-690028 VARCHAR(22)
          j         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_n       LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_i       LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_x00     LIKE type_file.chr50,   # No.FUN-690028 VARCHAR(50)
          l_apa06   LIKE apa_file.apa06,
          l_amt     LIKE apa_file.apa31,
          l_amt2    LIKE apa_file.apa31,
          l_wc      LIKE type_file.chr1000,    #No.FUN-690028 VARCHAR(300)
          sr        RECORD
                   #apa00   LIKE apa_file.apa00,  #CHI-930004 mark
                    apa06   LIKE apa_file.apa06,
                    apa07   LIKE apa_file.apa07,
                    apa311  LIKE apa_file.apa31,
                    apa312  LIKE apa_file.apa31,
                    apa31   LIKE apa_file.apa31   #CHI-930004 add
                    END RECORD
DEFINE     l_pmc903   LIKE pmc_file.pmc903                #No.FUN-8B0026
DEFINE     l_apa01    LIKE apa_file.apa01                 #No.FUN-8B0026
DEFINE     l_apa36    LIKE apa_file.apa36                 #No.FUN-8B0026                    
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### CR11 add ###
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
 
   LET l_wc = tm.wc
   FOR l_i = 1 TO length(l_wc)-4   #MOD-960018 
      CASE l_wc[l_i,l_i+4]
         WHEN 'apa01'
            LET l_wc[l_i,l_i+4] = 'alk01'
         WHEN 'apa06'
            LET l_wc[l_i,l_i+4] = 'alk05'
      END CASE
   END FOR

 #NO.FUN-A10098  ----start---mark 
 # FOR j = 1 TO g_atot
 #    IF cl_null(tm.plant[j]) THEN
 #       CONTINUE FOR
 #    END IF
 
 #    SELECT azp03 INTO l_dbs FROM azp_file
 #     WHERE azp01 = tm.plant[j]
 
 #    LET l_dbs = s_dbstring(l_dbs)
 #NO.FUN-A10098  ----end----
#FUN-BB0173 add START
    LET j = 1
    FOR j = 1 TO g_ary_i
       IF cl_null(g_ary[j].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END 
     #-CHI-B80010-add-
      LET l_sql1 = " "
      IF tm.misc = 'N' THEN   #列印MISC料件
         LET l_sql1 = " AND apb12[1,4] !='MISC'"
      END IF
     #-CHI-B80010-end-
     #-MOD-BA0141-add-
       LET l_sql2 = " "
       IF NOT cl_null(tm.apa00) THEN
          LET l_sql2 = " AND apa00= '",tm.apa00,"'"
       END IF
     #-MOD-BA0141-end-

      IF tm.type MATCHES "[13]" THEN #no.6536
         LET l_sql="SELECT a.apa06,a.apa07,SUM(a.sum1),SUM(a.sum2),SUM(a.sum3),a.pmc903 FROM ",
                   "(                                                           ", 
                  # Prog. Version..: '5.30.06-13.03.12(0) sum2,SUM(apa31-0) sum3, pmc903",  #CHI-B80010 mark 
                   "   SELECT apa00,apa06,apa07,SUM(apb10) sum1,SUM(0) sum2,SUM(apb10-0) sum3, pmc903",  #CHI-B80010
                 #NO.FUN-A10098  ----start---
                 # "     FROM ",l_dbs CLIPPED,"apa_file",
                 # " LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ON apa06=pmc01 ",
                  #"     FROM apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc01 ",          #CHI-B80010 mark
                  #"     FROM apb_file,apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc01 ", #CHI-B80010  #FUN-BB0173 mark
                 #NO.FUN-A10098  ----end----
                   "     FROM ",cl_get_target_table(g_ary[j].plant,'apb_file'),  #FUN-BB0173 add
                   "         ,",cl_get_target_table(g_ary[j].plant,'apa_file'),  #FUN-BB0173 add
                   "       LEFT OUTER JOIN ",cl_get_target_table(g_ary[j].plant,'pmc_file'),  #FUN-BB0173 add
                   "            ON apa06 = pmc01 ",  #FUN-BB0173 add
                   "    WHERE ",tm.wc CLIPPED,
                   "      AND apa01 = apb01 ",l_sql1,                         #CHI-B80010
                   "      AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "      AND apa41 = 'Y' ",
                   "      AND (apa75 = 'N' OR apa75 IS NULL )",
                  #"      AND apa00='11'",                                    #CHI-B80010 mark 
                   "      AND apa00 IN ('11','12','16') ",l_sql2,             #CHI-B80010 #MOD-BA0141 add l_sql2 
                   "      AND apb34 = 'N' ",                                  #MOD-BB0062 add
                   "    GROUP BY apa00,apa06,apa07,pmc903  ",
                   "    UNION ",   
                  # Prog. Version..: '5.30.06-13.03.12(0-apa31) sum3, pmc903", #CHI-B80010 mark 
                   "   SELECT apa00,apa06,apa07,SUM(0) sum1,SUM(apb10) sum2,SUM(0-apb10) sum3, pmc903", #CHI-B80010 
                 #NO.FUN-A10098 ----start----
                 # "     FROM ",l_dbs CLIPPED,"apa_file",
                 # " LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file ON apa06=pmc01 ",
                  #"     FROM apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc01 ",           #CHI-B80010 mark
                  #"     FROM apb_file,apa_file LEFT OUTER JOIN pmc_file ON apa06=pmc01 ",  #CHI-B80010  #FUN-BB0173 mark
                 #NO.FUN-A10098  ----end---
                   "     FROM ",cl_get_target_table(g_ary[j].plant,'apb_file'),  #FUN-BB0173 add
                   "         ,",cl_get_target_table(g_ary[j].plant,'apa_file'),  #FUN-BB0173 add
                   "       LEFT OUTER JOIN ",cl_get_target_table(g_ary[j].plant,'pmc_file'),  #FUN-BB0173 add
                   "            ON apa06 = pmc01 ",  #FUN-BB0173 add
                   "    WHERE ",tm.wc CLIPPED,
                   "      AND apa01 = apb01 ",l_sql1,             #CHI-B80010
                   "      AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "      AND apa41 = 'Y' ",
                   "      AND (apa75 = 'N' OR apa75 IS NULL )",
                  #"      AND apa00 ='21'",                                    #MOD-BB0062 mark
                   "      AND apa00 IN ('21','26')",                           #MOD-BB0062 add
                   "      AND apb34 = 'N' ",                                   #MOD-BB0062 add
                   "      AND apa58 <> '1' ",                                  #MOD-C60046 add
                   "    GROUP BY apa00,apa06,apa07,pmc903  ",
                   ") a                                                         ", 
                   "    GROUP BY apa06,apa07,pmc903 ",
                   "    ORDER BY apa06" 
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE aapr160_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM
         END IF
         DECLARE aapr160_curs1 CURSOR FOR aapr160_prepare1
 
         FOREACH aapr160_curs1 INTO sr.*,l_pmc903        #CHI-930004 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF                                                                     
            IF tm.type_1 = '1' THEN                                                                                                 
               IF l_pmc903  = 'N' THEN  CONTINUE FOREACH END IF                                                                     
            END IF                                                                                                                  
            IF tm.type_1 = '2' THEN   #非關系人                                                                                     
               IF l_pmc903  = 'Y' THEN  CONTINUE FOREACH END IF                                                                     
            END IF                                                                                                                  
            IF cl_null(sr.apa311) THEN LET sr.apa311 = 0 END IF
            IF cl_null(sr.apa312) THEN LET sr.apa312 = 0 END IF
            IF STATUS = 0 THEN
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               EXECUTE insert_prep USING
                #NO.FUN-A10098 ----start---
                # sr.apa06,sr.apa07,sr.apa311,sr.apa312,tm.plant[j],sr.apa31        #CHI-930004
                # sr.apa06,sr.apa07,sr.apa311,sr.apa312,'',sr.apa31  #FUN-BB0173 mark
                  sr.apa06,sr.apa07,sr.apa311,sr.apa312,g_ary[j].plant,sr.apa31    #FUN-BB0173 add
                #NO.FUN-A10098 ----end----
            END IF
         END FOREACH
      END IF
 
      IF tm.type = '2' OR tm.type = '3' THEN
        # Prog. Version..: '5.30.06-13.03.12(0),SUM(ale09-0),pmc903",   #CHI-930004 mod       #MOD-B10018 mark    
         LET l_sql="SELECT alk05,pmc03,SUM(ale09),SUM(0),SUM(ale09-0),pmc903",   #CHI-930004 mod            #MOD-B10018 add 
                  #NO.FUN-A10098  ----start---- 
                  #"  FROM ",l_dbs CLIPPED,"alk_file,",
                  #          l_dbs CLIPPED,"apa_file,",
                  #          l_dbs CLIPPED,"ale_file,",
                  #          l_dbs CLIPPED,"pmc_file",
                  #"  FROM alk_file,apa_file,ale_file,pmc_file",          #CHI-B80010 mark
                  #"  FROM alk_file,apa_file,apb_file,ale_file,pmc_file", #CHI-B80010  #FUN-BB0173 mark
                  #NO.FUN-A10098  ----end----
                   "  FROM ",cl_get_target_table(g_ary[j].plant,'alk_file'),  #FUN-BB0173 add
                   "      ,",cl_get_target_table(g_ary[j].plant,'apa_file'),  #FUN-BB0173 add
                   "      ,",cl_get_target_table(g_ary[j].plant,'apb_file'),  #FUN-BB0173 add
                   "      ,",cl_get_target_table(g_ary[j].plant,'ale_file'),  #FUN-BB0173 add
                   "      ,",cl_get_target_table(g_ary[j].plant,'pmc_file'),  #FUN-BB0173 add
                   " WHERE ",l_wc CLIPPED,
                   "   AND apa01 = apb01 ",l_sql1,             #CHI-B80010
                   "   AND alk02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "   AND alk01 = ale01 ",
                   "   AND alk_file.alk05 = pmc_file.pmc01 ",
                   "   AND apa01 = alk01 AND apa00='11' ",
                   "   AND alkfirm = 'Y'",
                   "   AND apb01 = ale01 ",                    #MOD-C30741 add
                   "   AND apb02 = ale02 ",                    #MOD-C30741 add
                   " GROUP BY alk05,pmc03,pmc903",        #CHI-930004 add
                  #-CHI-B80010-add-
                  #由於 aapt820 未寫入 apb_file,因此無須串 apb_file
                   "    UNION ",   
                   "SELECT alh06,pmc03,SUM(alh16),SUM(0),SUM(alh16-0),pmc903", 
                   "  FROM alh_file,apa_file,pmc_file",
                   " WHERE ",tm.wc CLIPPED,
                   "   AND alh021 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                   "   AND alh_file.alh06 = pmc_file.pmc01 ",
                   "   AND apa01 = alh01 AND apa00='12' ",
                   "   AND alhfirm = 'Y'",
                   " GROUP BY alh06,pmc03,pmc903"
                  #-CHI-B80010-end-
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE aapr160_prepare2 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM
         END IF         
         DECLARE aapr160_curs2 CURSOR FOR aapr160_prepare2
 
         FOREACH aapr160_curs2 INTO sr.*,l_pmc903                   #CHI-930004
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
            IF tm.type_1 = '1' THEN
               IF l_pmc903  = 'N' THEN  CONTINUE FOREACH END IF
            END IF
            IF tm.type_1 = '2' THEN   #非關係人
               IF l_pmc903  = 'Y' THEN  CONTINUE FOREACH END IF
            END IF
            IF cl_null(sr.apa311) THEN LET sr.apa311 = 0 END IF
            IF cl_null(sr.apa312) THEN LET sr.apa312 = 0 END IF
            IF STATUS = 0 THEN
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               EXECUTE insert_prep USING
                 #NO.FUN-A10098 ----start----
                 #sr.apa06,sr.apa07,sr.apa311,sr.apa312,tm.plant[j],sr.apa31         #CHI-930004
                  sr.apa06,sr.apa07,sr.apa311,sr.apa312,'',sr.apa31
                 #NO.FUN-A10098 ----end----
            END IF
         END FOREACH
      END IF
  #END FOR              #NO.FUN-A10098  mark
   END FOR  #FUN-BB0173 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #str MOD-B40116 mod
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
#FUN-BB0173 add START
   IF g_flag = 'Y' THEN  #流通
      LET l_name = 'aapr160_1'
   ELSE
      LET l_name = 'aapr160'
   END IF
#FUN-BB0173 add END
   LET l_sql = "SELECT apa06,apa07,SUM(apa311) apa311,SUM(apa312) apa312,plant,SUM(apa31) apa31",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY apa06,apa07,plant"
  #end MOD-B40116 mod
   #傳per檔的日期區間等參數
   LET g_str = tm.bdate,";",tm.edate,";",g_azi05
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apa01,apa06,apa36,apa00')
           RETURNING tm.wc
      LET g_str = g_str ,";",tm.wc,";"
   END IF
  #CALL cl_prt_cs3('aapr160','aapr160',l_sql,g_str)  #FUN-BB0173 mark
   CALL cl_prt_cs3('aapr160',l_name,l_sql,g_str)  #FUN-BB0173 add
 
 # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
 
FUNCTION r160_set_entry_1()
    CALL cl_set_comp_entry("type_1",TRUE)
END FUNCTION
FUNCTION r160_set_no_entry_1()
    IF tm.type = '2' OR tm.type = '3' THEN
       CALL cl_set_comp_entry("type_1",TRUE)
    ELSE
       CALL cl_set_comp_entry("type_1",FALSE)
    END IF   
END FUNCTION
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r160_set_entry()
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
FUNCTION r160_legal_db(p_string)
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
#No.FUN-9C0077 程式精簡
