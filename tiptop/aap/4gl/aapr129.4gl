# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: aapr129.4gl
# Descriptions...: 應付帳款明細表列印作業
# Date & Author..: 92/12/28  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 04/12/24 By Nicola 報表架構修改
# Modify.........: No.MOD-530382 05/03/29 By Smapmin 選列印其報表抬頭改成'待抵帳款明細',
#                                                    當apa00='21' or apa00='22'
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-550110 05/06/08 By pengu  報表無法列印
# Modify.........: No.MOD-5A0066 05/10/07 By Dido 報表表尾修改
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: No.TQC-630237 06/03/24 By Smapmin 拿掉CONTROLP
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.MOD-710089 07/01/15 By Mandy 執行aapr129,選本幣,則會出現錯誤訊息(azz-137)
# Modify.........: No.TQC-740144 07/04/24 By hongmei 修改排序第三個欄位沒有默認值
# Modify.........: No.FUN-770093 07/10/10 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.FUN-720033 08/01/21 By jamie 原幣、本幣一起顯示，增加本幣合計
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30101 10/03/17 By sabrina 本幣金額未考慮是否月底重評價
# Modify.........: No:MOD-AC0338 10/12/29 By Dido 重評價應增加 oox_file 金額 
# Modify.........: No:MOD-B40164 11/04/19 By Dido 應付金額應維持 apa34 + l_net 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C70283 12/08/01 By Polly 折讓性質為差異處理的單據將本幣金額歸零，解決金額重復扣除問題
# Modify.........: No.TQC-CC0041 12/12/07 By qirl QBE查詢條件開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc        STRING,   #TQC-630166
              s        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  
              t        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              u        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
             #c        LIKE type_file.chr3,        # FUN-720033 mark# No.FUN-690028 VARCHAR(01),
              w        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              h        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0055
