# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr126.4gl
# Descriptions...: 廠商已請未付明細表列印作業
# Date & Author..: 97/08/27  By  Kitty
# Modify.........: No.MOD-520130 05/02/25 By Nicola 未沖金額顯示錯誤在計算基準日期之後的已付金額,應該要加上判斷確認碼為"Y"者,因為確認才會回寫apa_file才有扣除..
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: No.MOD-5C0070 05/12/14 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.TQC-630042 06/03/06 無法執行
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/24 By douzh l_time轉g_time
# Modify.........: No.FUN-690080 06/10/25 By ice 查詢帳款,增加13,17,25類型的判斷與關聯
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0088 06/11/10 By baogui無列印順序
# Modify.........: No.TQC-6B0128 06/11/24 By Rayven 簡稱和帳款類型欄位寬度過短，有數據溢出，打印時有報錯提示
# Modify.........: No.TQC-740050 07/04/11 By Judy 報表FROM位置錯誤
# Modify.........: NO.MOD-720128 07/05/04 By Smapmin 原幣未付與本幣未付不需扣除留置金額
#                                                    增加留置金額欄位
# Modify.........: No.FUN-770093 07/11/01 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.CHI-830029 08/03/26 By Smapmin 納入2*類的資料
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
#                                                       若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.MOD-8C0191 08/12/22 By Sarah 當發票為MISC多發票的時候,報表無法印出發票資料
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0091 09/11/17 By wujie  报表改为多帐期资料
# Modify.........: No:FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB，去掉營運中心
# Modify.........: No:CHI-A30008 10/03/09 By sabrina 將g_azi03,g_azi04,g_azi05的定義移除
# Modify.........: No:CHI-A40017 10/04/22 By liuxqa modify sql
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_apa14應給予預設值''，抓不到值不應為'1'
# Modify.........: NO.FUN-B20014 11/02/12 By lilingyu SQL增加apf00<>'32' or apf00<>'36'的條件
# Modify.........: No:MOD-B70047 11/07/07 By Dido 未付金額應包含 apc14/apc15
# Modify.........: No:TQC-B70203 11/07/28 By Sarah 修正MOD-B70047,apc13不需再扣apc15
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
           wc      STRING,   #TQC-630166
           h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           a       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  
           u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
           b_date  LIKE type_file.dat,         #No.FUN-690028 DATE
           more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD,
          g_dash1_1      LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(400),    #No.MOD-590440    #No.TQC-630042 modify
          l_name2        LIKE type_file.chr20       # No.FUN-690028 VARCHAR(12)
   #DEFINE m_plant  ARRAY[10] OF VARCHAR(10)            #FUN-660117 remark
  #DEFINE m_plant  ARRAY[10] OF LIKE azp_file.azp01  #FUN-660117 #FUN-A10098 mark
   DEFINE g_atot   LIKE type_file.num5        # No.FUN-690028 SMALLINT
   DEFINE i        LIKE type_file.num5     #TQC-610053  #No.FUN-690028 SMALLINT
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0055
 
DEFINE   g_i             LIKE type_file.num5,     #count/index for any purpose  #No.FUN-690028 SMALLINT
         g_orderA      ARRAY[3] OF LIKE imm_file.imm13  #No.TQC-6A0088
DEFINE   g_sql           STRING                         #No.FUN-770093
DEFINE   g_str           STRING                         #No.FUN-770093
DEFINE   l_table         STRING                         #No.FUN-770093
DEFINE   l_table1        STRING                         #No.FUN-770093
 
