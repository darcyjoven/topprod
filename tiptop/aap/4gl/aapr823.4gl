# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr823.4gl
# Descriptions...: 信貸月底價值重評估表列印
# Date & Author..: 96/04/27  By  Roger
# Modify.........: No.FUN-4C0097 05/01/05 By Nicola 報表架構修改
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0128 06/11/27 By Rayven "接下頁" "結束"位置有誤
# Modify.........: No.MOD-720043 07/02/26 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C40208 12/04/23 By lujh 329行匯率的抓取應該調整為azj07月底重評價匯率，而非azj05。
# Modify.........: No.CHI-C80041 12/12/27 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_edate      LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE yymm         LIKE type_file.chr8        # No.FUN-690028 VARCHAR(6)
DEFINE tm  RECORD
              wc     STRING,     #No.TQC-630166
              #s       VARCHAR(3),   #TQC-610053
              #t       VARCHAR(3),   #TQC-610053
              #u       VARCHAR(3),   #TQC-610053
              more  LIKE type_file.chr1        # No.FUN-690028  VARCHAR(1)
           END RECORD,
#      g_orderA    ARRAY[3] OF VARCHAR(10)  #排序名稱
       g_orderA    ARRAY[3] OF LIKE oea_file.oea01      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                         #No.FUN-550030
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE l_table     STRING,      ### CR11 ###
       g_str       STRING,      ### CR11 ###
       g_sql       STRING       ### CR11 ###
 
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #MOD-720043 -START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
         LET g_sql  = " alh01.alh_file.alh01, ",
                      " alh02.alh_file.alh02, ",
                      " alh03.alh_file.alh03, ",
                      " alh11.alh_file.alh11, ",
                      " alh14.alh_file.alh14, ",
                      " alh15.alh_file.alh15, ",
                      " alh16.alh_file.alh16, ",
                      " new_ex.alh_file.alh15, ",
                      " new_amt.alh_file.alh14, ",
                      " ex_prof.nnl_file.nnl12, ",
                      " ex_loss.nnl_file.nnl12, ",
                      " azi07.azi_file.azi07 "    #No.FUN-870151
 
   LET l_table = cl_prt_temptable('aapr823',g_sql) CLIPPED               # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                              # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                 # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,         # TQC-780054
               " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
               "        ?, ?)"                                           #FUN-870151 add ? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720043 -END
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #LET tm.s  = ARG_VAL(8)   #TQC-610053
   #LET tm.t  = ARG_VAL(9)   #TQC-610053
   #LET tm.u  = ARG_VAL(10)  #TQC-610053
   LET g_edate  = ARG_VAL(8)  #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r823_tm(0,0)
   ELSE
      CALL r823()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r823_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r823_w AT p_row,p_col
     WITH FORM "aap/42f/aapr823"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.s    = '123'   #TQC-610053
   #LET tm.u    = 'Y'     #TQC-610053
   LET g_edate = TODAY
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON alh11,alh08,alh06,alh01,alh05,alh10
 
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
         CLOSE WINDOW r823_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME g_edate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD g_edate
            LET yymm = g_edate USING 'yyyymmdd'
 
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
         CLOSE WINDOW r823_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr823'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr823','9031',1)
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
                        #" '",tm.s CLIPPED,"'",   #TQC-610053
                        #" '",tm.t CLIPPED,"'",   #TQC-610053
                        #" '",tm.u CLIPPED,"'",   #TQC-610053
                        " '",g_edate CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr823',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r823_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r823()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r823_w
 
END FUNCTION
 
