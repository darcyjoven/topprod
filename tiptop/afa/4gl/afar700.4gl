# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar700.4gl
# Descriptions...: 投資抵減明細表
# Date & Author..: 96/05/13 By STAR
# Modify.........: No:7660 03/07/23 By Wiky " AND fcc20 IN ('3','5') " ORACLE
#                : 沒轉換
# Modify.........: No.FUN-510035 05/02/01 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720045 07/04/11 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              d       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE l_table     STRING                       ### MOD-720045 add ###
DEFINE g_sql       STRING                       ### MOD-720045 add ###
DEFINE g_str       STRING                       ### MOD-720045 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   #str MOD-720045 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> MOD-720045 *** ##
   LET g_sql = "fcb03.fcb_file.fcb03,",
               "fcb04.fcb_file.fcb04,",
               "fcb05.fcb_file.fcb05,",
               "fcb06.fcb_file.fcb06,",
               "fcc14.fcc_file.fcc14,",
               "fcc15.fcc_file.fcc15,",
               "type.type_file.chr1,",
               "cost1.type_file.num20_6,",
               "cost2.type_file.num20_6,",
               "cost3.type_file.num20_6,",
               "cost4.type_file.num20_6,",
               "cost5.type_file.num20_6,",
               "t_azi04.azi_file.azi04,",
               "g_azi04.azi_file.azi04,",
               "g_azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('afar700',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE r700_temp
#No.FUN-680070  -- begin --
   CREATE TEMP TABLE r700_temp(
     fcb04 LIKE fcb_file.fcb04,   #管理局核准文號
     fcc15 LIKE fcc_file.fcc15,   #扺減率
     fcc14 LIKE fcc_file.fcc14,   #幣別
     type  LIKE type_file.chr1,   #1/2
     cost1 LIKE type_file.num20_6,#原幣金額/本幣附屬費用
     cost2 LIKE type_file.num20_6,
     cost3 LIKE type_file.num20_6);
#No.FUN-680070  -- end --
    create  unique index r700_01 on r700_temp(fcb04,fcc15,fcc14,type);
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar700_tm(0,0)        # Input print condition
      ELSE CALL afar700()            # Read data and create out-file
   END IF
   DROP TABLE r700_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar700_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar700_w AT p_row,p_col WITH FORM "afa/42f/afar700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a = '2'
   LET tm.d = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb04,fcc14,fcb06,fcc15,fcb03,fcb05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
         LET INT_FLAG = 0 CLOSE WINDOW afar700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.d,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar700'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar700','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a  CLIPPED,"'",
                            " '",tm.d  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar700',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar700_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar700()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar700_w
