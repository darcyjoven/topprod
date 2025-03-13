# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr321.4gl
# Descriptions...: 付款清單列印作業
# Date & Author..: 93/01/13  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 04/12/29 By Nicola 報表架構修改
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-670133 06/07/31 By Smapmin 修改小計問題
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 列印順序寫錯 
# Modify.........: No.MOD-780274 07/09/03 By Smapmin 直接付款應抓取16類
# Modify.........: No.FUN-7A0025 07/10/16 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-B20014 11/02/12 By lilingyu SQL增加apf00<>'32' or apf00<>'36'的條件
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 #wc       LIKE type_file.chr1000,     # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc       STRING,      # Where condition   #TQC-630166
                 a        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
                 s        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Order by sequence
                 t        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Eject sw
                 u        LIKE type_file.chr2,          # No.FUN-690028 VARCHAR(2),        # Group total sw
                 g        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),        # Group total sw
                 more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
#         g_orderA    ARRAY[2] OF VARCHAR(10), #排序名稱
          g_orderA    ARRAY[2] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(16), #排序名稱
                                            #No.FUN-550030
          g_amt_1f,g_amt_1      LIKE apf_file.apf08f,
          g_amt_2f,g_amt_2      LIKE apf_file.apf09f,
          g_amt_3f,g_amt_3      LIKE aph_file.aph05f,
          g_amt_4f,g_amt_4      LIKE aph_file.aph05f,
          g_amt_5f,g_amt_5      LIKE aph_file.aph05f,
          g_amt_6f,g_amt_6      LIKE aph_file.aph05f
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   l_table         STRING  #No.FUN-7A0025
DEFINE   g_str           STRING  #No.FUN-7A0025
DEFINE   g_sql           STRING  #No.FUN-7A0025
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047
 
   #No.FUN-7A0025  --Begin
   LET g_sql = " order1.gen_file.gen02,",
               " order2.gen_file.gen02,",
               " apf44.apf_file.apf44,",
               " apf02.apf_file.apf02,",
               " apf01.apf_file.apf01,",
               " apf03.apf_file.apf03,",
               " apf12.apf_file.apf12,",
               " apf06.apf_file.apf06,",
               " gen02.gen_file.gen02,",
               " apf08f.apf_file.apf08,",
               " apf09f.apf_file.apf09,",
               " apf08.apf_file.apf08,",
               " apf09.apf_file.apf09,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " aph05_1f.aph_file.aph05,",
               " aph05_2f.aph_file.aph05,",
               " aph05_3f.aph_file.aph05,",
               " aph05_4f.aph_file.aph05,",
               " aph05_1.aph_file.aph05,",
               " aph05_2.aph_file.aph05,",
               " aph05_3.aph_file.aph05,",
               " aph05_4.aph_file.aph05,",
               " aza17.aza_file.aza17 " 
   LET l_table = cl_prt_temptable('aapr321',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7A0025  --End
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.g  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE r321_tmp
   CALL r321_create_tmp()    #no.5197
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r321_tm(0,0)
   ELSE
      CALL r321()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r321_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW r321_w AT p_row,p_col
     WITH FORM "aap/42f/aapr321"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.s    = '12'
   LET tm.g    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf44,apf01,apf02,apf03,apf06,apf04
 
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
         CLOSE WINDOW r321_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a = '3'
      LET tm.g = '3'
 
      INPUT BY NAME tm.a,tm.g,tm2.s1,tm2.s2,tm2.t1,tm2.t2,
                    tm2.u1,tm2.u2,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123]' OR cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[123]" OR cl_null(tm.g) THEN
               NEXT FIELD g
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
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
 
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
         CLOSE WINDOW r321_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr321'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr321','9031',1)
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
                        " '",tm.a CLIPPED,"'",   #TQC-610053
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",tm.g CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr321',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r321_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r321()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r321_w
 
END FUNCTION
 
 
FUNCTION r321()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql      STRING,      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#         l_order   ARRAY[2] OF VARCHAR(16),            #No.FUN-550030
          l_order   ARRAY[2] OF LIKE gen_file.gen02,      # No.FUN-690028 VARCHAR(30),            #No.FUN-560011
