# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar710.4gl
# Descriptions...: 投資抵減明細表
# Date & Author..: 96/05/13 By STAR
# Modify.........: No:7660 03/07/23 By Wiky " AND fcc20 IN ('3','5') " ORACLE
#                : 沒轉換
# Modify.........: No.FUN-510035 05/02/14 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720124 07/03/01 By Smapmin 修改ora檔
# Modify.........: No.TQC-780033 07/08/07 By wujie   去除多余的打印機控制碼
# Modify.........: No.FUN-850013 08/05/06 By arman   報表輸出至Crystal Reports功能
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.TQC-960374 09/07/06 By chenmoyan 去掉chmod
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              b       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              c       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              d       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
# NO.FUN-850013 --begin
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING
# No.FUN-850013 --end
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
#NO.FUN-850013  --begin
   LET g_sql = "fcb03.fcb_file.fcb03,",
               "fcb04.fcb_file.fcb04,",
               "fcb05.fcb_file.fcb05,",
               "fcb06.fcb_file.fcb06,",
               "fcc14.fcc_file.fcc14,",
               "faj43.faj_file.faj43,",
               "fcc02.fcc_file.fcc02,",
               "fcc03.fcc_file.fcc03,",
               "fcc031.fcc_file.fcc031,",
               "fcc15.fcc_file.fcc15,",
               "faj04.faj_file.faj04,",
               "fcc06.fcc_file.fcc06,",
               "fcc05.fcc_file.fcc05,",
               "fcc08.fcc_file.fcc08,",
               "faj47.faj_file.faj47,",
               "faj45.faj_file.faj45,",
               "faj51.faj_file.faj51,",
               "faj49.faj_file.faj49,",
               "qty.type_file.num5,",
               "cost1.type_file.num20,",
               "cost2.type_file.num20,",
               "cost3.type_file.num20,",
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('afar710',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
 
#NO.FUN-850013  --end
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
 
   DROP TABLE r710_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE r710_temp(
#     fcb04 VARCHAR(20),    #管理局核准文號
#     fcc15 smallint,    #扺減率
#     fcc14 VARCHAR(4),     #幣別
#     cost1 dec(20,6),   #原幣金額
#     cost2 dec(20,6),   #本幣金
#     cost3 dec(20,6));  #扺減額
   CREATE TEMP TABLE r710_temp(
     fcb04 LIKE fcb_file.fcb04,
     fcc15 LIKE fcc_file.fcc15,
     fcc14 LIKE fcc_file.fcc14,
     cost1 LIKE type_file.num20_6,
     cost2 LIKE type_file.num20_6,
     cost3 LIKE type_file.num20_6);
#No.FUN-680070  -- end --
create  unique index r710_01 on r710_temp(fcb04,fcc15,fcc14);
 
   DROP TABLE r710_temp2
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE r710_temp2(                                                
#     fcb04 VARCHAR(20),    #管理局核准文號
#     fcc15 smallint,    #扺減率
#     fcc14 VARCHAR(4),     #幣別
#     cost1 dec(20,6),   #原幣金額
#     cost2 dec(20,6),   #本幣金額
#     cost3 dec(20,6));  #扺減額
   CREATE TEMP TABLE r710_temp2(
     fcb04 LIKE fcb_file.fcb04,
     fcc15 LIKE fcc_file.fcc15,
     fcc14 LIKE fcc_file.fcc14,
     cost1 LIKE type_file.num20_6,
     cost2 LIKE type_file.num20_6,
     cost3 LIKE type_file.num20_6);
#No.FUN-680070  -- end --
create  unique index r710_02 on r710_temp2(fcb04,fcc15,fcc14);
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar710_tm(0,0)        # Input print condition
      ELSE CALL afar710()            # Read data and create out-file
   END IF
   DROP TABLE r710_temp
   DROP TABLE r710_temp2
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar710_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar710_w AT p_row,p_col WITH FORM "afa/42f/afar710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a = '3'
   LET tm.b = '2'
   LET tm.c = '3'
   LET tm.d = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcb04,fcb06,fcc14,fcc15,fcb03,fcb05,fcb01
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
         LET INT_FLAG = 0 CLOSE WINDOW afar710_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar710_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar710'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar710','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a  CLIPPED,"'",
                            " '",tm.b  CLIPPED,"'",
                            " '",tm.c  CLIPPED,"'",
                            " '",tm.d  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar710',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar710_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar710()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar710_w
END FUNCTION
 
FUNCTION afar710()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_name2   LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_cmd     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
          l_order   ARRAY[4] OF LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          sr               RECORD fcc01  LIKE fcc_file.fcc01, #單號
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
                                  faj04  LIKE faj_file.faj04, #主類別
                                  faj43  LIKE faj_file.faj43, #狀態
                                  faj45  LIKE faj_file.faj45, #帳款編號
                                  faj47  LIKE faj_file.faj47, #採購單號
                                  faj49  LIKE faj_file.faj49, #進口編號
                                  faj51  LIKE faj_file.faj51, #發票號碼
                                  cost1  LIKE fcc_file.fcc23,
                                  cost2  LIKE fcc_file.fcc24,
                                  cost3  LIKE fcc_file.fcc24,
                                  qty    LIKE fcc_file.fcc21
                        END RECORD,
          sr2              RECORD fcj  RECORD LIKE fcj_file.*,
                                  faj04  LIKE faj_file.faj04, #主類別
                                  faj43  LIKE faj_file.faj43, #狀態
                                  faj45  LIKE faj_file.faj45, #帳款編號
                                  faj47  LIKE faj_file.faj47, #採購單號
                                  faj49  LIKE faj_file.faj49, #進口編號
                                  faj51  LIKE faj_file.faj51  #發票號碼
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
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
                       " fcb03, fcb04, fcb05, fcb06, faj04, faj43, faj45,",
                       " faj47, faj49, faj51, '','','','' ",
                 "  FROM fcb_file, fcc_file,faj_file",
                 " WHERE fcb01 = fcc01 ",
                 "   AND fcc03 = faj02 ",
                 "   AND fcbconf !='X' ",         #010801增
                 "   AND fcc031= faj022 ",
                 "   AND ",tm.wc CLIPPED
      CASE
        WHEN tm.a = '1' LET l_sql = l_sql clipped," AND fcc20 = '3' "
        WHEN tm.a = '2' LET l_sql = l_sql clipped," AND fcc20 = '5' "
        WHEN tm.a = '3' LET l_sql = l_sql clipped," AND fcc20 IN ('3','5') " #No:7660
        OTHERWISE EXIT CASE
      END CASE
      #-->合併資料
      IF tm.b = '2' THEN
         LET l_sql = l_sql clipped," AND fcc04 IN ('1','2') "
      END IF
      #-->處份是否包含
      IF tm.d = 'N' THEN
         LET l_sql = l_sql clipped," AND faj43 NOT IN ('5','6')"
      END IF
 
     PREPARE afar710_prepare1 FROM l_sql
 
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar710_curs1 CURSOR FOR afar710_prepare1
     #--->附加費用(幣別/抵減率依申請項次)
     LET l_sql = "SELECT fcj_file.*,faj04,faj43,faj45,faj47,faj49,faj51",
                 " FROM fcj_file,faj_file " ,
                 " WHERE fcj01 = ?  AND fcj02 = ? ",
                 "   AND fcj03 = faj02 ",
                 "   AND fcj031= faj022 "
      IF tm.d = 'N' THEN
         LET l_sql = l_sql clipped," AND faj43 NOT IN ('5','6')"
      END IF
 
     PREPARE afar710_prepare2 FROM l_sql
 
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar710_curs2 CURSOR FOR afar710_prepare2
 
 
#    CALL cl_outnam('afar710') RETURNING l_name       #NO.FUN-850013
     IF tm.c = '3' THEN
        LET l_name2=l_name
        LET l_name2[11,11]='x'
     ELSE 
        LET l_name2= l_name
     END IF
 
     IF tm.c matches'[13]' THEN
#       START REPORT afar710_rep TO l_name   #No.FUN-850013
        LET g_pageno = 0
     END IF
     IF tm.c matches'[23]' THEN
#       START REPORT afar710_rep2 TO l_name2 #No.FUN-850013
        LET g_pageno = 0
     END IF
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file           #No.CHI-6A0004 l_azi-->t_azi
      WHERE azi01=sr.fcc14
     DELETE FROM r710_temp
     DELETE FROM r710_temp2
     FOREACH afar710_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.fcc14) THEN LET sr.fcc14 = ' ' END IF
       IF tm.c matches '[13]' THEN
          IF tm.b = '1' THEN
           # LET sr.cost1 = sr.fcc23                    #原幣值
           # LET sr.cost2 = sr.fcc24                    #本幣值
           # LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
           # LET sr.qty   = sr.fcc21                    #數量
             LET sr.cost1 = sr.fcc13                    #原幣值
             LET sr.cost2 = sr.fcc16                    #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
             LET sr.qty   = sr.fcc09                    #數量
          ELSE
           # LET sr.cost1 = sr.fcc13                    #原幣值
           # LET sr.cost2 = sr.fcc16                    #本幣值
           # LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
           # LET sr.qty   = sr.fcc09                    #數量
             LET sr.cost1 = sr.fcc23                    #原幣值
             LET sr.cost2 = sr.fcc24                    #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
             LET sr.qty   = sr.fcc21                    #數量
          END IF
          #-->依申請號+抵減率+幣別
          INSERT INTO r710_temp
               VALUES(sr.fcb04,sr.fcc15,sr.fcc14,sr.cost1,sr.cost2,sr.cost3)
          IF SQLCA.sqlcode THEN
             UPDATE r710_temp SET cost1=cost1 + sr.cost1,
                                  cost2=cost2 + sr.cost2,
                                  cost3=cost3 + sr.cost3
                          WHERE fcb04 = sr.fcb04
                            AND fcc15 = sr.fcc15
                            AND fcc14 = sr.fcc14
          END IF
#         OUTPUT TO REPORT afar710_rep(sr.*)    #NO.FUN-850013
#No.FUN-850013  ---begin
          LET l_name = 'afar710'
          EXECUTE insert_prep USING sr.fcb03,sr.fcb04,sr.fcb05,sr.fcb06,
                                    sr.fcc14,sr.faj43,sr.fcc02,sr.fcc03,
                                    sr.fcc031,sr.fcc15,sr.faj04,sr.fcc06,
                                    sr.fcc05,sr.fcc08,sr.faj47,sr.faj45,
                                    sr.faj51,sr.faj49,sr.qty,sr.cost1,
                                    sr.cost2,sr.cost3,t_azi03,t_azi04,
                                    t_azi05
#No.FUN-850013  -- end
       END IF
       #--->附加費用
       IF tm.c matches '[23]' AND sr.fcc04 matches '[12]' THEN
          FOREACH afar710_curs2
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
             LET sr.fcc14  = sr2.fcj.fcj10  #幣別
             LET sr.fcc05  = sr2.fcj.fcj04  #中文名稱
             LET sr.fcc06  = sr2.fcj.fcj05  #英文名稱
             LET sr.fcc08  = sr2.fcj.fcj08  #廠商名稱
             LET sr.fcc09  = sr2.fcj.fcj06  #數量
             LET sr.fcc21  = sr2.fcj.fcj06  #數量
             LET sr.fcc13  = sr2.fcj.fcj09  #原幣成本
             LET sr.fcc16  = sr2.fcj.fcj11  #本幣成本
             LET sr.fcc23  = sr2.fcj.fcj09  #合併前原幣
             LET sr.fcc24  = sr2.fcj.fcj11  #合併前原幣
             LET sr.qty   = sr2.fcj.fcj06   #數量
             LET sr.cost1 = sr2.fcj.fcj09   #原幣值
             LET sr.cost2 = sr2.fcj.fcj11   #本幣值
             LET sr.cost3 = sr.cost2 * (sr.fcc15/100)   #抵減額
 
             # 附加費用部份, 帶其對應的資產資料 ..
             LET sr.faj04 = sr2.faj04
             LET sr.faj43 = sr2.faj43
             LET sr.faj45 = sr2.faj45
             LET sr.faj47 = sr2.faj47
             LET sr.faj49 = sr2.faj49
             LET sr.faj51 = sr2.faj51
 
             #-->依申請號+抵減率+幣別
             INSERT INTO r710_temp2
                  VALUES(sr.fcb04,sr.fcc15,sr.fcc14,sr.cost1,sr.cost2,sr.cost3)
             IF SQLCA.sqlcode THEN
                UPDATE r710_temp2 SET cost1=cost1 + sr.cost1,
                                      cost2=cost2 + sr.cost2,
                                      cost3=cost3 + sr.cost3
                             WHERE fcb04 = sr.fcb04
                               AND fcc15 = sr.fcc15
                               AND fcc14 = sr.fcc14
             END IF
#No.FUN-850013  ---begin
          LET l_name = 'afar710'
          EXECUTE insert_prep USING sr.fcb03,sr.fcb04,sr.fcb05,sr.fcb06,
                                    sr.fcc14,sr.faj43,sr.fcc02,sr.fcc03,
                                    sr.fcc031,sr.fcc15,sr.faj04,sr.fcc06,
                                    sr.fcc05,sr.fcc08,sr.faj47,sr.faj45,
                                    sr.faj51,sr.faj49,sr.qty,sr.cost1,
                                    sr.cost2,sr.cost3,t_azi03,t_azi04,
                                    t_azi05
#No.FUN-850013  -- end
#            OUTPUT TO REPORT afar710_rep2(sr.*)          #NO.FUN-850013
          END FOREACH
       END IF
     END FOREACH
 
     IF tm.c matches'[13]' THEN
#       FINISH REPORT afar710_rep       #No.FUN-850013
     END IF
####TQC-960374 --Begin
  ## IF tm.c matches'[23]' THEN
# ##    FINISH REPORT afar710_rep2      #No.FUN-850013
  ##   #No.+366 010705 plum
  ##    LET l_cmd = "chmod 777 ", l_name2
  ##    RUN l_cmd
  ##   #No.+366..end
  ## END IF
  ## IF tm.c = '3' THEN
  ##    LET l_sql='cat ',l_name2,'>> ',l_name     
  ##    RUN l_sql
  ## END IF
####TQC-960374 --End
#No.FUN-850013 ----begin
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'fcb04,fcb06,fcc14,fcc15,fcb03,fcb05,fcb01')                                                                       
              RETURNING tm.wc                                                                                                       
    END IF 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
     LET g_str = tm.wc,";",g_azi04 
     CALL cl_prt_cs3('afar710',l_name,l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-850013 ----end 
END FUNCTION
 
#EPORT afar710_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#         sr               RECORD fcc01  LIKE fcc_file.fcc01, #單號
#                                 fcc02  LIKE fcc_file.fcc02, #項次
#                                 fcc03  LIKE fcc_file.fcc03, #財編
#                                 fcc031 LIKE fcc_file.fcc031,#附號
#                                 fcc04  LIKE fcc_file.fcc04, #合併碼
#                                 fcc05  LIKE fcc_file.fcc05, #中文名稱
#                                 fcc06  LIKE fcc_file.fcc06, #英文名稱
#                                 fcc08  LIKE fcc_file.fcc08, #廠商名稱
#                                 fcc09  LIKE fcc_file.fcc09, #數量
#                                 fcc21  LIKE fcc_file.fcc21, #數量
#                                 fcc14  LIKE fcc_file.fcc14, #幣別
#                                 fcc15  LIKE fcc_file.fcc15, #抵減率
#                                 fcc13  LIKE fcc_file.fcc13, #原幣成本
#                                 fcc16  LIKE fcc_file.fcc16, #本幣成本
#                                 fcc23  LIKE fcc_file.fcc23, #合併前原幣
#                                 fcc24  LIKE fcc_file.fcc24, #      本幣
#                                 fcb03  LIKE fcb_file.fcb03, #管理局核准日
#                                 fcb04  LIKE fcb_file.fcb04, #    文號
#                                 fcb05  LIKE fcb_file.fcb05, #國稅局核准日
#                                 fcb06  LIKE fcb_file.fcb06, #    文號
#                                 faj04  LIKE faj_file.faj04, #主類別
#                                 faj43  LIKE faj_file.faj43, #狀態
#                                 faj45  LIKE faj_file.faj45, #帳款編號
#                                 faj47  LIKE faj_file.faj47, #採購單號
#                                 faj49  LIKE faj_file.faj49, #進口編號
#                                 faj51  LIKE faj_file.faj51, #發票號碼
#                                 cost1  LIKE fcc_file.fcc23,
#                                 cost2  LIKE fcc_file.fcc24,
#                                 cost3  LIKE fcc_file.fcc24,
#                                 qty    LIKE fcc_file.fcc21
#                       END RECORD,
#         l_tot            RECORD fcb04  LIKE fcb_file.fcb04, #管理局核准文號
#                                 fcc15  LIKE fcc_file.fcc15, #抵減率
#                                 fcc14  LIKE fcc_file.fcc14, #幣別
#                                 cost1  LIKE fcc_file.fcc13, #原幣金額
#                                 cost2  LIKE fcc_file.fcc16, #本幣金額
#                                 cost3  LIKE fcc_file.fcc16  #抵減額
#                       END RECORD,
#         l_fcc14       LIKE fcc_file.fcc14,
#         l_fcc15       LIKE fcc_file.fcc15,
#         l_cost3       LIKE fcc_file.fcc16,
#          l_azi03       LIKE azi_file.azi03,         #No.CHI-6A0004 mark
#          l_azi04       LIKE azi_file.azi04,         #No.CHI-6A0004 mark
#          l_azi05       LIKE azi_file.azi05,         #No.CHI-6A0004 mark
#         l_sum1,l_sum2,l_sum3,l_amt,l_amt3 LIKE fcc_file.fcc16,
#         l_str,l_str2,l_str3  STRING
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.fcb03,sr.fcb04,sr.fcc02
# FORMAT
#  PAGE HEADER
#     IF g_pageno = 1 THEN
#        PRINT '~x0;'
#        PRINT                  #No.TQC-780033
#     ELSE
#        PRINT
#     END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#           g_x[47],g_x[48],g_x[49],g_x[50]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#     BEFORE GROUP OF sr.fcb04
#     PRINT COLUMN g_c[31],sr.fcb03 clipped,
#           COLUMN g_c[32],sr.fcb04,
#           COLUMN g_c[33],sr.fcb05 clipped,
#           COLUMN g_c[34],sr.fcb06;
 
#     ON EVERY ROW
#        SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file           #No.CHI-6A0004 l_azi-->t_azi
#         WHERE azi01=sr.fcc14
#
#        IF sr.faj43 matches '[56]' THEN
#           LET l_str3 = '*',sr.fcc02 USING '###&'
#        ELSE
#           LET l_str3 = sr.fcc02 USING '###&'
#        END IF
#        LET l_str = sr.fcc03,' ',sr.fcc031
#        LET l_str2 = sr.fcc15 USING '##&','%'
#        PRINT COLUMN g_c[35],l_str3 USING '###&',#FUN-590118          #項次
#              COLUMN g_c[36],sr.faj04,                                #類別
#              COLUMN g_c[37],l_str,                                   #財編
#              COLUMN g_c[38],sr.fcc06,                                #英文名稱
#              COLUMN g_c[39],sr.fcc05,                                #中文名稱
#              COLUMN g_c[40],sr.fcc08,                                #廠商名稱
#              COLUMN g_c[41],sr.faj47,                                #採購單號
#              COLUMN g_c[42],sr.faj45,                                #帳款編號
#              COLUMN g_c[43],sr.faj51,                                #發票號碼
#              COLUMN g_c[44],sr.faj49,                                #進口編號
#              COLUMN g_c[45],cl_numfor(sr.qty,45,0),                  #數量
#              COLUMN g_c[46],sr.fcc14,                                #幣別
#              COLUMN g_c[47],cl_numfor(sr.cost1,47,t_azi04) CLIPPED,  #原幣值         #No.CHI-6A0004 l_azi-->t_azi
#              COLUMN g_c[48],cl_numfor(sr.cost2,48,g_azi04) CLIPPED,  #本幣值
#              COLUMN g_c[49],l_str2,                                  #抵減率
#              COLUMN g_c[50],cl_numfor(sr.cost3,50,g_azi04)  CLIPPED  #抵減額
 
#     AFTER GROUP OF sr.fcb04    #小計
#       DECLARE r710_tot CURSOR FOR SELECT * FROM r710_temp
#                        WHERE fcb04 = sr.fcb04  #管理局核准文號
#                          ORDER BY fcc15,fcc14
#       PRINT g_dash2[1,g_len]
#       PRINT column g_c[45],g_x[10] CLIPPED;
#       FOREACH r710_tot INTO l_tot.*
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('r710_tot:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         LET l_str2 = l_tot.fcc15 USING '##&','%'
#         PRINT COLUMN g_c[46],l_tot.fcc14,
#               COLUMN g_c[47],cl_numfor(l_tot.cost1,47,t_azi05) CLIPPED,  #原幣值     #No.CHI-6A0004 l_azi-->t_azi
#               COLUMN g_c[48],cl_numfor(l_tot.cost2,48,g_azi05) CLIPPED,  #本幣值
#               COLUMN g_c[49],l_str2,
#               COLUMN g_c[50],cl_numfor(l_tot.cost3,50,g_azi05) CLIPPED   #抵減值
#       END FOREACH
 
#  ON LAST ROW
#      PRINT g_dash2[1,g_len]
#      PRINT COLUMN g_c[45],g_x[11] CLIPPED;
#      DECLARE r710_tot2  CURSOR FOR
#         SELECT fcc14,fcc15,SUM(cost1),SUM(cost2),SUM(cost3)
#           FROM r710_temp
#           GROUP BY fcc15,fcc14
#           ORDER BY fcc15,fcc14
#       LET l_amt = 0  LET l_amt3 = 0
#       FOREACH r710_tot2 INTO l_fcc14,l_fcc15,l_sum1,l_sum2,l_sum3
#          IF SQLCA.sqlcode != 0 THEN
#             CALL cl_err('r710_tot2:',SQLCA.sqlcode,1)
#             EXIT FOREACH
#          END IF
#          LET l_str2 = l_fcc15 USING '##&','%'
#          PRINT COLUMN g_c[46],l_fcc14 ,
#                COLUMN g_c[47],cl_numfor(l_sum1,47,t_azi05) CLIPPED,  #原幣值      #No.CHI-6A0004 l_azi-->t_azi
#                COLUMN g_c[48],cl_numfor(l_sum2,48,g_azi05) CLIPPED,  #本幣值
#                COLUMN g_c[49],l_str2,
#                COLUMN g_c[50],cl_numfor(l_sum3,50,g_azi05) CLIPPED   #抵減額
#          #-->總計(依本幣)
#          LET l_amt = l_amt + l_sum2
#          LET l_amt3 = l_amt3 + l_sum3
#        END FOREACH
#        #--->列印總計
#        PRINT g_dash2[1,g_len]
#        PRINT COLUMN g_c[45],g_x[12],
#              COLUMN g_c[48],cl_numfor(l_amt, 48,g_azi05) CLIPPED, #本幣值
#              COLUMN g_c[50],cl_numfor(l_amt3,50,g_azi05) CLIPPED  #抵減額
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     PRINT '~i;'       #No.TOC-780033
 
#  PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
#ND REPORT
#--------------------------附加費用----------------------------------
REPORT afar710_rep2(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr               RECORD fcc01  LIKE fcc_file.fcc01, #單號
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
                                  faj04  LIKE faj_file.faj04, #主類別
                                  faj43  LIKE faj_file.faj43, #狀態
                                  faj45  LIKE faj_file.faj45, #帳款編號
                                  faj47  LIKE faj_file.faj47, #採購單號
                                  faj49  LIKE faj_file.faj49, #進口編號
                                  faj51  LIKE faj_file.faj51, #發票號碼
                                  cost1  LIKE fcc_file.fcc23,
                                  cost2  LIKE fcc_file.fcc24,
                                  cost3  LIKE fcc_file.fcc24,
                                  qty    LIKE fcc_file.fcc21
                        END RECORD,
          l_tot            RECORD fcb04  LIKE fcb_file.fcb04, #管理局核准文號
                                  fcc15  LIKE fcc_file.fcc15, #抵減率
                                  fcc14  LIKE fcc_file.fcc14, #幣別
                                  cost1  LIKE fcc_file.fcc13, #原幣金額
                                  cost2  LIKE fcc_file.fcc16, #本幣金額
                                  cost3  LIKE fcc_file.fcc16  #抵減額
                        END RECORD,
          l_fcc14       LIKE fcc_file.fcc14,
          l_fcc15       LIKE fcc_file.fcc15,
#          l_azi03       LIKE azi_file.azi03,               #No.CHI-6A0004 mark
#          l_azi04       LIKE azi_file.azi04,               #No.CHI-6A0004 mark
#          l_azi05       LIKE azi_file.azi05,               #No.CHI-6A0004 mark
          l_sum1,l_sum2,l_sum3,l_amt,l_amt3 LIKE fcc_file.fcc16,
          l_str,l_str2,l_str3  STRING
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.fcb03,sr.fcb04,sr.fcc02
  FORMAT
   PAGE HEADER
      IF g_pageno=1 THEN
         PRINT '~x0;'   
      ELSE
         PRINT
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)+1,g_x[9]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.fcb04
      PRINT COLUMN g_c[31],sr.fcb03 clipped,
            COLUMN g_c[32],sr.fcb04,
            COLUMN g_c[33],sr.fcb05 clipped,
            COLUMN g_c[34],sr.fcb06;
 
      ON EVERY ROW
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file      #No.CHI-6A0004 l_azi-->t_azi
         WHERE azi01=sr.fcc14
         IF sr.faj43 matches '[56]' THEN
            LET l_str3 = '*',sr.fcc02 USING '###&'
         ELSE
            LET l_str3 = sr.fcc02 USING '###&'
         END IF
         LET l_str = sr.fcc03,' ',sr.fcc031
         LET l_str2 = sr.fcc15 USING '##&','%'
         PRINT COLUMN g_c[35],l_str3,                                 #項次
               COLUMN g_c[36],sr.faj04,                               #類別
               COLUMN g_c[37],l_str,                                  #財編
               COLUMN g_c[38],sr.fcc06,                               #英文名稱
               COLUMN g_c[39],sr.fcc05,                               #中文名稱
               COLUMN g_c[40],sr.fcc08,                               #廠商名稱
               COLUMN g_c[41],sr.faj47,                               #採購單號
               COLUMN g_c[42],sr.faj45,                               #帳款編號
               COLUMN g_c[43],sr.faj51,                               #發票號碼
               COLUMN g_c[44],sr.faj49,                               #進口編號
               COLUMN g_c[45],cl_numfor(sr.qty,45,0),                 #數量
               COLUMN g_c[46],sr.fcc14,                               #幣別
               COLUMN g_c[47],cl_numfor(sr.cost1,47,t_azi04) CLIPPED, #原幣值   #No.CHI-6A0004 l_azi-->t_azi
               COLUMN g_c[48],cl_numfor(sr.cost2,48,g_azi04) CLIPPED, #本幣值
               COLUMN g_c[49],l_str2,                                 #抵減率
               COLUMN g_c[50],cl_numfor(sr.cost3,50,g_azi04)  CLIPPED #抵減額
 
      AFTER GROUP OF sr.fcb04    #小計
        DECLARE r7102_tot CURSOR FOR SELECT * FROM r710_temp2
                         WHERE fcb04 = sr.fcb04  #管理局核准文號
                           ORDER BY fcc15,fcc14
        PRINT g_dash2[1,g_len]
        PRINT column g_c[45],g_x[10] CLIPPED;
        FOREACH r7102_tot INTO l_tot.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r710_tot:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_str2 = l_tot.fcc15 USING '##&','%'
          PRINT COLUMN g_c[46],l_tot.fcc14,
                COLUMN g_c[47],cl_numfor(l_tot.cost1,47,g_azi05) CLIPPED, #原幣值
                COLUMN g_c[48],cl_numfor(l_tot.cost2,48,g_azi05) CLIPPED, #本幣值
                COLUMN g_c[49],l_str2,
                COLUMN g_c[50],cl_numfor(l_tot.cost3,50,g_azi05) CLIPPED  #抵減值
        END FOREACH
 
   ON LAST ROW
       PRINT g_dash2[1,g_len]
       PRINT COLUMN g_c[45],g_x[11] CLIPPED;
       DECLARE r7102_tot2  CURSOR FOR
          SELECT fcc14,fcc15,SUM(cost1),SUM(cost2),SUM(cost3)
            FROM r710_temp2
            GROUP BY fcc15,fcc14
            ORDER BY fcc15,fcc14
        LET l_amt = 0  LET l_amt3 = 0
        FOREACH r7102_tot2 INTO l_fcc14,l_fcc15,l_sum1,l_sum2,l_sum3
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('r710_tot2:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_str2 = l_fcc15 USING '##&','%'
           PRINT COLUMN g_c[46],l_fcc14 ,
                 COLUMN g_c[47],cl_numfor(l_sum1,47,g_azi05) CLIPPED,  #原幣值
                 COLUMN g_c[48],cl_numfor(l_sum2,48,g_azi05) CLIPPED,  #本幣值
                 COLUMN g_c[49],l_str2,
                 COLUMN g_c[50],cl_numfor(l_sum3,50,g_azi05) CLIPPED   #抵減額
           #-->總計(依本幣)
           LET l_amt = l_amt + l_sum2
           LET l_amt3 = l_amt3 + l_sum3
         END FOREACH
         #--->列印總計
         PRINT g_dash2[1,g_len]
         PRINT COLUMN g_c[45],g_x[12],
               COLUMN g_c[48],cl_numfor(l_amt, 48,g_azi05) CLIPPED, #本幣值
               COLUMN g_c[50],cl_numfor(l_amt3,50,g_azi05) CLIPPED  #抵減額
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      PRINT '~i;'
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
END REPORT
#MOD-720124
#FUN-870144