DEFINE   l_table     STRING                        #No.FUN-770093
DEFINE   g_sql       STRING                        #No.FUN-770093
DEFINE   g_str       STRING                        #No.FUN-770093
 
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-770093 --start--
   LET g_sql="apa00.apa_file.apa00,apa01.apa_file.apa01,apa02.apa_file.apa02,",
             "apa06.apa_file.apa06,apa07.apa_file.apa07,apa13.apa_file.apa13,",
             "apa31f.apa_file.apa31f,apa32f.apa_file.apa32f,",
             "apa60f.apa_file.apa60f,apa61f.apa_file.apa61f,",
             "apa34f.apa_file.apa34f,apa41.apa_file.apa41,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "apa31.apa_file.apa31,apa32.apa_file.apa32,",                           #FUN-720033 add
             "apa60.apa_file.apa60,apa61.apa_file.apa61,",                           #FUN-720033 add
             "apa34.apa_file.apa34,g_azi04.azi_file.azi04,g_azi05.azi_file.azi05"    #FUN-720033 add
 
   LET l_table = cl_prt_temptable('aapr129',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #FUN-720033 add 7?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770093 --end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #-----TQC-610053---------
  #LET tm.c = ARG_VAL(11)     #FUN-720033 mark
   LET tm.w = ARG_VAL(12)
   LET tm.h = ARG_VAL(13)
   #-----END TQC-610053-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #no.6133
 
#No.FUN-770093 --mark--
#   DROP TABLE curr_tmp
## No.FUN-690028 --start-- 
#  CREATE TEMP TABLE curr_tmp(
#       curr    LIKE apa_file.apa13,
#       amt1    LIKE type_file.num20_6,
#       amt2    LIKE type_file.num20_6,
#       amt3    LIKE type_file.num20_6,
#       amt4    LIKE type_file.num20_6,
#       order1  LIKE apa_file.apa01,
#       order2  LIKE apa_file.apa01,
#       order3  LIKE apa_file.apa01);
#
## No.FUN-690028 ---end---
#No.FUN-770093 --end--
   #no.6133(end)
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r129_tm(0,0)
   ELSE
      CALL r129()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r129_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 14
   OPEN WINDOW r129_w AT p_row,p_col
     WITH FORM "aap/42f/aapr129"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
#  LET tm.s    = '12 '             #No.TQC-740144
   LET tm.s    = '123 '            #No.TQC-740144                  
   LET tm.u    = '   '
  #LET tm.c    = '1'     #FUN-720033 mark
   LET tm.w    = '3'
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
      CONSTRUCT BY NAME tm.wc ON apa00,apa01,apa02,apa06,apa13
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
         #--TQC-CC0041--add--star--
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(apa06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa12"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa06
                  NEXT FIELD apa06
             WHEN INFIELD(apa00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa00"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa00
                  NEXT FIELD apa00
             WHEN INFIELD(apa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa07"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
                  NEXT FIELD apa01
             WHEN INFIELD(apa13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa13"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa13
                  NEXT FIELD apa13
           END CASE
         #--TQC-CC0041--add--end---
 
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
         CLOSE WINDOW r129_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
     #INPUT BY NAME tm.c,tm.w,tm.h,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,   #FUN-720033 mark
      INPUT BY NAME tm.w,tm.h,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,        #FUN-720033 mod
                      tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD w
            IF cl_null(tm.w) OR tm.w NOT MATCHES '[123]' THEN
               NEXT FIELD w
            END IF
 
         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES '[123]' THEN
               NEXT FIELD h
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
 
         #ON ACTION CONTROLP   #TQC-630237
         #   CALL r129_wc()    #TQC-630237
 
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
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r129_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr129'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr129','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                       #" '",tm.c CLIPPED,"'",   #FUN-720033 mark #TQC-610053
                        " '",tm.w CLIPPED,"'",   #TQC-610053
                        " '",tm.h CLIPPED,"'",   #TQC-610053
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr129',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r129_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r129()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r129_w
 
END FUNCTION
 
FUNCTION r129_wc()
#DEFINE l_wc LIKE type_file.chr1000  #TQC-630166  #No.FUN-690028 VARCHAR(300)
DEFINE l_wc  STRING   #TQC-630166
 
   OPEN WINDOW r129_w2 AT 2,2
     WITH FORM "aap/42f/aapt110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt110")
 
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON apa01,apa02,apa05,apa06,apa18,apa08,apa09,
                             apa11,apa12,apa13,apa14,apa15,apa16,apa55,
                             apa41,apa19,apa20,apa171,apa17,apa172,apa173,
                             apa174,apa21,apa22,apa24,apa25,apa44,apamksg,
                             apa36,apa31,apa51,apa32,apa52,apa34,apa54,
                             apa35,apa33,apa53,apainpd,apauser,apagrup,
                             apamodu,apadate,apaacti
 
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
 
   CLOSE WINDOW r129_w2
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r129_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION r129()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql     STRING        # RDSQL STATEMENT   #TQC-630166
DEFINE l_order   ARRAY[5] OF LIKE apa_file.apa01      # No.FUN-690028 VARCHAR(100)              #FUN-560011
DEFINE apa	 RECORD LIKE apa_file.*
DEFINE sr        RECORD order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                        order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                        order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),           #FUN-560011
                        azi03 LIKE azi_file.azi03,
                        azi04 LIKE azi_file.azi04,
                        azi05 LIKE azi_file.azi05
                        END RECORD
DEFINE l_net     LIKE apv_file.apv04                     #MOD-AC0338
 
   CALL cl_del_data(l_table)                             #No.FUN-770093
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
#No.FUN-770093 --mark--
#   #no.6133   (針對幣別加總)
#   DELETE FROM curr_tmp;
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4)",
#             "   FROM curr_tmp ",    #group 1 小計
#             "  WHERE order1=? ",
#             "  GROUP BY curr"
#   PREPARE tmp1_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp1_cs CURSOR FOR tmp1_pre
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4)",
#             "   FROM curr_tmp ",    #group 2 小計
#             "  WHERE order1=? ",
#             "    AND order2=? ",
#             "  GROUP BY curr  "
#   PREPARE tmp2_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp2_cs CURSOR FOR tmp2_pre
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4)",
#             "   FROM curr_tmp ",    #group 3 小計
#             "  WHERE order1=? ",
#             "    AND order2=? ",
#             "    AND order3=? ",
#             "  GROUP BY curr  "
#   PREPARE tmp3_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp3_cs CURSOR FOR tmp3_pre
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4)",
#             "   FROM curr_tmp ",    #總計
#             "  GROUP BY curr  "
#   PREPARE tmp4_pre FROM l_sql
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('pre_4:',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   DECLARE tmp4_cs CURSOR FOR tmp4_pre
#   #no.6133(end)
#No.FUN-770093 --end--
 
   LET l_sql = "SELECT '','','',azi03, azi04, azi05,",
               "       apa_file.*",
               " FROM apa_file, OUTER azi_file",
               " WHERE apa_file.apa13=azi_file.azi01",
               "   AND apa42 = 'N'",
               "   AND ", tm.wc CLIPPED
 
   IF tm.h='1' THEN
      LET l_sql=l_sql CLIPPED," AND apa41='Y' "
   END IF
 
   IF tm.h='2' THEN
      LET l_sql=l_sql CLIPPED," AND apa41='N' "
   END IF
 
   PREPARE r129_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r129_curs1 CURSOR FOR r129_prepare1
 
#   CALL cl_outnam('aapr129') RETURNING l_name      #No.FUN-770093
#   START REPORT r129_rep TO l_name                 #No.FUN-770093
#
#   LET g_pageno = 0                                #No.FUN-770093
 
   FOREACH r129_curs1 INTO sr.*, apa.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #FUN-720033---mark---str---
     #IF tm.c='2' THEN
     #   LET apa.apa13  = g_aza.aza17
     #   LET apa.apa31f = apa.apa31
     #   LET apa.apa32f = apa.apa32
     #   LET apa.apa34f = apa.apa34
     #   LET apa.apa60f = apa.apa60   #No.B554
     #   LET apa.apa61f = apa.apa61   #No.B554
     #END IF
     #FUN-720033---mark---end---
     #-MOD-AC0338-add-
      CALL r129_comp_oox(apa.apa01) RETURNING l_net
     #LET apa.apa73 = apa.apa34 + l_net     #MOD-B40164 mark
     #-MOD-AC0338-end-
#     IF tm.w='1' AND apa.apa34<=apa.apa35 THEN
      IF tm.w='1' AND apa.apa73<= 0 THEN    #No.MOD-590440
         CONTINUE FOREACH
      END IF
 
#     IF tm.w='2' AND apa.apa34> apa.apa35 THEN
      IF tm.w='2' AND apa.apa73> 0 THEN     #No.MOD-590440
         CONTINUE FOREACH
      END IF
 
      #No.B554
      IF apa.apa00='21' AND apa.apa58='1' THEN
        #LET apa.apa34f = 0                 #MOD-C70283 mark
         CONTINUE FOREACH                   #MOD-C70283 add
      END IF
      #No.B554
 
      LET apa.apa73 = apa.apa34 + l_net    #MOD-B40164
      IF apa.apa00[1,1] = '2' THEN
         LET apa.apa31f = apa.apa31f * -1
         LET apa.apa32f = apa.apa32f * -1
         LET apa.apa34f = apa.apa34f * -1
         LET apa.apa60f = apa.apa60f * -1   #No.B554
         LET apa.apa61f = apa.apa61f * -1   #No.B554
        #FUN-720033---add---str---                                 
         LET apa.apa31  = apa.apa31  * -1
         LET apa.apa32  = apa.apa32  * -1
        #LET apa.apa34  = apa.apa34  * -1        #MOD-A30101 mark    
         LET apa.apa73  = apa.apa73  * -1        #MOD-A30101 add    
         LET apa.apa60  = apa.apa60  * -1 
         LET apa.apa61  = apa.apa61  * -1 
        #FUN-720033---add---end---                                 
      END IF
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
 
      #No.FUN-770093 --mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = apa.apa00
#                                       LET g_orderA[g_i]= g_x[14]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = apa.apa01
#                                       LET g_orderA[g_i]= g_x[15]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = apa.apa02 USING 'YYYYMMDD'
#                                       LET g_orderA[g_i]= g_x[16]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = apa.apa06
#                                       LET g_orderA[g_i]= g_x[17]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = apa.apa13
#                                       LET g_orderA[g_i]= g_x[18]
#              OTHERWISE LET l_order[g_i]  = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
#
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      IF cl_null(sr.order1) THEN LET sr.order1 = ' '  END IF
#      IF cl_null(sr.order2) THEN LET sr.order2 = ' '  END IF
#      IF cl_null(sr.order3) THEN LET sr.order3 = ' '  END IF
#
#      OUTPUT TO REPORT r129_rep(sr.*, apa.*)
#No.FUN-770093 --end--
#No.FUN-770093 --start--
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
            FROM azi_file 
      WHERE azi01=apa.apa13
      EXECUTE insert_prep USING apa.apa00,apa.apa01,apa.apa02,apa.apa06,
                                apa.apa07,apa.apa13,apa.apa31f,apa.apa32f,
                                apa.apa60f,apa.apa61f,apa.apa34f,apa.apa41,
                                t_azi03,t_azi04,t_azi05,
                               #apa.apa31,apa.apa32,apa.apa60,apa.apa61,apa.apa34,  #FUN-720033 add    #MOD-A30101 mark
                                apa.apa31,apa.apa32,apa.apa60,apa.apa61,apa.apa73,  #MOD-A30101 add
                                g_azi04,g_azi05                                     #FUN-720033 add
#No.FUN-770093 --end--
   END FOREACH
 
#   FINISH REPORT r129_rep                           #No.FUN-770093
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-770093
#No.FUN-770093 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'apa00,apa01,apa02,apa06,apa13')
           RETURNING tm.wc
      LET g_str=tm.wc
   END IF
   LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
             tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
             tm.u[3,3],";",tm.w,";",tm.h,";",g_apz.apz27            #FUN-720033 mod   #MOD-A30101 add apz27
            #tm.u[3,3],";",tm.c,";",tm.w,";",tm.h   #FUN-720033 mark
   LET l_sql="SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('aapr129','aapr129',l_sql,g_str)
#No.FUN-770093 --end--
   
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION

#-MOD-AC0338-add-
FUNCTION r129_comp_oox(p_apa01)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apa01   LIKE apa_file.apa01
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apa01
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apa01
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
#-MOD-AC0338-end-

#No.FUN-770093 --start-- mark
{REPORT r129_rep(sr, apa)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE apa          RECORD LIKE apa_file.*
DEFINE sr           RECORD order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),              #FUN-560011
                           order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),              #FUN-560011
                           order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(100),              #FUN-560011
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05
                    END RECORD,
          sr1           RECORD
                           curr      LIKE azi_file.azi01,      # No.FUN-690028 VARCHAR(04),
                           amt1      LIKE apa_file.apa31f,
                           amt2      LIKE apa_file.apa32f,
                           amt3      LIKE apa_file.apa34f,
                           amt4      LIKE apa_file.apa60f
                        END RECORD
