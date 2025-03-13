# Prog. Version..: '5.30.06-13.03.12(00010)'     #

# Pattern name...: aapr610.4gl
# Descriptions...: 應付帳款分錄底稿清單列印
# Date & Author..: 93/07/01  By  Roger
# Modify.........: 97/04/21 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: No.9382 04/03/30 By Kitty tm.sGui處理段放錯位置
# Modify.........: No.FUN-4C0097 05/01/03 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02、部門名稱gem02、廠商編號apa06、廠商簡稱apa07
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.MOD-570215 05/08/04 By Nicola 總合計科目列印範圍放大
# Modify.........: No.MOD-610004 06/01/03 By Smapmin 廠商簡稱未列印出來
# Modify.........: No.MOD-610121 06/01/19 By Smapmin 原宣告 ARRAY OF [40] 改為 DYNAMIC ARRAY
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0172 06/12/28 By wujie 調整“接下頁/結束”位置
# Modify.........: No.FUN-730064 07/04/03 By mike  會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By hongmei 用年度取帳號
# Modify.........: No.TQC-750048 07/05/11 By jamie 重新過單
# Modify.........: No.TQC-750061 01/05/14 By johnray 同步到informix區后報l_sql語法錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990203 09/10/18 By mike aapr610分錄底稿貸方出現重復現象,(原是多借一貸,現變成多借多貸)
# Modify.........: No.TQC-990144 09/10/21 By mike 有抓取npp_file与npq_file的SQL,请加上AND npptype=npqtype条件
# Modify.........: No.MOD-A30111 10/03/16 By sabrina 抓取筆數時時間過長，將tm.wc條件加入where裡
# Modify.........: No.TQC-A40079 10/04/16 By Carrier GP5.2报表追单
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,     #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,                     #TQC-630166  #TQC-750048 add
              s        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              t        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              u        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              h        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)         #No.FUN-550030
DEFINE    tot DYNAMIC ARRAY OF RECORD
                 dc       LIKE npq_file.npq06,
                 actno    LIKE npq_file.npq03,
                 actname  LIKE aag_file.aag02,
                 amt      LIKE npq_file.npq07
              END RECORD
DEFINE   ix   LIKE type_file.num5        # No.FUN-690028 SMALLINT
DEFINE   g_i  LIKE type_file.num5        #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE  g_cou LIKE type_file.num5        # No.FUN-690028 SMALLINT   #No.MOD-570215
#     DEFINE  l_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE  g_bookno1  LIKE aza_file.aza81      #No.FUN-730064
DEFINE  g_bookno2  LIKE aza_file.aza82      #No.FUN-730064
DEFINE  g_flag     LIKE type_file.chr1      #No.FUN-730064
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

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
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
   LET tm.h  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r610_tm(0,0)
   ELSE
      CALL r610()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN

FUNCTION r610_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)

   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r610_w AT p_row,p_col
     WITH FORM "aap/42f/aapr610"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.h    = '3'
   LET tm.s    = '321'
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
      CONSTRUCT BY NAME tm.wc ON apa00,apa01,apa02,apa21,apa22,apa06,apa15,apa44

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
         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF

      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF

      INPUT BY NAME tm.h,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS

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

         #No:9382 add
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CALL r610_wc()

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
         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr610'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr610','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr610',g_time,l_cmd)
         END IF

         CLOSE WINDOW r610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL r610()

      ERROR ""
   END WHILE

   CLOSE WINDOW r610_w

END FUNCTION

FUNCTION r610_wc()
#DEFINE l_wc LIKE type_file.chr1000  #TQC-630166  #No.FUN-690028 VARCHAR(300)
DEFINE l_wc  STRING   #TQC-630166

   OPEN WINDOW r610_w2 AT 2,2
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

   CLOSE WINDOW r610_w2

   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION r610()
