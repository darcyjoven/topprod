# Prog. Version..: '5.30.07-13.05.30(00005)'     #
#
# Pattern name...: aapx165.4gl
# Descriptions...: 應付賬款重評價表
# Date & Author..: 02/09/09 By Joe
# Modify by......: 05/04/11 By Anney
# Modify.........: No.FUN-550015 05/05/24 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-560008 05/06/02 By Smapmin DEFINE單價,金額,匯率
# Modify.........: No.MOD-580141 05/08/19 By Smapmin 程式中的 page length 寫死 66
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: NO.MOD-5C0008 05/12/06 BY yiting apf41 <> 'X' "的地方,是否應調整為 apf41 = 'Y',
#                  因為若遇客戶有未確認的aapt330,此份報表的未付本幣會呈現double.
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 應付金額不應扣除留置金額
# Modify.........: No.TQC-770052 07/07/12 By Rayven 制表日期的位置在報表名之上
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-7A0025 07/10/19 By zhoufeng 報表打印改Crystal Report
# Modify.........: No.MOD-7B0136 07/11/19 By Smapmin 未付本幣金額有誤
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.MOD-820114 08/02/26 By Smapmin apk_file為參考資料,故將join 改為OUTER ,並修改原本組成l_sql的語法
#                                                    評價後台幣金額，沒有回加截止日後沖銷得金額
# Modify.........: No.MOD-850142 08/05/19 By Sarah SQL增加過濾條件apa00<>'23'
# Modify.........: No.MOD-890058 08/09/11 By Sarah amt_d應改為sr.amt_b-sr.amt_c
# Modify.........: No.MOD-8A0054 08/10/07 By Sarah 計算未付金額需再抓aph_file
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                  若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: NO.MOD-940218 09/04/15 By lilingyu 計算apa34 amt_al時應該根據rate_no選擇來決定 
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-950033 09/05/07 By lilingyu 計算sr.apa34 sr.amt_b sr.amt_al三值的程式段往后搬到寫入Temptalbe前
# Modify.........: No.MOD-960108 09/06/08 By Sarah 將計算amt_d的程式段搬到算完amt_b與amt_c後
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0076 09/10/12 By mike SQL里有用l_dbs的,应该要调整成s_dbstring(l_dbs CLIPPED)     
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB，去掉報表營運中心
# Modify.........: No.TQC-A40136 10/04/28 By dxfwo  語法錯誤
# Modify.........: No.CHI-A40017 10/05/04 By liuxqa outer语法错误.
# Modify.........: No.TQC-A50157 10/05/28 By Carrier 修案TQC-A40136错误
# Modify.........: No:MOD-B10078 11/01/11 By Dido 過濾預付/暫付應參考 apz62 設定 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_apa14應給予預設值'',抓不到值不應為'1'
# Modify.........: No.MOD-B70265 11/07/29 By Polly 1.l_sql將之OUTER apk_file移除，改成在FOREACH裡再抓取
#                                                  2.修正待抵金額抓取不到問題
# Modify.........: No:TQC-BA0021 11/10/09 By yinhy 1.QBE條件中,賬款編號等欄位建議開窗，方便報表的輸出
#                                                  2.匯率抓取錯誤
# Modify.........: No:MOD-BA0207 11/10/30 By Dido 增加回溯 aapt820 部分;單別條件需排除外購資料
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-CA0132 12/11/05 By minppp CR轉XtraGrid                       
# Modify.........: No.FUN-D40020 13/03/18 By zhangweib  CR轉XtraGrid BUG修改
# Modify.........: No.FUN-D30070 13/03/21 By yangtt 去除畫面檔上小計欄位，并去除4gl中grup_sum_field
# Modify.........: No.FUN-D40129 13/05/23 By yangtt 添加小數取位


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,   #TQC-630166
           h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03), 
          #u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  #FUN-D30070 mark
           b_date  LIKE type_file.dat,     #No.FUN-690028 DATE
           rate_op LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),   #FUN-550015
           wc1      STRING,   #TQC-630166
           more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE    g_orderA  ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)  #TQC-5A0134 VARCHAR-->CHAR
DEFINE    l_name2        LIKE type_file.chr20       # No.FUN-690028 VARCHAR(12)
DEFINE    l_azj01 ARRAY[10] OF LIKE azj_file.azj01,  #幣別 #FUN-660117
          l_azj07 ARRAY[10] OF LIKE azj_file.azj07      # No.FUN-690028 DEC(20,10)  #匯率   #MOD-560008
DEFINE    l_j     LIKE type_file.num5,       #No.FUN-690028 SMALLINT
          l_jj    LIKE type_file.num5        # No.FUN-690028 SMALLINT