DEFINE l_apa13   LIKE apa_file.apa13
DEFINE amt1      LIKE apa_file.apa31f
DEFINE amt2      LIKE apa_file.apa32f
DEFINE amt3      LIKE apa_file.apa34f
DEFINE amt4      LIKE apa_file.apa60f
DEFINE l_amt3    LIKE apa_file.apa60f
DEFINE g_head1    STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
 #MOD-530382
         IF apa.apa00 = '21' OR apa.apa00 = '22' THEN
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[42]
         ELSE
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         END IF
 #END MOD-530382
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
#        LET g_head1 = g_x[19] CLIPPED,g_orderA[1] CLIPPED,    #TQC-6A0088
         LET g_head1 = g_x[13] CLIPPED,g_orderA[1] CLIPPED,    #TQC-6A0088
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         IF tm.c = 1 THEN
#           SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
            SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
              FROM azi_file
             WHERE azi01=apa.apa13
         END IF
         PRINT COLUMN g_c[31],apa.apa00,
               COLUMN g_c[32],apa.apa01,
               COLUMN g_c[33],apa.apa02,
               COLUMN g_c[34],apa.apa06,
               COLUMN g_c[35],apa.apa07,
               COLUMN g_c[36],apa.apa13,
#NO.CHI-6A0004 --START
#              COLUMN g_c[37],cl_numfor(apa.apa31f,37,g_azi04),
#              COLUMN g_c[38],cl_numfor(apa.apa32f,38,g_azi04),
#              COLUMN g_c[39],cl_numfor(apa.apa60f+apa.apa61f,39,g_azi04),
#              COLUMN g_c[40],cl_numfor(apa.apa34f,40,g_azi05),
               COLUMN g_c[37],cl_numfor(apa.apa31f,37,t_azi04),
               COLUMN g_c[38],cl_numfor(apa.apa32f,38,t_azi04),
               COLUMN g_c[39],cl_numfor(apa.apa60f+apa.apa61f,39,t_azi04),
               COLUMN g_c[40],cl_numfor(apa.apa34f,40,t_azi05),