MAIN
 
   OPTIONS
 
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047
 
   #No.FUN-770093 --start--
   LET g_sql="chr1.type_file.chr1,apa06.apa_file.apa06,apa07.apa_file.apa07,",
             "apa01.apa_file.apa01,apr02.apr_file.apr02,apa54.apa_file.apa54,",
             "apa22.apa_file.apa22,apa08.apa_file.apa08,apa02.apa_file.apa02,",
             "apa44.apa_file.apa44,apa43.apa_file.apa43,apa12.apa_file.apa12,",
             "apa34.apa_file.apa34,apa34f.apa_file.apa34f,",
             "apa20.apa_file.apa20,apa13.apa_file.apa13,apa14.apa_file.apa14,",
             "apa25.apa_file.apa25,apa36.apa_file.apa36,apa21.apa_file.apa21,",
             "azi04.azi_file.azi04,azi05.azi_file.azi05,azi07.azi_file.azi07,",
             "apa06_1.apa_file.apa06,apa07_1.apa_file.apa07,",
             "apr02_1.apr_file.apr02,apa13_1.apa_file.apa13,",
             "apa34_1.apa_file.apa34,apa34f_1.apa_file.apa34f,",
             "apa20_1.apa_file.apa20,azi05_1.azi_file.azi05"
   LET l_table = cl_prt_temptable('aapr126',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055  #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
   
   LET g_sql="apk01.apk_file.apk01,apk03.apk_file.apk03,apk06.apk_file.apk06"
   LET l_table1 = cl_prt_temptable('aapr1261',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
 
   #No.FUN-770093 --end--
 
   #No.FUN-770093 --mark--
#   DROP TABLE aapr126_tmp
## No.FUN-690028 --start-- 
#  CREATE TEMP TABLE aapr126_tmp(
#      order1   LIKE apa_file.apa54,
#      order2   LIKE apa_file.apa54,
#      order3   LIKE apa_file.apa54,
#      curr     LIKE adu_file.adu10,
#      un_pay   LIKE type_file.num20_6,
#      un_pay1  LIKE type_file.num20_6,
#      on_hold  LIKE type_file.num20_6)   #MOD-720128
## No.FUN-690028 ---end---
  #No.FUN-770093 --end--
 
  #-----MOD-720128---------
  DROP TABLE aapr126_tmp2
  CREATE TEMP TABLE aapr126_tmp2
     (apa06    LIKE apa_file.apa06,
      apa07    LIKE apa_file.apa07,       #No.FUN-770093 add
      apa13    LIKE apa_file.apa13,
      apr02    LIKE apr_file.apr02,
      un_pay   LIKE type_file.num20_6,
      un_pay1  LIKE type_file.num20_6,
      on_hold  LIKE type_file.num20_6,
      azi05    LIKE azi_file.azi05)       #No.FUN-770093 add
  #-----END MOD-720128-----
 
   IF STATUS THEN CALL cl_err('create',STATUS,1)
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.h  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
  #-----TQC-610053---------
  LET tm.s = ARG_VAL(10)
  LET tm.u = ARG_VAL(11)
  LET tm.b_date = ARG_VAL(12)

 #NO.FUN-A10098 ---start---mark---
 #LET m_plant[1] = ARG_VAL(13)
 #LET m_plant[2] = ARG_VAL(14)
 #LET m_plant[3] = ARG_VAL(15)
 #LET m_plant[4] = ARG_VAL(16)
 #LET m_plant[5] = ARG_VAL(17)
 #LET m_plant[6] = ARG_VAL(18)
 #LET m_plant[7] = ARG_VAL(19)
 #LET m_plant[8] = ARG_VAL(20)
 #LET m_plant[9] = ARG_VAL(21)
 #LET m_plant[10] = ARG_VAL(22)
 #FOR i = 1 TO 10
 #    IF NOT cl_null(ARG_VAL(i+12)) THEN
 #       LET g_atot = g_atot + 1
 #    END IF
 #END FOR
 ##-----END TQC-610053-----
 # #No.FUN-570264 --start--
 # LET g_rep_user = ARG_VAL(23)
 # LET g_rep_clas = ARG_VAL(24)
 # LET g_template = ARG_VAL(25)
 # LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
 # #No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)
 #NO.FUN-A10098 ---end--- 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r126_tm(0,0)
   ELSE
      CALL r126()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r126_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_i,l_ac     LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE li_result    LIKE type_file.num5    #No.FUN-940102 
   
   LET p_row = 1 LET p_col = 20
   OPEN WINDOW r126_w AT p_row,p_col
     WITH FORM "aap/42f/aapr126"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.h    = '3'
   LET tm.a    = '1'
   LET tm.s    = '123'
   LET tm.u    = 'Y'
   LET tm.b_date = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #NO.FUN-A10098 ---start--mark---
  #FOR l_i = 1 TO 10
  #    INITIALIZE m_plant[l_i] TO NULL
  #END FOR
  #LET m_plant[1] = g_plant
  #NO.FUN-A10098 ---end---mark---
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
#   DELETE FROM aapr126_tmp                  #No.FUN-770093 --mark--
   DELETE FROM aapr126_tmp2   #MOD-720128
   CONSTRUCT BY NAME tm.wc ON apa06,apa01,apa54,apa08,apa13,apa36,apa12,
                              apa21
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
      CLOSE WINDOW r126_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   CALL SET_COUNT(1)

 #NO.FUN-A10098 ----start---mark---
 # #----- 工廠編號 -B---#
 # INPUT ARRAY m_plant WITHOUT DEFAULTS FROM s_plant.*
 #    AFTER FIELD plant
 #      LET l_ac = ARR_CURR()
 #      IF NOT cl_null(m_plant[l_ac]) THEN
 #         SELECT azp01 FROM azp_file WHERE azp01 = m_plant[l_ac]
 #         IF STATUS THEN
##            CALL cl_err('sel azp',STATUS,1) #No.FUN-660122
 #            CALL cl_err3("sel","azp_file",m_plant[l_ac],"",STATUS,"","sel azp",1)  #No.FUN-660122
 #            NEXT FIELD plant
 #         END IF
 #         FOR l_i = 1 TO l_ac-1      # 檢查工廠是否重覆
 #             IF m_plant[l_i] = m_plant[l_ac] THEN
 #                CALL cl_err('','aom-492',1) NEXT FIELD plant
 #             END IF
 #         END FOR
 #   #No.FUN-940102 --begin--
 #             CALL s_chk_demo(g_user,m_plant[l_ac]) RETURNING li_result
 #               IF not li_result THEN 
 #                  NEXT FIELD plant
 #               END IF 
 #   #No.FUN-940102 --end--  
 #      END IF
 #    AFTER INPUT                    # 檢查至少輸入一個工廠
 #      IF INT_FLAG THEN EXIT INPUT END IF
 #      LET g_atot = ARR_COUNT()
 #      FOR l_i = 1 TO g_atot
 #          IF NOT cl_null(m_plant[l_i]) THEN EXIT INPUT END IF
 #      END FOR
 #      IF l_i = g_atot+1 THEN
 #         CALL cl_err('','aom-423',1) NEXT FIELD plant
 #      END IF
 #    ON IDLE g_idle_seconds
 #       CALL cl_on_idle()
 #       CONTINUE INPUT
 
 #    ON ACTION about         #MOD-4C0121
 #       CALL cl_about()      #MOD-4C0121
 
 #    ON ACTION help          #MOD-4C0121
 #       CALL cl_show_help()  #MOD-4C0121
 
 #    ON ACTION controlg      #MOD-4C0121
 #       CALL cl_cmdask()     #MOD-4C0121
 
 
 #        ON ACTION exit
 #        LET INT_FLAG = 1
 #        EXIT INPUT
 # END INPUT
 # IF INT_FLAG THEN
 #    LET INT_FLAG = 0 CLOSE WINDOW aapr120_w EXIT PROGRAM
 # END IF
 # #----- 工廠編號 -E---#
 #NO.FUN-A10098  ---end---mark---
 
   INPUT BY NAME tm.b_date,tm.h,tm.a,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more
                   WITHOUT DEFAULTS
      AFTER FIELD b_date
         IF cl_null(tm.b_date) THEN NEXT FIELD b_date END IF
      AFTER FIELD h
         IF cl_null(tm.h) OR tm.h NOT MATCHES '[123]' THEN
            NEXT FIELD h
         END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r126_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aapr126'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr126','9031',1)
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
                         " '",tm.h CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                        #-----TQC-610053---------
                        " '",tm.b_date CLIPPED,"'",
                       #NO.FUN-A10098 ---start---mark--
                       #" '",m_plant[1] CLIPPED,"'",
                       #" '",m_plant[2] CLIPPED,"'",
                       #" '",m_plant[3] CLIPPED,"'",
                       #" '",m_plant[4] CLIPPED,"'",
                       #" '",m_plant[5] CLIPPED,"'",
                       #" '",m_plant[6] CLIPPED,"'",
                       #" '",m_plant[7] CLIPPED,"'",
                       #" '",m_plant[8] CLIPPED,"'",
                       #" '",m_plant[9] CLIPPED,"'",
                       #" '",m_plant[10] CLIPPED,"'",
                       #NO.FUN-A10098 ---end---mark--
                        #-----END TQC-610053-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapr126',g_time,l_cmd)
      END IF
      CLOSE WINDOW r126_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r126()
   ERROR ""
END WHILE
   CLOSE WINDOW r126_w
END FUNCTION
 
FUNCTION r126()
   DEFINE l_name    LIKE type_file.chr20      # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0055
   #DEFINE l_sql     LIKE type_file.chr1000   # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
   DEFINE l_sql      STRING        # RDSQL STATEMENT   #TQC-630166
   DEFINE l_za05    LIKE type_file.chr1000,   #No.FUN-690028 VARCHAR(40)
          l_dbs     LIKE azp_file.azp03,      # No.FUN-690028 VARCHAR(22),
          l_cmd     LIKE type_file.chr50,     #No.+366 010705 plum  #No.FUN-690028 VARCHAR(30)
         #g_azi03        LIKE azi_file.azi03,       #CHI-A30008 mark 
         #g_azi04        LIKE azi_file.azi04,       #CHI-A30008 mark 
         #g_azi05        LIKE azi_file.azi05,       #CHI-A30008 mark 
          l_apg04       LIKE apg_file.apg04,
          l_over_pay    LIKE apg_file.apg05,
          l_over_pay_1  LIKE apg_file.apg05f,
          l_i           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_order       ARRAY[5] OF LIKE apa_file.apa54      # No.FUN-690028 VARCHAR(100)     #FUN-560011
   DEFINE l_apg04_1       LIKE apg_file.apg04
 
   DEFINE  sr  RECORD
                       order1 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                       order2 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                       order3 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                       apa01 LIKE apa_file.apa01,  #帳款編號
                       apa02 LIKE apa_file.apa02,  #帳款日期
                       apa06 LIKE apa_file.apa06,  #付款廠商
                       apa07 LIKE apa_file.apa07,  #廠商簡稱
                       apa08 LIKE apa_file.apa08,  #發票號碼
                       apa12 LIKE apa_file.apa12,  #幣別
                       apa13 LIKE apa_file.apa13,  #幣別
                       apa14 LIKE apa_file.apa14,  #匯率
                       apa19 LIKE apa_file.apa19,  #留置原因
                       apo02 LIKE apo_file.apo02,
                       apa21 LIKE apa_file.apa21,  #帳款人員
                       apa22 LIKE apa_file.apa22,  #帳款部門
                       apa25 LIKE apa_file.apa25,  #備註
                       apa75 LIKE apa_file.apa75,  #是否為外購
                       apa36 LIKE apa_file.apa36,  #帳款類別
                       apa00 LIKE apa_file.apa00,  #帳款性質
                       apa43 LIKE apa_file.apa43,  #傳票日期
                       apa44 LIKE apa_file.apa44,  #傳票編號
                       apr02 LIKE apr_file.apr02,  #帳款類別
                       apa54 LIKE apa_file.apa54,
                       apa34f LIKE apa_file.apa34f,
                       apa34 LIKE apa_file.apa34,
                       apa20 LIKE apa_file.apa20,   #MOD-720128
                       un_pay  LIKE apa_file.apa34,
                       un_pay1  LIKE apa_file.apa34f #No.MOD-5C0070
                  END RECORD
   DEFINE  sr_1  RECORD
                       apk01 like apk_file.apk01,
                       apk03 like apk_file.apk03,
                       apk06 like apk_file.apk06
                  END RECORD
 
#No.FUN-770093 --start--
   DEFINE sr1    RECORD
                       apa06   LIKE apa_file.apa06,
                       apa07   LIKE apa_file.apa07,
                       apr02   LIKE apr_file.apr02, 
                       apa13   LIKE apa_file.apa13,
                       un_pay  LIKE apa_file.apa34,
                       un_pay1 LIKE apa_file.apa34f,
                       apa20   LIKE apa_file.apa20,
                       azi05   LIKE azi_file.azi05
                 END RECORD
#No.FUN-770093 --end--
 
   DEFINE  l_str  LIKE type_file.chr1000             #No.FUN-770093
   DEFINE l_oox01   STRING                           #CHI-830003 add
   DEFINE l_oox02   STRING                           #CHI-830003 add
   DEFINE l_sql_1   STRING                           #CHI-830003 add
   DEFINE l_sql_2   STRING                           #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
   DEFINE l_apa14   LIKE apa_file.apa14              #CHI-830003 add   
 
   #No.FUN-770093 --start--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM 
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM 
   END IF
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #No.FUN-770093 --end--
 
#   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055     #FUN-B80105  MARK
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004------Begin-------
#  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#    FROM azi_file WHERE azi01 = g_aza.aza17
#No.CHI-6A0004-----End---------
 
   #No.TQC-6B0128 --start--
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr126'
#  IF g_len = 0 OR g_len IS NULL THEN
#     LET g_len = 192    #No.MOD-5C0070
#  END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aapr126'
 
#  FOR g_i = 1 TO g_len
#      LET g_dash[g_i,g_i] = '='
#  END FOR
#  FOR g_i = 1 TO g_len
#      LET g_dash1_1[g_i,g_i] = '-'
#  END FOR
   #No.TQC-6B0128 --end--
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
  #No.FUN-770093 --mark--
#  CALL cl_outnam('aapr126') RETURNING l_name
#  IF tm.a      = '3' THEN
#     LET l_name2=l_name
#     LET l_name2[11,11]='x'
#  ELSE LET l_name2= l_name
#  END IF
#  IF tm.a      matches'[13]' THEN
#     START REPORT r126_rep TO l_name
#  END IF
#  IF tm.a      matches'[23]' THEN
#        START REPORT r126_rep2 TO l_name2
#  END IF
  #No.FUN-770093 --end--

#NO.FUN-A10098 start---mark-- 
#  FOR l_i = 1 TO g_atot
#     IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF
#     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = m_plant[l_i]
#     LET l_dbs=s_dbstring(l_dbs CLIPPED)
#NO.FUN-A10098 end---mark---
      #No.MOD-5C0070  --Begin
      IF g_apz.apz27 = 'N' THEN
         LET l_sql = "SELECT '','','',",
#No.MOD-9B0091 --begin
#                     " apa01,apa02,apa06,apa07,apa08,apa12,apa13,apa14,",
#                     " apa19,apo02,apa21,apa22,",
#                     " apa25,apa75,apa36,apa00,apa43,apa44,apr02,apa54,",
#                     " (apa34f-apa35f), ",   #TQC-610098   #MOD-720128
#                     " (apa34-apa35),apa20,0,0  ",   #TQC-610098   #MOD-720128
#                     #" (apa34f-apa35f-apa20), ",   #TQC-610098   #MOD-720128
#                     #" (apa34-apa35-apa20*apa14),0,0  ",   #TQC-610098   #MOD-720128
                      " apa01,apa02,apa06,apa07,apc12,apc04,apa13,apc06,",
                      " apa19,apo02,apa21,apa22,",
                      " apa25,apa75,apa36,apa00,apa43,apa44,apr02,apa54,",
                      " (apc08-apc10-apc14), ",           #MOD-B70047 add apc14
                      " (apc09-apc11-apc15),apc16,0,0  ", #MOD-B70047 add apc15 
#MOD-9B0091 --end
                   #NO.FUN-A10098 ----start----
                   # " FROM ",l_dbs CLIPPED," apa_file,OUTER ",
                   #          l_dbs CLIPPED," apr_file,OUTER ",
                   #          l_dbs CLIPPED," apo_file ",
                   # "      ,",l_dbs,"apc_file ",               #No.MOD-9B0091
                   # " FROM apa_file,OUTER apr_file,OUTER ",   #CHI-A40017 mark
                   # " FROM apa_file,OUTER apr_file,OUTER ",   #CHI-A40017 mark
                    " FROM apa_file LEFT OUTER JOIN apr_file ON apa36 = apr01 ",  #CHI-A40017 mod 
                    "  LEFT OUTER JOIN apo_file ON apa19 = apo01 ",  #CHI-A40017 mod
                     " ,apc_file ",  #CHI-A40017 mod
                   #NO.FUN-A10098 ----end----  
                     #" WHERE apa_file.apa36 = apr_file.apr01 ",  #CHI-A40017 mark
                     #"   AND apa_file.apa19 = apo_file.apo01 ",  #CHI-A40017 mark
                     "   WHERE apc01 = apa01",            #CHI-A40017 mod        #No.MOD-9B0091
                     #"   AND (apa00 = '11' OR apa00='12' OR apa00='15' OR apa00 = '13' OR apa00 = '17') ",  #No.FUN-690080   #CHI-830029
                     "   AND (apa00 LIKE '1%' OR apa00 LIKE '2%') ",  #No.FUN-690080   #CHI-830029
                     "   AND apa42 = 'N' AND apa74 = 'N'  ",
                     "   AND apa02 <= '",tm.b_date,"'",
                     "   AND ", tm.wc CLIPPED
      ELSE
         LET l_sql = "SELECT '','','',",
#MOD-9B0091 --begin
#                     " apa01,apa02,apa06,apa07,apa08,apa12,apa13,apa72,",
#                     " apa19,apo02,apa21,apa22,",
#                     " apa25,apa75,apa36,apa00,apa43,apa44,apr02,apa54,",
#                     " (apa34f-apa35f), ",   #TQC-610098   #MOD-720128
#                     " apa73,apa20,0,0 ",   #TQC-610098   #MOD-720128
#                     #" (apa34f-apa35f-apa20), ",   #TQC-610098   #MOD-720128
#                     #" (apa73-apa20*apa72),0,0 ",   #TQC-610098   #MOD-720128
                      " apa01,apa02,apa06,apa07,apc12,apc04,apa13,apc07,",
                      " apa19,apo02,apa21,apa22,",
                      " apa25,apa75,apa36,apa00,apa43,apa44,apr02,apa54,",
                      " (apc08-apc10-apc14), ",    #MOD-B70047 add apc14
                     #" (apc13-apc15),apa20,0,0 ", #MOD-B70047 add apc15  #TQC-B70203 mark
                      " apc13,apa20,0,0 ", #MOD-B70047 add apc15          #TQC-B70203
#MOD-9B0091 --end
                    #NO.FUN-A10098 ----start---
                    #" FROM ",l_dbs CLIPPED," apa_file,OUTER ",
                    #         l_dbs CLIPPED," apr_file,OUTER ",
                    #         l_dbs CLIPPED," apo_file ",
                    #"      ,",l_dbs,"apc_file ",               #No.MOD-9B0091
                    # " FROM apa_file,OUTER apr_file,OUTER ",
                    # " apo_file,apc_file ",
                     " FROM apa_file LEFT OUTER JOIN apr_file ON apa36=apr01 ", #CHI-A40017 
                     " LEFT OUTER JOIN apo_file ON apa19 = apo01 ",  #CHI-A40017
                     " ,apc_file ",  #CHI-A40017 mod
                    #NO.FUN-A10098 ----end---
                     #" WHERE apa_file.apa36 = apr_file.apr01 ", #CHI-A40017
                     #"   AND apa_file.apa19 = apo_file.apo01 ", #CHI-A40017 
                     " WHERE apc01 = apa01", #CHI-A40017                   #No.MOD-9B0091
                     #"   AND (apa00 = '11' OR apa00='12' OR apa00='15' OR apa00 = '13' OR apa00 = '17') ",  #No.FUN-690080   #CHI-830029
                     "   AND (apa00 LIKE '1%' OR apa00 LIKE '2%') ",  #No.FUN-690080   #CHI-830029
                     "   AND apa42 = 'N' AND apa74 = 'N'  ",
                     "   AND apa02 <= '",tm.b_date,"'",
                     "   AND ", tm.wc CLIPPED
      END IF
      #No.MOD-5C0070  --End
 
      IF tm.h='1' THEN
         LET l_sql=l_sql CLIPPED," AND apa41='Y' "
      END IF
      IF tm.h='2' THEN
         LET l_sql=l_sql CLIPPED," AND apa41='N' "
      END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      PREPARE r126_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
      DECLARE r126_curs1 CURSOR FOR r126_prepare1
 
     #LET l_sql =" SELECT apk01,apk03,apk06 FROM ",l_dbs CLIPPED,"apk_file", #NO.FUN-A10098 
      LET l_sql =" SELECT apk01,apk03,apk06 FROM apk_file",               #NO.FUN-A10098
                 "  WHERE apk01 = ? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      PREPARE r126_prepare_apk FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
      DECLARE r126_curs_apk CURSOR FOR r126_prepare_apk
 
      LET g_pageno = 0
      FOREACH r126_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
          
         #CHI-830003--Add--Begin--#    
         IF g_apz.apz27 = 'Y' THEN
            LET l_oox01 = YEAR(tm.b_date)
            LET l_oox02 = MONTH(tm.b_date)                      	 
            LET l_apa14 = ''  #TQC-B10083 add
            WHILE cl_null(l_apa14)
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.apa01,"'",
                             "   AND oox04 = '0'"
               PREPARE r126_prepare7 FROM l_sql_2
               DECLARE r126_oox7 CURSOR FOR r126_prepare7
               OPEN r126_oox7
               FETCH r126_oox7 INTO l_count
               CLOSE r126_oox7                       
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
                  PREPARE r126_prepare07 FROM l_sql_1
                  DECLARE r126_oox07 CURSOR FOR r126_prepare07
                  OPEN r126_oox07
                  FETCH r126_oox07 INTO l_apa14
                  CLOSE r126_oox07
               END IF              
            END WHILE                       
         END IF
         
         #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
         IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN   #TQC-B10083 mod
            LET sr.apa34 = sr.apa34f * l_apa14
         END IF    
         #CHI-830003--End--#            
          
         #--->基準日期之後的已付金額
         IF sr.apa00 MATCHES '1*' THEN   #CHI-830029
            LET l_sql =" SELECT apg04,SUM(apg05),SUM(apg05f) ",
                      #NO.FUN-A10098 ---start---
                      #"   FROM ",l_dbs CLIPPED,"apf_file,",
                      #           l_dbs CLIPPED,"apg_file",
                       "   FROM apf_file,apg_file",
                      #NO.FUN-A10098 ----end---
                       "  WHERE apf01 = apg01 ",
                     # "    AND apf41 <> 'X' ",  #No.MOD-520130 Mark
                       "    AND apf41 = 'Y' ",   #No.MOD-520130
                       "    AND (apf00 <> '32' OR apf00 <> '36')",      #FUN-B20014           
                       "    AND apg04 = '",sr.apa01,"'",  #帳款編號
                       "    AND apf02 > '",tm.b_date,"'",
              #        " and apf00 = '33' ",
                       "  GROUP BY apg04 "
         #-----CHI-830029---------
         ELSE
            LET l_sql =" SELECT aph04,SUM(aph05),SUM(aph05f) ",
                      #NO.FUN-A10098 ---start---
                      #"   FROM ",l_dbs CLIPPED,"apf_file,",
                      #           l_dbs CLIPPED,"aph_file",
                       "   FROM apf_file,apg_file",
                      #NO.FUN-A10098 ----end---
                       "  WHERE apf01 = aph01 ",
                       "    AND apf41 = 'Y' ",   
                       "    AND (apf00 <> '32' OR apf00 <> '36')",      #FUN-B20014                                 
                       "    AND aph04 = '",sr.apa01,"'",  
                       "    AND apf02 > '",tm.b_date,"'",
                       "  GROUP BY aph04 "
         END IF
         #-----END CHI-830029-----
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE apg_pre FROM l_sql
         IF STATUS THEN
            CALL cl_err('apg_pre',STATUS,1)
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
            EXIT PROGRAM
         END IF
         DECLARE apg_curs CURSOR FOR apg_pre
         OPEN apg_curs
         FETCH apg_curs INTO l_apg04,l_over_pay,l_over_pay_1
         IF SQLCA.sqlcode != 0 THEN
            CLOSE apg_curs
            LET l_apg04 = ' '
            LET l_over_pay = 0
            LET l_over_pay_1 = 0
         END IF
         CLOSE apg_curs
         
         #CHI-830003--Begin--#
         #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
         IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN   #TQC-B10083 mod
            LET l_over_pay = l_over_pay_1 * l_apa14
         END IF    
         #CHI-830003--End--#           
 
         LET sr.un_pay = sr.apa34 + l_over_pay
         LET sr.un_pay1 = sr.apa34f + l_over_pay_1
         IF sr.un_pay = 0 OR sr.un_pay1 = 0 THEN CONTINUE FOREACH END IF
         #-----CHI-830029---------
         IF sr.apa00 MATCHES '2*' THEN 
            LET sr.un_pay = sr.un_pay * -1
            LET sr.un_pay1 = sr.un_pay1 * -1
            LET sr.apa20 = sr.apa20 * -1
         END IF
         #-----END CHI-830029----- 
         IF sr.apa75 != 'Y' THEN
            IF sr.apo02 IS NOT NULL AND sr.apo02 != ' ' THEN
               LET sr.apa25 = sr.apo02
            END IF
         END IF
        #No.FUN-770093 --mark--
#        FOR g_i = 1 TO 3
#            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa06
#                                          LET g_orderA[g_i] = g_x[11]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa13
#                                          LET g_orderA[g_i] = g_x[34]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa01
#                                          LET g_orderA[g_i] = g_x[35]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa36
#     	                            LET g_orderA[g_i] = g_x[36]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa54
#     	                            LET g_orderA[g_i] = g_x[37]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa12
#     	                            LET g_orderA[g_i] = g_x[38]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apa08
#     	                            LET g_orderA[g_i] = g_x[39]    #TQC-6A0088 add
#                 WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.apa21
#     	                            LET g_orderA[g_i] = g_x[40]    #TQC-6A0088 add
#                 OTHERWISE LET l_order[g_i] = '-'
#     	                            LET g_orderA[g_i] = ''   #TQC-6A0088 add
#            END CASE
#        END FOR
#        LET sr.order1 = l_order[1]
#        LET sr.order2 = l_order[2]
#        LET sr.order3 = l_order[3]
#        IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#        IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
#        IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
         #No.FUN-770093 --end--
 
         #No.FUN-770093 --start--
         SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
           FROM azi_file WHERE azi01=sr.apa13
 
         IF tm.a MATCHES '[13]' THEN
#           OUTPUT TO REPORT r126_rep(sr.*)
#           INSERT INTO aapr126_tmp VALUES(sr.order1,sr.order2,sr.order3,
#                                          #sr.apa13,sr.un_pay,sr.un_pay1)   #MOD-720128
#                                          sr.apa13,sr.un_pay,sr.un_pay1,sr.apa20)   #MOD-720128
            EXECUTE insert_prep USING
               '1',sr.apa06,sr.apa07,sr.apa01,
               sr.apr02,sr.apa54,sr.apa22,sr.apa08,
               sr.apa02,sr.apa44,sr.apa43,sr.apa12,
               sr.un_pay,sr.un_pay1,sr.apa20,
               sr.apa13,sr.apa14,sr.apa25,sr.apa36,
               sr.apa21,t_azi04,
               t_azi05,t_azi07,'','','','','','',
               '',''
         END IF
         IF tm.a MATCHES '[23]' THEN
#           OUTPUT TO REPORT r126_rep2(sr.apa06, sr.apa07,
#                                      #sr.apr02, sr.apa54,sr.un_pay,   #MOD-720128
#                                      sr.apa13,sr.apr02, sr.apa54,sr.un_pay,   #MOD-720128
#                                      sr.un_pay1)  #No.MOD-5C0070
#           INSERT INTO aapr126_tmp2 VALUES(sr.apa06,sr.apa13,sr.apr02,
#                                           sr.un_pay,sr.un_pay1,sr.apa20)   #MOD-720128
            INSERT INTO aapr126_tmp2 VALUES(sr.apa06,sr.apa07,sr.apa13,
                                            sr.apr02,sr.un_pay,sr.un_pay1,
                                            sr.apa20,t_azi05)
#           EXECUTE insert_prep USING
#              '2','','','','','','','','','','','',
#              '','','','','','','','','','','',
#              sr.apa06, sr.apa07,sr.apr02,sr.apa13,
#              sr.un_pay,sr.un_pay1,sr.apa20,t_azi05
         END IF
         IF sr.apa08 = 'MISC' THEN
           #OPEN r126_curs_apk USING sr.apa01                 #MOD-8C0191 mark
           #FOREACH r126_curs_apk INTO sr_1.*                 #MOD-8C0191 mark
            FOREACH r126_curs_apk USING sr.apa01 INTO sr_1.*  #MOD-8C0191
               EXECUTE insert_prep1 USING sr.apa01,sr_1.apk03,sr_1.apk06
            END FOREACH
         END IF
         #No.FUN-770093 --end--
      END FOREACH
#  END FOR            #NO.FUN-A10098 ---mark---
   #No.FUN-770093 --mark--
#  IF tm.a MATCHES '[13]' THEN
#     FINISH REPORT r126_rep
#  END IF
#  IF tm.a MATCHES '[23]' THEN
#     FINISH REPORT r126_rep2
#    #No.+366 010705 plum
#     LET l_cmd = "chmod 777 ", l_name2
#     RUN l_cmd
#    #No.+366..end
#  END IF
#  IF tm.a = '3' THEN
#     LET l_sql='cat ',l_name2,'>> ',l_name
#     RUN l_sql
#  END IF
#
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #No.FUN-770093 --end--
   #No.FUN-770093 --start--
   IF tm.a MATCHES '[23]' THEN 
      DECLARE sum_curs4 CURSOR FOR 
         SELECT apa06,apa07,apr02,apa13,SUM(un_pay),
                SUM(un_pay1),SUM(on_hold),azi05
           FROM aapr126_tmp2
          GROUP BY apa06,apa07,apa13,azi05,apr02
          ORDER BY apa06,apa13,apr02
 
      FOREACH sum_curs4 INTO sr1.*
         EXECUTE insert_prep USING
            '2','','','','','','','','','','','', 
            '','','','','','','','','','','',     
            sr1.apa06,sr1.apa07,sr1.apr02,sr1.apa13, 
            sr1.un_pay,sr1.un_pay1,sr1.apa20,sr1.azi05
      END FOREACH
   END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'apa06,apa01,apa54,apa08,apa13,apa36,apa12,apa21')
           RETURNING tm.wc
      LET g_str = tm.wc 
   END IF
   IF g_towhom IS NULL OR g_towhom = ' ' THEN
      LET l_str = ''
   ELSE 
      LET l_str = 'TO:',g_towhom
   END IF
   LET g_str=g_str,";",tm.a,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
             tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",g_azi05,";",
             g_azi04,";",tm.b_date,";",l_str,";",tm.h
   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   CALL cl_prt_cs3('aapr126','aapr126',l_sql,g_str)
   #No.FUN-770093 --end--
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
END FUNCTION
#No.FUN-770093 --start-- mark
{REPORT r126_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#No.CHI-6A0004-----Begin--------
#         l_azi03        LIKE azi_file.azi03,
#         l_azi04        LIKE azi_file.azi04,
#         l_azi05        LIKE azi_file.azi05,
#         l_azi07        LIKE azi_file.azi07
#No.CHI-6A0004----End---------
   DEFINE    sr            RECORD
                                  order1 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                                  order2 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                                  order3 LIKE apa_file.apa54,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                                  apa01 LIKE apa_file.apa01,  #帳款編號
                                  apa02 LIKE apa_file.apa02,  #帳款日期
                                  apa06 LIKE apa_file.apa06,  #付款廠商
                                  apa07 LIKE apa_file.apa07,  #廠商簡稱
                                  apa08 LIKE apa_file.apa08,  #發票號碼
                                  apa12 LIKE apa_file.apa12,  #幣別
                                  apa13 LIKE apa_file.apa13,  #幣別
                                  apa14 LIKE apa_file.apa14,  #匯率
                                  apa19 LIKE apa_file.apa19,  #留置原因
                                  apo02 LIKE apo_file.apo02,
                                  apa21 LIKE apa_file.apa21,  #帳款人員
                                  apa22 LIKE apa_file.apa22,  #帳款部門
                                  apa25 LIKE apa_file.apa25,  #備註
                                  apa75 LIKE apa_file.apa75,  #是否為外購
                                  apa36 LIKE apa_file.apa36,  #帳款類別
                                  apa00 LIKE apa_file.apa00,  #帳款性質
                                  apa43 LIKE apa_file.apa43,  #傳票日期
                                  apa44 LIKE apa_file.apa44,  #傳票編號
                                  apr02 LIKE apr_file.apr02,  #帳款類別
                                  apa54 LIKE apa_file.apa54,
                                  apa34f LIKE apa_file.apa34f,
                                  apa34 LIKE apa_file.apa34,
                                  apa20 LIKE apa_file.apa20,   #MOD-720128
                                  un_pay  LIKE apa_file.apa34,
                                  un_pay1  LIKE apa_file.apa34f #No.MOD-5C0070
                           END RECORD
 
   DEFINE  sr_1 RECORD
                       apk01 LIKE apk_file.apk01,  #帳款編號
                       apk03 LIKE apk_file.apk03,  #發票號碼
                       apk06 LIKE apk_file.apk06  #金額
                   END RECORD
 
   DEFINE l_apr02      LIKE  apr_file.apr02     # 帳款類別名稱
   DEFINE l_amt_1      LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)
   DEFINE l_amt_11     LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)
   DEFINE l_amt_2      LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)
   define l_sum        LIKE type_file.num20_6     # No.FUN-690028 decimal(20,6)
   define l_sum1       LIKE type_file.num20_6     # No.FUN-690028 decimal(20,6)
   define l_rate       LIKE sta_file.sta04        # No.FUN-690028 dec(10,4)
   define l_curr       LIKE azi_file.azi01        # No.FUN-690028 VARCHAR(04)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      #No.TQC-6B0128 --start--
      #LET g_len = 199   #MOD-720128
      LET g_len = 218   #MOD-720128
      FOR g_i = 1 TO g_len
          LET g_dash[g_i,g_i] = '=' 
      END FOR
      FOR g_i = 1 TO g_len
          LET g_dash1_1[g_i,g_i] = '-'
      END FOR 
      #No.TQC-6B0128 --end-- 
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' ' THEN
         PRINT '';
      ELSE
         PRINT 'TO:',g_towhom;
      END IF
      PRINT ' '   #TQC-740050
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-740050 mark
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 50,g_x[31] CLIPPED,' : ',tm.b_date,
            COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED, #TQC-740050
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_x[9] CLIPPED,g_orderA[1] CLIPPED,        #TQC-6A0088                                                                             
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED  #TQC-6A0088
      PRINT g_dash[1,g_len]