DEFINE l_name    LIKE type_file.chr20       # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8       # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql      STRING       # RDSQL STATEMENT   #TQC-630166
DEFINE l_chr     LIKE type_file.chr1        #No.FUN-690028 VARCHAR(1)
DEFINE j     LIKE type_file.num5            #No.FUN-690028 SMALLINT
DEFINE l_order   ARRAY[5] OF LIKE apa_file.apa01      # No.FUN-690028  VARCHAR(16)    #No.FUN-550030
DEFINE sr        RECORD order1 LIKE apa_file.apa01,   # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        order2 LIKE apa_file.apa01,   # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        order3 LIKE apa_file.apa01,   # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        apa00 LIKE apa_file.apa00,
                        apa01 LIKE apa_file.apa01,
                        apa02 LIKE apa_file.apa02,
                        apa06 LIKE apa_file.apa06,
                        apa07 LIKE apa_file.apa07,   #MOD-610004
                        apa13 LIKE apa_file.apa13,
                        apa15 LIKE apa_file.apa15,
                        apa21 LIKE apa_file.apa21,
                        apa22 LIKE apa_file.apa22,
                        apa44 LIKE apa_file.apa44,
                        npq06 LIKE npq_file.npq06,
                        npq03 LIKE npq_file.npq03,
                        npq07 LIKE npq_file.npq07,
                        npq04 LIKE npq_file.npq04,
                        aag02 LIKE aag_file.aag02,
                        npp02 LIKE npp_file.npp02,   #No.TQC-750061
                        azi04 LIKE azi_file.azi04,
                        azi05 LIKE azi_file.azi05,
                        #apa07 LIKE apa_file.apa07,   #MOD-610004
                        gen02 LIKE gen_file.gen02,
                        gem02 LIKE gem_file.gem02
#                        npp02 LIKE npp_file.npp02     #No.FUN-730064  TQC-750061
                        END RECORD