#NO.CHI-6A0004 --END
               COLUMN g_c[41],apa.apa41
 
         #no.6133
         IF tm.c = '1' THEN
            LET l_amt3 = apa.apa60f + apa.apa61f
            INSERT INTO curr_tmp VALUES(apa.apa13,apa.apa31f,apa.apa32f,l_amt3,
                                        apa.apa34f,sr.order1,sr.order2,sr.order3)
         END IF
         #no.6133(end)
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET amt1 = GROUP SUM(apa.apa31f)
            LET amt2 = GROUP SUM(apa.apa32f)
            LET amt3 = GROUP SUM(apa.apa34f)
            LET amt4 = GROUP SUM(apa.apa60f+apa.apa61f)
            PRINT
            IF tm.c = '2' THEN
               PRINT COLUMN g_c[34],sr.order1 CLIPPED,
                     COLUMN g_c[35],g_orderA[1] CLIPPED,
                     COLUMN g_c[36],g_x[11] CLIPPED,
#NO.CHI-6A0004 --START
#                    COLUMN g_c[37],cl_numfor(amt1,37,g_azi05),
#                    COLUMN g_c[38],cl_numfor(amt2,38,g_azi05),
#                    COLUMN g_c[39],cl_numfor(amt4,39,g_azi05),
#                    COLUMN g_c[40],cl_numfor(amt3,40,g_azi05)
                     COLUMN g_c[37],cl_numfor(amt1,37,t_azi05),
                     COLUMN g_c[38],cl_numfor(amt2,38,t_azi05),
                     COLUMN g_c[39],cl_numfor(amt4,39,t_azi05),
                     COLUMN g_c[40],cl_numfor(amt3,40,t_azi05)