#No.TQC-6B0128 --start-- 
#     PRINT g_x[11],
#           COLUMN 47,g_x[32] CLIPPED,
#           COLUMN 53,g_x[33] CLIPPED,
#           COLUMN 61,g_x[12] CLIPPED,
#           COLUMN 109,g_x[13] CLIPPED,
#           COLUMN 150,g_x[14] CLIPPED #No.MOD-5C0070
 
#     PRINT '--------- ---------- ---------------- ------------ ------- ',
#           '------ ---------------- -------- ---------------- ',
#           '-------- -------- ------------------ ',
#           '------------------ ---- ---------- -----------'  #No.MOD-5C0070
 
      PRINT g_x[11],
            COLUMN 56,g_x[32] CLIPPED,
            COLUMN 59,g_x[33] CLIPPED,
            COLUMN 67,g_x[12] CLIPPED,
            COLUMN 116,g_x[13] CLIPPED,
            COLUMN 154,g_x[14] CLIPPED
 
      PRINT '---------- -------------------- ---------------- -------- ------- ',
            '------ ---------------- -------- ---------------- ',
            '-------- -------- ------------------ ',
            #'------------------ ---- ---------- -----------'   #MOD-720128
            '------------------ ------------------ ---- ---------- -----------'    #MOD-720128