END FUNCTION
 
 
FUNCTION afar700()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_name2   LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          l_fcc24   LIKE   fcc_file.fcc24,
          l_cost4   LIKE type_file.num20_6,
          l_cost5   LIKE type_file.num20_6,
          sr               RECORD
                                  fcc01  LIKE fcc_file.fcc01, #申請編號
                                  fcc02  LIKE fcc_file.fcc02, #項次
                                  fcc03  LIKE fcc_file.fcc03, #財編
                                  fcc031 LIKE fcc_file.fcc031,#附號
                                  fcc04  LIKE fcc_file.fcc04, #合併碼
                                  fcc05  LIKE fcc_file.fcc05, #中文名稱
                                  fcc06  LIKE fcc_file.fcc06, #英文名稱
                                  fcc08  LIKE fcc_file.fcc08, #廠商名稱
                                  fcc09  LIKE fcc_file.fcc09, #數量
                                  fcc21  LIKE fcc_file.fcc21, #數量
                                  fcc14  LIKE fcc_file.fcc14, #幣別
                                  fcc15  LIKE fcc_file.fcc15, #抵減率
                                  fcc13  LIKE fcc_file.fcc13, #原幣成本
                                  fcc16  LIKE fcc_file.fcc16, #本幣成本
                                  fcc23  LIKE fcc_file.fcc23, #合併前原幣
                                  fcc24  LIKE fcc_file.fcc24, #      本幣
                                  fcb03  LIKE fcb_file.fcb03, #管理局核准日
                                  fcb04  LIKE fcb_file.fcb04, #    文號
                                  fcb05  LIKE fcb_file.fcb05, #國稅局核准日
                                  fcb06  LIKE fcb_file.fcb06, #    文號
                                  faj45  LIKE faj_file.faj45, #帳款編號
                                  faj47  LIKE faj_file.faj47, #採購單號
                                  faj49  LIKE faj_file.faj49, #進口編號
                                  faj51  LIKE faj_file.faj51, #發票號碼
                                  faj52  LIKE faj_file.faj52, #傳票編號
                                  cost1  LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  cost2  LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  cost3  LIKE type_file.num20_6,      #No.FUN-680070 DEC(20,6)
                                  qty    LIKE fcc_file.fcc21
                        END RECORD,
          sr2              RECORD fcj  RECORD LIKE fcj_file.*,
                                  faj45  LIKE faj_file.faj45, #帳款編號
                                  faj47  LIKE faj_file.faj47, #採購單號
                                  faj49  LIKE faj_file.faj49, #進口編號
                                  faj51  LIKE faj_file.faj51, #發票號碼
                                  faj52  LIKE faj_file.faj52  #傳票編號
                        END RECORD
 
   #str MOD-720045  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720045 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end MOD-720045  add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### MOD-720045 add ###
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fcbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fcbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fcbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcbuser', 'fcbgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT fcc01, fcc02, fcc03, fcc031, fcc04, fcc05, ",
                       " fcc06, fcc08, fcc09, fcc21,  fcc14, fcc15,",
                       " fcc13, fcc16, fcc23, fcc24, ",
                       " fcb03, fcb04, fcb05, fcb06, faj45,",
                       " faj47, faj49, faj51, faj52,'','','','' ",
                 "  FROM fcb_file, fcc_file, faj_file",
                 " WHERE fcb01 = fcc01 ",
                 "   AND fcbconf != 'X' ",   #010802 增
                 "   AND fcc03 = faj02 ",
                 "   AND fcc031= faj022 ",
                 "   AND fcc04 IN ('1','2') ",  # 只列印合併後資料
                 "   AND ",tm.wc CLIPPED
      CASE
        WHEN tm.a = '1' LET l_sql = l_sql clipped," AND fcc20 = '3' "
        WHEN tm.a = '2' LET l_sql = l_sql clipped," AND fcc20 = '5' "
        WHEN tm.a = '3' LET l_sql = l_sql clipped," AND fcc20 IN ('3','5') " #No:7660
        OTHERWISE EXIT CASE
      END CASE
      #-->處份是否包含
      IF tm.d = 'N' THEN
         LET l_sql = l_sql clipped," AND faj43 not IN ('5','6')"
      END IF
 
     PREPARE afar700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar700_curs1 CURSOR FOR afar700_prepare1
 
     #--->附加費用(幣別/抵減率依申請項次)
     LET l_sql = "SELECT fcj_file.*,faj45,faj47,faj49,faj51, faj52",
                 " FROM fcj_file, faj_file ",
                 " WHERE fcj01 = ?  AND fcj02 = ? ",
                 "   AND fcj03 = faj02 ",
                 "   AND fcj031= faj022 "
      #-->處份是否包含
      IF tm.d = 'N' THEN
         LET l_sql = l_sql clipped," AND faj43 not IN ('5','6')"
      END IF
     PREPARE afar700_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar700_curs2 CURSOR FOR afar700_prepare2
 
     LET g_pageno = 0
     DELETE FROM r700_temp
     FOREACH afar700_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.fcc14) THEN LET sr.fcc14 = ' ' END IF
             LET sr.cost1 = sr.fcc23                    #原幣值
             LET sr.cost2 = sr.fcc24                    #本幣值
             LET sr.qty   = sr.fcc21                    #數量
 
          #-->扺減額獨立推算
          DECLARE afar700_cost3 CURSOR FOR
           SELECT fcc16 FROM fcc_file WHERE fcc01=sr.fcc01 AND fcc02=sr.fcc02
          LET sr.cost3 = 0 LET l_fcc24 = 0
          FOREACH afar700_cost3 INTO l_fcc24
            IF STATUS THEN
               LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
               EXIT FOREACH
            END IF
            LET sr.cost3 = sr.cost3 + (l_fcc24*(sr.fcc15/100))
          END FOREACH
 
          #-->依申請號+抵減率+幣別
          INSERT INTO r700_temp
               VALUES(sr.fcb04,sr.fcc15,sr.fcc14,'1',sr.cost1,sr.cost2,sr.cost3)
          IF SQLCA.sqlcode THEN
             UPDATE r700_temp SET cost1=cost1 + sr.cost1,
                                  cost2=cost2 + sr.cost2,
                                  cost3=cost3 + sr.cost3
                          WHERE fcb04 = sr.fcb04
                            AND fcc15 = sr.fcc15
                            AND fcc14 = sr.fcc14
                            AND type = '1'
          END IF
 
          SELECT cost1,cost2,cost3 INTO sr.cost1,sr.cost2,sr.cost3
           FROM  r700_temp
           WHERE fcb04 = sr.fcb04
             AND fcc15 = sr.fcc15
             AND fcc14 = sr.fcc14
             AND type = '1'
          
          LET l_cost4 = NULL
          LET l_cost5 = NULL
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
       # EXECUTE insert_prep USING 
       # sr.fcb03,sr.fcb04,sr.fcb05,sr.fcb06,sr.fcc14,
       # sr.fcc15,'1'     ,sr.cost1,sr.cost2,sr.cost3,
       # l_cost4 ,l_cost5
       #------------------------------ CR (3) ------------------------------#
       #end MOD-740025 add 
 
       #--->附加費用
       IF sr.fcc04 matches '[12]' THEN
          FOREACH afar700_curs2
          USING sr.fcc01,sr.fcc02
          INTO sr2.*
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             IF cl_null(sr2.fcj.fcj10) THEN LET sr2.fcj.fcj10 = ' ' END IF
             #--->替換成附加費用資料
             LET sr.fcc03  = sr2.fcj.fcj03  #財編
             LET sr.fcc031 = sr2.fcj.fcj031 #附號
             LET sr.fcc05  = sr2.fcj.fcj04  #中文名稱
             LET sr.fcc06  = sr2.fcj.fcj05  #英文名稱
             LET sr.fcc08  = sr2.fcj.fcj08  #廠商名稱
             LET sr.fcc09  = sr2.fcj.fcj06  #數量
             LET sr.fcc21  = sr2.fcj.fcj06  #數量
             LET sr.fcc13  = sr2.fcj.fcj09  #原幣成本
             LET sr.fcc16  = sr2.fcj.fcj11  #本幣成本
             LET sr.fcc23  = sr2.fcj.fcj09  #合併後原幣
             LET sr.fcc24  = sr2.fcj.fcj11  #合併後原幣
             LET sr.qty   = sr2.fcj.fcj06   #數量
             LET sr.cost1 = sr2.fcj.fcj09   #原幣值
             LET sr.cost2 = sr2.fcj.fcj11   #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
 
 
             #-->依申請號+抵減率+幣別
             INSERT INTO r700_temp
             VALUES(sr.fcb04,sr.fcc15,sr.fcc14,'2',sr.cost1,sr.cost2,sr.cost3)
             IF SQLCA.sqlcode THEN
                UPDATE r700_temp SET cost1=cost1 + sr.cost1,
                                      cost2=cost2 + sr.cost2,
                                      cost3=cost3 + sr.cost3
                             WHERE fcb04 = sr.fcb04
                               AND fcc15 = sr.fcc15
                               AND fcc14 = sr.fcc14
                               AND type = '2'
             END IF
          END FOREACH
 
          SELECT cost2,cost3 INTO l_cost4,l_cost5
           FROM  r700_temp
           WHERE fcb04 = sr.fcb04
             AND fcc15 = sr.fcc15
             AND fcc14 = sr.fcc14
             AND type = '2'
 
       END IF
 
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
       FROM azi_file
       WHERE azi01=sr.fcc14
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> MOD-720045 *** ##
         EXECUTE insert_prep USING 
         sr.fcb03,sr.fcb04,sr.fcb05,sr.fcb06,sr.fcc14,
         sr.fcc15,'2'     ,sr.cost1,sr.cost2,sr.cost3,
         l_cost4 ,l_cost5 ,t_azi04,g_azi04  ,g_azi05
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
   #str MOD-720045 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'fcb04,fcc14,fcb06,fcc15,fcb03,fcb05')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   CALL cl_prt_cs3('afar700','afar700',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end MOD-720045 add 
 
END FUNCTION