#NO.CHI-6A0004 --END
            ELSE
               #no.6133
               PRINT COLUMN g_c[33],sr.order1 CLIPPED,
                     COLUMN g_c[34],g_orderA[1] CLIPPED;
               FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#                 SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
                  SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                   WHERE azi01 = sr1.curr
#MOD-5A0066
                  PRINT COLUMN g_c[35],g_x[11] CLIPPED,
                        COLUMN g_c[36],sr1.curr CLIPPED,
#                 PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#                       COLUMN g_c[36],g_x[11] CLIPPED,
#NO.CHI-6A0004 --START
#                       COLUMN g_c[37],cl_numfor(sr1.amt1,37,g_azi05),
#                       COLUMN g_c[38],cl_numfor(sr1.amt2,38,g_azi05),
#                       COLUMN g_c[39],cl_numfor(sr1.amt3,39,g_azi05),
#                       COLUMN g_c[40],cl_numfor(sr1.amt4,40,g_azi05)
                        COLUMN g_c[37],cl_numfor(sr1.amt1,37,t_azi05),
                        COLUMN g_c[38],cl_numfor(sr1.amt2,38,t_azi05),
                        COLUMN g_c[39],cl_numfor(sr1.amt3,39,t_azi05),
                        COLUMN g_c[40],cl_numfor(sr1.amt4,40,t_azi05)
#NO.CHI-6A0004 --END
                  END FOREACH
               #no.6133(end)
            END IF
            PRINT COLUMN g_c[34],g_dash2[42,g_len]
#           PRINT COLUMN g_c[34],g_dash2[32,g_len]
#MOD-5A0066 End
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT
            LET amt1 = GROUP SUM(apa.apa31f)
            LET amt2 = GROUP SUM(apa.apa32f)
            LET amt3 = GROUP SUM(apa.apa34f)
            LET amt4 = GROUP SUM(apa.apa60f+apa.apa61f)
            IF tm.wc='2' THEN
               PRINT COLUMN g_c[34],sr.order2[11,20] CLIPPED,
                     COLUMN g_c[35],g_orderA[2] CLIPPED,
                     COLUMN g_c[36],g_x[10] CLIPPED,
