# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr123.4gl
# Descriptions...: 待抵帳款明細表列印作業
# Date & Author..: 92/02/01  By  Felicity  Tseng
# Modify.........: 97/05/23 By Danny
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: No.TQC-5B0138 05/11/22 By Rosayu 營運中心給預設值
# Modify.........: No.MOD-630066 06/03/20 By Smapmin 小計有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-720118 07/02/26 By Smapmin 修改ora檔
# Modify.........: No.FUN-820051 07/06/28 By ice CR報表修改
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-890178 08/09/19 By Sarah 待抵明細增加顯示成本分攤資料
# Modify.........: No.MOD-910023 09/01/08 By liuxqa 修正NO.MOD-890178抓取有關待扺日期的sql條件
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB
# Modify.........: No:MOD-B30068 11/03/09 By Dido 增加抓取 apg_file 資料 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:FUN-BB0173 12/01/17 by pauline 增加跨法人抓取資料
# Modify.........: No:MOD-C20177 12/02/22 By yinhy 大陸版本把沒有沖帳的aapq230資料也顯示出來
# Modify.........: No:MOD-C50235 12/0531 By Polly 不分地區別，都將沒有沖帳的aapq230資料顯示出來
# Modify.........: No:MOD-C70239 12/07/23 By Polly 拿除帳款營運中心條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc       STRING,       # Where condition   #TQC-630166
              a       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
             #plant   LIKE azp_file.azp01, #FUN-660117   No.FUN-A10098  mark
              plant   LIKE azp_file.azp01,         #FUN-BB0173 add
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),           # Order by sequence
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Eject sw
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Group total sw
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
          g_amt1,g_amt2,g_amt3,g_amt4  LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
          g_amt11,g_amt21,g_amt31,g_amt41  LIKE type_file.num20_6, #MOD-59044  #No.FUN-690028 DECIMAL(20,6)
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
          g_head1     LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE l_table     STRING                 ### FUN-820051 ###
DEFINE g_str       STRING                 ### FUN-820051 ###
DEFINE g_sql       STRING                 ### FUN-820051 ###
DEFINE g_flag      LIKE type_file.chr1    #FUN-BB0173 add 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 add
 
    LET g_sql = "apa00.apa_file.apa00,apa01.apa_file.apa01,",
                "apa02.apa_file.apa02,apa06.apa_file.apa06,",
                "apa13.apa_file.apa13,apa21.apa_file.apa21,",
                "apa34.apa_file.apa34,apa35.apa_file.apa35,",
                "apa36.apa_file.apa36,apa07.apa_file.apa07,",
                "apv01.apv_file.apv01,apv04.apv_file.apv04,",
                "apa72.apa_file.apa72,apa73.apa_file.apa73,",
                "num20_6.type_file.num20_6,azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,azi05.azi_file.azi05,",
                "azi07.azi_file.azi07,paydate.type_file.dat,",  #No.FUN-870151 azi07
                "sum_apv04.apv_file.apv04,l_type.type_file.chr1"   #MOD-890178 add
    LET l_table = cl_prt_temptable('aapr123',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?)" #No.FUN-870151   #MOD-890178 add 2?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)           # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.h     = ARG_VAL(9)
  #No.FUN-A10098 ---start---
  #LET tm.plant = ARG_VAL(10)
  #LET tm.s     = ARG_VAL(11)
  #LET tm.t     = ARG_VAL(12)
  #LET tm.u     = ARG_VAL(13)
  #LET g_rep_user = ARG_VAL(14)
  #LET g_rep_clas = ARG_VAL(15)
  #LET g_template = ARG_VAL(16)
  #LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#FUN-BB0173 mark START
#  LET tm.s     = ARG_VAL(10)
#  LET tm.t     = ARG_VAL(11)
#  LET tm.u     = ARG_VAL(12)
#  LET g_rep_user = ARG_VAL(13)
#  LET g_rep_clas = ARG_VAL(14)
#  LET g_template = ARG_VAL(15)
#  LET g_rpt_name = ARG_VAL(16)
#FUN-BB0173 mark END
  #NO.FUN-A10098 ---end---
