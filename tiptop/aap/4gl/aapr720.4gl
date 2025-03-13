# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapr720.4gl
# Descriptions...: 開狀到單餘額明細表
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 05/01/04 By Nicola 報表架構修改
#                                                   增加列印銀行名稱alg02、部門名稱gem02
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
#
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.TQC-6A0086 06/11/14 By baogui  結束位置調整
# Modify.........: No.FUN-770093 07/10/24 By zhoufeng 報表打印改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 #wc      LIKE type_file.chr1000,      # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc      STRING,       # Where condition   #TQC-630166
                 s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Order by sequence
                 t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Eject sw
                 u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Group total sw
                 more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                            #No.FUN-550030
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0055
DEFINE   g_str           STRING                  #No.FUN-770093
DEFINE   g_sql           STRING                  #No.FUN-770093
DEFINE   l_table         STRING                  #No.FUN-770093
 
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-770093 --start--
   LET g_sql="ala07.ala_file.ala07,alg02.alg_file.alg02,ala04.ala_file.ala04,",
             "gem02.gem_file.gem02,ala02.ala_file.ala02,ala20.ala_file.ala20,",
             "ala08.ala_file.ala08,ala72.ala_file.ala72,ala01.ala_file.ala01,",
             "amt1.ala_file.ala23,amt2.ala_file.ala23,amt3.ala_file.ala23,",
             "ala05.ala_file.ala05,azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('aapr720',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770093 --end-- 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-770093 --mark--
#   #no.6133
#   DROP TABLE curr_tmp
## No.FUN-690028 --start--
#   CREATE TEMP TABLE curr_tmp(
#       curr    LIKE apa_file.apa13,
#       amt1    LIKE type_file.num20_6,
#       amt2    LIKE type_file.num20_6,
#       amt3    LIKE type_file.num20_6,
#       amt4    LIKE type_file.num20_6,
#       order1  LIKE ala_file.ala01,
#       order2  LIKE ala_file.ala01,
#       order3  LIKE ala_file.ala01);
#      
## No.FUN-690028 ---end---
#   #no.6133(end)
   #No.FUN-770093 --end--
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r720_tm(0,0)
   ELSE
      CALL r720()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r720_w AT p_row,p_col
     WITH FORM "aap/42f/aapr720"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '761'
   LET tm.u    = 'Y'
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
 
      CONSTRUCT BY NAME tm.wc ON ala01,ala02,ala04,ala05,ala08,ala07,ala20
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
         CLOSE WINDOW r720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
            CALL cl_cmdask()    # Command execution
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr720'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr720','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr720',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r720()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r720_w
 
END FUNCTION
 
FUNCTION r720()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_order   ARRAY[5] OF LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
          l_alh     RECORD LIKE alh_file.*,
          a1        LIKE alh_file.alh12,
          a2        LIKE alh_file.alh13,
          a3        LIKE alh_file.alh14,
          sr        RECORD order1  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
                           order2  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
                           order3  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),  #No.FUN-550030
                           ala07   LIKE ala_file.ala07,
                           ala20   LIKE ala_file.ala20,
                           ala72   LIKE ala_file.ala72,
                           ala01   LIKE ala_file.ala01,
                           ala21   LIKE ala_file.ala21,
                           ala23   LIKE ala_file.ala23,
                           ala24   LIKE ala_file.ala24,
                           ala25   LIKE ala_file.ala25,
                           ala02   LIKE ala_file.ala02,
                           ala04   LIKE ala_file.ala04,
                           ala05   LIKE ala_file.ala05,
                           ala08   LIKE ala_file.ala08,
                           alaclos LIKE ala_file.alaclos,
                           amt1    LIKE ala_file.ala23,
                           amt2    LIKE ala_file.ala23,
                           amt3    LIKE ala_file.ala23,
                           alg02   LIKE alg_file.alg02,
                           gem02   LIKE gem_file.gem02
                    END RECORD
 
   CALL cl_del_data(l_table)                         #No.FUN-770093
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
   #End:FUN-980030
 
   #No.FUN-770093 --mark--
#   #no.6133   (針對幣別加總)
#   DELETE FROM curr_tmp;
#
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
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
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
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
#   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
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
#   #no.6133(end)
   #No.FUN-770093 --end--
 
   LET l_sql = "SELECT '','','', ",
               " ala07,ala20,ala72,ala01,ala21,ala23,ala24,ala25,",
               " ala02,ala04,ala05,ala08,alaclos,0,ala34,0,'',''",
               " FROM ala_file",
               " WHERE alafirm='Y'",
               "   AND ", tm.wc CLIPPED
   PREPARE r720_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r720_curs1 CURSOR FOR r720_prepare1
 