#DEFINE m_plant  ARRAY[10] OF LIKE azp_file.azp01  #FUN-660117   #NO.FUN-A10098 mark
DEFINE g_atot   LIKE type_file.num5          # No.FUN-690028 SMALLINT
DEFINE l_order  ARRAY[5] OF LIKE apa_file.apa54      # No.FUN-690028 VARCHAR(20)
DEFINE g_i      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_b_date LIKE type_file.chr8        # No.FUN-690028 VARCHAR(6)
DEFINE i        LIKE type_file.num5     #TQC-610053  #No.FUN-690028 SMALLINT
DEFINE g_sql      STRING                       #No.FUN-7A0025
DEFINE g_str      STRING                       #No.FUN-7A0025
DEFINE l_table    STRING                       #No.FUN-7A0025
 
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF NOT cl_setup("AAP") THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   LET g_sql="apa06.apa_file.apa06,apa07.apa_file.apa07,apk03.apk_file.apk03,",
             "apk05.apk_file.apk05,apa13.apa_file.apa13,apa14.apa_file.apa14,",
             "apa34f.apa_file.apa34f,pma02.pma_file.pma02,",
             "apa64.apa_file.apa64,azj07.azj_file.azj07,apa01.apa_file.apa01,",
             "apa36.apa_file.apa36,apa54.apa_file.apa54,apa12.apa_file.apa12,",
             "apa08.apa_file.apa08,apa21.apa_file.apa21,apa34.apa_file.apa34,",
             "amt_a.apa_file.apa34f,amt_b.apa_file.apa34f,",
             "amt_c.apa_file.apa34f,amt_d.apa_file.apa34f,",
             "amt_a1.apa_file.apa34,azi04.azi_file.azi04,azi07.azi_file.azi07,",
             "g_azi04.azi_file.azi04,g_azi05.azi_file.azi05"   #FUN-D40129 add
   LET l_table = cl_prt_temptable('aapx165',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"    #FUN-D40129 add 2?        
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_trace = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
  LET tm.wc1 = ARG_VAL(8)
#NO.FUN-A10098  ----start---
# LET m_plant[1] = ARG_VAL(9)
# LET m_plant[2] = ARG_VAL(10)
# LET m_plant[3] = ARG_VAL(11)
# LET m_plant[4] = ARG_VAL(12)
# LET m_plant[5] = ARG_VAL(13)
# LET m_plant[6] = ARG_VAL(14)
# LET m_plant[7] = ARG_VAL(15)
# LET m_plant[8] = ARG_VAL(16)
# LET m_plant[9] = ARG_VAL(17)
# LET m_plant[10] = ARG_VAL(18)
# FOR i = 1 TO 10
#     IF NOT cl_null(ARG_VAL(i+12)) THEN
#        LET g_atot = g_atot + 1
#     END IF
# END FOR
# LET tm.b_date = ARG_VAL(19)
# LET tm.rate_op = ARG_VAL(20)
# LET tm.h  = ARG_VAL(21)
# LET tm.s  = ARG_VAL(22)
# LET tm.u  = ARG_VAL(23)
#  LET g_rep_user = ARG_VAL(24)
#  LET g_rep_clas = ARG_VAL(25)
#  LET g_template = ARG_VAL(26)
#  LET g_rpt_name = ARG_VAL(9)  #No.FUN-7C0078
  LET tm.b_date = ARG_VAL(10)
  LET tm.rate_op = ARG_VAL(11)
  LET tm.h  = ARG_VAL(12)
  LET tm.s  = ARG_VAL(13)
#FUN-D30070----mod---str--
 #LET tm.u  = ARG_VAL(14)
 #LET g_rep_user = ARG_VAL(15)
 #LET g_rep_clas = ARG_VAL(16)
 #LET g_template = ARG_VAL(17)
  LET g_rep_user = ARG_VAL(14)
  LET g_rep_clas = ARG_VAL(15)
  LET g_template = ARG_VAL(16)
#FUN-D30070----mod---end--
  LET g_rpt_name = ARG_VAL(9)
#NO.FUN-A10098  ----end----
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL x165_tm()
   ELSE
      CALL x165()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION x165_tm()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_azq01      LIKE azq_file.azq01,      # No.FUN-690028 VARCHAR(10),
          l_i,l_ac     LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_count      LIKE type_file.num5        # No.FUN-690028 SMALLINT
   DEFINE li_result    LIKE type_file.num5     #No.FUN-940102
 
 OPEN WINDOW x165_w WITH FORM "aap/42f/aapx165"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)     #No.FUN-580092 HCN
 CALL cl_ui_init()
 
 CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.h    = '3'
   LET tm.s    = '123'
 # LET tm.u    = 'Y'  #FUN-D30070 mark
   LET tm.b_date = g_today
   LET tm.rate_op = 'S'   #FUN-550015
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #NO.FUN-A10098  ----start---
 # FOR l_i = 1 TO 10
 #     INITIALIZE m_plant[l_i] TO NULL
 # END FOR
 # LET m_plant[1] = g_plant
 #NO.FUN-A10098  ----end---
 #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