#         sr        RECORD order1 VARCHAR(16),          #No.FUN-550030
#                          order2 VARCHAR(16),          #No.FUN-550030
          sr        RECORD order1 LIKE gen_file.gen02,      # No.FUN-690028 VARCHAR(30),          #No.FUN-560011
                           order2 LIKE gen_file.gen02,      # No.FUN-690028 VARCHAR(30),          #No.FUN-560011
                           apf44 LIKE apf_file.apf44, #付款單單頭檔
                           apf02 LIKE apf_file.apf02,
                           apf01 LIKE apf_file.apf01,
                           apf03 LIKE apf_file.apf03,
                           apf12 LIKE apf_file.apf12,
                           apf06 LIKE apf_file.apf06,
                           gen02 LIKE gen_file.gen02,   #MOD-670133
                           apf08f LIKE apf_file.apf08,
                           apf09f LIKE apf_file.apf09,
                           apf08 LIKE apf_file.apf08,
                           apf09 LIKE apf_file.apf09,
                           azi03 LIKE azi_file.azi03,
                           azi04 LIKE azi_file.azi04,
                           azi05 LIKE azi_file.azi05,
                           aph05_1f LIKE aph_file.aph05,#5197 原幣
                           aph05_2f LIKE aph_file.aph05,
                           aph05_3f LIKE aph_file.aph05,
                           aph05_4f LIKE aph_file.aph05,
                           aph05_1 LIKE aph_file.aph05, #     本幣
                           aph05_2 LIKE aph_file.aph05,
                           aph05_3 LIKE aph_file.aph05,
                           aph05_4 LIKE aph_file.aph05,
                           aza17   LIKE aza_file.aza17
                    END RECORD
 
   #No.FUN-7A0025  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #DELETE FROM r321_tmp
   #No.FUN-7A0025  --End
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #No.FUN-7A0025  --Begin
   ##bugno:5197................................................................
   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
   #            " FROM r321_tmp WHERE order1 = ? ",
   #            " GROUP BY curr ORDER BY curr"
   #PREPARE r321tmp_pre1 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre1:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r321_tmpcs1 CURSOR FOR r321tmp_pre1
 
   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
   #            #" FROM r321_tmp WHERE order2 = ? ",   #MOD-670133
   #            " FROM r321_tmp WHERE order1 = ? AND order2 = ? ",   #MOD-670133
   #            " GROUP BY curr ORDER BY curr"
   #PREPARE r321tmp_pre2 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre2:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r321_tmpcs2 CURSOR FOR r321tmp_pre2
 
   #LET l_sql = "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
   #            " FROM r321_tmp ",
   #            " GROUP BY curr ORDER BY curr"
   #PREPARE r321tmp_pre4 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre4:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r321_tmpcs4 CURSOR FOR r321tmp_pre4
   ##bug end.................................................................
   #No.FUN-7A0025  --End  
 
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
 
 
   LET l_sql = "SELECT '','',",
               #" apf44, apf02, apf01, apf03, apf12, apf06,",   #MOD-670133
               " apf44, apf02, apf01, apf03, apf12, apf06, gen02,",   #MOD-670133
               " apf08f, apf09f, apf08, apf09, azi03, azi04, azi05 ,''",
               " FROM apf_file,",
               #" OUTER azi_file",   #MOD-670133
               " OUTER azi_file,OUTER gen_file",   #MOD-670133
               " WHERE ",
               " azi_file.azi01 = apf_file.apf06 ",  #幣別
               " AND gen_file.gen01 = apf_file.apf04 ",   #MOD-670133
               " AND apf41 <> 'X' ",
#              " AND apf00 <> '11' ",   #MOD-780274    #FUN-B20014 
               " AND (apf00 <> '11' OR apf00 <> '32' OR apf00 <>'36')",    #FUN-B20014
               " AND ", tm.wc CLIPPED
 
   CASE
      WHEN tm.a = '1'
         #LET l_sql = l_sql CLIPPED, " AND apf00 ='11' "   #MOD-780274
         LET l_sql = l_sql CLIPPED, " AND apf00 ='16' "   #MOD-780274
      WHEN tm.a = '2'
         LET l_sql = l_sql CLIPPED, " AND apf00 ='33' "
   END CASE
 
   IF tm.a <> '1' THEN
      CASE
         WHEN tm.g = '1'
            LET l_sql = l_sql CLIPPED, " AND apf41 ='Y'  "
         WHEN tm.g = '2'
            LET l_sql = l_sql CLIPPED, " AND apf41 ='N'  "
      END CASE
   END IF
 
   PREPARE r321_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r321_curs1 CURSOR FOR r321_prepare1
 
   #No.FUN-7A0025  --Begin
   #CALL cl_outnam('aapr321') RETURNING l_name
   #START REPORT r321_rep TO l_name
   #No.FUN-7A0025  --End  
 
 
   #NO:8234
