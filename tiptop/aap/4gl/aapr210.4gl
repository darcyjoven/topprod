# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr210.4gl
# Descriptions...: 退貨折舊明細表
# Date & Author..: 93/11/15 By Fiona
# Modify.........: No.9523 04/07/07 Kammy 把l_apa58的判斷搬到 BEFORE GROUP
# Modify.........: No.FUN-4C0097 04/12/28 By Nicola 報表架構修改
#                                                   增加列印廠商名稱apa07、品名ima02、規格ima021、退貨單號+項次apb04a、採購單號+項次apb06a
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.MOD-640220 06/04/10 By Smapmin 退貨單號+項次應該抓取apb21+apb22
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.MOD-740486 07/04/27 By Smapmin 折讓性質增加扣款折讓
# Modify.........: No.TQC-740326 07/04/24 By dxfwo   排序第三欄位未有默認值
# Modify.........: No.FUN-7A0025 07/10/12 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.MOD-7A0150 07/10/25 By Smapmin 上線前的退回資料，並不會在aapt210 單身維謢那一張倉退單，
#                                                    所以串apb_file 應為OUTER 的寫法
# Modify.........: No.CHI-7B0042 07/11/28 By Smapmin 增加apa00='26'的列印條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 #wc       LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc       STRING,   #TQC-630166
                 s        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  
                 t        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
                 u        LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
                 h        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
                 more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
              END RECORD,
          m_fld    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
DEFINE    g_orderA ARRAY[3] OF  LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)
DEFINE   g_i       LIKE type_file.num5        #count/index for any purpose  #No.FUN-690028 SMALLINT
#DEFINE  l_time    LIKE type_file.chr8        #No.FUN-6A0055
DEFINE   g_str     STRING                     #No.FUN-7A0025
DEFINE   g_sql     STRING                     #No.FUN-7A0025
DEFINE   l_table   STRING                     #No.FUN-7A0025
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #No.FUN-7A0025 --start--
   LET g_sql="apa01.apa_file.apa01,apa02.apa_file.apa02,apa06.apa_file.apa06,",
             "apa07.apa_file.apa07,apa58.apa_file.apa58,apb11.apb_file.apb11,",
             "apb21a.type_file.chr21,apb06a.type_file.chr21,",
             "apb12.apb_file.apb12,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,apb10.apb_file.apb10,",
             "apa13.apa_file.apa13,apa15.apa_file.apa15,apa31.apa_file.apa31,",
             "apa32.apa_file.apa32,apa34.apa_file.apa34,azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('aapr210',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('inser_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7A0025 --end--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)   #TQC-610053
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.h  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr210_tm(0,0)
   ELSE
      CALL aapr210()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW aapr210_w AT p_row,p_col
     WITH FORM "aap/42f/aapr210"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
#  LET tm.s    = '12'                          
   LET tm.s    = '123'     #No.TQC-740326                        
   LET tm.u    = 'Y'
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
      WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON apa06,apa01,apa02,apa15,apa13,apa58
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
            ON ACTION locale
               LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT CONSTRUCT
 
            AFTER FIELD apa58
               LET m_fld = GET_FLDBUF(apa58)
 
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
            CLOSE WINDOW aapr210_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM
         END IF
 
         IF tm.wc != '1=1' THEN
            EXIT WHILE
         END IF
 
         CALL cl_err('',9046,0)
 
      END WHILE
 
      DISPLAY BY NAME tm.more         # Condition
 
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
         CLOSE WINDOW aapr210_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr210'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr210','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr210',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr210_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr210()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr210_w
 
END FUNCTION
 