#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #抓取帳別
   CALL s_get_bookno(YEAR(g_today)) RETURNING g_flag,g_bookno1,g_bookno2  #MOD-990203
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


   #No.TQC-A40079  --Begin
   LET l_sql = "SELECT '','','',",
               "      apa00,apa01,apa02,apa06,apa07,apa13,apa15,apa21,",
               "      apa22,apa44,npq06,npq03,npq07,npq04,'',npp02, ",
               "      azi04,azi05,'','' ",
               " FROM apa_file LEFT OUTER JOIN npp_file LEFT OUTER JOIN npq_file LEFT OUTER JOIN aag_file ",
               "                                                                       ON npq03 = aag01 ",
               "                                              ON npp01  = npq01  AND npp00 =npq00 ",
               "                                             AND nppsys = npqsys AND npp011=npq011",
               "                                             AND npptype= npqtype  ",
               "                     ON apa01 = npp01 ",
               "               LEFT OUTER JOIN azi_file ",
               "                     ON apa13 = azi01 ",
               " WHERE apa42='N' AND apa75= 'N'",
               "   AND aag00 = '",g_bookno1,"'",
               "   AND nppsys = 'AP' ",
               "   AND ", tm.wc CLIPPED
   #No.TQC-A40079  --End
   IF g_aza.aza63='N' THEN #TQC-990144
      LET l_sql=l_sql CLIPPED," AND npptype='0' " #TQC-990144
   END IF #TQC-990144
   IF tm.h='1' THEN
      LET l_sql=l_sql CLIPPED," AND apa41='Y' "
   END IF

   IF tm.h='2' THEN
      LET l_sql=l_sql CLIPPED," AND apa41='N' "
   END IF

   PREPARE r610_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r610_curs1 CURSOR FOR r610_prepare1

    #-----No.MOD-570215-----
   IF g_aza.aza63='Y' THEN #TQC-990144
     #MOD-A30111---modify---start---
     #SELECT COUNT(*) INTO g_cou
     #  FROM apa_file LEFT OUTER JOIN npp_file ON(apa01 = npp01) LEFT OUTER JOIN (npq_file LEFT OUTER JOIN aag_file ON(npq03 = aag01 AND aag00=g_bookno1)) ON(apa01 = npq01)
     # WHERE npp01 = npq01 AND apa42='N' AND apa75= 'N'
     #   AND nppsys = 'AP' AND npp00=npq00
     #   AND nppsys=npqsys AND npp011=npq011
     ##TQC-990144   ---START
     #   AND npptype=npqtype
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM apa_file LEFT OUTER JOIN npp_file ON(apa01 = npp01) ",
                  "                LEFT OUTER JOIN (npq_file LEFT OUTER JOIN aag_file ON(npq03 = aag01 AND aag00='",g_bookno1,"')) ",
                  "                                 ON(apa01 = npq01) ",
                  " WHERE npp01 = npq01 AND apa42='N' AND apa75= 'N' ",
                  "   AND nppsys = 'AP' AND npp00=npq00 ",
                  "   AND nppsys=npqsys AND npp011=npq011 ",
                  "   AND npptype=npqtype ",
                  "   AND ",tm.wc CLIPPED
     #MOD-A30111---modify---end---
   ELSE
     #MOD-A30111---modify---start---
     #SELECT COUNT(*) INTO g_cou
     #  FROM apa_file LEFT OUTER JOIN npp_file ON (apa01=npp01) LEFT OUTER JOIN (npq_file LEFT OUTER JOIN aag_file ON (npq03=aag01 AND aag00=g_bookno1)) ON (apa01=npq01)
     # WHERE npp01=npq01 AND apa42='N' AND apa75='N'
     #   AND nppsys='AP' AND npp00=npq00
     #   AND nppsys=npqsys AND npp011=npq011
     #   AND npptype=npqtype AND npptype='0'
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM apa_file LEFT OUTER JOIN npp_file ON (apa01=npp01) ",
                  "  LEFT OUTER JOIN (npq_file LEFT OUTER JOIN aag_file ON (npq03=aag01 AND aag00='",g_bookno1,"'))",
                  "   ON (apa01=npq01) ",
                  " WHERE npp01=npq01 AND apa42='N' AND apa75='N' ",
                  "   AND nppsys='AP' AND npp00=npq00 ",
                  "   AND nppsys=npqsys AND npp011=npq011 ",
                  "   AND npptype=npqtype AND npptype='0' ",
                  "   AND ",tm.wc CLIPPED
     #MOD-A30111---modify---end---
   END IF
  #TQC-990144   ---END
    #-----No.MOD-570215 END-----
  #MOD-A30111---add---start---
   PREPARE r610_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   EXECUTE r610_prepare2 INTO g_cou
  #MOD-A30111---add---end---

   CALL cl_outnam('aapr610') RETURNING l_name
   START REPORT r610_rep TO l_name

   LET g_pageno = 0
   LET ix = 0

#  FOR j = 1 TO 20
#     LET tot[j].dc      = NULL
#     LET tot[j].actno   = NULL
#     LET tot[j].actname = NULL
#     LET tot[j].amt     = 0
#  END FOR

    CALL tot.clear()   #No.MOD-570215

   FOREACH r610_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-730064   --begin--
      CALL s_get_bookno(YEAR(sr.npp02))   RETURNING g_flag,g_bookno1,g_bookno2     #No.TQC-740042
      IF g_flag='1' THEN  #抓不到帳套
          CALL cl_err(sr.npp02,'aoo-081',1)
      END IF
      SELECT aag02 INTO sr.aag02 FROM aag_file WHERE aag00=g_bookno1 AND aag01=sr.npq03
      #No.FUN-730064   --end--
      IF cl_null(sr.npq07) THEN
         LET sr.npq07 = 0
      END IF

      SELECT gen02 INTO sr.gen02 FROM gen_file
       WHERE gen01 = sr.apa21

      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.apa22

      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa00
                                       LET g_orderA[g_i]= g_x[14]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa01
                                       LET g_orderA[g_i]= g_x[15]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
                                       LET g_orderA[g_i]= g_x[16]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa21
                                       LET g_orderA[g_i]= g_x[17]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa22
                                       LET g_orderA[g_i]= g_x[18]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa06
                                       LET g_orderA[g_i]= g_x[19]
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apa15
                                       LET g_orderA[g_i]= g_x[20]
              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.apa44
                                       LET g_orderA[g_i]= g_x[21]
              OTHERWISE LET l_order[g_i]  = '-'
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR

      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF

      OUTPUT TO REPORT r610_rep(sr.*)

   END FOREACH

   FINISH REPORT r610_rep

   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105  MARK