#   CALL cl_outnam('aapr720') RETURNING l_name    #No.FUN-770093
#   START REPORT r720_rep TO l_name               #No.FUN-770093
#
#   LET g_pageno = 0                              #No.FUN-770093
 
   FOREACH r720_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT alg02 INTO sr.alg02 FROM alg_file
       WHERE alg01 = sr.ala07
 
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.ala04
 
      DECLARE c2 CURSOR FOR SELECT * FROM alh_file
                             WHERE alh03=sr.ala01
                               AND alh00='1'
                               AND alhfirm='Y'
 
      LET a1 = 0
      LET a2 = 0
      LET a3 = 0
 
      FOREACH c2 INTO l_alh.*
         IF l_alh.alh75='1' THEN		# 若已改貸, 則以改貸為準
            SELECT alh76 INTO l_alh.alh76 FROM alh_file
             WHERE alh30=l_alh.alh01
               AND alh00='2'
               AND alhfirm='Y'
         END IF
         IF l_alh.alh76 > 0 THEN                # 若已還款, 則不列入統計
            LET a1 = a1 + l_alh.alh12
            LET a2 = a2 + l_alh.alh13
         ELSE
            LET a3 = a3 + l_alh.alh14
         END IF
      END FOREACH
 
      LET sr.amt1=(sr.ala23+sr.ala24) - a1
    # LET sr.amt2=(sr.ala23+sr.ala24) * sr.ala21/100 - a2
      LET sr.amt3=a3
 
      IF (sr.alaclos='Y' OR sr.amt1=0) AND sr.amt3=0 THEN
         CONTINUE FOREACH
      END IF
 
      #No.FUN-770093 --mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ala01
#                                       LET g_orderA[g_i]= g_x[10]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ala02
#                                       LET g_orderA[g_i]= g_x[11]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ala04
#                                       LET g_orderA[g_i]= g_x[12]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ala05
#                                       LET g_orderA[g_i]= g_x[13]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ala08 USING 'YYYYMMDD'
#                                       LET g_orderA[g_i]= g_x[14]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ala07
#                                       LET g_orderA[g_i]= g_x[15]
#              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.ala20
#                                       LET g_orderA[g_i]= g_x[16]
#              OTHERWISE LET l_order[g_i]  = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
#
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
#      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
#
#      OUTPUT TO REPORT r720_rep(sr.*)
      #No.FUN-770093 --end--
      #No.FUN-770093 --start--
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 
            FROM azi_file WHERE azi01 = sr.ala20
      EXECUTE insert_prep USING sr.ala07,sr.alg02,sr.ala04,sr.gem02,
                                sr.ala02,sr.ala20,sr.ala08,sr.ala72,
                                sr.ala01,sr.amt1,sr.amt2,sr.amt3,
                                sr.ala05,t_azi04,t_azi05
      #No.FUN-770093 --end--
   END FOREACH
 
#   FINISH REPORT r720_rep                         #No.FUN-770093
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-770093
   #No.FUN-770093 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ala01,ala02,ala04,ala05,ala08,ala07,ala20')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF 
   LET g_str=g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
             tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
             tm.u[2,2],";",tm.u[3,3]
   LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aapr720','aapr720',l_sql,g_str)
   #No.FUN-770093 --end--
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
#No.FUN-770093 --start-- mark
{REPORT r720_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD order1  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                           order2  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                           order3  LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                           ala07   LIKE ala_file.ala07,
                           ala20   LIKE ala_file.ala20,
                           ala72   LIKE ala_file.ala72,
                           ala01   LIKE ala_file.ala01,
                           ala21   LIKE ala_file.ala21,
                           ala23   LIKE ala_file.ala23,
                           ala24   LIKE ala_file.ala24,
                           ala25   LIKE ala_file.ala25,
                           ala02   LIKE ala_file.ala02,
                           ala04   LIKE ala_file.ala04,
                           ala05   LIKE ala_file.ala05,
                           ala08   LIKE ala_file.ala08,
                           alaclos LIKE ala_file.alaclos,
                           amt1    LIKE ala_file.ala23,
                           amt2    LIKE ala_file.ala23,
                           amt3    LIKE ala_file.ala23,
                           alg02   LIKE alg_file.alg02,
                           gem02   LIKE gem_file.gem02
                    END RECORD,
          sr1       RECORD
                       curr    LIKE ala_file.ala20,
                       amt1    LIKE ala_file.ala23,
                       amt2    LIKE ala_file.ala23,
                       amt3    LIKE ala_file.ala23,
                       amt4    LIKE ala_file.ala23
                    END RECORD,
      l_amt_1       LIKE alb_file.alb06,
      l_amt_2       LIKE alb_file.alb08,
      l_sum_1       LIKE alb_file.alb07,
      l_sum_2       LIKE alb_file.alb08,
      l_amt4        LIKE ala_file.ala23
DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.ala01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
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
         SELECT azi03,azi04,azi05
#          INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
           INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
           FROM azi_file
          WHERE azi01=sr.ala20
 
         PRINT COLUMN g_c[31],sr.ala07,
               COLUMN g_c[32],sr.alg02,
               COLUMN g_c[33],sr.ala04,
               COLUMN g_c[34],sr.gem02,
               COLUMN g_c[35],sr.ala02,
               COLUMN g_c[36],sr.ala20,
               COLUMN g_c[37],sr.ala08,
               COLUMN g_c[38],sr.ala72,
               COLUMN g_c[39],sr.ala01,
               COLUMN g_c[40],cl_numfor(sr.amt1,40,t_azi04),    #No.CHI-6A0004
               COLUMN g_c[41],cl_numfor(sr.amt2,41,t_azi04),    #No.CHI-6A0004
               COLUMN g_c[42],cl_numfor(sr.amt3,42,t_azi04),    #No.CHI-6A0004
               COLUMN g_c[43],cl_numfor(sr.amt1-sr.amt2-sr.amt3,43,t_azi04)   #No.CHI-6A0004
 
         #no.6133
         LET l_amt4 = sr.amt1-sr.amt2-sr.amt3
         INSERT INTO curr_tmp VALUES(sr.ala20,sr.amt1,sr.amt2,sr.amt3,l_amt4,
                                     sr.order1,sr.order2,sr.order3)
         #no.6133(end)
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT
            PRINT COLUMN g_c[37],g_orderA[1] CLIPPED;
            #no.6133
            FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#               SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
                SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                 WHERE azi01 = sr1.curr
                PRINT COLUMN g_c[38],sr1.curr CLIPPED,
                      COLUMN g_c[39],g_x[17] CLIPPED,
#NO.CHI-6A0004 --START
#                     COLUMN g_c[40],cl_numfor(sr1.amt1,40,g_azi05),
#                     COLUMN g_c[41],cl_numfor(sr1.amt2,41,g_azi05),
#                     COLUMN g_c[42],cl_numfor(sr1.amt3,42,g_azi05),
#                     COLUMN g_c[43],cl_numfor(sr1.amt4,43,g_azi05)
                      COLUMN g_c[40],cl_numfor(sr1.amt1,40,t_azi05),
                      COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05),
                      COLUMN g_c[42],cl_numfor(sr1.amt3,42,t_azi05),
                      COLUMN g_c[43],cl_numfor(sr1.amt4,43,t_azi05)