#No.TQC-6B0128 --end--
 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07   #No.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.apa13
 
#No.TQC-6B0128 --start--
#     PRINT COLUMN 1,sr.apa06 CLIPPED,
#           COLUMN 11,sr.apa07 CLIPPED,
#           COLUMN 22,sr.apa01 CLIPPED,
#           COLUMN 39,sr.apr02[1,8],
#           COLUMN 52,sr.apa54[1,7];
#     PRINT COLUMN 60,sr.apa22 CLIPPED,
#           COLUMN 67,sr.apa08 CLIPPED,
#           COLUMN 84,sr.apa02 CLIPPED,
#           COLUMN 93,sr.apa44 CLIPPED,
#           COLUMN 110,sr.apa43 CLIPPED,
#           COLUMN 119,sr.apa12 CLIPPED;
#     PRINT COLUMN 127,cl_numfor(sr.un_pay,18,g_azi04) ,
#           COLUMN 146,cl_numfor(sr.un_pay1,18,t_azi04) ,   #No.CHI-6A0004
#           COLUMN 166,sr.apa13 CLIPPED,
#           COLUMN 170,cl_numfor(sr.apa14,10,t_azi07),    #No.CHI-6A0004
#           COLUMN 182,sr.apa25[1,10] CLIPPED   #No.MOD-5C0070
      PRINT COLUMN 1,sr.apa06 CLIPPED,
            COLUMN 12,sr.apa07 CLIPPED,
            COLUMN 33,sr.apa01 CLIPPED,
            COLUMN 50,sr.apr02[1,8],
            COLUMN 59,sr.apa54[1,7];
      PRINT COLUMN 67,sr.apa22 CLIPPED,
            COLUMN 74,sr.apa08 CLIPPED,
            COLUMN 91,sr.apa02 CLIPPED,
            COLUMN 100,sr.apa44 CLIPPED,
            COLUMN 117,sr.apa43 CLIPPED,
            COLUMN 126,sr.apa12 CLIPPED;
      PRINT COLUMN 134,cl_numfor(sr.un_pay,18,g_azi04) ,
            COLUMN 153,cl_numfor(sr.un_pay1,18,t_azi04) ,   #No.CHI-6A0004
            #-----MOD-720128--------- 
            #COLUMN 173,sr.apa13 CLIPPED,
            #COLUMN 177,cl_numfor(sr.apa14,10,t_azi07),    #No.CHI-6A0004
            #COLUMN 189,sr.apa25[1,10] CLIPPED   #No.MOD-5C0070
            COLUMN 172,cl_numfor(sr.apa20,18,t_azi04),
            COLUMN 192,sr.apa13 CLIPPED,
            COLUMN 196,cl_numfor(sr.apa14,10,t_azi07),   
            COLUMN 208,sr.apa25[1,10] CLIPPED  
            #-----END MOD-720128-----