FUNCTION r823()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          amt1      LIKE nnl_file.nnl12,
          amt2      LIKE nnl_file.nnl14,
          l_order   ARRAY[5] OF  LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16),       #No.FUN-550030
          sr        RECORD order1  LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                           order2  LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                           order3  LIKE oea_file.oea01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                           alh     RECORD LIKE alh_file.*,
                           new_ex  LIKE alh_file.alh15,
                           new_amt LIKE alh_file.alh14,
                           ex_prof LIKE nnl_file.nnl12,
                           ex_loss LIKE nnl_file.nnl12,
                           azi04   LIKE azi_file.azi04,
                           azi05   LIKE azi_file.azi05,
                           azi07   LIKE azi_file.azi07     #No.FUN-870151
                    END RECORD
 
   #MOD-720043 -START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #MOD-720043 -END
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720043 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alhuser', 'alhgrup')
   #End:FUN-980030
 
   IF g_aza.aza19 = '1' THEN
      LET l_sql = "SELECT '','','', ",
                 #" alh_file.*,azj05,0,0,0,azi04,azi05,azi07",  #No.FUN-870151 add azi07   #TQC-C40208  mark
                  " alh_file.*,azj07,0,0,0,azi04,azi05,azi07",  #No.FUN-870151 add azi07   #TQC-C40208  add
                  " FROM alh_file, OUTER azj_file,azi_file",
                  " WHERE alh_file.alh11=azj_file.azj01 AND azj02='",yymm,"'",
                  "   AND azi_file.azi01=alh_file.alh11 ",
                  "   AND (alh14>alh76 OR",
                  "        alh01 IN (SELECT nnl04 FROM nnk_file,nnl_file",
                  "                   WHERE nnk01=nnl01 ",
                  "                     AND nnkconf <> 'X' ",  #CHI-C80041
                  "                     AND nnk02>'",g_edate,"'))",
                  "   AND ", tm.wc CLIPPED
   ELSE
      LET l_sql = "SELECT '','','', ",
                  " alh_file.*,0,0,0,0,azi04,azi05,azi07",  #No.FUN-870151 add azi07
                  " FROM alh_file, azi_file",
                  " WHERE azi01=alh11 ",
                  "   AND (alh14>alh76 OR",
                  "        alh01 IN (SELECT nnl04 FROM nnk_file,nnl_file",
                  "                   WHERE nnk01=nnl01 ",
                  "                     AND nnkconf <> 'X' ",  #CHI-C80041
                  "                     AND nnk02>'",g_edate,"'))",
                  "   AND ", tm.wc CLIPPED
   END IF
 
   PREPARE r823_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r823_curs1 CURSOR FOR r823_prepare1
 
   LET g_pageno = 0
 
   FOREACH r823_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.alh.alh11 = g_aza.aza17 THEN
         CONTINUE FOREACH
      END IF
 
      SELECT SUM(nnl12),SUM(nnl14-nnl16) INTO amt1,amt2
        FROM nnk_file,nnl_file
       WHERE nnl04 = sr.alh.alh01
         AND nnk01 = nnl01
         AND nnk02 > g_edate
         AND nnkconf <> 'X'  #CHI-C80041
 
      IF amt1 IS NULL THEN
         LET amt1 = 0
         LET amt2 = 0
      END IF
 
      LET sr.alh.alh14 = sr.alh.alh14 - sr.alh.alh76 + amt1
      LET sr.alh.alh16 = sr.alh.alh16 - sr.alh.alh77 + amt2
 
      IF sr.alh.alh14 <= 0 THEN
         CONTINUE FOREACH
      END IF
 
      ### 02/09/19 add by connie
      IF g_aza.aza19 = '2' THEN
         CALL s_curr3(sr.alh.alh11,g_edate,g_apz.apz33) RETURNING sr.new_ex #FUN-640022
      END IF
      ###
 
      IF cl_null(sr.new_ex) THEN
         LET sr.new_ex = 0
      END IF
 
      LET sr.new_amt = sr.alh.alh14 * sr.new_ex
      LET amt1 = sr.alh.alh16 - sr.new_amt
 
      IF amt1 > 0 THEN
         LET sr.ex_prof = amt1
         LET sr.ex_loss = 0
      ELSE
         LET sr.ex_prof = 0
        LET sr.ex_loss = amt1*-1
      END IF
 
      #MOD-720043 -START
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
              sr.alh.alh01,sr.alh.alh02,sr.alh.alh03,sr.alh.alh11,sr.alh.alh14,
              sr.alh.alh15,sr.alh.alh16,sr.new_ex,
              sr.new_amt,sr.ex_prof,sr.ex_loss,sr.azi07  #No.FUN-870151 add azi07
      #------------------------------ CR (3) ------------------------------#
      #MOD-720043 -END
 
   END FOREACH
 
   #MOD-720043 -START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'alh11,alh08,alh06,alh01,alh05,alh10')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_azi04,";",g_azi05          #FUN-710080 modify
   CALL cl_prt_cs3('aapr823','aapr823',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #MOD-720043 -END
 
END FUNCTION