END FUNCTION

REPORT r610_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE sr        RECORD order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                        apa00 LIKE apa_file.apa00,
                        apa01 LIKE apa_file.apa01,
                        apa02 LIKE apa_file.apa02,
                        apa06 LIKE apa_file.apa06,
                        apa07 LIKE apa_file.apa07,
                        apa13 LIKE apa_file.apa13,
                        apa15 LIKE apa_file.apa15,
                        apa21 LIKE apa_file.apa21,
                        apa22 LIKE apa_file.apa22,
                        apa44 LIKE apa_file.apa44,
                        npq06 LIKE npq_file.npq06,
                        npq03 LIKE npq_file.npq03,
                        npq07 LIKE npq_file.npq07,
                        npq04 LIKE npq_file.npq04,
                        aag02 LIKE aag_file.aag02,
                        npp02 LIKE npp_file.npp02,
                        azi04 LIKE azi_file.azi04,
                        azi05 LIKE azi_file.azi05,
                        #apa07 LIKE apa_file.apa07,   #MOD-610004
                        gen02 LIKE gen_file.gen02,
                        gem02 LIKE gem_file.gem02
#                        npp02 LIKE npp_file.npp02     #No.FUN-730064
                    END RECORD
DEFINE l_amt_1      LIKE npq_file.npq07
DEFINE l_amt_2      LIKE npq_file.npq07
#DEFINE l_buf        ARRAY[40] OF RECORD      #MOD-610121
DEFINE l_buf        DYNAMIC ARRAY OF RECORD     #MOD-610121
                       npq03  LIKE npq_file.npq03,
                       aag02  LIKE aag_file.aag02,
                       npq06  LIKE npq_file.npq06,
                       npq07  LIKE npq_file.npq07,
                       npq04  LIKE npq_file.npq04
                    END RECORD