#No.CHI-6A0004--------Begin-------
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#   WHERE azi01 = g_aza.aza17
#No.CHI-6A0004-------End---------
   LET g_pageno = 0
   LET g_amt_1f= 0  LET g_amt_1 = 0
   LET g_amt_2f= 0  LET g_amt_2 = 0
   LET g_amt_3f= 0  LET g_amt_3 = 0
   LET g_amt_4f= 0  LET g_amt_4 = 0
   LET g_amt_5f= 0  LET g_amt_5 = 0
   LET g_amt_6f= 0  LET g_amt_6 = 0
 
   FOREACH r321_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.apf06 != g_aza.aza17 THEN
         LET sr.aza17 = g_aza.aza17
      ELSE
         LET sr.aza17=''
      END IF
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
      IF cl_null(sr.apf08f) THEN LET sr.apf08f = 0 END IF
      IF cl_null(sr.apf09f) THEN LET sr.apf09f = 0 END IF
      IF cl_null(sr.apf08) THEN LET sr.apf08 = 0 END IF
      IF cl_null(sr.apf09) THEN LET sr.apf09 = 0 END IF
 
      SELECT sum(aph05f),sum(aph05) INTO sr.aph05_1f,sr.aph05_1
        FROM aph_file WHERE aph01 = sr.apf01 AND aph03 = '1' # 1.支票類
      IF cl_null(sr.aph05_1) THEN LET sr.aph05_1 = 0 LET sr.aph05_1f = 0 END IF
 
      SELECT sum(aph05f),sum(aph05) INTO sr.aph05_2f,sr.aph05_2
        FROM aph_file WHERE aph01 = sr.apf01 AND aph03 = '2' # 2.現金類
      IF cl_null(sr.aph05_2) THEN LET sr.aph05_2 = 0 LET sr.aph05_2f = 0 END IF
 
      SELECT sum(aph05f),sum(aph05) INTO sr.aph05_3f,sr.aph05_3
        FROM aph_file WHERE aph01 = sr.apf01 AND aph03 NOT IN ('1','2','6','7','8','9')
      IF cl_null(sr.aph05_3) THEN LET sr.aph05_3 = 0 LET sr.aph05_3f = 0 END IF
 
      SELECT sum(aph05f),sum(aph05) INTO sr.aph05_4f,sr.aph05_4
        FROM aph_file WHERE aph01 = sr.apf01 AND aph03 IN ('6','7','8','9')
      IF cl_null(sr.aph05_4) THEN LET sr.aph05_4 = 0 LET sr.aph05_4f = 0 END IF
 
      #No.FUN-7A0025  --Begin
      #FOR g_i = 1 TO 2
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apf44
      #                                 LET g_orderA[g_i]= g_x[10]
      #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apf01
      #                                 LET g_orderA[g_i]= g_x[11]
      #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apf02 USING 'YYYYMMDD'
      #                                 LET g_orderA[g_i]= g_x[12]
      #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apf03,sr.apf12
      #                                 LET g_orderA[g_i]= g_x[13]
      #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apf06
      #                                 LET g_orderA[g_i]= g_x[14]
      #        #-----MOD-670133---------
      #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gen02
      #                                 LET g_orderA[g_i] = g_x[20]
      #        #-----END MOD-670133-----
      #        OTHERWISE LET l_order[g_i]  = '-'
      #                  LET g_orderA[g_i] = ' '    #清為空白
      #   END CASE
      #END FOR
 
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      #IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
 
      #INSERT INTO r321_tmp          #no.5197
      #     VALUES(sr.apf06,sr.apf08f,sr.aph05_1f,sr.aph05_2f,
      #            sr.aph05_3f,sr.aph05_4f,sr.order1,sr.order2)
 
      # OUTPUT TO REPORT r321_rep(sr.*)
      EXECUTE insert_prep USING sr.*
      #No.FUN-7A0025  --End  
 
   END FOREACH
 
   #No.FUN-7A0025  --Begin
   #FINISH REPORT r321_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apf44,apf01,apf02,apf03,apf06,apf04')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u,";",
               g_azi04,";",g_azi05
   CALL cl_prt_cs3('aapr321','aapr321',g_sql,g_str)
   #No.FUN-7A0025  --End  
 # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
 