#NO.CHI-6A0004 --END
            END FOREACH
            #no.6133(end)
            PRINT
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT
            PRINT COLUMN g_c[37],g_orderA[2] CLIPPED;
            #no.6133
            FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#               SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
                SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                 WHERE azi01 = sr1.curr
                PRINT COLUMN g_c[38],sr1.curr CLIPPED,
                      COLUMN g_c[39],g_x[17] CLIPPED,
#NO.CHI-6A0004 --START
#                     COLUMN g_c[40],cl_numfor(sr1.amt1,40,g_azi05),
#                     COLUMN g_c[41],cl_numfor(sr1.amt2,41,g_azi05),
#                     COLUMN g_c[42],cl_numfor(sr1.amt3,42,g_azi05),
#                     COLUMN g_c[43],cl_numfor(sr1.amt4,43,g_azi05)
                      COLUMN g_c[40],cl_numfor(sr1.amt1,40,t_azi05),
                      COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05),
                      COLUMN g_c[42],cl_numfor(sr1.amt3,42,t_azi05),
                      COLUMN g_c[43],cl_numfor(sr1.amt4,43,t_azi05)
#NO.CHI-6A0004 --END
            END FOREACH
            #no.6133(end)
            PRINT
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT
            PRINT COLUMN g_c[37],g_orderA[3] CLIPPED;
            #no.6133
            FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#               SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
                SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
                 WHERE azi01 = sr1.curr
                PRINT COLUMN g_c[38],sr1.curr CLIPPED,
                      COLUMN g_c[39],g_x[17] CLIPPED,
#NO.CHI-6A0004 --START
#                     COLUMN g_c[40],cl_numfor(sr1.amt1,40,g_azi05),
#                     COLUMN g_c[41],cl_numfor(sr1.amt2,41,g_azi05),
#                     COLUMN g_c[42],cl_numfor(sr1.amt3,42,g_azi05),
#                     COLUMN g_c[43],cl_numfor(sr1.amt4,43,g_azi05)
                      COLUMN g_c[40],cl_numfor(sr1.amt1,40,t_azi05),
                      COLUMN g_c[41],cl_numfor(sr1.amt2,41,t_azi05),
                      COLUMN g_c[42],cl_numfor(sr1.amt3,42,t_azi05),
                      COLUMN g_c[43],cl_numfor(sr1.amt4,43,t_azi05)
#NO.CHI-6A0004 --END
            END FOREACH
            #no.6133(end)
            PRINT
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'ala01,ala02,ala03,ala04,ala05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #   END IF
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
    #    PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[43],g_x[7] CLIPPED       #TQC-6A0086
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED       #TQC-6A0086
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
        #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[43],g_x[6] CLIPPED    #TQC-6A0086
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0086
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-770093 --end--
