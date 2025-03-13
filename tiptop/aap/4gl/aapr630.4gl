# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapr630.4gl
# Descriptions...: 付款沖帳分錄底稿清單列印
# Date & Author..: 93/07/01  By  Roger
# Modify.........: 97/04/21 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: No.FUN-4C0097 05/01/04 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02、部門名稱gem02
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
#
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0172 06/12/27 By wujie 調整“接下頁/結束”位置
# Modify.........: No.FUN-730064 07/04/03 By mike  會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By hongmei 用年度取帳號 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.TQC-C90069 12/09/13 By lujh 程序中增加判斷,若apf00 = '11'則sql重寫
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc      STRING,   #TQC-630166
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)        #No.FUN-550030
DEFINE    tot DYNAMIC ARRAY OF RECORD
                 dc      LIKE npq_file.npq06,
                 actno   LIKE npq_file.npq03,
                 actname LIKE aag_file.aag02,
                 amt     LIKE npq_file.npq07
              END RECORD
DEFINE   ix,j   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE   g_bookno1 LIKE aza_file.aza81    #No.FUN-730064
DEFINE   g_bookno2 LIKE aza_file.aza82    #No.FUN-730064  
DEFINE   g_flag    LIKE type_file.chr1    #No.FUN-730064  
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
      CALL r630_tm(0,0)
   ELSE
      CALL r630()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r630_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r630_w AT p_row,p_col
     WITH FORM "aap/42f/aapr630"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
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
 
      CONSTRUCT BY NAME tm.wc ON apf00,apf01,apf02,apf04,apf05,apf06,apf44
 
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
         CLOSE WINDOW r630_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.h,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         CLOSE WINDOW r630_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr630'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr630','9031',1)
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
                        " '",tm.h CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr630',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r630_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r630()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r630_w
 
END FUNCTION
 
