# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar420.4gl
# Desc/riptions...: 固定資產折舊費用兩期比較明細表(稅簽)
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No:No.FUN-580010 05/08/12 wujie   報表轉xml
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720045 07/04/11 By TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,                 # 資料年度       #No.FUN-680070 SMALLINT
                mm      LIKE type_file.num5,                 # 資料月份       #No.FUN-680070 SMALLINT
                yy1     LIKE type_file.num5,                 # 比較年度       #No.FUN-680070 SMALLINT
                m1      LIKE type_file.num5,                 # 比較月份       #No.FUN-680070 SMALLINT
                difcost LIKE type_file.num5,                 # 差異金額大於       #No.FUN-680070 SMALLINT
                s       LIKE type_file.chr3,                  # Order by sequence       #No.FUN-680070 VARCHAR(3)
                t       LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
                c       LIKE type_file.chr3,                  # subtotal       #No.FUN-680070 VARCHAR(3)
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt   #No.FUN-680070 VARCHAR(15)
#DEFINE   g_dash          LIKE type_file.chr1000  #Dash line                #No.FUN-580010       #No.FUN-680070 VARCHAR(400)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#DEFINE   g_len           LIKE type_file.num5     #Report width(79/132/136)                #No.FUN-580010       #No.FUN-680070 SMALLINT
#DEFINE   g_pageno        LIKE type_file.num5     #Report page no                #No.FUN-580010       #No.FUN-680070 SMALLINT
#DEFINE   g_zz05          LIKE type_file.chr1     #Print tm.wc ?(Y/N)                #No.FUN-580010       #No.FUN-680070 VARCHAR(1)
DEFINE l_table     STRING                        ### MOD-720045 add ###
DEFINE g_sql       STRING                        ### MOD-720045 add ###
DEFINE g_str       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> MOD-720045 *** ##
  LET g_sql = "fab02.fab_file.fab02,",           
         "fao06.fao_file.fao06," ,         
         "faj02.faj_file.faj02," ,        
         "faj022.faj_file.faj022,",       
         "faj04.faj_file.faj04," ,        
         "faj05.faj_file.faj05," ,        
         "faj06.faj_file.faj06," ,        
         "faj26.faj_file.faj26,",
         "faj07.faj_file.faj07," ,      
         "faj64.faj_file.faj64," ,
         "cost.fao_file.fao14,",
         "acct_d.fao_file.fao14,",
         "curr_val.fao_file.fao14,",
         "curr_val2.fao_file.fao14,",
         "curr_1.fao_file.fao14,",
         "curr_2.fao_file.fao14,",
         "diff.fao_file.fao14,",
         "g_azi03.azi_file.azi03,",
         "g_azi04.azi_file.azi04,",
         "g_azi05.azi_file.azi05 " 
 LET l_table = cl_prt_temptable('afar420',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF# Temp Table產生
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
             "        ?,?,?,?,?, ?,?,?,?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
 END IF
 #------------------------------ CR (1) ------------------------------#
 
 
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.yyyy= ARG_VAL(9)
   LET tm.mm  = ARG_VAL(10)
   LET tm.yy1 = ARG_VAL(11)   #TQC-610055
   LET tm.m1  = ARG_VAL(12)
   LET tm.difcost = ARG_VAL(13)
   LET tm.s   = ARG_VAL(14)
   LET tm.t   = ARG_VAL(15)
   LET tm.c   = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r420_tm(0,0)            # Input print condition
      ELSE CALL afar420()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r420_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r420_w AT p_row,p_col WITH FORM "afa/42f/afar420"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '16'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.difcost = 0
   LET tm.yyyy = g_faa.faa07
   LET tm.mm   = g_faa.faa08
   LET tm.yy1  = g_faa.faa07
   LET tm.m1   = g_faa.faa08
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
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   LET tm2.u3   = tm.c[3,3]
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
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj022,faj06
         #No.FUN-890122 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-890122 ---end---
 
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
 
         #No.FUN-890122 --start--
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r420_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      CONSTRUCT BY NAME tm.wc2 ON fao06
         #No.FUN-890122 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
 
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
 
         #No.FUN-890122 --start--
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r420_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME
            tm.yyyy,tm.mm,tm.yy1,tm.m1,tm.difcost,
            tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.more
            WITHOUT DEFAULTS
         #No.FUN-890122 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
            END IF
         AFTER FIELD m1
            IF cl_null(tm.m1) OR tm.m1<1 OR tm.m1>12 THEN
               NEXT FIELD m1
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()        # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.c = tm2.u1,tm2.u2,tm2.u3
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
         #No.FUN-890122 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-890122 ---end---
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r420_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar420'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar420','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",
                        " '",tm.yyyy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.yy1  CLIPPED,"'",
                        " '",tm.m1   CLIPPED,"'",
                        " '",tm.difcost CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar420',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r420_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar420()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r420_w
END FUNCTION
 
FUNCTION afar420()
   DEFINE l_name        LIKE type_file.chr20,                 # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0069
          l_sql         LIKE type_file.chr1000,               # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,               #No.FUN-680070 VARCHAR(40)
          l_str2        LIKE type_file.chr50,                 #No.FUN-580010                   #No.FUN-680070 VARCHAR(50)
          l_order       ARRAY[6] OF LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07,    #英文名稱
                               faj26  LIKE faj_file.faj26,    #入帳日期
                               faj64  LIKE faj_file.faj64     #耐用年限
                        END RECORD,
          sr2           RECORD
                               type      LIKE type_file.chr1,    #年度       #No.FUN-680070 VARCHAR(1)
                               fao03     LIKE fao_file.fao03,    #年度
                               fao04     LIKE fao_file.fao04,    #月份
                               fao05     LIKE fao_file.fao05,    #分攤方式
                               fao06     LIKE fao_file.fao06,    #部門
                               gem02     LIKE gem_file.gem02,    #部門名稱
                               fao07     LIKE fao_file.fao07,    #折舊金額
                               fao14     LIKE fao_file.fao14,    #成本
                               fao15     LIKE fao_file.fao15,    #累折
                               pre_d     LIKE fao_file.fao15,    #前期折舊
                               curr_d    LIKE fao_file.fao15,    #本期折舊
                               curr      LIKE fao_file.fao15,    #本月折舊
                               curr_val  LIKE fao_file.fao15,    #帳面價值
                               curr_val2 LIKE fao_file.fao15,    #No.CHI-480001
                               fao17     LIKE fao_file.fao17     #No.CHI-480001
                        END RECORD
   #str MOD-720045 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720045 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar420'
     #No.CHI-480001
     IF g_aza.aza26 = '2' THEN
        LET g_len = 215
     ELSE
        LET g_len = 199
     END IF
     #end
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','',",
                 "faj02,faj022,faj04,faj05,faj06,faj07,faj26,faj64 ",
                 " FROM faj_file",
                 " WHERE ",tm.wc
     PREPARE r420_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r420_cs1 CURSOR FOR r420_prepare1
 
     #--->取每筆資產本年度月份折舊(資料年月)
     LET l_sql = " SELECT '1',fao03, fao04, fao05, fao06, gem02, fao07,",
                 " fao14, fao15,0,fao08,0,0,0,fao17 ",    #No.CHI-480001
                 " FROM fao_file ,OUTER gem_file",
                 " WHERE fao_file.fao06=gem_file.gem02 ",
                 "   AND fao01 = ? AND fao02 = ? ",
                 "   AND fao03 = ", tm.yyyy," AND fao04=",tm.mm ,
                 "   AND ",tm.wc2
 
     PREPARE r420_prefao  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r420_csfao CURSOR FOR r420_prefao
 
     #--->取每筆資產本年度月份折舊(比較年月)
     LET l_sql = " SELECT '2',fao03, fao04, fao05, fao06, gem02, fao07,",
                 "  fao14, fao15,0,fao08,0,0,0,fao17 ",     #No.CHI-480001
                 " FROM fao_file ,OUTER gem_file",
                 " WHERE fao_file.fao06=gem_file.gem02 ",
                 "   AND fao01 = ? AND fao02 = ? " ,
                 "   AND fao03 = ", tm.yy1," AND fao04=",tm.m1,
                 "   AND ",tm.wc2
 
     PREPARE r420_prefao2  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r420_csfao2 CURSOR FOR r420_prefao2
 
     LET l_str2=tm.yy1 using '####'
     START REPORT r420_rep TO 'afar420' 
     LET g_pageno = 0
     FOREACH r420_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       #--->篩選部門(資料年月)
       FOREACH r420_csfao
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r420_csfao:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fao07) THEN LET sr2.fao07 = 0 END IF
          #--->本月折舊
          LET sr2.curr = sr2.fao07
          #--->前期折舊 = (累折 - 前期折舊)
          LET sr2.pre_d   = sr2.fao15 - sr2.curr_d
          #--->帳面價值 = (成本 - 本期折舊 - 前期折舊)
          LET sr2.curr_val = sr2.fao14-sr2.fao15
          #No.CHI-480001
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.curr_val2 = sr2.curr_val - sr2.fao17
          #end
           FOR g_i = 1 TO 3
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[13]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[09]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                          LET g_descripe[g_i]=g_x[10]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                          LET g_descripe[g_i]=g_x[14]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
                                          LET g_descripe[g_i]=g_x[11]
                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fao06
                                          LET g_descripe[g_i]=g_x[12]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          OUTPUT TO REPORT r420_rep(sr.*,sr2.*)
       END FOREACH
 
       #--->篩選部門(比較年月)
       FOREACH r420_csfao2
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r420_csfao:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fao07) THEN LET sr2.fao07 = 0 END IF
          LET sr2.curr = sr2.fao07
           FOR g_i = 1 TO 3
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[13]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[09]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                          LET g_descripe[g_i]=g_x[10]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                          LET g_descripe[g_i]=g_x[14]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
                                          LET g_descripe[g_i]=g_x[11]
                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fao06
                                          LET g_descripe[g_i]=g_x[12]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          OUTPUT TO REPORT r420_rep(sr.*,sr2.*)
       END FOREACH
 
    END FOREACH
 
     FINISH REPORT r420_rep
 
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> MOD-720045 **** ##
LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080
#是否列印選擇條件
IF g_zz05 = 'Y' THEN
   CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06')
        RETURNING tm.wc
   LET g_str = tm.wc