#FUN-BB0173 add START
   LET tm.plant = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   LET tm.u     = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
#FUN-BB0173 add END 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r123_tm(0,0)        # Input print condition
   ELSE
      CALL r123()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
FUNCTION r123_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5    #No.FUN-940102 
   
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW r123_w AT p_row,p_col
     WITH FORM "aap/42f/aapr123"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r123_set_entry()     #FUN-BB0173 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '1'
   LET tm.h    = '3'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.plant = g_plant #TQC-5B0138   #NO.FUN-A10098  mark
   LET tm.plant = g_plant #FUN-BB0173 add
   #genero版本default 排序,跳頁,合計值
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
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa06,apa01,apa02,apa21,apa13
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
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
         CLOSE WINDOW r123_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
     #INPUT BY NAME tm.plant,tm.a,tm.h,tm2.s1,tm2.s2,tm2.s3,    #NO.FUN-A10098 
     #INPUT BY NAME tm.a,tm.h,tm2.s1,tm2.s2,tm2.s3,             #NO.FUN-A10098  #FUN-BB0173 mark
      INPUT BY NAME tm.plant,tm.a,tm.h,tm2.s1,tm2.s2,tm2.s3,    #FUN-BB0173 add
                    tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more
                    WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[12]' OR cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES '[123]' OR cl_null(tm.h) THEN
               NEXT FIELD h
            END IF
       
        #NO.FUN-A10098 ---start---mark-- 
        #AFTER FIELD plant
        #   IF tm.plant IS NULL AND tm.plant = ' ' THEN
        #      NEXT FIELD plant
        #   ELSE
        #      SELECT azp03 INTO g_dbs_new FROM azp_file
        #       WHERE azp01 = tm.plant
        #      IF SQLCA.SQLCODE THEN
        #         LET g_errno='aap-025'
        #         CALL cl_err3("sel","azp_file",tm.plant,"",g_errno,"","tm.plant",0)  #No.FUN-660122
        #         NEXT FIELD plant
        #      END IF
        #      CALL s_chk_demo(g_user,tm.plant) RETURNING li_result
        #        IF not li_result THEN 
        #           NEXT FIELD plant
        #        END IF 
        #   END IF
        #NO.FUN-A10098 ---end---mark--

        #FUN-BB0173 add START
         AFTER FIELD plant
            IF tm.plant IS NULL AND tm.plant = ' ' THEN
               NEXT FIELD plant
            ELSE
               SELECT azp03 INTO g_dbs_new FROM azp_file
                WHERE azp01 = tm.plant
               IF SQLCA.SQLCODE THEN
                  LET g_errno='aap-025'
                  CALL cl_err3("sel","azp_file",tm.plant,"",g_errno,"","tm.plant",0)  #No.FUN-660122
                  NEXT FIELD plant
               END IF
               CALL s_chk_demo(g_user,tm.plant) RETURNING li_result
                 IF not li_result THEN
                    NEXT FIELD plant
                 END IF
            END IF
        #FUN-BB0173 add END
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r123_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr123'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr123','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc    CLIPPED,"'",
                        " '",tm.a     CLIPPED,"'",
                        " '",tm.h     CLIPPED,"'",   #TQC-610053
                       #" '",tm.plant CLIPPED,"'",  #NO.FUN-A10098  mark
                        " '",tm.plant CLIPPED,"'",  #FUN-BB0173 add
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr123',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r123_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r123()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r123_w
 
END FUNCTION
 