DEFINE i,j          LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE k            LIKE type_file.num5    #MOD-610121  #No.FUN-690028 SMALLINT
DEFINE l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_head1    STRING

   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

   ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01,sr.npq06

   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[13] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
               g_x[47]
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

      BEFORE GROUP OF sr.apa01
         CALL l_buf.clear()
         LET i = 0

      ON EVERY ROW
         LET i = i + 1
         LET l_buf[i].npq03 = sr.npq03
         LET l_buf[i].aag02 = sr.aag02
         LET l_buf[i].npq06 = sr.npq06
         LET l_buf[i].npq07 = sr.npq07
         LET l_buf[i].npq04 = sr.npq04
        #No.FUN-730064   --begin--
        CALL s_get_bookno(YEAR(sr.apa02))  RETURNING g_flag,g_bookno1,g_bookno2      #No.TQC-740042
        #No.FUN-730064  --end--
        #FOR j = 1 TO 20
          FOR j = 1 TO g_cou     #No.MOD-570215
            IF tot[j].dc IS NULL THEN
               LET tot[j].dc    = sr.npq06
               LET tot[j].actno = sr.npq03
               LET tot[j].amt   = sr.npq07
               EXIT FOR
            END IF
            IF sr.npq06 = tot[j].dc AND sr.npq03 = tot[j].actno THEN
               LET tot[j].amt = tot[j].amt + sr.npq07
               EXIT FOR
            END IF
         END FOR

      AFTER GROUP OF sr.apa01
         PRINT COLUMN g_c[31],sr.apa00,
               COLUMN g_c[32],sr.apa01,
               COLUMN g_c[33],sr.apa44,
               COLUMN g_c[34],sr.apa02,
               COLUMN g_c[35],sr.apa06,
               COLUMN g_c[36],sr.apa07,
               COLUMN g_c[37],sr.apa21,
               COLUMN g_c[38],sr.gen02,
               COLUMN g_c[39],sr.apa22,
               COLUMN g_c[40],sr.gem02,
               COLUMN g_c[41],sr.apa13,
               COLUMN g_c[42],sr.apa15,
               COLUMN g_c[43],l_buf[1].npq03,
               COLUMN g_c[44],l_buf[1].aag02,
               COLUMN g_c[45],l_buf[1].npq06,
               COLUMN g_c[46],cl_numfor(l_buf[1].npq07,46,sr.azi04),
               COLUMN g_c[47],l_buf[1].npq04

         #-----MOD-610121---------
         #FOR i = 2 TO 40
         FOR k = 2 TO i
            IF l_buf[k].npq03 IS NOT NULL THEN
               PRINT COLUMN g_c[43],l_buf[k].npq03,
                     COLUMN g_c[44],l_buf[k].aag02,
                     COLUMN g_c[45],l_buf[k].npq06,
                     COLUMN g_c[46],cl_numfor(l_buf[k].npq07,46,sr.azi04),
                     COLUMN g_c[47],l_buf[k].npq04
            END IF
         END FOR
         #-----END MOD-610121-----

      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[43],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[43],g_orderA[1] CLIPPED,
                  COLUMN g_c[44],g_x[11] CLIPPED,
                  COLUMN g_c[45],'1',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT COLUMN g_c[45],'2',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT ''
         END IF

      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[43],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[43],g_orderA[2] CLIPPED,
                  COLUMN g_c[44],g_x[10] CLIPPED,
                  COLUMN g_c[45],'1',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT COLUMN g_c[45],'2',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT ''
         END IF

      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[43],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[43],g_orderA[3] CLIPPED,
                  COLUMN g_c[44],g_x[9] CLIPPED,
                  COLUMN g_c[45],'1',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT COLUMN g_c[45],'2',
                  COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
            PRINT ''
         END IF

      ON LAST ROW
         LET l_amt_1 = SUM(sr.npq07) WHERE sr.npq06 = '1'
         LET l_amt_2 = SUM(sr.npq07) WHERE sr.npq06 = '2'
        #FOR i = 1 TO 20
          FOR i = 1 TO g_cou     #No.MOD-570215
            IF tot[i].actno IS NULL THEN
               CONTINUE FOR
            END IF
            CALL s_aapact('2',g_bookno1,tot[i].actno) RETURNING tot[i].actname   #No:8727
         END FOR

         PRINT COLUMN g_c[43],g_dash2[1,g_len-g_c[43]]
         PRINT COLUMN g_c[40],g_x[12] CLIPPED,
               COLUMN g_c[41],tot[1].dc,
               COLUMN g_c[42],tot[1].actno CLIPPED,
               COLUMN g_c[43],tot[1].actname CLIPPED,
               COLUMN g_c[44],cl_numfor(tot[1].amt,46,sr.azi04),
               COLUMN g_c[45],'1',
               COLUMN g_c[46],cl_numfor(l_amt_1,46,sr.azi04)
         PRINT COLUMN g_c[41],tot[2].dc,
               COLUMN g_c[42],tot[2].actno CLIPPED,
               COLUMN g_c[43],tot[2].actname CLIPPED,
               COLUMN g_c[44],cl_numfor(tot[2].amt,46,sr.azi04),
               COLUMN g_c[45],'2',
               COLUMN g_c[46],cl_numfor(l_amt_2,46,sr.azi04)

        #FOR i = 3 TO 20
          FOR i = 3 TO g_cou     #No.MOD-570215
            IF tot[i].dc IS NULL THEN
               CONTINUE FOR
            END IF
            PRINT COLUMN g_c[41],tot[i].dc,
                  COLUMN g_c[42],tot[i].actno CLIPPED,
                  COLUMN g_c[43],tot[i].actname CLIPPED,
                  COLUMN g_c[44],cl_numfor(tot[i].amt,46,sr.azi04)
         END FOR

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
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[47],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED      #No.TQC-6C0172

      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[47],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-6C0172
         ELSE
            SKIP 2 LINE
         END IF

END REPORT