#No.FUN-7A0025  --Begin
#REPORT r321_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          l_curr       LIKE apf_file.apf06,
#          sr           RECORD order1 LIKE gen_file.gen02,      # No.FUN-690028 VARCHAR(30),           #FUN-560011
#                              order2 LIKE gen_file.gen02,      # No.FUN-690028 VARCHAR(30),           #FUN-560011
#                              apf44 LIKE apf_file.apf44, #付款單單頭檔
#                              apf02 LIKE apf_file.apf02,
#                              apf01 LIKE apf_file.apf01,
#                              apf03 LIKE apf_file.apf03,
#                              apf12 LIKE apf_file.apf12,
#                              apf06 LIKE apf_file.apf06,
#                              gen02 LIKE gen_file.gen02,   #MOD-670133
#                              apf08f LIKE apf_file.apf08,
#                              apf09f LIKE apf_file.apf09,
#                              apf08 LIKE apf_file.apf08,
#                              apf09 LIKE apf_file.apf09,
#                              azi03 LIKE azi_file.azi03,
#                              azi04 LIKE azi_file.azi04,
#                              azi05 LIKE azi_file.azi05,
#                              aph05_1f LIKE aph_file.aph05,#5197 原幣
#                              aph05_2f LIKE aph_file.aph05,
#                              aph05_3f LIKE aph_file.aph05,
#                              aph05_4f LIKE aph_file.aph05,
#                              aph05_1 LIKE aph_file.aph05, #     本幣
#                              aph05_2 LIKE aph_file.aph05,
#                              aph05_3 LIKE aph_file.aph05,
#                              aph05_4 LIKE aph_file.aph05,
#                              aza17   LIKE aza_file.aza17
#                       END RECORD,
#      m_amt_1f,m_amt_1      LIKE apf_file.apf08f,
#      m_amt_2f,m_amt_2      LIKE apf_file.apf09f,
#      m_amt_3f,m_amt_3      LIKE aph_file.aph05f,
#      m_amt_4f,m_amt_4      LIKE aph_file.aph05f,
#      m_amt_5f,m_amt_5      LIKE aph_file.aph05f,
#      m_amt_6f,m_amt_6      LIKE aph_file.aph05f,
#      l_amt_1f,l_amt_1      LIKE apf_file.apf08f,
#      l_amt_2f,l_amt_2      LIKE apf_file.apf09f,
#      l_amt_3f,l_amt_3      LIKE aph_file.aph05f,
#      l_amt_4f,l_amt_4      LIKE aph_file.aph05f,
#      l_amt_5f,l_amt_5      LIKE aph_file.aph05f,
#      l_amt_6f,l_amt_6      LIKE aph_file.aph05f,
##      l_azi05      LIKE azi_file.azi05,     #NO:8234   #No.CHI-6A0004
#      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#   DEFINE g_head1   STRING
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   ORDER BY sr.order1,sr.order2,sr.apf01
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
# #       LET g_head1 = g_x[11] CLIPPED,g_orderA[1] CLIPPED,        #TQC-6A0088
#         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,         #TQC-6A0088
#                       '-',g_orderA[2] CLIPPED
#         PRINT g_head1
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#               #g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]   #MOD-670133
#               g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]   #MOD-670133
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
#      BEFORE GROUP OF sr.order1
#         IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#         LET l_amt_1f=0 LET l_amt_1 =0
#         LET l_amt_2f=0 LET l_amt_2 =0
#         LET l_amt_3f=0 LET l_amt_3 =0
#         LET l_amt_4f=0 LET l_amt_4 =0
#         LET l_amt_5f=0 LET l_amt_5 =0
#         LET l_amt_6f=0 LET l_amt_6 =0
# 
#      BEFORE GROUP OF sr.order2
#         IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#         LET m_amt_1f=0 LET m_amt_1 =0
#         LET m_amt_2f=0 LET m_amt_2 =0
#         LET m_amt_3f=0 LET m_amt_3 =0
#         LET m_amt_4f=0 LET m_amt_4 =0
#         LET m_amt_5f=0 LET m_amt_5 =0
#         LET m_amt_6f=0 LET m_amt_6 =0
# 
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.apf44,
#               COLUMN g_c[32],sr.apf01,
#               COLUMN g_c[33],sr.apf02,
#               COLUMN g_c[34],sr.apf03,
#               COLUMN g_c[35],sr.apf12,
#               COLUMN g_c[36],sr.apf06,
#               COLUMN g_c[48],sr.gen02,   #MOD-670133
#               COLUMN g_c[37],sr.aza17,
#               COLUMN g_c[38],cl_numfor(sr.apf08f,38,sr.azi04),
#               COLUMN g_c[39],cl_numfor(sr.apf08,39,g_azi04),
#               COLUMN g_c[40],cl_numfor(sr.aph05_1f,40,sr.azi04),  # 支票付款
#               COLUMN g_c[41],cl_numfor(sr.aph05_1,41,g_azi04),    # 支票付款
#               COLUMN g_c[42],cl_numfor(sr.aph05_2f,42,sr.azi04),  # 現金付款
#               COLUMN g_c[43],cl_numfor(sr.aph05_2,43,g_azi04),    # 現金付款
#               COLUMN g_c[44],cl_numfor(sr.aph05_3f,44,sr.azi04),  # 其他付款
#               COLUMN g_c[45],cl_numfor(sr.aph05_3,45,g_azi04),    # 其他付款
#               COLUMN g_c[46],cl_numfor(sr.aph05_4f,46,sr.azi04),  # 沖帳付款
#               COLUMN g_c[47],cl_numfor(sr.aph05_4,47,g_azi04)     # 沖帳付款
# 
#      AFTER GROUP OF sr.order1
#         IF tm.u[1,1] = 'Y' THEN
#            PRINT COLUMN g_c[35],g_dash2[1,g_w[35]+g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+g_w[47]+12]
#            FOREACH r321_tmpcs1 USING sr.order1
#               INTO l_curr,l_amt_1,l_amt_3,l_amt_4,l_amt_5,l_amt_6
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach1',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#
#               SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = l_curr    #No.CHI-6A0004
#
#               PRINT COLUMN g_c[35],l_curr,
#                     COLUMN g_c[36],g_orderA[1] CLIPPED,
#                     COLUMN g_c[37],g_x[16] CLIPPED,
#                     COLUMN g_c[39],cl_numfor(l_amt_1,39,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[41],cl_numfor(l_amt_3,41,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[43],cl_numfor(l_amt_4,43,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[45],cl_numfor(l_amt_5,45,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[47],cl_numfor(l_amt_6,47,t_azi05)   #No.CHI-6A0004
#            END FOREACH
#
#            PRINT COLUMN g_c[35],g_x[18] CLIPPED,
#                  COLUMN g_c[36],g_orderA[1] CLIPPED,
#                  COLUMN g_c[37],g_x[16] CLIPPED,
#                  COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apf08),39,g_azi05),
#                  COLUMN g_c[41],cl_numfor(GROUP SUM(sr.aph05_1),41,g_azi05), # 支票付款
#                  COLUMN g_c[43],cl_numfor(GROUP SUM(sr.aph05_2),43,g_azi05), # 現金付款
#                  COLUMN g_c[45],cl_numfor(GROUP SUM(sr.aph05_3),45,g_azi05), # 其他付款
#                  COLUMN g_c[47],cl_numfor(GROUP SUM(sr.aph05_4),47,g_azi05)  # 沖帳付款
#
#            PRINT ''
#         END IF
# 
#      AFTER GROUP OF sr.order2
#         IF tm.u[2,2] = 'Y' THEN
#            #FOREACH r321_tmpcs2 USING sr.order2   #MOD-670133
#            FOREACH r321_tmpcs2 USING sr.order1,sr.order2   #MOD-670133
#               INTO l_curr,m_amt_1,m_amt_3,m_amt_4,m_amt_5,m_amt_6
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach2',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
# 
#               SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = l_curr  #No.CHI-6A0004
#
#               PRINT COLUMN g_c[35],l_curr,
#                     COLUMN g_c[36],g_orderA[2] CLIPPED,
#                     COLUMN g_c[37],g_x[15] CLIPPED,
#                     COLUMN g_c[39],cl_numfor(m_amt_1,39,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[41],cl_numfor(m_amt_3,41,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[43],cl_numfor(m_amt_4,43,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[45],cl_numfor(m_amt_5,45,t_azi05),  #No.CHI-6A0004
#                     COLUMN g_c[47],cl_numfor(m_amt_6,47,t_azi05)   #No.CHI-6A0004
#            END FOREACH
#
#            PRINT COLUMN g_c[35],g_x[18] CLIPPED,
#                  COLUMN g_c[36],g_orderA[2] CLIPPED,
#                  COLUMN g_c[37],g_x[15] CLIPPED,
#                  COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apf08),39,g_azi05),
#                  COLUMN g_c[41],cl_numfor(GROUP SUM(sr.aph05_1),41,g_azi05),
#                  COLUMN g_c[43],cl_numfor(GROUP SUM(sr.aph05_2),43,g_azi05),
#                  COLUMN g_c[45],cl_numfor(GROUP SUM(sr.aph05_3),45,g_azi05),
#                  COLUMN g_c[47],cl_numfor(GROUP SUM(sr.aph05_4),47,g_azi05)
#            PRINT ''
#         END IF
# 
#      ON LAST ROW
#         FOREACH r321_tmpcs4
#            INTO l_curr,g_amt_1,g_amt_3,g_amt_4,g_amt_5,g_amt_6
#            IF SQLCA.sqlcode THEN
#               CALL cl_err('foreach4',SQLCA.sqlcode,1)
#               EXIT FOREACH
#            END IF
# 
#            SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = l_curr  #No.CHI-6A0004
#
#            PRINT COLUMN g_c[35],l_curr,
#                  COLUMN g_c[37],g_x[17] CLIPPED,
#                  COLUMN g_c[39],cl_numfor(g_amt_1,39,t_azi05),  #No.CHI-6A0004
#                  COLUMN g_c[41],cl_numfor(g_amt_3,41,t_azi05),  #No.CHI-6A0004
#                  COLUMN g_c[43],cl_numfor(g_amt_4,43,t_azi05),  #No.CHI-6A0004
#                  COLUMN g_c[45],cl_numfor(g_amt_5,45,t_azi05),  #No.CHI-6A0004
#                  COLUMN g_c[47],cl_numfor(g_amt_6,47,t_azi05)   #No.CHI-6A0004
#         END FOREACH
#
#         PRINT COLUMN g_c[35],g_x[18] CLIPPED,
#               COLUMN g_c[37],g_x[17] CLIPPED,
#               COLUMN g_c[39],cl_numfor(SUM(sr.apf08),39,g_azi05),
#               COLUMN g_c[41],cl_numfor(SUM(sr.aph05_1),41,g_azi05), # 支票付款
#               COLUMN g_c[43],cl_numfor(SUM(sr.aph05_2),43,g_azi05), # 現金付款
#               COLUMN g_c[45],cl_numfor(SUM(sr.aph05_3),45,g_azi05), # 其他付款
#               COLUMN g_c[47],cl_numfor(SUM(sr.aph05_4),47,g_azi05)  # 沖帳付款
#
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'apf01,apf02,apf12,apf44,apf05') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
#            #TQC-630166
#            #IF tm.wc[001,070] > ' ' THEN            # for 80
#            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
#            #END IF
#            #IF tm.wc[071,140] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
#            #END IF
#            #IF tm.wc[141,210] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
#            #END IF
#            #IF tm.wc[211,280] > ' ' THEN
#            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
#            #END IF
#            CALL cl_prt_pos_wc(tm.wc)
#            #END TQC-630166
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#    #    PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[47],g_x[7] CLIPPED              #TQC-6A0088
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED              #TQC-6A0088
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#       #    PRINT g_x[14],g_x[5] CLIPPED,COLUMN g_c[47],g_x[6] CLIPPED          #TQC-6A0088
#            PRINT g_x[14],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED          #TQC-6A0088
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-7A0025  --End  
 
FUNCTION r321_create_tmp()    #no.5197
#No.FUN-690028 --mark--
#   CREATE TEMP TABLE r321_tmp
#      (
#       curr      VARCHAR(04),
#       amt1      DEC(20,6),
#       amt2      DEC(20,6),
#       amt3      DEC(20,6),
#       amt4      DEC(20,6),
#       amt5      DEC(20,6),
#       order1    VARCHAR(30),           #FUN-560011
#       order2    VARCHAR(30)            #FUN-560011
#      )
#No.FUN-690028 ---end---
#No.FUN-690028 --start--
   CREATE TEMP TABLE r321_tmp(
       curr  LIKE type_file.chr4,  
       amt1  LIKE type_file.num20_6,
       amt2  LIKE type_file.num20_6,
       amt3  LIKE type_file.num20_6,
       amt4  LIKE type_file.num20_6,
       order1  LIKE gen_file.gen02,
       order1  LIKE gen_file.gen02)
#No.FUN-690028 ---end---
END FUNCTION
#Patch....NO.TQC-610035 <001> #
