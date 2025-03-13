# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr128.4gl
# Descriptions...: 留置金額明細表列印作業
# Date & Author..: 96/12/19  By  grace
# Modify.........: No.FUN-4C0097 04/12/24 By Nicola 報表架構修改
#                                                   增加印列員工姓名gen02
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: No.MOD-5C0070 05/12/14 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.MOD-670133 06/07/31 By Smapmin 修改小計問題
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui列印順序寫錯
# Modify.........: No.MOD-6C0117 06/12/19 By Smapmin 應付=留置時,該報表也應該印得出來
# Modify.........: No.TQC-740326 07/04/27 By dxfwo   排序第三個欄位未有默認值
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 應付金額不應扣除留置金額
# Modify.........: No.FUN-750129 07/06/01 By Carrier 報表轉Crystal Report格式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(300)
              wc      STRING,   #TQC-630166
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
              g       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
DEFINE l_table   STRING  #No.FUN-750129
DEFINE g_str     STRING  #No.FUN-750129
DEFINE g_sql     STRING  #No.FUN-750129
 
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
   #No.FUN-750129  --Begin
   LET g_sql = " apa00.apa_file.apa00,",
               " apa01.apa_file.apa01,",
               " apa02.apa_file.apa02,",
               " apa06.apa_file.apa06,",
               " apa07.apa_file.apa07,",
               " apa08.apa_file.apa08,",
               " apa11.apa_file.apa11,",
               " apa12.apa_file.apa12,",
               " apa13.apa_file.apa13,",
               " apa15.apa_file.apa15,",
               " apa19.apa_file.apa19,",
               " apa20.apa_file.apa20,",
               " apa21.apa_file.apa21,",
               " apa22.apa_file.apa22,",
               " apa24.apa_file.apa24,",
               " apa64.apa_file.apa64,",
               " apa34f.apa_file.apa34f,",
               " un_payf.apa_file.apa35f,",
               " apa34.apa_file.apa34,",
               " un_pay.apa_file.apa35,",
               " payf.apa_file.apa35f,",
               " pay.apa_file.apa35,",
               " apa36.apa_file.apa36,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " gen02.gen_file.gen02,",
               " apo02.apo_file.apo02 "
   LET l_table = cl_prt_temptable('aapr128',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ? )  "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
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
   LET tm.g  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE r128_tmp
   CALL r128_create_tmp()
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r128_tm(0,0)
   ELSE
      CALL r128()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r128_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW r128_w AT p_row,p_col
     WITH FORM "aap/42f/aapr128"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
#  LET tm.s    = '23 '
   LET tm.s    = '234'  #No.TQC-740326
   LET tm.u    = 'Y  '
   LET tm.g    = '3'
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
      CONSTRUCT BY NAME tm.wc ON apa21,apa06,apa02,apa01,apa22,apa36,apa00,apa13
 
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
         CLOSE WINDOW r128_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.g,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         CLOSE WINDOW r128_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr128'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr128','9031',1)
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
                        " '",tm.g CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr128',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r128_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r128()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r128_w
 
END FUNCTION
 