END IF
    LET g_str = g_str ,";",tm.s,";",tm.t,";" ,tm.c,";",
                           tm.yyyy,";",tm.mm,";",tm.yy1,";",tm.m1 
#LET g_str = g_str CLIPPED,";",tm.yy1,";",tm.m1
IF g_aza.aza26 = '2' THEN
   CALL cl_prt_cs3('afar420','afar420',l_sql,g_str)
ELSE 
   CALL cl_prt_cs3('afar420','afar420_1',l_sql,g_str)
END IF 
#------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
REPORT r420_rep(sr,sr2)
   DEFINE l_last_sw     LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr50,                #No.FUN-680070 VARCHAR(50)
          sr            RECORD order1  LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(20)
                               order2  LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(20)
                               order3  LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(20)
                               faj02 LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,  #附號
                               faj04 LIKE faj_file.faj04,    #主類別
                               faj05 LIKE faj_file.faj05,    #次類別
                               faj06 LIKE faj_file.faj06,    #中文名稱
                               faj07 LIKE faj_file.faj07,    #英文名稱
                               faj26 LIKE faj_file.faj26,    #入帳日期
                               faj64 LIKE faj_file.faj64     #耐用年限
                        END RECORD,
          sr2           RECORD
                               type      LIKE type_file.chr1,    #1/2       #No.FUN-680070 VARCHAR(1)
                               fao03     LIKE fao_file.fao03,    #年度
                               fao04     LIKE fao_file.fao04,    #月份
                               fao05     LIKE fao_file.fao05,    #分攤方式
                               fao06     LIKE fao_file.fao06,    #部門
                               gem02     LIKE gem_file.gem02,    #部門名稱
                               fao07     LIKE fao_file.fao07,    #折舊金額
                             # fao09     LIKE fao_file.fao09,    #被攤部門
                               fao14     LIKE fao_file.fao14,    #成本
                               fao15     LIKE fao_file.fao15,    #累折
                               pre_d     LIKE fao_file.fao15,    #前期折舊
                               curr_d    LIKE fao_file.fao15,    #本期折舊
                               curr      LIKE fao_file.fao15,    #本月折舊
                               curr_val  LIKE fao_file.fao15,    #帳面價值
                               curr_val2 LIKE fao_file.fao15,    #No.CHI-480001
                               fao17     LIKE fao_file.fao17     #No.CHI-480001
                        END RECORD,
           l_fab02                   LIKE fab_file.fab02,
           l_difcost                 LIKE fao_file.fao14,
           l_cost                    LIKE fao_file.fao14,
           l_pre_d                   LIKE fao_file.fao14,
           l_curr_d                  LIKE fao_file.fao14,
           l_acct_d                   LIKE fao_file.fao14,
           l_curr_1                   LIKE fao_file.fao14,
           l_curr_2                   LIKE fao_file.fao14,
           l_curr_val,l_tot1_curr_val LIKE fao_file.fao14,
           l_diff                     LIKE fao_file.fao14
  DEFINE   l_curr_val2,l_tot1_curr_val2       LIKE fao_file.fao14,  #No.CHI-480001
           l_tot2_curr_val2,l_tot3_curr_val2  LIKE fao_file.fao14   #No.CHI-480001
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.faj02,sr.faj022
  FORMAT
   PAGE HEADER
   AFTER GROUP OF sr.faj022
      #-->主類別名稱
      SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
      IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
      #-->成本
        LET  l_cost  = GROUP SUM(sr2.fao14)  WHERE sr2.type = '1'
        IF cl_null(l_cost) THEN LET l_cost = 0 END IF
      #-->前期折舊
        LET  l_pre_d = GROUP SUM(sr2.pre_d)  WHERE sr2.type = '1'
        IF cl_null(l_pre_d) THEN LET l_pre_d = 0 END IF
      #-->本期折舊
        LET  l_curr_d = GROUP SUM(sr2.curr_d)  WHERE sr2.type = '1'
        IF cl_null(l_curr_d) THEN LET l_curr_d = 0 END IF
      #-->累積折舊
        LET  l_acct_d = l_pre_d + l_curr_d
      #-->本月折舊(資料年月)(比較年月)
        LET  l_curr_1  = GROUP SUM(sr2.curr)  WHERE sr2.type = '1'
        IF cl_null(l_curr_1) THEN LET l_curr_1 = 0 END IF
        LET  l_curr_2  = GROUP SUM(sr2.curr)  WHERE sr2.type = '2'
        IF cl_null(l_curr_2) THEN LET l_curr_2 = 0 END IF
        LET  l_diff = l_curr_1 - l_curr_2
        IF l_diff < 0
        THEN LET l_difcost = l_diff * -1
        ELSE LET l_difcost = l_diff
        END IF
      #-->帳面價值
       LET l_curr_val=GROUP SUM(sr2.curr_val) WHERE sr2.type = '1'
      #-->資產淨額
       LET l_curr_val2=GROUP SUM(sr2.curr_val2) WHERE sr2.type = '1'
      IF cl_null(l_cost) THEN LET l_cost = 0 END IF 
      IF cl_null(l_acct_d) THEN LET l_acct_d = 0 END IF 
      IF cl_null(l_curr_val) THEN LET l_curr_val = 0 END IF 
      IF cl_null(l_curr_val2) THEN LET l_curr_val2 = 0 END IF 
      IF cl_null(l_curr_1) THEN LET l_curr_1 = 0 END IF 
      IF cl_null(l_curr_2) THEN LET l_curr_2 = 0 END IF 
      IF cl_null(l_diff) THEN LET l_diff = 0 END IF 
      IF l_difcost >= tm.difcost THEN
          EXECUTE insert_prep USING 
             l_fab02     , sr2.fao06,  sr.faj02,  sr.faj022, sr.faj04 , 
             sr.faj05    , sr.faj06 , sr.faj26 , sr.faj07 ,  sr.faj64, 
             l_cost      , l_acct_d, l_curr_val  , l_curr_val2, l_curr_1,
             l_curr_2    , l_diff   , g_azi03     , g_azi04  ,  g_azi05
         END IF
   ON LAST ROW
 
   PAGE TRAILER
END REPORT
#Patch....NO.TQC-610035 <> #