#No.TQC-6B0128 --end--
      IF sr.apa08 = 'MISC' THEN
         OPEN r126_curs_apk USING sr.apa01
         FOREACH r126_curs_apk INTO sr_1.*
#No.TQC-6B0128 --start--
#        PRINT COLUMN 67, sr_1.apk03 CLIPPED,
#              COLUMN 127,cl_numfor(sr_1.apk06,18,g_azi04)
         PRINT COLUMN 74, sr_1.apk03 CLIPPED,
               COLUMN 134,cl_numfor(sr_1.apk06,18,g_azi04)
#No.TQC-6B0128 --end--
         END FOREACH
      END IF
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         DECLARE sum_curs1 CURSOR FOR
          #SELECT curr,SUM(un_pay),SUM(un_pay1)   #MOD-720128
          SELECT curr,SUM(un_pay),SUM(un_pay1),SUM(on_hold)   #MOD-720128
            FROM aapr126_tmp
           WHERE order1 = sr.order1
           GROUP BY curr
           ORDER BY curr
         SKIP 1 LINE
#        PRINT COLUMN 81,g_x[30] CLIPPED;  #No.TQC-6B0128 mark
         PRINT COLUMN 88,g_x[30] CLIPPED;  #No.TQC-6B0128
         #FOREACH sum_curs1 INTO l_curr,l_amt_1,l_amt_11   #MOD-720128
         FOREACH sum_curs1 INTO l_curr,l_amt_1,l_amt_11,l_amt_2   #MOD-720128
           LET l_rate = l_amt_1 / l_amt_11
           IF cl_null(l_rate) THEN LET l_rate = 0 END IF
           SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr   #MOD-720128