#NO.CHI-6A0004 --START
#                    COLUMN g_c[37],cl_numfor(amt1,37,g_azi05),
#                    COLUMN g_c[38],cl_numfor(amt2,38,g_azi05),
#                    COLUMN g_c[39],cl_numfor(amt4,39,g_azi05),
#                    COLUMN g_c[40],cl_numfor(amt3,40,g_azi05)
                     COLUMN g_c[37],cl_numfor(amt1,37,t_azi05),
                     COLUMN g_c[38],cl_numfor(amt2,38,t_azi05),
                     COLUMN g_c[39],cl_numfor(amt4,39,t_azi05),
                     COLUMN g_c[40],cl_numfor(amt3,40,t_azi05)
#NO.CHI-6A0004 --END
            ELSE
               #no.6133
               PRINT COLUMN g_c[33],sr.order1[11,20] CLIPPED,
                     COLUMN g_c[34],g_orderA[1] CLIPPED;
               FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#                 SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
                  SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                   WHERE azi01 = sr1.curr
#MOD-5A0066
                  PRINT COLUMN g_c[35],g_x[10] CLIPPED,
                        COLUMN g_c[36],sr1.curr CLIPPED,
#                 PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#                       COLUMN g_c[36],g_x[10] CLIPPED,
#NO.CHI-6A0004 --START
#                       COLUMN g_c[37],cl_numfor(sr1.amt1,37,g_azi05),
#                       COLUMN g_c[38],cl_numfor(sr1.amt2,38,g_azi05),
#                       COLUMN g_c[39],cl_numfor(sr1.amt3,39,g_azi05),
                        COLUMN g_c[37],cl_numfor(sr1.amt1,37,t_azi05),
                        COLUMN g_c[38],cl_numfor(sr1.amt2,38,t_azi05),
                        COLUMN g_c[39],cl_numfor(sr1.amt3,39,t_azi05),
                       #--------------------No.MOD-550110---------------
                        #COLUMN g_c[40],cl_numfor(sr1.amt4,49,g_azi05)
#                       COLUMN g_c[40],cl_numfor(sr1.amt4,40,g_azi05)
                        COLUMN g_c[40],cl_numfor(sr1.amt4,40,t_azi05)
                       #--------------------No.MOD-550110---------------
#NO.CHI-6A0004 --END
               END FOREACH
               #no.6133(end)
            END IF
            PRINT COLUMN g_c[34],g_dash2[42,g_len]
#           PRINT COLUMN g_c[34],g_dash2[32,g_len]
#MOD-5A0066 End
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT
            LET amt1 = GROUP SUM(apa.apa31f)
            LET amt2 = GROUP SUM(apa.apa32f)
            LET amt3 = GROUP SUM(apa.apa34f)
            LET amt4 = GROUP SUM(apa.apa60f+apa.apa61f)
            IF tm.wc='2' THEN
               PRINT COLUMN g_c[34],sr.order2[11,20] CLIPPED,
                     COLUMN g_c[35],g_orderA[3] CLIPPED,
                     COLUMN g_c[36],g_x[9] CLIPPED,
#NO.CHI-6A0004 --START
#                    COLUMN g_c[37],cl_numfor(amt1,37,g_azi05),
#                    COLUMN g_c[38],cl_numfor(amt2,38,g_azi05),
#                    COLUMN g_c[39],cl_numfor(amt4,39,g_azi05),
#                    COLUMN g_c[40],cl_numfor(amt3,40,g_azi05)
                     COLUMN g_c[37],cl_numfor(amt1,37,t_azi05),
                     COLUMN g_c[38],cl_numfor(amt2,38,t_azi05),
                     COLUMN g_c[39],cl_numfor(amt4,39,t_azi05),
                     COLUMN g_c[40],cl_numfor(amt3,40,t_azi05)
#NO.CHI-6A0004 --END
            ELSE
               #no.6133
               PRINT COLUMN g_c[33],sr.order1[11,20] CLIPPED,
                     COLUMN g_c[34],g_orderA[1] CLIPPED;
               FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#                 SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004 
                  SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                   WHERE azi01 = sr1.curr