FUNCTION aapr210()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql      STRING,          # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_order    ARRAY[5] OF LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
          sr  RECORD
                 order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 apa01 LIKE apa_file.apa01,   # 帳款編號
                 apa02 LIKE apa_file.apa02,   # 帳款日期
                 apa06 LIKE apa_file.apa06,   #付款廠商編號
                 apa07 LIKE apa_file.apa07,   #付款廠商簡稱
                 apa15 LIKE apa_file.apa15,   #稅別
                 apa13 LIKE apa_file.apa13,   #幣別
                 apb11 LIKE apb_file.apb11,   #原發票號碼
                 #-----MOD-640220---------
                 #apb04 LIKE apb_file.apb04,   #退貨單號
                 #apb05 LIKE apb_file.apb05,   #退貨單項次
                 apb21 LIKE apb_file.apb21,   #退貨單號
                 apb22 LIKE apb_file.apb22,   #退貨單項次
                 #-----END MOD-640220-----
                 apb06 LIKE apb_file.apb06,   #採購單號
                 apb07 LIKE apb_file.apb07,   #採購單項次
                 apb12 LIKE apb_file.apb12,   #品  名
                 apb10 LIKE apb_file.apb10,   #未稅金額
                 apa31 LIKE apa_file.apa31,   #未稅金額
                 apa32 LIKE apa_file.apa32,   #稅額
                 apa34 LIKE apa_file.apa34,   #合計金額
                 apa58 LIKE apa_file.apa58,   #性  質
                 azi03 LIKE azi_file.azi03,   #單位小數位數
                 azi04 LIKE azi_file.azi04,   #金額小數位數
                 azi05 LIKE azi_file.azi05,   #小計小數位數
                 ima02 LIKE ima_file.ima02,
                 ima021 LIKE ima_file.ima021,
                 #apb04a VARCHAR(21),     #MOD-640220
                 apb21a LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),     #MOD-640220
                 apb06a LIKE type_file.chr21        # No.FUN-690028 VARCHAR(21)
              END RECORD
 
   CALL cl_del_data(l_table)                       #No.FUN-7A0025
 
#  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
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
 
 
   LET l_sql = "SELECT '','','',",
               "  apa01, apa02, apa06, apa07, apa15, apa13, apb11,",
               #"  apb04, apb05, apb06, apb07, apb12, apb10, apa31,",   #MOD-640220
               "  apb21, apb22, apb06, apb07, apb12, apb10, apa31,",   #MOD-640220
               "  apa32, apa34,apa58,",
               "  azi03, azi04, azi05,'','','',''",
               #"  FROM apa_file, apb_file,",   #MOD-7A0150
               "  FROM apa_file LEFT OUTER JOIN apb_file ON apa_file.apa01 = apb_file.apb01",   #MOD-7A0150
               "  LEFT OUTER JOIN azi_file ON apa13 = azi01 ",
               #"  WHERE apa00 = '21' AND apa42='N' ",   #CHI-7B0042
               "  WHERE (apa00 = '21' OR apa00 = '26') AND apa42='N' ",   #CHI-7B0042
               "   AND apaacti = 'Y'",
               "   AND ",tm.wc
 
#  CASE m_fld
#     WHEN '1'  LET l_sql = l_sql CLIPPED, " AND apa58 = '1' "
#     WHEN '2'  LET l_sql = l_sql CLIPPED, " AND apa58 = '2' "
#     OTHERWISE EXIT CASE
#  END CASE
 
   IF tm.h='1' THEN
      LET l_sql = l_sql CLIPPED," AND apa41='Y' "
   END IF
 
   IF tm.h='2' THEN
      LET l_sql = l_sql CLIPPED," AND apa41='N' "
   END IF
 
   PREPARE aapr210_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapr210_curs1 CURSOR FOR aapr210_prepare1
 
#   CALL cl_outnam('aapr210') RETURNING l_name      #No.FUN-7A0025
#   START REPORT aapr210_rep TO l_name              #No.FUN-7A0025
#
#   LET g_pageno = 0                                #No.FUN-7A0025
 
   FOREACH aapr210_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT ima02,ima021 INTO sr.ima02,sr.ima021
        FROM ima_file
       WHERE ima01 = sr.apb12
 
      #LET sr.apb04a = sr.apb04,'-',sr.apb05 USING "&&&&"   #MOD-640220
      LET sr.apb21a = sr.apb21,'-',sr.apb22 USING "&&&&"   #MOD-640220
      LET sr.apb06a = sr.apb06,'-',sr.apb07 USING "&&&&"
 
      #No.FUN-7A0025 --mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa06
#                                       LET g_orderA[g_i]= g_x[16]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa01
#                                       LET g_orderA[g_i]= g_x[17]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
#                                       LET g_orderA[g_i]= g_x[18]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa15
#                                       LET g_orderA[g_i]= g_x[19]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa13
#                                       LET g_orderA[g_i]= g_x[20]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa58
#                                       LET g_orderA[g_i]= g_x[21]
#              OTHERWISE LET l_order[g_i] = '-'
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
#      OUTPUT TO REPORT aapr210_rep(sr.*)
      #No.FUN-7A0025 --end--
      #No.FUN-7A0025 --start--
      EXECUTE insert_prep USING sr.apa01,sr.apa02,sr.apa06,sr.apa07,sr.apa58,
                                sr.apb11,sr.apb21a,sr.apb06a,sr.apb12,
                                sr.ima02,sr.ima021,sr.apb10,sr.apa13,sr.apa15,
                                sr.apa31,sr.apa32,sr.apa34,sr.azi03,sr.azi04,
                                sr.azi05
      #No.FUN-7A0025 --end--
   END FOREACH
 