FUNCTION r123()
   DEFINE l_name      LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql       STRING,                 # RDSQL STATEMENT   #TQC-630166
          l_chr       LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05      LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_cnt       LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_apa01_o   LIKE apa_file.apa01,
          l_order     ARRAY[5] OF LIKE apa_file.apa01,      #No.FUN-690028 VARCHAR(16),             #No.FUN-550030
          sr          RECORD order1  LIKE apa_file.apa01,   #No.FUN-690028 order1 VARCHAR(16),    #No.FUN-550030
                             order2  LIKE apa_file.apa01,   #No.FUN-690028 order2 VARCHAR(16),    #No.FUN-550030
                             order3  LIKE apa_file.apa01,   #No.FUN-690028 order3 VARCHAR(16),    #No.FUN-550030
                             apa00 LIKE apa_file.apa00,
                             apa01 LIKE apa_file.apa01,
                             apa02 LIKE apa_file.apa02,
                             apa06 LIKE apa_file.apa06,
                             apa13 LIKE apa_file.apa13,
                             apa21 LIKE apa_file.apa21,
                             apa34 LIKE apa_file.apa34,
                             apa35 LIKE apa_file.apa35,
                             apa36 LIKE apa_file.apa36,
                             apa07 LIKE apa_file.apa07,
                             apv01 LIKE apv_file.apv01,
                             apv04 LIKE apv_file.apv04,
                             paydate  LIKE apa_file.apa02,
                             apa72 LIKE apa_file.apa72,  #No.MOD-590440
                             apa73 LIKE apa_file.apa73,  #No.MOD-590440
                             pay1  LIKE apa_file.apa73,  #No.MOD-590440
                             azi03 LIKE azi_file.azi03,
                             azi04 LIKE azi_file.azi04,
                             azi05 LIKE azi_file.azi05,
                             azi07 LIKE azi_file.azi07   #No.FUN-870151
                      END RECORD,
          l_apv01     LIKE apv_file.apv01,     #MOD-890178 add
          l_apa02     LIKE apa_file.apa02,     #MOD-890178 add
          l_apv04     LIKE apv_file.apv04,     #MOD-890178 add
          l_aph01     LIKE aph_file.aph01,
          l_aph05     LIKE aph_file.aph05,
          l_apf02     LIKE apf_file.apf02,
          l_aqa01     LIKE aqa_file.aqa01,     #MOD-890178 add
          l_aqa02     LIKE aqa_file.aqa02,     #MOD-890178 add
          l_aqb04     LIKE aqb_file.aqb04,     #MOD-890178 add
          l_i         LIKE type_file.num5,     #No.MOD-590440  #No.FUN-690028 SMALLINT
          l_len       LIKE type_file.num5,     #No.FUN-690028 SMALLINT         #No.MOD-590440
          l_sum_apv04 LIKE apv_file.apv04,     #MOD-890178 add
          l_type      LIKE type_file.chr1,     #MOD-890178 add
          l_plant     LIKE azw_file.azw01      #FUN-BB0173 add
 
   LET g_amt1 = 0
   LET g_amt2 = 0
   LET g_amt3 = 0
   LET g_amt4 = 0
   LET g_amt11 = 0
   LET g_amt21 = 0
   LET g_amt31 = 0
   LET g_amt41 = 0
 
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
 
 
   #-->直接沖帳部份
   LET l_plant = tm.plant       #FUN-BB0173 add
   LET l_sql = "SELECT '','','',",
               " apa00, apa01, apa02, apa06, apa13, apa21,",
               " apa34, apa35, apa36, apa07, ",
               " ' ', 0, ' ',apa72,apa73,apa35+apa73,",            #MOD-890178
               " azi03, azi04, azi05,azi07 ", #No.FUN-870151 add azi07   #No.MOD-590440
               " FROM apa_file LEFT OUTER JOIN azi_file ON(azi_file.azi01 = apa_file.apa13 )",                   #MOD-890178
               " WHERE ",tm.wc CLIPPED,
              #" AND substring(apa00,1,1) ='2' ",   #折讓/D.M./預付/暫付  #FUN-A10098 mark
               " AND (apa58 != '1' OR apa58 IS NULL)",   #modi by kitty
               " AND apa42 = 'N' "       #未結案
 
   IF tm.a ='1' THEN
      LET l_sql = l_sql CLIPPED, " AND apa73 > 0 "       #No.MOD-590440
   END IF
 
   IF tm.h ='1' THEN
      LET l_sql = l_sql CLIPPED, " AND apa41='Y' "
   END IF
 
   IF tm.h ='2' THEN
      LET l_sql = l_sql CLIPPED, " AND apa41='N' "
   END IF
   LET l_sql = l_sql CLIPPED, " ORDER BY apa01"   #MOD-890178 add
   PREPARE r123_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare :',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r123_curs1 CURSOR FOR r123_prepare1
 
  #LET g_plant_new = tm.plant   #NO.FUN-A10098  mark
  #CALL s_getdbs()              #NO.FUN-A10098  mark
 
   ##-->直接沖帳部份
    LET l_sql = "SELECT apv01, apv04, apa02",
               #NO.FUN-A10098 ---start---
               #" FROM  ",g_dbs_new CLIPPED," apv_file,",
               #          g_dbs_new CLIPPED," apa_file ",
               #" FROM apv_file,apa_file ",  #FUN-BB0173 mark
                " FROM ",cl_get_target_table(l_plant,'apv_file'),  #FUN-BB0173 add
                "     ,",cl_get_target_table(l_plant,'apa_file'),  #FUN-BB0173 add
               #NO.FUN-A10098 ---end---
                " WHERE apv03 = ? ",
                "   AND apv01 = apa01",    #No.MOD-910023 mod by liuxqa
                " ORDER BY apv01,apv04"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE r123_preapv FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('preapv:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
       EXIT PROGRAM
    END IF
    DECLARE r123_curapv CURSOR FOR r123_preapv
 
   #-->財務廠沖帳部份
   LET l_sql = "SELECT aph01, aph05, apf02 ",
              #NO.FUN-A10098  ---start---
              #" FROM  ",g_dbs_new CLIPPED," aph_file, ",
              #" ",g_dbs_new CLIPPED," apf_file ",
              #" FROM aph_file,apf_file ",  #FUN-BB0173 mark
               " FROM ",cl_get_target_table(l_plant,'aph_file'),  #FUN-BB0173 add
               "     ,",cl_get_target_table(l_plant,'apf_file'),  #FUN-BB0173 add 
              #NO.FUN-A10098 ---end--- 
                 " WHERE aph04 = ?  AND apf_file.apf41='Y'   ",
                 "   AND aph01 = apf_file.apf01 "
              ," ORDER BY aph01,aph05"   #MOD-890178 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   PREPARE r123_preaph FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('preaph:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105   
      EXIT PROGRAM
   END IF
   DECLARE r123_curaph CURSOR FOR r123_preaph
 
  #-MOD-B30068-add- 
   #-->財務廠沖暫估部份
   LET l_sql = "SELECT apg01, apg05, apf02 ",                                                                   
               "  FROM apg_file,apf_file ",                                                                       
               " WHERE apg01 = apf01 AND apf41='Y' ",                                                                         
              #"   AND apg03 = '",g_plant CLIPPED,"' ",                 #MOD-C70239 mark
               "   AND apg04 = ? ",                                                                            
               "   AND apf01 NOT IN(SELECT apf01 FROM apf_file,apg_file",            
              #"                 WHERE apf01 =apg01 AND apf992 IS NOT NULL AND apg03 ='",g_plant,"')",  #MOD-C70239 mark
               "                 WHERE apf01 =apg01 AND apf992 IS NOT NULL)",                           #MOD-C70239 add
               " ORDER BY apg01,apg05 "                                                                                             
   PREPARE r123_prepag FROM l_sql                                                                                             
   DECLARE r123_curapg CURSOR FOR r123_prepag                                                                               
  #-MOD-B30068-end- 

   ##-->成本分攤部份
    LET l_sql = "SELECT aqa01, aqb04, aqa02",
               #NO.FUN-A10098 ---start---
               #" FROM  ",g_dbs_new CLIPPED," aqa_file,",
               #          g_dbs_new CLIPPED," aqb_file ",
               #" FROM aqa_file,aqb_file ",  #FUN-BB0173 mark
                " FROM ",cl_get_target_table(l_plant,'aqa_file'), #FUN-BB0173 add
                "     ,",cl_get_target_table(l_plant,'aqb_file'),           #FUN-BB0173 add
               ##NO.FUN-A10098 ---end---
                " WHERE aqb02 = ? ",
                "   AND aqa01 = aqb01",
                "   AND aqa04 = 'Y' ",
                "   AND aqaconf='Y' ",
                " ORDER BY aqa01,aqb04"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE r123_preaqa FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('preaqa:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD       
       EXIT PROGRAM
    END IF
    DECLARE r123_curaqa CURSOR FOR r123_preaqa

 
   LET l_apa01_o = ' '
   LET l_sum_apv04 = 0   #MOD-890178 add
   FOREACH r123_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.apa00[1,1] != '2' THEN           #FUN-A10098
         CONTINUE FOREACH                    #FUN-A10098
      END IF                                 #FUN-A10098

      IF sr.apa01 != l_apa01_o THEN
         LET l_sum_apv04 = 0
      END IF

 
      IF cl_null(sr.azi03) THEN
         LET sr.azi03 = 0
      END IF
 
      IF cl_null(sr.azi04) THEN
         LET sr.azi04 = 0
      END IF
 
      IF cl_null(sr.azi05) THEN
         LET sr.azi05 = 0
      END IF
      
      IF cl_null(sr.azi07) THEN
         LET sr.azi07 = 0
      END IF
 
      LET g_sql = " SELECT gae04 FROM gae_file ",
                  "  WHERE gae01 = 'aapr123' ",
                  "    AND gae03 = '",g_lang,"' ",
                  "    AND gae11 = 'N' ",
                  "    AND gae02 = ? "
      PREPARE r123_gae04_pre FROM g_sql
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' 
                 EXECUTE r123_gae04_pre USING 's1_1' INTO g_orderA[g_i]
              WHEN tm.s[g_i,g_i] = '2' 
                 EXECUTE r123_gae04_pre USING 's1_2' INTO g_orderA[g_i]
              WHEN tm.s[g_i,g_i] = '3'
                 EXECUTE r123_gae04_pre USING 's1_3' INTO g_orderA[g_i]
              WHEN tm.s[g_i,g_i] = '4'
                 EXECUTE r123_gae04_pre USING 's1_4' INTO g_orderA[g_i]
              WHEN tm.s[g_i,g_i] = '5'
                 EXECUTE r123_gae04_pre USING 's1_5' INTO g_orderA[g_i]
              OTHERWISE LET g_orderA[g_i]= ' '
         END CASE
      END FOR
      LET g_head1 = g_x[12] CLIPPED, g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
 

 
      IF sr.apa01 != l_apa01_o THEN
         #-->直接沖帳部份
         FOREACH r123_curapv USING sr.apa01 INTO l_apv01,l_apv04,l_apa02
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach-apv:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET sr.apv01   = l_apv01    #付款單號
            LET sr.apv04   = l_apv04    #金額
            LET sr.paydate = l_apa02    #日期
            LET l_type     = '1'
            IF cl_null(sr.paydate) THEN
               LET sr.paydate = '********'
            END IF
            LET l_sum_apv04 = l_sum_apv04 + sr.apv04
            EXECUTE insert_prep USING
               sr.apa00,sr.apa01,sr.apa02,sr.apa06,sr.apa13,
               sr.apa21,sr.apa34,sr.apa35,sr.apa36,sr.apa07,
               sr.apv01,sr.apv04,sr.apa72,sr.apa73,sr.pay1,
               sr.azi03,sr.azi04,sr.azi05,sr.azi07,sr.paydate
              ,l_sum_apv04,l_type
         END FOREACH
 
         #-->財務廠沖帳部份
         FOREACH r123_curaph USING sr.apa01 INTO l_aph01,l_aph05,l_apf02
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach-aph:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET sr.apv01   = l_aph01    #付款單號
            LET sr.apv04   = l_aph05    #金額
            LET sr.paydate = l_apf02    #日期
            LET l_type     = '2'        #MOD-890178 add
            IF cl_null(sr.paydate) THEN
               LET sr.paydate = '********'
            END IF
            LET l_sum_apv04 = l_sum_apv04 + sr.apv04   #MOD-890178 add
            EXECUTE insert_prep USING 
               sr.apa00,sr.apa01,sr.apa02,sr.apa06,sr.apa13,
               sr.apa21,sr.apa34,sr.apa35,sr.apa36,sr.apa07,
               sr.apv01,sr.apv04,sr.apa72,sr.apa73,sr.pay1,
               sr.azi03,sr.azi04,sr.azi05,sr.azi07,sr.paydate  #No.FUN-870151
              ,l_sum_apv04,l_type   #MOD-890178 add
         END FOREACH
 
        #-MOD-B30068-add-
         #-->財務廠沖暫估部份
         LET l_aph01 = ''
         LET l_aph05 = 0 
         LET l_apf02 = '' 
         FOREACH r123_curapg USING sr.apa01 INTO l_aph01,l_aph05,l_apf02
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach-aph:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_chr = 'Y'  
            LET sr.apv01   = l_aph01    #付款單號
            LET sr.apv04   = l_aph05    #金額
            LET sr.paydate = l_apf02    #日期
            LET l_type     = '2'     
            IF cl_null(sr.paydate) THEN
               LET sr.paydate = '********'
            END IF
            LET l_sum_apv04 = l_sum_apv04 + sr.apv04   
            EXECUTE insert_prep USING 
               sr.apa00,sr.apa01,sr.apa02,sr.apa06,sr.apa13,
               sr.apa21,sr.apa34,sr.apa35,sr.apa36,sr.apa07,
               sr.apv01,sr.apv04,sr.apa72,sr.apa73,sr.pay1,
               sr.azi03,sr.azi04,sr.azi05,sr.azi07,sr.paydate  
              ,l_sum_apv04,l_type   
         END FOREACH
        #-MOD-B30068-end-

        #-->成本分攤部份
         FOREACH r123_curaqa USING sr.apa01 INTO l_aqa01,l_aqb04,l_aqa02
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach-aqa:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET sr.apv01   = l_aqa01    #付款單號
            LET sr.apv04   = l_aqb04    #金額
            LET sr.paydate = l_aqa02    #日期
            LET l_type     = '3'
            IF cl_null(sr.paydate) THEN
               LET sr.paydate = '********'
            END IF
            LET l_sum_apv04 = l_sum_apv04 + sr.apv04
            EXECUTE insert_prep USING 
               sr.apa00,sr.apa01,sr.apa02,sr.apa06,sr.apa13,
               sr.apa21,sr.apa34,sr.apa35,sr.apa36,sr.apa07,
               sr.apv01,sr.apv04,sr.apa72,sr.apa73,sr.pay1,
               sr.azi03,sr.azi04,sr.azi05,sr.azi07,sr.paydate
              ,l_sum_apv04,l_type
         END FOREACH
      END IF
      LET l_apa01_o = sr.apa01

      #No.MOD-C20177  --Begin
     #IF g_aza.aza26 = 2 AND sr.apa35 = 0 AND sr.apa00 !='26' THEN      #MOD-C50235 mark
      IF sr.apa35 = 0 AND sr.apa00 !='26' THEN                          #MOD-C50235 add
         LET l_sum_apv04 = 0
         LET l_type     = '4'
         EXECUTE insert_prep USING
               sr.apa00,sr.apa01,sr.apa02,sr.apa06,sr.apa13,
               sr.apa21,sr.apa34,sr.apa35,sr.apa36,sr.apa07,
               sr.apv01,sr.apv04,sr.apa72,sr.apa73,sr.pay1,
               sr.azi03,sr.azi04,sr.azi05,sr.azi07,sr.paydate,
               l_sum_apv04,l_type
      END IF
      #No.MOD-C20177  --End
   END FOREACH
 
 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05') RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
                g_head1,";",g_azi04,";",g_azi07,";",
                g_zz05,g_apz.apz27
    IF g_apz.apz27 = 'N' THEN
       CALL cl_prt_cs3('aapr123','aapr123',l_sql,g_str)     
    ELSE
       CALL cl_prt_cs3('aapr123','aapr123_1',l_sql,g_str)     
    END IF
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r123_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("plant",FALSE)
     LET g_flag = 'Y'  #流通
     LET tm.plant = g_plant
  END IF
END FUNCTION
#FUN-BB0173 add END 
#No.FUN-9C0077 程式精簡