#  LET tm2.u1   = tm.u[1,1]   #FUN-D30070 mark
#  LET tm2.u2   = tm.u[2,2]   #FUN-D30070 mark
#  LET tm2.u3   = tm.u[3,3]   #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apa06,apa13,apa01,apa36,apa54,apa12,
                              apa08,apa21
         #No.TQC-BA0021  --Begin
         ON ACTION CONTROLP
           CASE
              WHEN INFIELD(apa06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c" 
                   LET g_qryparam.form = "q_pmc1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa06
                   NEXT FIELD apa06    
              WHEN INFIELD(apa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c" 
                  LET g_qryparam.form ="q_apa08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
              WHEN INFIELD(apa21) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c" 
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa21
                  NEXT FIELD apa21
              WHEN INFIELD(apa13) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa13
                  NEXT FIELD apa13
              WHEN INFIELD(apa36) #帳款類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apr"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa36
                  NEXT FIELD apa36
              #FUN-CA0132---ADD---STR
               WHEN INFIELD(apa08) #查詢預付號碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apa081"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa08
                  NEXT FIELD apa08
               WHEN INFIELD(apa54) # Account number
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag02"   #TQC-790133
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa54
                  NEXT FIELD apa54
               #FUN-CA0132---ADD---END
              OTHERWISE EXIT CASE
           END CASE
         #No.TQC-BA0021  --End
   ON ACTION locale
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
 
   CONSTRUCT BY NAME tm.wc1 ON apyslip
 
 
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
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW x165_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF cl_null(tm.wc1) THEN LET tm.wc1=" 1=1" END IF  #No.TQC-BA0021
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   CALL SET_COUNT(1)
 
#NO.FUN-A10098  ----start---mark
#  #----- 工廠編號 -B---#
#  INPUT ARRAY m_plant WITHOUT DEFAULTS FROM s_plant.* #ATTRIBUTE(YELLOW)  #TQC-8C0076
#     AFTER FIELD plant
#       LET l_ac = ARR_CURR()
#       IF NOT cl_null(m_plant[l_ac]) THEN
#          SELECT azp01 FROM azp_file WHERE azp01 = m_plant[l_ac]
#          IF STATUS THEN
#             CALL cl_err3("sel","azp_file",m_plant[l_ac],"",STATUS,"","sel azp",1)  #No.FUN-660122
#             NEXT FIELD plant
#          END IF
#          FOR l_i = 1 TO l_ac-1      # 檢查工廠是否重覆
#              IF m_plant[l_i] = m_plant[l_ac] THEN
#                 CALL cl_err('','aom-492',1) NEXT FIELD plant
#              END IF
#          END FOR
#              CALL s_chk_demo(g_user,m_plant[l_ac]) RETURNING li_result
#                IF not li_result THEN 
#                   NEXT FIELD plant
#                END IF 
#       END IF
#     AFTER INPUT                    # 檢查至少輸入一個工廠
#       IF INT_FLAG THEN EXIT INPUT END IF
#       LET g_atot = ARR_COUNT()
#       FOR l_i = 1 TO g_atot
#           IF NOT cl_null(m_plant[l_i]) THEN EXIT INPUT END IF
#       END FOR
#       IF l_i = g_atot+1 THEN
#          CALL cl_err('','aom-423',1) NEXT FIELD plant
#       END IF
#    ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#    ON ACTION exit
#       LET INT_FLAG = 1
#       EXIT INPUT
#
#
#  END INPUT
 
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0 CLOSE WINDOW aapr120_w EXIT PROGRAM
#  END IF
#  #----- 工廠編號 -E---#
#NO.FUN-A10086   ---end---
 
   INPUT BY NAME tm.b_date,tm.rate_op,tm.h,   #FUN-550015
                   tm2.s1,tm2.s2,tm2.s3,
                  #tm2.u1,tm2.u2,tm2.u3, #FUN-D30070 mark
                   tm.more
                   WITHOUT DEFAULTS

      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070 mark
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
      CLOSE WINDOW x165_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aapx165'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapx165','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET tm.wc1=cl_wcsub(tm.wc1)
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",
                    #NO.FUN-A10098 ----start---mark
                    #   " '",m_plant[1] CLIPPED,"'",
                    #   " '",m_plant[2] CLIPPED,"'",
                    #   " '",m_plant[3] CLIPPED,"'",
                    #   " '",m_plant[4] CLIPPED,"'",
                    #   " '",m_plant[5] CLIPPED,"'",
                    #   " '",m_plant[6] CLIPPED,"'",
                    #   " '",m_plant[7] CLIPPED,"'",
                    #   " '",m_plant[8] CLIPPED,"'",
                    #   " '",m_plant[9] CLIPPED,"'",
                    #   " '",m_plant[10] CLIPPED,"'",
                    #NO.FUN-A10098 ----end---
                        " '",tm.b_date CLIPPED,"'",
                        " '",tm.rate_op CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                      # " '",tm.u CLIPPED,"'",  #FUN-D30070 mark
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         IF g_trace = 'Y' THEN
            ERROR l_cmd
         END IF
         CALL cl_cmdat('aapx165',g_time,l_cmd)
      END IF
      CLOSE WINDOW x165_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x165()
   ERROR ""
END WHILE
   CLOSE WINDOW x165_w
END FUNCTION
 
FUNCTION x165()
   DEFINE l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql           STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_dbs           LIKE azp_file.azp03,          #No.FUN-690028 VARCHAR(22),
          l_cmd           LIKE type_file.chr1000,       #No.+366 010705 plum  #No.FUN-690028 VARCHAR(30)
          g_azi03         LIKE azi_file.azi03,
          g_azi04         LIKE azi_file.azi04,
          g_azi05         LIKE azi_file.azi05,
          l_apg04         LIKE apg_file.apg04,
          l_over_pay      LIKE apg_file.apg05,
          l_over_pay_1    LIKE apg_file.apg05f,
          l_aph04         LIKE aph_file.aph04,   #MOD-8A0054 add
          l_over_payh     LIKE aph_file.aph05,   #MOD-8A0054 add
          l_over_payh_1   LIKE aph_file.aph05f,  #MOD-8A0054 add
          l_over_payv     LIKE apv_file.apv04,   #MOD-B70265 add
          l_over_payv_1   LIKE apv_file.apv04f,  #MOD-B70265 add
          l_over_paya     LIKE apa_file.apa34,   #MOD-BA0207
          l_over_paya_1   LIKE apa_file.apa34f,  #MOD-BA0207
          l_i             LIKE type_file.num5,   #No.FUN-690028 SMALLINT
          l_apg04_1       LIKE apg_file.apg04,
          l_over_pay_21   LIKE apg_file.apg05,
          l_over_pay_22   LIKE apg_file.apg05
   DEFINE sr     RECORD
                  order1  LIKE apa_file.apa54,   #No.FUN-690028 VARCHAR(20),
                  order2  LIKE apa_file.apa54,   #No.FUN-690028 VARCHAR(20),
                  order3  LIKE apa_file.apa54,   #No.FUN-690028 VARCHAR(20),
                  apa00   LIKE apa_file.apa00,   #賬款性質
                  apa01   LIKE apa_file.apa01,   #帳款編號
                  apa36   LIKE apa_file.apa36,   #帳款類別
                  apa54   LIKE apa_file.apa54,   #貸方
                  apa08   LIKE apa_file.apa08,   #發票
                  apa21   LIKE apa_file.apa21,   #請款人員
                  apa06   LIKE apa_file.apa06,   #付款廠商
                  apa07   LIKE apa_file.apa07,   #廠商簡稱
                  apk03   LIKE apk_file.apk03,   #Inv No.
                  apk05   LIKE apk_file.apk05,   #Inv Date.
                  apa13   LIKE apa_file.apa13,   #幣別
                  apa14   LIKE apa_file.apa14,   #匯率
                  apa12   LIKE apa_file.apa12,   #重評價匯率
                  apa34f  LIKE apa_file.apa34f,  #應付帳款
                  amt_a   LIKE apa_file.apa34f,  #未付帳款
                  amt_b   LIKE apa_file.apa34f,  #未付本幣
                  pma02   LIKE pma_file.pma02,   #付款條件
                  apa64   LIKE apa_file.apa64,   #到期日
                  amt_c   LIKE apa_file.apa34f,  #評價後台幣金額
                  amt_d   LIKE apa_file.apa34f,  #匯兌損益
                  apa34   LIKE apa_file.apa34,   #應付帳款 L
                  amt_al  LIKE apa_file.apa34,   #未付帳 L
                  azj01   LIKE azj_file.azj01,   #幣別
                  un_pay  LIKE apa_file.apa34,
                  un_pay1 LIKE apa_file.apa34f,  
                  azj07   LIKE azj_file.azj07    #月底重評匯率
                 END RECORD
   DEFINE sr_1   RECORD
                  apk01   LIKE apk_file.apk01,   #帳款單號
                  apk03   LIKE apk_file.apk03,   #發票號碼
                  apk06   LIKE apk_file.apk06    #含稅金額
                 END RECORD
   DEFINE l_oox01         STRING                 #CHI-830003 add
   DEFINE l_oox02         STRING                 #CHI-830003 add
   DEFINE l_sql_1         STRING                 #CHI-830003 add
   DEFINE l_sql_2         STRING                 #CHI-830003 add
   DEFINE l_count         LIKE type_file.num5    #CHI-830003 add
   DEFINE l_apa14         LIKE apa_file.apa14    #CHI-830003 add                  
   DEFINE l_apyslip       LIKE type_file.num5    #FUN-A10098 add
   DEFINE l_apa01         LIKE apa_file.apa01    #No.TQC-A40136
   DEFINE l_str           STRING                 #FUN-CA0132 
   DEFINE amt_al1         LIKE apa_file.apa34    #FUN-CA0132
   DEFINE l_apa34         LIKE apa_file.apa34    #FUN-CA0132
   CALL cl_del_data(l_table)                    #No.FUN-7A0025
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05 FROM azi_file
    WHERE azi01 = g_aza.aza17
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   LET l_apa34=0                                  #FUN-CA0132
   LET amt_al1=0                                  #FUN-CA0132 
   LET l_b_date[1,4] = YEAR(tm.b_date)
   IF MONTH(tm.b_date) > 9 THEN
      LET l_b_date[5,6] = MONTH(tm.b_date)
   ELSE
      LET l_b_date[5,5] = '0'
      LET l_b_date[6,6] = MONTH(tm.b_date)
   END IF
   


 #NO.FUN-A10098   ----start----mark 
 # FOR l_i = 1 TO g_atot
 #    IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF
 #    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = m_plant[l_i]
 #NO.FUN-A10098   ----end---
      LET l_sql = "SELECT '','','',",
                  " apa00,apa01,apa36,apa54,apa08,apa21,",
                # " apa06,apa07,apa08,apk05,apa13,apa14,0,apa34f,",       #No.MOD-B70265 mark
                  " apa06,apa07,apa08,'',apa13,apa14,0,apa34f,",          #No.MOD-B70265 add
                  " (apa34f-apa35f),apa73,",    #MOD-720128
                  " pma02,apa64,(apa34f-apa35f),0,",   #MOD-720128
                  " apa34, apa73,azj01, ",          #MOD-720128         
                   " 0,0,azj07 ",
                #NO.FUN-A10098  ----start---
                # " FROM ",s_dbstring(l_dbs CLIPPED),"apa_file,",  #FUN-820017
                #          s_dbstring(l_dbs CLIPPED),"pma_file,",  #FUN-820017
                #          " OUTER ",s_dbstring(l_dbs CLIPPED),"apk_file,",  #FUN-820017   #MOD-820114
                #          s_dbstring(l_dbs CLIPPED),"azj_file ",  #FUN-820017 
                # " WHERE apa_file.apa01 = apk_file.apk01 ",   #MOD-820114
                # "   AND apk_file.apk02 = '1' ",
                # " FROM apa_file LEFT OUTER JOIN apk_file ",                  #No.MOD-B70265 mark
                  " FROM apa_file,pma_file,azj_file",                          #No.MOD-B70265 add
                # " ON apa_file.apa01 = apk_file.apk01 ,pma_file,azj_file ", #CHI-A40017 mark
                # " ON apa_file.apa01 = apk_file.apk01 AND apk_file.apk02 = '1' ,pma_file,azj_file ", #CHI-A40017 mod  #No.MOD-B70265 mark
                # " WHERE apk_file.apk02 = '1' ",  #CHI-A40017 mark
                #NO.FUN-A10098  ----end---
                # "   AND apa11 = pma01 ",   #MOD-820114    #CHI-A40017 mark
                  "   WHERE apa11 = pma01 ",   #MOD-820114  #CHI-A40017 mod
                 #"   AND apa00 <> '23'",   #MOD-850142 add #MOD-B10078 mark
                  "   AND apa42 = 'N' ",
                  "   AND apa02 <= '",tm.b_date,"'",
                  "   AND apa13 = azj01 ",   #MOD-820114
                  "   AND apa13 <> '",g_aza.aza17,"'",   #FUN-550015
                  "   AND azj02 = '",l_b_date CLIPPED,"'",
                  "   AND ", tm.wc CLIPPED  
                # "   AND SUBSTRING(apa01,1,",g_doc_len,") in (SELECT apyslip FROM apy_file WHERE ",tm.wc1 CLIPPED,")"   #MOD-560008 #FUN-A10098  mark
 
      IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
      IF tm.h='1' THEN
         LET l_sql=l_sql CLIPPED," AND apa41='Y' "
      END IF
      IF tm.h='2' THEN
         LET l_sql=l_sql CLIPPED," AND apa41='N' "
      END IF
     #-MOD-B10078-add-
      IF g_apz.apz62 = 'Y' THEN    #預付/暫付不做月底重評價
         LET l_sql = l_sql CLIPPED,
                     " AND apa00 != '23' AND apa00 != '24' "
      END IF
     #-MOD-B10078-end-
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
      PREPARE x165_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE x165_curs1 CURSOR FOR x165_prepare1

    #NO.FUN-A10098  ----start--- 
    # LET l_sql =" SELECT apk01,apk03,apk06 FROM ",s_dbstring(l_dbs CLIPPED),"apk_file", #MOD-9A0076
      LET l_sql =" SELECT apk01,apk03,apk06 FROM apk_file",
    #NO.FUN-A10098 ----end---
                 "  WHERE apk01 = ? "
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
      PREPARE x165_prepare_apk FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      DECLARE x165_curs_apk CURSOR FOR x165_prepare_apk
 
      ####取幣別、匯率
      LET l_sql =" SELECT DISTINCT apa13,azj07 FROM ",
                #NO.FUN-A10098  ----start----
                #  s_dbstring(l_dbs CLIPPED),"apa_file ,",                                                                          
                #  s_dbstring(l_dbs CLIPPED),"azj_file ",
                 " apa_file,azj_file ",
                #NO.FUN-A10098  ----end---                                                                           
                 " WHERE apa42 = 'N'  ",
                 "   AND apa02 <= '",tm.b_date,"'",
                 "   AND apa13 = azj_file.azj01 ",
                #"   AND apa00 <> '23'",   #MOD-850142 add #MOD-B10078 mark
                 "   AND azj02 = '",l_b_date CLIPPED,"'",
                 "   AND ", tm.wc CLIPPED
     #-MOD-B10078-add-
      IF g_apz.apz62 = 'Y' THEN    #預付/暫付不做月底重評價
         LET l_sql = l_sql CLIPPED,
                     " AND apa00 != '23' AND apa00 != '24' "
      END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
     #-MOD-B10078-end-
      PREPARE x165_prepare_azj FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      LET l_j=1
      DECLARE x165_curs_azj CURSOR FOR x165_prepare_azj
      FOREACH x165_curs_azj INTO l_azj01[l_j],l_azj07[l_j]
         IF l_azj01[l_j] <> g_aza.aza17 THEN
            LET  l_j=l_j+1
         END IF
      END FOREACH
      LET l_jj = l_j -1
 
 
      LET g_pageno = 0
#     LET l_apa01 = sr.apa01[1,g_doc_len]  #No.TQC-A40136  #No.TQC-A50157
      FOREACH x165_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
        #FUN-A10098  ---start---  
        #-MOD-BA0207-add-
         LET l_count = 0        
         LET l_apyslip = 0     
         SELECT COUNT(*) INTO l_count
           FROM alk_file
          WHERE alk01 = sr.apa01
         IF cl_null(l_count) THEN LET l_count = 0 END IF
        #-MOD-BA0207-end-
         LET l_sql = " SELECT COUNT(*) FROM apy_file ",
                     " WHERE apyslip = ? AND ",tm.wc1 CLIPPED
         PREPARE x165_pre_apyslip FROM l_sql
#        EXECUTE x165_pre_apyslip INTO l_apyslip USING sr.apa01[1,g_doc_len]#No.TQC-A40136

         LET l_apa01 = sr.apa01[1,g_doc_len]  #No.TQC-A40136  #No.TQC-A50157
         EXECUTE x165_pre_apyslip INTO l_apyslip USING l_apa01              #No.TQC-A40136     
        #IF l_apyslip = 0 THEN                   #MOD-BA0207 mark
         IF l_apyslip = 0 AND l_count = 0 THEN   #MOD-BA0207
            CONTINUE FOREACH
         END IF
        #FUN-A10098 ---end---         
#-----------------------------------No.MOD-B70265-----------------------------------start
         SELECT apk05 INTO sr.apk05 FROM apk_file
          WHERE apk_file.apk01=sr.apa01 AND apk_file.apk02 = '1'
#-----------------------------------No.MOD-B70265-------------------------------------end 
      IF g_apz.apz27 = 'Y' THEN
         LET l_oox01 = YEAR(tm.b_date)
         LET l_oox02 = MONTH(tm.b_date)                      	 
         LET l_apa14 = ''  #TQC-B10083 add
         WHILE cl_null(l_apa14)
               LET l_count = 0         #MOD-BA0207
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.apa01,"'",
                             "   AND oox04 = '0'"
               PREPARE x165_prepare7 FROM l_sql_2
               DECLARE x165_oox7 CURSOR FOR x165_prepare7
               OPEN x165_oox7
               FETCH x165_oox7 INTO l_count
               CLOSE x165_oox7                       
               IF l_count = 0 THEN
                  #LET l_apa14 = '1'  #TQC-B10083 mark 
                  EXIT WHILE          #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AP' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.apa01,"'",
                                "   AND oox04 = '0'"
               END IF                  
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE x165_prepare07 FROM l_sql_1
               DECLARE x165_oox07 CURSOR FOR x165_prepare07
               OPEN x165_oox07
               FETCH x165_oox07 INTO l_apa14
               CLOSE x165_oox07
            END IF              
         END WHILE                       
      END IF
 
      CALL s_curr3(sr.apa13,tm.b_date,tm.rate_op) RETURNING sr.azj07     #MOD-940218 
      
      #IF cl_null(l_apa14)  THEN LET l_apa14=1  END IF
      #IF cl_null(sr.azj07) THEN LET sr.azj07=1 END IF
 
         IF sr.apa34f= ' ' OR cl_null(sr.apa34f) THEN LET sr.apa34f= 0 END IF
         IF sr.amt_a = ' ' OR cl_null(sr.amt_a)  THEN LET sr.amt_a = 0 END IF
         IF sr.amt_b = ' ' OR cl_null(sr.amt_b)  THEN LET sr.amt_b = 0 END IF
         IF sr.amt_c = ' ' OR cl_null(sr.amt_c)  THEN LET sr.amt_c = 0 END IF
         IF sr.amt_d = ' ' OR cl_null(sr.amt_d)  THEN LET sr.amt_d = 0 END IF
         #--->基準日期之後的已付金額
         LET l_sql =" SELECT apg04,SUM(apg05),SUM(apg05f) ",
                   #NO.FUN-A10098   ----start----
                   #"   FROM ",s_dbstring(l_dbs CLIPPED),"apf_file,",                                                               
                   #           s_dbstring(l_dbs CLIPPED),"apg_file",                                                                
                    "   FROM apf_file,apg_file",
                   #NO.FUN-A10098   ----end----
                    "  WHERE apf01 = apg01 ",
                    "    AND apf41 = 'Y' ", #NO.MOD-5C0008
                    "    AND apg04 = '",sr.apa01,"'",  #帳款編號
                    "    AND apf02 > '",tm.b_date,"'",
                    "  GROUP BY apg04 "
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
         PREPARE apg_pre FROM l_sql
         IF STATUS THEN CALL cl_err('apg_pre',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM 
         END IF
         DECLARE apg_curs CURSOR FOR apg_pre
         OPEN apg_curs
         FETCH apg_curs INTO l_apg04,l_over_pay,l_over_pay_1
         IF sqlca.sqlcode  !=  0  then
            CLOSE apg_curs
            LET l_apg04 = ' '
            LET l_over_pay = 0
            LET l_over_pay_1 = 0
         END IF
         CLOSE apg_curs
         
         #IF g_apz.apz27 = 'Y'  AND l_count <> 0 THEN         #TQC-B10083 mark
         IF g_apz.apz27 = 'Y'  AND NOT cl_null(l_apa14) THEN  #TQC-B10083 mod
            LET l_over_pay = l_over_pay_1 * l_apa14
         END IF    
         
         LET l_sql =" SELECT aph04,SUM(aph05),SUM(aph05f) ",
                   #NO.FUN-A10098  ----start---
                   #"   FROM ",s_dbstring(l_dbs CLIPPED),"apf_file,",                                                               
                   #           s_dbstring(l_dbs CLIPPED),"aph_file",                                                                
                    "   FROM apf_file,aph_file",
                   #NO.FUN-A10098  ----end---
                    "  WHERE apf01 = aph01 ",
                    "    AND apf41 = 'Y' ",
                    "    AND aph04 = '",sr.apa01,"'",  #帳款編號
                    "    AND apf02 > '",tm.b_date,"'",
                    "  GROUP BY aph04 "
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
         PREPARE aph_pre FROM l_sql
         IF STATUS THEN CALL cl_err('aph_pre',STATUS,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM 
         END IF
         DECLARE aph_curs CURSOR FOR aph_pre
         OPEN aph_curs
         FETCH aph_curs INTO l_aph04,l_over_payh,l_over_payh_1
         IF sqlca.sqlcode != 0  then
            CLOSE aph_curs
            LET l_aph04 = ' '
            LET l_over_payh = 0
            LET l_over_payh_1 = 0
         END IF
         CLOSE  aph_curs
#--------------------------------------No.MOD-B70265----------------------------start
         LET l_sql ="SELECT SUM(apv04),SUM(apv04f) ",
                     " FROM apv_file,apa_file",
                     " WHERE apv03= ?  AND apv01=apa01 AND apa41<>'X' ",
                     "   AND apa02 > ?",
                     "   AND apa42 = 'N'",
                     "   AND apv05 = '1'"

         PREPARE apv_pre FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare apv:',SQLCA.sqlcode,1)
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-BB0047 add
            EXIT PROGRAM
         END IF
         DECLARE apv_curs CURSOR FOR apv_pre
         OPEN apv_curs USING sr.apa01,tm.b_date
         FETCH apv_curs INTO l_over_payv,l_over_payv_1
         IF cl_null(l_over_payv) THEN
            LET l_over_payv = 0
         END IF
         IF cl_null(l_over_payv_1) THEN
            LET l_over_payv_1 = 0
         END IF
         CLOSE  apv_curs
#--------------------------------------No.MOD-B70265------------------------------end
        #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
         IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN   #TQC-B10083 mod
            LET l_over_payh = l_over_payh_1 * l_apa14
         END IF    

        #-MOD-BA0207-add-
         LET l_over_paya = 0
         LET l_over_paya_1 = 0
         LET l_sql ="SELECT apa34,apa34f ",
                     " FROM alh_file,apa_file",
                     " WHERE alh30= ?  AND alh30=apa01 AND apa41<>'X' ",
                     "   AND alh021 > ?",
                     "   AND apa42 = 'N'"
         PREPARE alh_pre FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare alh:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #MOD-BA0207
            EXIT PROGRAM
         END IF
         DECLARE alh_curs CURSOR FOR alh_pre
         OPEN alh_curs USING sr.apa01,tm.b_date
         FETCH alh_curs INTO l_over_paya,l_over_paya_1
         IF cl_null(l_over_paya) THEN LET l_over_paya = 0 END IF
         IF cl_null(l_over_paya_1) THEN LET l_over_paya_1 = 0 END IF
         CLOSE alh_curs
        #-MOD-BA0207-end-
       
        #LET sr.amt_b = sr.amt_b + l_over_pay + l_over_payh                                         #MOD-BA0207 mark
        #LET sr.amt_b = sr.amt_b + l_over_pay + l_over_payh  + l_over_paya                          #MOD-BA0207 #MOD-B70265 mark
         LET sr.amt_b = sr.amt_b + l_over_pay + l_over_payh + l_over_payv + l_over_paya             #MOD-B70265 add
        #LET sr.amt_a = sr.amt_a + l_over_pay_1 + l_over_payh_1                                     #MOD-BA0207 mark
        #LET sr.amt_a = sr.amt_a + l_over_pay_1 + l_over_payh_1 + l_over_paya_1                     #MOD-BA0207 #MOD-B70265 mark
         LET sr.amt_a = sr.amt_a + l_over_pay_1 + l_over_payh_1 + l_over_payv_1 + l_over_paya_1     #MOD-B70265 add 
        #LET sr.amt_c = sr.amt_c + l_over_pay_1 + l_over_payh_1                                     #MOD-BA0207 mark
        #LET sr.amt_c = sr.amt_c + l_over_pay_1 + l_over_payh_1  + l_over_paya_1                    #MOD-BA0207 #MOD-B70265 mark
         LET sr.amt_c = sr.amt_c + l_over_pay_1 + l_over_payh_1 + l_over_payv_1 + l_over_paya_1     #MOD-B70265 add 

	 IF sr.amt_b = 0 OR sr.amt_a = 0 THEN CONTINUE FOREACH END IF
 
         IF sr.apa00[1,1] = '2' THEN
            LET sr.apa34f= sr.apa34f * -1
            LET sr.amt_a = sr.amt_a * -1
            LET sr.amt_b = sr.amt_b * -1
            LET sr.amt_c = sr.amt_c * -1
         END IF

         LET sr.amt_c = sr.amt_c * sr.azj07
         IF cl_null(sr.amt_c) THEN
            LET sr.amt_c = 0
         END IF
 
         #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN             #TQC-B10083 mark
         IF g_apz.apz27 = 'Y' THEN                               #TQC-B10083 mod
            #IF tm.rate_op = 'R' THEN                            #TQC-B10083 mark
            IF tm.rate_op = 'R' AND NOT cl_null(l_apa14) THEN    #TQC-B10083 mod              
               LET sr.apa34  = sr.apa34f * l_apa14
               LET sr.amt_b  = sr.amt_a * l_apa14
               LET sr.amt_al = sr.amt_a * l_apa14
            #ELSE                                                #TQC-B10083 mark
            END IF                                               #TQC-B10083 add
            #No.TQC-BA0021  --Begin
            #IF tm.rate_op != 'R' AND NOT cl_null(sr.azj07) THEN  #TQC-B10083 add                
            #   LET sr.apa34  = sr.apa34f * sr.azj07 
            #   LET sr.amt_b  = sr.amt_a * sr.azj07    
            #   LET sr.amt_al = sr.amt_a * sr.azj07  
            #END IF 	                               
            #No.TQC-BA0021  --Begin
         END IF    
 
         LET sr.amt_d = sr.amt_b-sr.amt_c   #MOD-890058   #MOD-960108 mod

         SELECT azi03,azi04,azi05,azi07
           INTO t_azi03,t_azi04,t_azi05,t_azi07  
           FROM azi_file
          WHERE azi01=sr.apa13
         EXECUTE insert_prep USING
            sr.apa06,sr.apa07,sr.apk03,sr.apk05,
            sr.apa13,sr.apa14,sr.apa34f,sr.pma02,
            sr.apa64,sr.azj07,sr.apa01,sr.apa36,
            sr.apa54,sr.apa12,sr.apa08,sr.apa21,
            sr.apa34,sr.amt_a,sr.amt_b,sr.amt_c,
            sr.amt_d,sr.amt_al,t_azi04,t_azi07
            ,g_azi04,g_azi05   #FUN-D40129
          
          LET l_apa34 =l_apa34+sr.apa34                      #FUN-CA0132-應付帳款本幣求和
          LET amt_al1 =amt_al1+sr.amt_al                     #FUN-CA0132-未付帳款本幣求和
      END FOREACH
  #END FOR              #NO.FUN-A10098  ----mark----

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = ''
   END IF
#FUN-CA0132--mod--str
#   LET g_str = g_str,";",tm.b_date,";",tm.s[1,1],";",tm.s[2,2],";",
#               tm.s[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
#              ,";",g_azi04,";",g_azi05   #MOD-890058 add g_azi05  #MOD-960108 add g_azi04
#   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#   CALL cl_prt_cs3('aapx165','aapx165',l_sql,g_str)
   LET g_xgrid.table = l_table
   LET g_xgrid.order_field = cl_get_order_field(tm.s,"apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21")
  #LET g_xgrid.grup_field = cl_get_sum_field(tm.s,tm.u,"apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21")  #FUN-D30070 mark
   LET g_xgrid.grup_field = cl_get_order_field(tm.s,"apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21")  #FUN-D30070 add
  #No.FUN-D40020 -start--- Add
   IF cl_null(g_xgrid.grup_field) THEN
      LET g_xgrid.grup_field = "apa13"
   ELSE
      LET g_xgrid.grup_field = g_xgrid.grup_field,",apa13"
   END IF
  #No.FUN-D40020 ---end  --- Add
  #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21") #FUN-D30070 mark
  #LET l_str = cl_wcchp(g_xgrid.order_field,"apa06,apa13,apa01,apa36,apa54,apa12,apa08,apa21")  #FUN-D30070 mark
  #LET l_str = cl_replace_str(l_str,',','-')  #FUN-D30070 mark
   LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc       #列印條件
   LET g_xgrid.footerinfo1 = cl_getmsg("lib-058",g_lang),l_apa34   #應付帳款總計
   LET g_xgrid.footerinfo2 = cl_getmsg("lib-059",g_lang),amt_al1   #未付帳款總計
  #LET g_xgrid.footerinfo3 = cl_getmsg("lib-626",g_lang),l_str     #排列順序  #FUN-D30070 mark
   CALL cl_xg_view()   
#FUN-CA0132--mod--end
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
#No.FUN-9C0077 程式精簡


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