FUNCTION r630()
DEFINE l_name    LIKE type_file.chr20       # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8       # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql   STRING       # RDSQL STATEMENT   #TQC-630166
DEFINE l_chr     LIKE type_file.chr1        #No.FUN-690028 VARCHAR(1)
DEFINE l_apf00   LIKE apf_file.apf00        #TQC-C90069  add
DEFINE l_order   ARRAY[5] OF LIKE apf_file.apf01         # No.FUN-690028 VARCHAR(16)        #No.FUN-550030
DEFINE sr        RECORD order1 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                        order2 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                        order3 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN_550030
                        apf00  LIKE apf_file.apf00,
                        apf01  LIKE apf_file.apf01,
                        apf02  LIKE apf_file.apf02,
                        apf04  LIKE apf_file.apf04,
                        apf05  LIKE apf_file.apf05,
                        apf06  LIKE apf_file.apf06,
                        apf44  LIKE apf_file.apf44,
                        npq06  LIKE npq_file.npq06,
                        npq03  LIKE npq_file.npq03,
                        npq07  LIKE npq_file.npq07,
                        npq04  LIKE npq_file.npq04,
                        npq23  LIKE npq_file.npq23,
                        aag02  LIKE aag_file.aag02,
                        azi04  LIKE azi_file.azi04,
                        azi05  LIKE azi_file.azi05,
                        gen02  LIKE gen_file.gen02,
                        gem02  LIKE gem_file.gem02,
                        npp02  LIKE npp_file.npp02   # No.FUN-730064
                 END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
   #End:FUN-980030
 
   #TQC-C90069--add--str--
   LET l_sql = "SELECT apf00 ",
               " FROM apf_file ",
               " WHERE apf41 <> 'X' ",
               "   AND ", tm.wc CLIPPED
   PREPARE r630_pre1 FROM l_sql
   DECLARE r630_cus1 CURSOR FOR r630_pre1   
 
   FOREACH r630_cus1 INTO l_apf00
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF      
      IF l_apf00 = '11' THEN
         LET l_sql = "SELECT '','','',",
                     " apf00, apf01, apf02, apf04, apf05, apf06, apf44,",
                     " npq06, npq03, npq07, npq04, npq23,'',azi04,azi05,'','',npp02",  
                     " FROM apf_file ",      
                     " LEFT OUTER JOIN azi_file ON(azi01 = apf06) ,apa_file LEFT OUTER JOIN npp_file ON(apa01 = npp01 ) ",
                     " LEFT OUTER JOIN npq_file ON(apa01= npq01)",
                     "  WHERE apf41 <> 'X' ",
                     "   AND npp01 = npq01 ",
                     "   AND nppsys= 'AP'",
                     "   AND nppsys=npqsys AND npp00=npq00",
                     "   AND npp011=npq011",  
                     "   AND apa80 = apf01 ",
                     "   AND ", tm.wc CLIPPED
       ELSE
          LET l_sql = "SELECT '','','',",
                      "apf00, apf01, apf02, apf04, apf05, apf06, apf44,",
                      "npq06, npq03, npq07, npq04, npq23,'',azi04,azi05,'','',npp02",  
                      " FROM apf_file ",
                      " LEFT OUTER JOIN azi_file ON(azi01 = apf06) LEFT OUTER JOIN npp_file ON(apf01 = npp01) LEFT OUTER JOIN npq_file ON(apf01 = npq01)",     
                      "  WHERE apf41 <> 'X' ",
                      "   AND npp01 = npq01 ",
                      "   AND nppsys= 'AP'",
                      "   AND nppsys=npqsys AND npp00=npq00",
                      "   AND npp011=npq011",
                      "   AND ", tm.wc CLIPPED
       END IF 
   END FOREACH
   #TQC-C90069--add--end--
   #TQC-C90069--mark--str--
   #LET l_sql = "SELECT '','','',",
   #            "apf00, apf01, apf02, apf04, apf05, apf06, apf44,",
   #            "npq06, npq03, npq07, npq04, npq23,'',azi04,azi05,'','',npp02",  #No.FUN-730064
   #            " FROM apf_file ",
   #            " LEFT OUTER JOIN azi_file ON(azi01 = apf06) LEFT OUTER JOIN npp_file ON(apf01 = npp01) LEFT OUTER JOIN npq_file ON(apf01 = npq01)",        #No.FUN-730064 
   #            "  WHERE apf41 <> 'X' ",
   #            "   AND npp01 = npq01 ",
   #            "   AND nppsys= 'AP'",
   #            "   AND nppsys=npqsys AND npp00=npq00",
   #            "   AND npp011=npq011",
   #            "   AND ", tm.wc CLIPPED
   #TQC-C90069--mark--end--
   IF tm.h='1' THEN
      LET l_sql=l_sql CLIPPED," AND apf41='Y' "
   END IF
 
   IF tm.h='2' THEN
      LET l_sql=l_sql CLIPPED," AND apf41='N' "
   END IF
 
   PREPARE r630_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r630_curs1 CURSOR FOR r630_prepare1
 
   CALL cl_outnam('aapr630') RETURNING l_name
   START REPORT r630_rep TO l_name
 
   LET g_pageno = 0
   LET ix       = 0
 
   FOR j = 1 TO 20
      LET tot[j].dc    = NULL
      LET tot[j].actno = NULL
      LET tot[j].actname = NULL
      LET tot[j].amt   = 0
   END FOR
 
   FOREACH r630_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-730064   --BEGIN---
      CALL s_get_bookno(YEAR(sr.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag='1'   THEN   #抓不到帳套
         CALL cl_err(sr.npp02,'aoo-081',1)
      END IF
      SELECT aag02 INTO sr.aag02 FROM aag_file WHERE aag00 = g_bookno1 AND aag01 = sr.npq03   
      #No.FUN-730064   --END---
 
      SELECT gen02 INTO sr.gen02 FROM gen_file
       WHERE gen01 = sr.apf04
 
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.apf05
 
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apf00
                                       LET g_orderA[g_i]= g_x[14]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apf01
                                       LET g_orderA[g_i]= g_x[15]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apf02 USING 'YYYYMMDD'
                                       LET g_orderA[g_i]= g_x[16]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apf04
                                       LET g_orderA[g_i]= g_x[17]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apf05
                                       LET g_orderA[g_i]= g_x[18]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apf06
                                       LET g_orderA[g_i]= g_x[19]
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apf44
                                       LET g_orderA[g_i]= g_x[20]
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
 
      OUTPUT TO REPORT r630_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT r630_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
 
REPORT r630_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE sr        RECORD order1 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                        order2 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                        order3 LIKE apf_file.apf01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
                        apf00  LIKE apf_file.apf00,
                        apf01  LIKE apf_file.apf01,
                        apf02  LIKE apf_file.apf02,
                        apf04  LIKE apf_file.apf04,
                        apf05  LIKE apf_file.apf05,
                        apf06  LIKE apf_file.apf06,
                        apf44  LIKE apf_file.apf44,
                        npq06  LIKE npq_file.npq06,
                        npq03  LIKE npq_file.npq03,
                        npq07  LIKE npq_file.npq07,
                        npq04  LIKE npq_file.npq04,
                        npq23  LIKE npq_file.npq23,
                        aag02  LIKE aag_file.aag02,
                        azi04  LIKE azi_file.azi04,
                        azi05  LIKE azi_file.azi05,
                        gen02  LIKE gen_file.gen02,
                        gem02  LIKE gem_file.gem02,
                        npp02  LIKE npp_file.npp02    #No.FUN-730064
                 END RECORD
DEFINE l_amt_1   LIKE npq_file.npq07
DEFINE l_amt_2   LIKE npq_file.npq07
DEFINE l_buf     ARRAY[1000] OF RECORD
                    npq03  LIKE npq_file.npq03,
                    aag02  LIKE aag_file.aag02,
                    npq06  LIKE npq_file.npq06,
                    npq07  LIKE npq_file.npq07,
                    npq04  LIKE npq_file.npq04,
                    npq23  LIKE npq_file.npq23
                 END RECORD
DEFINE i         LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_chr     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_head1    STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.apf01,sr.npq06
 
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
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
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
 
      BEFORE GROUP OF sr.apf01
         CALL l_buf.clear()
         LET i = 0
 
      ON EVERY ROW
         LET i = i + 1
         LET l_buf[i].npq03 = sr.npq03
         LET l_buf[i].aag02 = sr.aag02
         LET l_buf[i].npq06 = sr.npq06
         LET l_buf[i].npq07 = sr.npq07
         LET l_buf[i].npq04 = sr.npq04
         LET l_buf[i].npq23 = sr.npq23
         CALL s_get_bookno(YEAR(sr.apf02))  RETURNING  g_flag,g_bookno1,g_bookno2    #No.FUN-730064 #No.TQC-740042
         FOR j = 1 TO 20
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
 
      AFTER GROUP OF sr.apf01
         PRINT COLUMN g_c[31],sr.apf00,
               COLUMN g_c[32],sr.apf01,
               COLUMN g_c[33],sr.apf44,
               COLUMN g_c[34],sr.apf02,
               COLUMN g_c[35],sr.apf04,
               COLUMN g_c[36],sr.gen02,
               COLUMN g_c[37],sr.apf05,
               COLUMN g_c[38],sr.gem02,
               COLUMN g_c[39],sr.apf06,
               COLUMN g_c[40],l_buf[1].npq03,
               COLUMN g_c[41],l_buf[1].aag02,
               COLUMN g_c[42],l_buf[1].npq06,
               COLUMN g_c[43],cl_numfor(l_buf[1].npq07,43,sr.azi04),
               COLUMN g_c[44],l_buf[1].npq04,
               COLUMN g_c[45],l_buf[1].npq23
 
         FOR i = 2 TO 1000
            IF l_buf[i].npq03 IS NOT NULL THEN
               PRINT COLUMN g_c[40],l_buf[i].npq03,
                     COLUMN g_c[41],l_buf[i].aag02,
                     COLUMN g_c[42],l_buf[i].npq06,
                     COLUMN g_c[43],cl_numfor(l_buf[i].npq07,43,sr.azi04),
                     COLUMN g_c[44],l_buf[i].npq04,
                     COLUMN g_c[45],l_buf[i].npq23
            END IF
         END FOR
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[40],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[40],g_orderA[1] CLIPPED,
                  COLUMN g_c[41],g_x[11] CLIPPED,
                  COLUMN g_c[42],'1',
                  COLUMN g_c[43],cl_numfor(l_amt_1,43,sr.azi05)
            PRINT COLUMN g_c[42],'2',
                  COLUMN g_c[43],cl_numfor(l_amt_2,43,sr.azi05)
            PRINT ''
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[40],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[40],g_orderA[2] CLIPPED,
                  COLUMN g_c[41],g_x[10] CLIPPED,
                  COLUMN g_c[42],'1',
                  COLUMN g_c[43],cl_numfor(l_amt_1,43,sr.azi05)
            PRINT COLUMN g_c[42],'2',
                  COLUMN g_c[43],cl_numfor(l_amt_2,43,sr.azi05)
            PRINT ''
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            LET l_amt_1 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '1'
            LET l_amt_2 = GROUP SUM(sr.npq07) WHERE sr.npq06 = '2'
            PRINT COLUMN g_c[40],g_dash2[105,g_len-30]
            PRINT COLUMN g_c[40],g_orderA[3] CLIPPED,
                  COLUMN g_c[41],g_x[9] CLIPPED,
                  COLUMN g_c[42],'1',
                  COLUMN g_c[43],cl_numfor(l_amt_1,43,sr.azi05)
            PRINT COLUMN g_c[42],'2',
                  COLUMN g_c[43],cl_numfor(l_amt_2,43,sr.azi05)
            PRINT ''
         END IF
 
      ON LAST ROW
         LET l_amt_1 = SUM(sr.npq07) WHERE sr.npq06 = '1'
         LET l_amt_2 = SUM(sr.npq07) WHERE sr.npq06 = '2'
 
         FOR i = 1 TO 20
             IF tot[i].actno IS NULL THEN
                CONTINUE FOR
             END IF
             CALL s_aapact('2',g_bookno1,tot[i].actno) RETURNING tot[i].actname   #No:8727
         END FOR
 
         PRINT COLUMN g_c[40],g_dash2[105,g_len-30]
         PRINT COLUMN g_c[37],g_x[12] CLIPPED,
               COLUMN g_c[38],tot[1].dc,
               COLUMN g_c[39],tot[1].actno CLIPPED,
               COLUMN g_c[40],tot[1].actname CLIPPED,
               COLUMN g_c[41],cl_numfor(tot[1].amt,43,sr.azi05),
               COLUMN g_c[42],'1',
               COLUMN g_c[43],cl_numfor(l_amt_1,43,sr.azi05)
         PRINT COLUMN g_c[38],tot[2].dc,
               COLUMN g_c[39],tot[2].actno CLIPPED,
               COLUMN g_c[40],tot[2].actname CLIPPED,
               COLUMN g_c[41],cl_numfor(tot[2].amt,43,sr.azi05),
               COLUMN g_c[42],'2',
               COLUMN g_c[43],cl_numfor(l_amt_2,43,sr.azi05)
 
         FOR i = 3 TO 20
            IF tot[i].dc IS NULL THEN
               CONTINUE FOR
            END IF
            PRINT COLUMN g_c[38],tot[i].dc,
                  COLUMN g_c[39],tot[i].actno CLIPPED,
                  COLUMN g_c[40],tot[i].actname CLIPPED,
                  COLUMN g_c[41],cl_numfor(tot[i].amt,43,sr.azi05)
         END FOR
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apf01,apf02,apf03,apf04,apf05') RETURNING tm.wc
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
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED     #No.TQC-6C0172
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[45],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-6C0172
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