#   FINISH REPORT aapr210_rep                      #No.FUN-7A0025
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-7A0025
   #No.FUN-7A0025 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apa06,apa01,apa02,apa15,apa13,apa58')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
               tm.u[2,2],";",tm.u[3,3]
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aapr210','aapr210',l_sql,g_str)
   #No.FUN-7A0025 --end--
 # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
 
#No.FUN-7A0025 --start-- mark
{REPORT aapr210_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr  RECORD
                 order1 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 order2 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 order3 LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),
                 apa01 LIKE apa_file.apa01,   # 帳款編號
                 apa02 LIKE apa_file.apa02,   # 帳款日期
                 apa06 LIKE apa_file.apa06,   #付款廠商編號
                 apa07 LIKE apa_file.apa07,   #付款廠商簡稱
                 apa15 LIKE apa_file.apa15,   #稅別
                 apa13 LIKE apa_file.apa13,   #幣別
                 apb11 LIKE apb_file.apb11,   #原發票號碼
                 #-----MOD-640220---------
                 #apb04 LIKE apb_file.apb04,   #退貨單號
                 #apb05 LIKE apb_file.apb05,   #退貨單項次
                 apb21 LIKE apb_file.apb21,   #退貨單號
                 apb22 LIKE apb_file.apb22,   #退貨單項次
                 #-----END MOD-640220-----
                 apb06 LIKE apb_file.apb06,   #採購單號
                 apb07 LIKE apb_file.apb07,   #採購單項次
                 apb12 LIKE apb_file.apb12,   #品  名
                 apb10 LIKE apb_file.apb10,   #未稅金額
                 apa31 LIKE apa_file.apa31,   #未稅金額
                 apa32 LIKE apa_file.apa32,   #稅額
                 apa34 LIKE apa_file.apa34,   #合計金額
                 apa58 LIKE apa_file.apa58,   #性  質
                 azi03 LIKE azi_file.azi03,   #單位小數位數
                 azi04 LIKE azi_file.azi04,   #金額小數位數
                 azi05 LIKE azi_file.azi05,   #小計小數位數
                 ima02 LIKE ima_file.ima02,
                 ima021 LIKE ima_file.ima021,
                 #apb04a VARCHAR(21),   #MOD-640220
                 apb21a LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),   #MOD-640220
                 apb06a LIKE type_file.chr21        # No.FUN-690028 VARCHAR(21)
              END RECORD,
      #l_apa58       LIKE apa_file.apa58,   #MOD-740486
      l_apa58       VARCHAR(8),   #MOD-740486
      l_apa31_1     LIKE apa_file.apa31,
      l_apa31_2     LIKE apa_file.apa31,
      l_apa31_3     LIKE apa_file.apa31,
      l_apa32_1     LIKE apa_file.apa32,
      l_apa32_2     LIKE apa_file.apa32,
      l_apa32_3     LIKE apa_file.apa32,
      l_apa34_1     LIKE apa_file.apa34,
      l_apa34_2     LIKE apa_file.apa34,
      l_apa34_3     LIKE apa_file.apa34,
      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