#No.TQC-6B0128 --start--
#          PRINT COLUMN 116,l_curr CLIPPED,
#                COLUMN 127,cl_numfor(l_amt_1,18,g_azi05)
           PRINT COLUMN 123,l_curr CLIPPED,
                 COLUMN 134,cl_numfor(l_amt_1,18,g_azi05),   
                 COLUMN 153,cl_numfor(l_amt_11,18,t_azi05),   #MOD-720128
                 COLUMN 172,cl_numfor(l_amt_2,18,t_azi05)   #MOD-720128
#No.TQC-6B0128 --end--
         END FOREACH
         PRINT g_dash1_1[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         DECLARE sum_curs2 CURSOR FOR
          #SELECT curr,SUM(un_pay),SUM(un_pay1)   #MOD-720128
          SELECT curr,SUM(un_pay),SUM(un_pay1),SUM(on_hold)   #MOD-720128
            FROM aapr126_tmp
           WHERE order1 = sr.order1
             AND order2 = sr.order2
           GROUP BY curr
           ORDER BY 1
         SKIP 1 LINE
#        PRINT COLUMN 81,g_x[30] CLIPPED;  #No.TQC-6B0128 mark
         PRINT COLUMN 88,g_x[30] CLIPPED;  #No.TQC-6B0128
         #FOREACH sum_curs2 INTO l_curr,l_amt_1,l_amt_11   #MOD-720128
         FOREACH sum_curs2 INTO l_curr,l_amt_1,l_amt_11,l_amt_2   #MOD-720128
           SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr   #MOD-720128
           LET l_rate = l_amt_1 / l_amt_11
           IF cl_null(l_rate) THEN LET l_rate = 0 END IF
#No.TQC-6B0128 --start--
#          PRINT COLUMN 116,l_curr,
#                COLUMN 127,cl_numfor(l_amt_1,18,g_azi05)
           PRINT COLUMN 123,l_curr,
                 COLUMN 134,cl_numfor(l_amt_1,18,g_azi05),
                 COLUMN 153,cl_numfor(l_amt_11,18,t_azi05),   #MOD-720128
                 COLUMN 172,cl_numfor(l_amt_2,18,t_azi05)   #MOD-720128
#No.TQC-6B0128 --end--
         END FOREACH
         PRINT g_dash1_1[1,g_len]
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         DECLARE sum_curs3 CURSOR FOR
          #SELECT curr,SUM(un_pay),SUM(un_pay1)   #MOD-720128
          SELECT curr,SUM(un_pay),SUM(un_pay1),SUM(on_hold)   #MOD-720128
            FROM aapr126_tmp
           WHERE order1 = sr.order1
             AND order2 = sr.order2
             AND order3 = sr.order3
           GROUP BY curr
           ORDER BY curr
         SKIP 1 LINE
#        PRINT COLUMN 81,g_x[30] CLIPPED;  #No.TQC-6B0128 mark
         PRINT COLUMN 88,g_x[30] CLIPPED;  #No.TQC-6B0128
         #FOREACH sum_curs3 INTO l_curr,l_amt_1,l_amt_11   #MOD-720128
         FOREACH sum_curs3 INTO l_curr,l_amt_1,l_amt_11,l_amt_2   #MOD-720128
           SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr   #MOD-720128
           LET l_rate = l_amt_1 / l_amt_11
           IF cl_null(l_rate) THEN LET l_rate = 0 END IF
#No.TQC-6B0128 --start--
#          PRINT COLUMN 116,l_curr,
#                COLUMN 127,cl_numfor(l_amt_1,18,g_azi05)
           PRINT COLUMN 123,l_curr,
                 COLUMN 134,cl_numfor(l_amt_1,18,g_azi05),
                 COLUMN 153,cl_numfor(l_amt_11,18,t_azi05),   #MOD-720128
                 COLUMN 172,cl_numfor(l_amt_2,18,t_azi05)   #MOD-720128
#No.TQC-6B0128 --end--
         END FOREACH
         PRINT g_dash1_1[1,g_len]
      END IF
 
   ON LAST ROW
      DECLARE sum_curs CURSOR FOR
       #SELECT curr,SUM(un_pay),SUM(un_pay1)   #MOD-720128
       SELECT curr,SUM(un_pay),SUM(un_pay1),SUM(on_hold)   #MOD-720128
         FROM aapr126_tmp
        GROUP BY curr
        ORDER BY curr
#     PRINT COLUMN 81,g_x[22] CLIPPED;  #No.TQC-6B0128 mark
      PRINT COLUMN 88,g_x[22] CLIPPED;  #No.TQC-6B0128
      #FOREACH sum_curs INTO l_curr,l_amt_1,l_amt_11   #MOD-720128
      FOREACH sum_curs INTO l_curr,l_amt_1,l_amt_11,l_amt_2   #MOD-720128
        SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr   #MOD-720128
        LET l_rate = l_amt_1 / l_amt_11
        IF cl_null(l_rate) THEN LET l_rate = 0 END IF
#No.TQC-6B0128 --start--
#       PRINT COLUMN 116,l_curr,
#             COLUMN 127,cl_numfor(l_amt_1,18,g_azi05)
        PRINT COLUMN 123,l_curr,
              COLUMN 134,cl_numfor(l_amt_1,18,g_azi05),
              COLUMN 153,cl_numfor(l_amt_11,18,t_azi05),   #MOD-720128
              COLUMN 172,cl_numfor(l_amt_2,18,t_azi05)   #MOD-720128
#No.TQC-6B0128 --end--
      END FOREACH
 
      IF g_zz05 = 'Y' THEN     # (132)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa06,apa36,apa00,apa21,apa22,apa01,apa44,apa43,apa54')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
 
END REPORT
 
REPORT r126_rep2(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          #l_sql        LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(200)
          l_sql          STRING,   #TQC-630166
          sr   RECORD apa06   LIKE apa_file.apa06,  #付款廠商
                      apa07   LIKE apa_file.apa07,  #廠商簡稱
                      apa13   LIKE apa_file.apa13,  #幣別   #MOD-720128
                      apr02   LIKE apr_file.apr02,  #帳款類別
                      apa54   LIKE apa_file.apa54,
                      un_pay  LIKE apa_file.apa34, #未付金額
                      un_pay1  LIKE apa_file.apa34f  #未付金額  #No.MOD-5C0070
               END RECORD,
      l_sum         LIKE apa_file.apa34,
      l_sum1        LIKE apa_file.apa34f,
      l_sum2        LIKE apa_file.apa20,   #MOD-720128
      l_tot         LIKE apa_file.apa34,
      l_tot1        LIKE apa_file.apa34f, #No.MOD-5C0070
      l_tot2        LIKE apa_file.apa20   #MOD-720128
  DEFINE l_apa13    LIKE apa_file.apa13   #MOD-720128
  DEFINE l_apr02    LIKE apr_file.apr02   #MOD-720128
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #ORDER BY sr.apa06,sr.apr02      #MOD-720128
  ORDER BY sr.apa06,sr.apa13      #MOD-720128
  FORMAT
   PAGE HEADER
      #No.TQC-6B0128 --start--
#     LET g_len = 105   #No.MOD-5C0070 #No.TQC-6B0128
      #-----MOD-720128---------
      #LET g_len = 116
      LET g_len = 159
      FOR g_i = 1 TO g_len
          LET g_dash1_1[g_i,g_i] = '-'
      END FOR
      #-----END MOD-720128-----
      FOR g_i = 1 TO g_len
          LET g_dash[g_i,g_i] = '='
      END FOR 
      #No.TQC-6B0128 --end--
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      #PRINT (g_len-FGL_WIDTH(g_x[30]))/2 SPACES,g_x[30]   #MOD-720128
      PRINT (g_len-FGL_WIDTH(g_x[30]))/2 SPACES,g_x[10]   #MOD-720128
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 60,g_x[14] CLIPPED,tm.bdate,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_x[9] CLIPPED,g_orderA[1] CLIPPED,        #TQC-6A0088                                                                             
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED  #TQC-6A0088
      PRINT g_dash[1,g_len]
      #No.MOD-5C0070  --Begin
      PRINT g_x[16],
      #-----MOD-720128---------
#     #      COLUMN 41,g_x[17] CLIPPED;  #No.TQC-6B0128 mark
      #      COLUMN 52,g_x[17] CLIPPED;  #No.TQC-6B0128
#     #PRINT COLUMN 70,g_x[30] CLIPPED   #No.TQC-6B0128 mark
      #PRINT COLUMN 81,g_x[30] CLIPPED   #No.TQC-6B0128
#     #PRINT '---------- --------- -------- ------------------ '; #No.TQC-6B0128 mark
      #PRINT '---------- -------------------- -------- ------------------ '; #No.TQC-6B0128
      #PRINT '------------------ ------------------ ',
      #      '------------------ '
            COLUMN 52,g_x[17] CLIPPED,
            COLUMN 85,g_x[42] CLIPPED,
            COLUMN 104,g_x[30] CLIPPED,
            COLUMN 142,g_x[41] CLIPPED
      PRINT '---------- -------------------- -------- ---- ------------------ ',
            '------------------ ------------------ ',
            '------------------ ',
            '------------------ ------------------'
      #-----END MOD-720128-----
 
      #No.MOD-5C0070  --End
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.apa06   #付款廠商
      #No.MOD-5C0070  --Begin
      PRINT COLUMN 1,sr.apa06 CLIPPED,
            COLUMN 12,sr.apa07 CLIPPED;
      #LET l_tot = 0   #MOD-720128
      #LET l_tot1 = 0  #MOD-720128
      #No.MOD-5C0070  --End
 
   #-----MOD-720128---------
#
# #Wendy---98/12/23---B---
#   AFTER GROUP OF sr.apr02
#      LET l_sum = GROUP SUM(sr.un_pay)
#      LET l_sum1 = GROUP SUM(sr.un_pay1)
#      LET l_tot = l_tot + l_sum
#      LET l_tot1 = l_tot1 + l_sum1
#      #No.MOD-5C0070  --Begin
##No.TQC-6B0128 --start--
##     PRINT COLUMN 22,sr.apr02[1,8] clipped;
##     PRINT COLUMN 30,cl_numfor(l_sum,18,g_azi05)  CLIPPED,
##           COLUMN 49,cl_numfor(l_sum1,18,g_azi05) CLIPPED;
##     PRINT COLUMN 68,cl_numfor(l_tot,18,g_azi05)  CLIPPED,
##           COLUMN 87,cl_numfor(l_tot1,18,g_azi05) CLIPPED
#      PRINT COLUMN 33,sr.apr02[1,8] clipped;
#      PRINT COLUMN 41,cl_numfor(l_sum,18,g_azi05)  CLIPPED,
#            COLUMN 60,cl_numfor(l_sum1,18,g_azi05) CLIPPED;
#      PRINT COLUMN 79,cl_numfor(l_tot,18,g_azi05)  CLIPPED,
#            COLUMN 98,cl_numfor(l_tot1,18,g_azi05) CLIPPED
##No.TQC-6B0128 --end--
#      #No.MOD-5C0070  --End
#
      BEFORE GROUP OF sr.apa13
        LET l_tot = 0
        LET l_tot1 = 0
        LET l_tot2 = 0
 
      AFTER GROUP OF sr.apa13
        DECLARE sum_curs4 CURSOR FOR
          SELECT apr02,SUM(un_pay),SUM(un_pay1),SUM(on_hold)
            FROM aapr126_tmp2
            WHERE apa06 = sr.apa06 AND
                  apa13 = sr.apa13
          GROUP BY apr02
          ORDER BY apr02
 
     FOREACH sum_curs4 INTO l_apr02,l_sum,l_sum1,l_sum2
        SELECT azi05 INTO t_azi05 FROM azi_file where azi01=sr.apa13
        LET l_tot = l_tot + l_sum
        LET l_tot1 = l_tot1 + l_sum1
        LET l_tot2 = l_tot2 + l_sum2
        PRINT COLUMN 33,l_apr02[1,8] CLIPPED,
              COLUMN 43,sr.apa13 CLIPPED,
              COLUMN 46,cl_numfor(l_sum,18,g_azi05) CLIPPED,
              COLUMN 65,cl_numfor(l_sum1,18,t_azi05) CLIPPED,
              COLUMN 84,cl_numfor(l_sum2,18,t_azi05) CLIPPED,
              COLUMN 103,cl_numfor(l_tot,18,g_azi05) CLIPPED,
              COLUMN 122,cl_numfor(l_tot1,18,t_azi05) CLIPPED,
              COLUMN 141,cl_numfor(l_tot2,18,t_azi05) CLIPPED
     END FOREACH
   #-----END MOD-720128-----
   ON LAST ROW
      #-----MOD-720128---------
#
#      LET l_tot = SUM(sr.un_pay)
#      LET l_tot1 = SUM(sr.un_pay1)
##No.TQC-6B0128 --start--
##     PRINT COLUMN 22,'Total:',
##           COLUMN 30,cl_numfor(l_tot,18,g_azi05) CLIPPED,
##           COLUMN 49,cl_numfor(l_tot1,18,g_azi05) CLIPPED  #No.MOD-5C0070
#      PRINT COLUMN 33,'Total:',
#            COLUMN 41,cl_numfor(l_tot,18,g_azi05) CLIPPED,
#            COLUMN 60,cl_numfor(l_tot1,18,g_azi05) CLIPPED
##No.TQC-6B0128 --end--
#
      DECLARE sum_curs5 CURSOR FOR
       SELECT apa13,SUM(un_pay),SUM(un_pay1),SUM(on_hold)
         FROM aapr126_tmp2
        GROUP BY apa13
        ORDER BY apa13
      FOREACH sum_curs5 INTO l_apa13,l_sum,l_sum1,l_sum2
         SELECT azi05 INTO t_azi05 FROM azi_file where azi01=l_apa13
      PRINT COLUMN 33,g_x[22],
            COLUMN 43,l_apa13 CLIPPED,
            COLUMN 46,cl_numfor(l_sum,18,g_azi05),
            COLUMN 65,cl_numfor(l_sum1,18,t_azi05),
            COLUMN 84,cl_numfor(l_sum2,18,t_azi05)
      END FOREACH
      #-----END MOD-720128----- 
      IF g_zz05 = 'Y' THEN
         CALL
         cl_wcchp(tm.wc,'apa06,apa36,apa00,apa21,apa22,apa01,apa44,apa43,apa54')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770093 --end--
#Patch....NO.TQC-610035 <002,003,004,005,006> #