FUNCTION r128()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(600)
DEFINE l_sql      STRING        # RDSQL STATEMENT   #TQC-630166
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)         #FUN-560011
DEFINE l_i       LIKE type_file.num5           #No.MOD-590440  #No.FUN-690028 SMALLINT
DEFINE l_len     LIKE type_file.num5        # No.FUN-690028 SMALLINT         #No.MOD-590440
DEFINE l_apo02   LIKE apo_file.apo02           #No.FUN-750129
DEFINE sr        RECORD order1 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),      #FUN-560011
                        order2 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),      #FUN-560011
                        order3 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),      #FUN-560011
                        apa00 LIKE apa_file.apa00,
                        apa01 LIKE apa_file.apa01,
                        apa02 LIKE apa_file.apa02,
                        apa06 LIKE apa_file.apa06,
                        apa07 LIKE apa_file.apa07,
                        apa08 LIKE apa_file.apa08,
                        apa11 LIKE apa_file.apa11,
                        apa12 LIKE apa_file.apa12,
                        apa13 LIKE apa_file.apa13,
                        apa15 LIKE apa_file.apa15,
                        apa19 LIKE apa_file.apa19,
                        apa20 LIKE apa_file.apa20,
                        apa21 LIKE apa_file.apa21,
                        apa22 LIKE apa_file.apa22,
                        apa24 LIKE apa_file.apa24,
                        apa64 LIKE apa_file.apa64,
                        apa34f LIKE apa_file.apa34f,
                        un_payf LIKE apa_file.apa35f,
                        apa34 LIKE apa_file.apa34,
                        un_pay LIKE apa_file.apa35,
                        payf  LIKE apa_file.apa35f,    #MOD-720128
                        pay   LIKE apa_file.apa35,   #MOD-720128
                        apa36 LIKE apa_file.apa36,  #No.MOD-5C0070
                        azi03 LIKE azi_file.azi03,
                        azi04 LIKE azi_file.azi04,
                        azi05 LIKE azi_file.azi05,
                        gen02 LIKE gen_file.gen02
                        END RECORD
 
   DELETE FROM r128_tmp
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   #No.FUN-750129  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-750129  --End
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #No.FUN-750129  --Begin
   ##bugno:5197................................................................
   #LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp WHERE order1 = ? ",
   #            " GROUP BY apa13 ORDER BY apa13"
   #PREPARE r128tmp_pre1 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre1:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r128_tmpcs1 CURSOR FOR r128tmp_pre1
 
   ##LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp WHERE order2 = ? ",   #MOD-670133
   #LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp WHERE order1 = ? AND order2 = ? ",   #MOD-670133
   #            " GROUP BY apa13 ORDER BY apa13"
   #PREPARE r128tmp_pre2 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre2:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r128_tmpcs2 CURSOR FOR r128tmp_pre2
 
   ##LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp WHERE order3 = ? ",   #MOD-670133
   #LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp WHERE order1 = ? AND order2 = ? AND order3 = ? ",   #MOD-670133
   #            " GROUP BY apa13 ORDER BY apa13"
   #PREPARE r128tmp_pre3 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre3:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r128_tmpcs3 CURSOR FOR r128tmp_pre3
 
   #LET l_sql = "SELECT apa13,SUM(amt1),SUM(amt2) FROM r128_tmp ",
   #            " GROUP BY apa13 ORDER BY apa13"
   #PREPARE r128tmp_pre4 FROM l_sql
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('tmp_pre4:',SQLCA.sqlcode,1)
   #   RETURN
   #END IF
   #DECLARE r128_tmpcs4 CURSOR FOR r128tmp_pre4
   ##bug end.................................................................
   #No.FUN-750129  --End  
 
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
 
 
   #No.MOD-5C0070  --Begin
   IF g_apz.apz27 = 'N' THEN
      LET l_sql = "SELECT '','','',",
                  " apa00, apa01, apa02, apa06, apa07, apa08, apa11, apa12,",
                  " apa13, apa15, apa19, apa20, apa21, apa22, apa24, apa64,",
                  " apa34f, (apa34f-apa35f),",   #TQC-610098   #MOD-720128
                  " apa34, (apa34-apa35),",    #TQC-610098   #MOD-720128
                  #" apa34f, (apa34f-apa35f-apa20),",   #TQC-610098   #MOD-720128
                  #" apa34, (apa34-apa35-apa20*apa14),",    #TQC-610098   #MOD-720128
                  " (apa34f-apa35f-apa20),(apa34-apa35-apa20*apa14),",   #MOD-720128
                  " apa36, azi03, azi04, azi05,''",
                  " FROM apa_file, OUTER azi_file",
                  " WHERE azi_file.azi01 = apa_file.apa13 ",
                  #" AND apa34f > apa35f AND apa42 = 'N' ",   #TQC-610098
                  #" AND apa34f > apa35f+apa20 AND apa42 = 'N' ",   #TQC-610098      #MOD-6C0117
                  " AND apa34f >= apa35f+apa20 AND apa42 = 'N' ",   #TQC-610098      #MOD-6C0117
                  " AND apa20 > 0 "
   ELSE
      LET l_sql = "SELECT '','','',",
                  " apa00, apa01, apa02, apa06, apa07, apa08, apa11, apa12,",
                  " apa13, apa15, apa19, apa20, apa21, apa22, apa24, apa64,",
                  " apa34f, (apa34f-apa35f),",   #TQC-610098   #MOD-720128
                  " apa34, apa73,",   #TQC-610098   #MOD-720128
                  #" apa34f, (apa34f-apa35f-apa20),",   #TQC-610098   #MOD-720128
                  #" apa34, (apa73-apa20*apa72),",   #TQC-610098   #MOD-720128
                  " (apa34f-apa35f-apa20),(apa73-apa20*apa72),",   #MOD-720128
                  " apa36, azi03, azi04, azi05,''",
                  " FROM apa_file, OUTER azi_file",
                  " WHERE azi_file.azi01 = apa_file.apa13 ",
                  #" AND apa34f > apa35f AND apa42 = 'N' ",   #TQC-610098
                  #" AND apa34f > apa35f+apa20 AND apa42 = 'N' ",   #TQC-610098   #MOD-6C0117
                  " AND apa34f >= apa35f+apa20 AND apa42 = 'N' ",   #TQC-610098   #MOD-6C0117
                  " AND apa20 > 0 "
   END IF
   #No.MOD-5C0070  --End
 
   IF tm.g = '1' THEN
      LET l_sql = l_sql CLIPPED," AND apa41 = 'Y'"
   END IF
 
   IF tm.g = '2' THEN
      LET l_sql = l_sql CLIPPED," AND apa41 = 'N'"
   END IF
 
   LET l_sql = l_sql CLIPPED,"   AND ",tm.wc
 
   PREPARE r128_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r128_curs1 CURSOR FOR r128_prepare1
 
   #No.FUN-750129  --Begin
   #CALL cl_outnam('aapr128') RETURNING l_name  #No.MOD-5C0070
   #START REPORT r128_rep TO l_name
   #No.FUN-750129  --End  
 
   LET g_pageno = 0
 
   FOREACH r128_curs1 INTO sr.*
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gen02 INTO sr.gen02 FROM gen_file
       WHERE gen01 = sr.apa21
      IF sr.apa00[1,1] = '2' THEN
         LET sr.apa34f= sr.apa34f * -1
         LET sr.un_payf= sr.un_payf * -1
         LET sr.apa34 = sr.apa34 * -1
         LET sr.un_pay = sr.un_pay * -1  #No.MOD-5C0070
      END IF
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
      #No.FUN-750129  --Begin
      #FOR g_i = 1 TO 3
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa21
      #                                 LET g_orderA[g_i]= g_x[14]
      #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa06,sr.apa07
      #                                 LET g_orderA[g_i]= g_x[15]
      #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
      #                                 LET g_orderA[g_i]= g_x[16]
      #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa01
      #                                 LET g_orderA[g_i]= g_x[17]
      #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa22
      #                                 LET g_orderA[g_i]= g_x[18]
      #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa36
      #                                 LET g_orderA[g_i]= g_x[19]
      #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apa00
      #                                 LET g_orderA[g_i]= g_x[20]
      #        WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.apa13
      #                                 LET g_orderA[g_i]= g_x[21]
      #        OTHERWISE LET l_order[g_i]  = '-'
      #                  LET g_orderA[g_i] = ' '          #清為空白
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
 
      #IF sr.order1 IS NULL THEN
      #   LET sr.order1 = ' '
      #END IF
 
      #IF sr.order2 IS NULL THEN
      #   LET sr.order2 = ' '
      #END IF
 
      #IF sr.order3 IS NULL THEN
      #   LET sr.order3 = ' '
      #END IF
 
      #INSERT INTO r128_tmp VALUES(sr.apa13,sr.un_payf,sr.un_pay,
      #                            sr.order1,sr.order2,sr.order3)
 
      #OUTPUT TO REPORT r128_rep(sr.*)
      SELECT apo02 INTO l_apo02 FROM apo_file
       WHERE apo01 = sr.apa19
      IF SQLCA.sqlcode THEN
         LET l_apo02 = ' '
      END IF
      EXECUTE insert_prep USING 
              sr.apa00, sr.apa01, sr.apa02, sr.apa06, sr.apa07,
              sr.apa08, sr.apa11, sr.apa12, sr.apa13, sr.apa15,
              sr.apa19, sr.apa20, sr.apa21, sr.apa22, sr.apa24,
              sr.apa64, sr.apa34f, sr.un_payf, sr.apa34, sr.un_pay,
              sr.payf,  sr.pay,    sr.apa36,   sr.azi03, sr.azi04,
              sr.azi05, sr.gen02,  l_apo02
      #No.FUN-750129  --End  
   END FOREACH
 
   #No.FUN-750129  --Begin
   #FINISH REPORT r128_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED            
   LET g_str = ''                                                              
   #是否列印選擇條件                                                           
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'apa21,apa22,apa06,apa36,apa02,apa00,apa01,apa13')         
           RETURNING g_str
   END IF                                                                      
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t,";",tm.u,";",g_azi03,";",g_azi04,";",g_azi05
   CALL cl_prt_cs3('aapr128','aapr128',g_sql,g_str)
   #No.FUN-750129  --End  
 
  # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055     #FUN-B80105 MARK
 
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT r128_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#DEFINE l_apa13      LIKE apa_file.apa13
#DEFINE sr           RECORD order1 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),         #FUN-560011
#                           order2 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),         #FUN-560011
#                           order3 LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),         #FUN-560011
#                           apa00 LIKE apa_file.apa00,
#                           apa01 LIKE apa_file.apa01,
#                           apa02 LIKE apa_file.apa02,
#                           apa06 LIKE apa_file.apa06,
#                           apa07 LIKE apa_file.apa07,
#                           apa08 LIKE apa_file.apa08,
#                           apa11 LIKE apa_file.apa11,
#                           apa12 LIKE apa_file.apa12,
#                           apa13 LIKE apa_file.apa13,
#                           apa15 LIKE apa_file.apa15,
#                           apa19 LIKE apa_file.apa19,
#                           apa20 LIKE apa_file.apa20,
#                           apa21 LIKE apa_file.apa21,
#                           apa22 LIKE apa_file.apa22,
#                           apa24 LIKE apa_file.apa24,
#                           apa64 LIKE apa_file.apa64,
#                           apa34f LIKE apa_file.apa34f,
#                           un_payf LIKE apa_file.apa35f,
#                           apa34 LIKE apa_file.apa34,
#                           un_pay LIKE apa_file.apa35,
#                           payf  LIKE apa_file.apa35f,   #MOD-720128
#                           pay   LIKE apa_file.apa35,   #MOD-720128
#                           apa36 LIKE apa_file.apa36,  #No.MOD-5C0070
#                           azi03 LIKE azi_file.azi03,
#                           azi04 LIKE azi_file.azi04,
#                           azi05 LIKE azi_file.azi05,
#                           gen02 LIKE gen_file.gen02
#                    END RECORD
#DEFINE l_apo02      LIKE apo_file.apo02     # 留置原因名稱
#DEFINE l_amt_1      LIKE apa_file.apa35f
#DEFINE l_amt_2      LIKE apa_file.apa35
#DEFINE g_head1       STRING
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         LET g_head1 = g_x[13] CLIPPED,g_orderA[1] CLIPPED,    #TQC-6A0088
#                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
#         PRINT g_head1
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44], #No.MOD-5C0070
#               g_x[45],g_x[46]   #MOD-720128
#         PRINT g_dash1
#         LET l_last_sw = 'n'
#
#      BEFORE GROUP OF sr.order1
#         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#      BEFORE GROUP OF sr.order2
#         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#      BEFORE GROUP OF sr.order3
#         IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#      ON EVERY ROW
#         SELECT apo02 INTO l_apo02 FROM apo_file
#          WHERE apo01 = sr.apa19
#         IF SQLCA.sqlcode THEN
#            LET l_apo02 = ' '
#         END IF
#         PRINT COLUMN g_c[31],sr.apa06,
#               COLUMN g_c[32],sr.apa07,
#               COLUMN g_c[33],sr.apa02,
#               COLUMN g_c[34],sr.apa08,
#               COLUMN g_c[35],sr.apa01,
#               COLUMN g_c[36],sr.apa13,
#               COLUMN g_c[37],sr.apa21,
#               COLUMN g_c[38],sr.gen02,
#               COLUMN g_c[39],sr.apa12,
#               COLUMN g_c[40],sr.apa64,
#               COLUMN g_c[41],cl_numfor(sr.un_payf,41,sr.azi04),
#               COLUMN g_c[42],cl_numfor(sr.un_pay,42,0),
#               COLUMN g_c[43],cl_numfor(sr.apa20,43,sr.azi04),
#               #-----MOD-720128---------
#               COLUMN g_c[44],cl_numfor(sr.payf,44,sr.azi04),
#               COLUMN g_c[45],cl_numfor(sr.pay,45,0),
#               #COLUMN g_c[44],l_apo02  #No.MOD-5C0070
#               COLUMN g_c[46],l_apo02
#               #-----END MOD-720128
#
#      AFTER GROUP OF sr.order1
#         IF tm.u[1,1] = 'Y' THEN
##           PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+g_w[39]+g_w[40]
##                       +g_w[41]+g_w[42]+g_w[43]+g_w[44]+7]  #No.MOD-5C0070
#            PRINT g_dash2[1,g_len]
#            FOREACH r128_tmpcs1 USING sr.order1 INTO l_apa13,l_amt_1,l_amt_2
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach1',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               PRINT COLUMN g_c[38],l_apa13 CLIPPED,
#                     COLUMN g_c[39],g_orderA[1] CLIPPED,
#                     COLUMN g_c[40],g_x[10] CLIPPED,
#                     COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#                     COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            END FOREACH
#            LET l_amt_2 = GROUP SUM(sr.un_pay)
#            PRINT COLUMN g_c[39],g_orderA[1] CLIPPED,
#                  COLUMN g_c[40],g_x[10] CLIPPED,
#                  COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            PRINT ''
#         END IF
#
#      AFTER GROUP OF sr.order2
#         IF tm.u[2,2] = 'Y' THEN
#            #FOREACH r128_tmpcs2 USING sr.order2 INTO l_apa13,l_amt_1,l_amt_2   #MOD-670133
#            FOREACH r128_tmpcs2 USING sr.order1,sr.order2 INTO l_apa13,l_amt_1,l_amt_2   #MOD-670133
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach2',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               PRINT COLUMN g_c[38],l_apa13 CLIPPED,
#                     COLUMN g_c[39],g_orderA[2] CLIPPED,
#                     COLUMN g_c[40],g_x[10] CLIPPED,
#                     COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#                     COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            END FOREACH
#            LET l_amt_2 = GROUP SUM(sr.un_pay)
#            PRINT COLUMN g_c[39],g_orderA[2] CLIPPED,
#                  COLUMN g_c[40],g_x[10] CLIPPED,
#                  COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            PRINT ''
#         END IF
#
#      AFTER GROUP OF sr.order3
#         IF tm.u[3,3] = 'Y' THEN
#            #FOREACH r128_tmpcs3 USING sr.order3 INTO l_apa13,l_amt_1,l_amt_2   #MOD-670133
#            FOREACH r128_tmpcs3 USING sr.order1,sr.order2,sr.order3 INTO l_apa13,l_amt_1,l_amt_2   #MOD-670133
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach3',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF
#               PRINT COLUMN g_c[38],l_apa13 CLIPPED,
#                     COLUMN g_c[39],g_orderA[1] CLIPPED,
#                     COLUMN g_c[40],g_x[10] CLIPPED,
#                     COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#                     COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            END FOREACH
#            LET l_amt_2 = GROUP SUM(sr.un_pay)
#            PRINT COLUMN g_c[39],g_orderA[3] CLIPPED,
#                  COLUMN g_c[40],g_x[10] CLIPPED,
#                  COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#            PRINT ''
#         END IF
#
#      ON LAST ROW
#         FOREACH r128_tmpcs4 INTO l_apa13,l_amt_1,l_amt_2
#             IF SQLCA.sqlcode THEN
#                CALL cl_err('foreach4',SQLCA.sqlcode,1)
#                EXIT FOREACH
#             END IF
#             PRINT COLUMN g_c[38],l_apa13 CLIPPED,
#                   COLUMN g_c[39],g_x[12] CLIPPED,
#                   COLUMN g_c[41],cl_numfor(l_amt_1,41,sr.azi05),
#                   COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#         END FOREACH
#         LET l_amt_2 = SUM(sr.un_pay)
#         PRINT COLUMN g_c[39],g_x[12] CLIPPED,
#               COLUMN g_c[42],cl_numfor(l_amt_2,42,0)
#
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05') RETURNING tm.wc
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
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED
#
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-750129  --End
 
FUNCTION r128_create_tmp()    #no.5197
# No.FUN-690028 --start--
CREATE TEMP TABLE r128_tmp(
     apa13     LIKE apa_file.apa13,
     amt1      LIKE type_file.num20_6,
     amt2      LIKE type_file.num20_6,
     order1    LIKE zaa_file.zaa08,
     order2    LIKE zaa_file.zaa08,
     order3    LIKE zaa_file.zaa08)
 
# No.FUN-690028 ---end---
END FUNCTION