#        PRINT                                  #TQC-6A0088
         PRINT g_x[43] CLIPPED,g_orderA[1] CLIPPED,            #TQC-6A0088                                                                     
                '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         LET l_apa31_1 = 0
         LET l_apa32_1 = 0
         LET l_apa34_1 = 0
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         LET l_apa31_2 = 0
         LET l_apa32_2 = 0
         LET l_apa34_2 = 0
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         LET l_apa31_3 = 0
         LET l_apa32_3 = 0
         LET l_apa34_3  = 0
         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.apa01
         #No.9523
         #-----MOD-740486---------
         #IF sr.apa58 = '1'  THEN
         #   LET l_apa58 = g_x[14]
         #ELSE
         #   LET l_apa58 = g_x[15]
         #END IF
         CASE sr.apa58
             WHEN '1'
                LET l_apa58 = g_x[14]
             WHEN '2'
                LET l_apa58 = g_x[15]
             WHEN '3'
                LET l_apa58 = g_x[22]
         END CASE
         #-----END MOD-740486-----
         #No.9523(end)
         PRINT COLUMN g_c[31],sr.apa01,
               COLUMN g_c[32],sr.apa02,
               COLUMN g_c[33],sr.apa06,
               COLUMN g_c[34],sr.apa07,
               COLUMN g_c[35],l_apa58 CLIPPED;
 
      ON EVERY ROW
         PRINT COLUMN g_c[36],sr.apb11,
               #COLUMN g_c[37],sr.apb04a,   #MOD-640220
               COLUMN g_c[37],sr.apb21a,   #MOD-640220
               COLUMN g_c[38],sr.apb06a,
               COLUMN g_c[39],sr.apb12,
               COLUMN g_c[40],sr.ima02,
               COLUMN g_c[41],sr.ima021,
               COLUMN g_c[42],cl_numfor(sr.apb10,42,sr.azi04)
 
      AFTER GROUP OF sr.apa01
         PRINT COLUMN g_c[36],g_x[9] CLIPPED,
               COLUMN g_c[37],g_x[10] CLIPPED,
               COLUMN g_c[38],cl_numfor(sr.apa31,42,sr.azi03),
               COLUMN g_c[39],g_x[11] CLIPPED,
               COLUMN g_c[40],cl_numfor(sr.apa32,42,sr.azi03),
               COLUMN g_c[41],g_x[12] CLIPPED,
               COLUMN g_c[42],cl_numfor(sr.apa34,42,sr.azi05)
         PRINT ''
         ###--->合計計算
         LET l_apa31_1 = l_apa31_1 + sr.apa31
         LET l_apa31_2 = l_apa31_2 + sr.apa31
         LET l_apa31_3 = l_apa31_3 + sr.apa31
         LET l_apa32_1 = l_apa32_1 + sr.apa32
         LET l_apa32_2 = l_apa32_2 + sr.apa32
         LET l_apa32_3 = l_apa32_3 + sr.apa32
         LET l_apa34_1 = l_apa34_1 + sr.apa34
         LET l_apa34_2 = l_apa34_2 + sr.apa34
         LET l_apa34_3 = l_apa34_3 + sr.apa34
 
      AFTER GROUP OF sr.order1
       IF tm.u[1,1] = 'Y' THEN
          PRINT COLUMN g_c[35],g_orderA[1] CLIPPED,
                COLUMN g_c[36],g_x[13] CLIPPED,
                COLUMN g_c[37],g_x[10] CLIPPED,
                COLUMN g_c[38],cl_numfor(l_apa31_1,42,sr.azi03),
                COLUMN g_c[39],g_x[11] CLIPPED,
                COLUMN g_c[40],cl_numfor(l_apa32_1,42,sr.azi03),
                COLUMN g_c[41],g_x[12] CLIPPED,
                COLUMN g_c[42],cl_numfor(l_apa34_1,42,sr.azi05)
          PRINT ''
       END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT COLUMN g_c[35],g_orderA[2] CLIPPED,
                  COLUMN g_c[36],g_x[13] CLIPPED,
                  COLUMN g_c[37],g_x[10] CLIPPED,
                  COLUMN g_c[38],cl_numfor(l_apa31_2,42,sr.azi03),
                  COLUMN g_c[39],g_x[11] CLIPPED,
                  COLUMN g_c[40],cl_numfor(l_apa32_2,42,sr.azi03),
                  COLUMN g_c[41],g_x[12] CLIPPED,
                  COLUMN g_c[42],cl_numfor(l_apa34_2,42,sr.azi05)
            PRINT ''
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT COLUMN g_c[35],g_orderA[1] CLIPPED,
                  COLUMN g_c[36],g_x[13] CLIPPED,
                  COLUMN g_c[37],g_x[10] CLIPPED,
                  COLUMN g_c[38],cl_numfor(l_apa31_3,42,sr.azi03),
                  COLUMN g_c[39],g_x[11] CLIPPED,
                  COLUMN g_c[40],cl_numfor(l_apa32_3,42,sr.azi03),
                  COLUMN g_c[41],g_x[12] CLIPPED,
                  COLUMN g_c[42],cl_numfor(l_apa34_3,42,sr.azi05)
            PRINT ''
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa01,apa02,apa07,apa15,apa13') RETURNING tm.wc
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
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[42],g_x[7] CLIPPED           #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED           #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[42],g_x[6] CLIPPED        #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED        #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-7A0025 --end--