#MOD-5A0066
                  PRINT COLUMN g_c[35],g_x[9] CLIPPED,
                        COLUMN g_c[36],sr1.curr CLIPPED,
#                 PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#                       COLUMN g_c[36],g_x[9] CLIPPED,
#NO.CHI-6A0004 --START
#                       COLUMN g_c[37],cl_numfor(sr1.amt1,37,g_azi05),
#                       COLUMN g_c[38],cl_numfor(sr1.amt2,38,g_azi05),
#                       COLUMN g_c[39],cl_numfor(sr1.amt3,39,g_azi05),
#                       COLUMN g_c[40],cl_numfor(sr1.amt4,40,g_azi05)
                        COLUMN g_c[37],cl_numfor(sr1.amt1,37,t_azi05),
                        COLUMN g_c[38],cl_numfor(sr1.amt2,38,t_azi05),
                        COLUMN g_c[39],cl_numfor(sr1.amt3,39,t_azi05),
                        COLUMN g_c[40],cl_numfor(sr1.amt4,40,t_azi05)
#NO.CHI-6A0004 --END
               END FOREACH
               #no.6133(end)
            END IF
            PRINT COLUMN g_c[34],g_dash2[42,g_len]
#           PRINT COLUMN g_c[34],g_dash2[32,g_len]
#MOD-5A0066 End
         END IF
 
      ON LAST ROW
         IF tm.c='2' THEN
            LET amt1 = SUM(apa.apa31f)
            LET amt2 = SUM(apa.apa32f)
            LET amt3 = SUM(apa.apa34f)
            LET amt4 = SUM(apa.apa60f+apa.apa61f)
#MOD-5A0066
#           PRINT COLUMN g_x[12] CLIPPED,g_c[36], #MOD-710089 mark
            PRINT COLUMN g_c[35],g_x[12] CLIPPED, #MOD-710089 add
#           PRINT COLUMN g_c[36],g_x[12] CLIPPED,
#MOD-5A0066 End
#NO.CHI-6A0004 --START
#                 COLUMN g_c[37],cl_numfor(amt1,37,g_azi05),
#                 COLUMN g_c[38],cl_numfor(amt2,38,g_azi05),
#                 COLUMN g_c[39],cl_numfor(amt4,39,g_azi05),
#                 COLUMN g_c[40],cl_numfor(amt3,40,g_azi05)
                  COLUMN g_c[37],cl_numfor(amt1,37,t_azi05),
                  COLUMN g_c[38],cl_numfor(amt2,38,t_azi05),
                  COLUMN g_c[39],cl_numfor(amt4,39,t_azi05),
                  COLUMN g_c[40],cl_numfor(amt3,40,t_azi05)
#NO.CHI-6A0004 --END
         ELSE
            FOREACH tmp4_cs INTO sr1.*
#              SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
               SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                WHERE azi01 = sr1.curr
#MOD-5A0066
               PRINT COLUMN g_c[35],g_x[12] CLIPPED,
                     COLUMN g_c[36],sr1.curr CLIPPED,
#              PRINT COLUMN g_c[35],sr1.curr CLIPPED,
#                    COLUMN g_c[36],g_x[12] CLIPPED,
#NO.CHI-6A0004 --START
#                    COLUMN g_c[37],cl_numfor(sr1.amt1,37,g_azi05),
#                    COLUMN g_c[38],cl_numfor(sr1.amt2,38,g_azi05),
#                    COLUMN g_c[39],cl_numfor(sr1.amt3,39,g_azi05),
#                    COLUMN g_c[40],cl_numfor(sr1.amt4,40,g_azi05)
                     COLUMN g_c[37],cl_numfor(sr1.amt1,37,t_azi05),
                     COLUMN g_c[38],cl_numfor(sr1.amt2,38,t_azi05),
                     COLUMN g_c[39],cl_numfor(sr1.amt3,39,t_azi05),
                     COLUMN g_c[40],cl_numfor(sr1.amt4,40,t_azi05)
#NO.CHI-6A0004 --END
#MOD-5A0066 End
            END FOREACH
            #no.6133(end)
         END IF
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[7] CLIPPED        #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED        #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[6] CLIPPED      #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED      #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-770093 --end--
