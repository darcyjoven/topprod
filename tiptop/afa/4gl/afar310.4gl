# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar310.4gl
# Desc/riptions...: 固定資產折舊費用兩期比較彙總表
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No.CHI-480001 04/08/16 By Danny  新增大陸版報表段(減值準備)
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.FUN-5B0008 05/11/04 By Sarah 新增資料抓取fan_file開帳資料(fan041='1' OR fan041='0')
# Modify.........: No.TQC-610106 06/01/20 By Smapmin 成本欄位依金額方式取位
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: NO.MOD-720045 07/03/29 By TSD.Jack  Crystal Report修改
# Modify.........: No.MOD-740044 07/04/13 By Smapmin 比較年月顯示有誤
# Modify.........: No.MOD-810060 08/01/16 By Smapmin 修改抓取部門名稱WHERE條件
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80100 10/08/12 By Dido 累折計算增加多部門分攤條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,                 # 資料年度       #No.FUN-680070 SMALLINT
                mm      LIKE type_file.num5,                 # 資料月份       #No.FUN-680070 SMALLINT
                yy1     LIKE type_file.num5,                 # 比較年度       #No.FUN-680070 SMALLINT
                m1      LIKE type_file.num5,                 # 比較月份       #No.FUN-680070 SMALLINT
                difcost LIKE type_file.num5,                 # 差異金額大於       #No.FUN-680070 SMALLINT
                a       LIKE type_file.chr1,                  #       #No.FUN-680070 VARCHAR(1)
                s       LIKE type_file.chr3,                  # Order by sequence       #No.FUN-680070 VARCHAR(3)
                t       LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
                c       LIKE type_file.chr3,                  # subtotal       #No.FUN-680070 VARCHAR(3)
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt   #No.FUN-680070 VARCHAR(15)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_head1         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
#No.FUN-580010  --end
#070329 Add By TSD.Jack -----(S)-----
DEFINE   l_table     STRING 
DEFINE   g_sql       STRING 
DEFINE   g_str       STRING 
#070329 Add By TSD.Jack -----(E)-----
 
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
   #MOD-720045 --add
   #070329 Add By TSD.Jack ------(S)------
   LET g_sql = "order1.faj_file.faj06,",    
               "order2.faj_file.faj06, ", 
               "faj02.faj_file.faj02,  ",    #財編
               "faj022.faj_file.faj022,",    #附號
               "faj04.faj_file.faj04,  ",    #主類別
               "faj05.faj_file.faj05,  ",    #次類別
               "faj06.faj_file.faj06,  ",    #中文名稱
               "faj07.faj_file.faj07,  ",    #英文名稱
               "type.type_file.chr1,   ",    
               "fan03.fan_file.fan03,  ",    #年度
               "fan04.fan_file.fan04,  ",    #月份
               "fan05.fan_file.fan05,  ",    #分攤方式
               "fan06.fan_file.fan06,  ",    #部門
               "fan07.fan_file.fan07,  ",    #折舊金額
               "fan09.fan_file.fan09,  ",    #被攤部門
               "fan14.fan_file.fan14,  ",    #成本
               "fan15.fan_file.fan15,  ",    #累折
               "pre_d.fan_file.fan15,  ",    #前期折舊
               "curr_d.fan_file.fan15, ",    #本期折舊
               "curr.fan_file.fan15,   ",    #本月折舊
               "curr_val.fan_file.fan15,",   #帳面價值
               "curr_val2.fan_file.fan15,",
               "fan17.fan_file.fan17,   ",
               "fab02.fab_file.fab02,   ",
               "gem02.gem_file.gem02,   ",
               "azi03.azi_file.azi03,   ",
               "azi04.azi_file.azi04,   ",
               "azi05.azi_file.azi05    "
 
   LET l_table = cl_prt_temptable('afar310',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #070329 Add By TSD.Jack ------(E)------
   #MOD-720045 --end 
 
 
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
   LET tm.a   = ARG_VAL(14)
   LET tm.s   = ARG_VAL(15)
   LET tm.t   = ARG_VAL(16)
   LET tm.c   = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r310_tm(0,0)            # Input print condition
      ELSE CALL afar310()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r310_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r310_w AT p_row,p_col WITH FORM "afa/42f/afar310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.a    = '1'
   LET tm.s    = '12'
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
         LET INT_FLAG = 0 CLOSE WINDOW r310_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      CONSTRUCT BY NAME tm.wc2 ON fan06
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
         LET INT_FLAG = 0 CLOSE WINDOW r310_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME
            tm.yyyy,tm.mm,tm.yy1,tm.m1,tm.difcost,tm.a,
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
         LET INT_FLAG = 0 CLOSE WINDOW r310_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar310'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar310','9031',1)
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
                        " '",tm.a CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar310',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r310_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar310()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r310_w
END FUNCTION
 
FUNCTION afar310()
   DEFINE l_name        LIKE type_file.chr20,                 # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0069
          l_sql         LIKE type_file.chr1000,               # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,               #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF   LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07     #英文名稱
                        END RECORD,
          sr2           RECORD
                               type      LIKE type_file.chr1,    #年度       #No.FUN-680070 VARCHAR(1)
                               fan03     LIKE fan_file.fan03,    #年度
                               fan04     LIKE fan_file.fan04,    #月份
                               fan05     LIKE fan_file.fan05,    #分攤方式
                               fan06     LIKE fan_file.fan06,    #部門
                               fan07     LIKE fan_file.fan07,    #折舊金額
                               fan09     LIKE fan_file.fan09,    #被攤部門
                               fan14     LIKE fan_file.fan14,    #成本
                               fan15     LIKE fan_file.fan15,    #累折
                               pre_d     LIKE fan_file.fan15,    #前期折舊
                               curr_d    LIKE fan_file.fan15,    #本期折舊
                               curr      LIKE fan_file.fan15,    #本月折舊
                               curr_val  LIKE fan_file.fan15,    #帳面價值
                               curr_val2 LIKE fan_file.fan15,    #No.CHI-480001
                               fan17     LIKE fan_file.fan17     #No.CHI-480001
                        END RECORD
     DEFINE l_i,l_cnt         LIKE type_file.num5         #No.FUN-680070 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02
     #070329 Add BY TSD.Jack -----(S)-----
     DEFINE l_fab02           LIKE fab_file.fab02,
            l_gem02           LIKE gem_file.gem02 
 
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar310'
     #070329 Add BY TSD.Jack -----(E)-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
 
     LET l_sql = "SELECT '','',faj02,faj022,faj04,faj05,faj06,faj07 ",
                 " FROM faj_file",
                 " WHERE ",tm.wc
     PREPARE r310_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r310_cs1 CURSOR FOR r310_prepare1
 
     #--->取每筆資產本年度月份折舊(資料年月)
     LET l_sql = " SELECT '1',fan03, fan04, fan05, fan06,  fan07,",
                 " fan09, fan14, fan15,0,fan08,0,0,0,fan17 ",  #No.CHI-480001
                 " FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                #"   AND fan041 = '1'",                      #FUN-5B0008 mark
                 "   AND (fan041 = '1' OR fan041 = '0') ",   #FUN-5B0008
                 "   AND ",tm.wc2
     CASE
       WHEN tm.a = '1' #--->分攤前
        LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
       WHEN tm.a = '2' #--->分攤後
        LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
       OTHERWISE EXIT CASE
     END CASE
     PREPARE r310_prefan  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r310_csfan CURSOR FOR r310_prefan
 
     #--->取每筆資產本年度月份折舊(比較年月)
     LET l_sql = " SELECT '2',fan03, fan04, fan05, fan06, fan07,",
                 " fan09, fan14, fan15,0,fan08,0,0,0,fan17 ",    #No.CHI-480001
                 " FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yy1," AND fan04=",tm.m1,
                #"   AND fan041 = '1'",                      #FUN-5B0008 mark
                 "   AND (fan041 = '1' OR fan041 = '0') ",   #FUN-5B0008
                 "   AND ",tm.wc2
     CASE
       WHEN tm.a = '1' #--->分攤前
        LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
       WHEN tm.a = '2' #--->分攤後
        LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
       OTHERWISE EXIT CASE
     END CASE
 
     PREPARE r310_prefan2  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r310_csfan2 CURSOR FOR r310_prefan2
 
    #070329 Marked By TSD.Jack -----(S)-----
    #CALL cl_outnam('afar310') RETURNING l_name
 
#No.FUN-580010 --start
    #IF g_aza.aza26 = '2' THEN
    #   LET g_zaa[41].zaa06 = "N"
    #ELSE
    #   LET g_zaa[41].zaa06 = "Y"
    #END IF
    #CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
    #START REPORT r310_rep TO l_name
    #070329 Marked By TSD.Jack -----(E)-----
     LET g_pageno = 0
 
     FOREACH r310_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       #--->篩選部門(資料年月)
       FOREACH r310_csfan
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r310_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
          #--->本月折舊
          LET sr2.curr = sr2.fan07
          IF cl_null(sr2.curr) THEN LET sr2.curr = 0 END IF
##1999/07/22 Modify By Sophia
          SELECT SUM(fan15),SUM(fan17)                  #No.CHI-480001
            INTO sr2.fan15,sr2.fan17   FROM fan_file
           WHERE fan01 = sr.faj02
             AND fan02 = sr.faj022
             AND fan03 = sr2.fan03
             AND fan04 = sr2.fan04
             AND fan06 = sr2.fan06                               #MOD-A80100
          IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
          IF cl_null(sr2.fan17) THEN LET sr2.fan17 = 0 END IF    #No.CHI-480001
##----------------------------
          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d   = sr2.fan15 - sr2.curr_d
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          #--->帳面價值 = (成本 - 累折)
          LET sr2.curr_val = sr2.fan14-sr2.fan15
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          #No.CHI-480001
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.curr_val2 = sr2.curr_val - sr2.fan17
          IF cl_null(sr2.curr_val2) THEN LET sr2.curr_val2 = 0 END IF
          #end
           FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[15]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[16]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          #070329 Modify By TSD.Jack ------(S)------
         #OUTPUT TO REPORT r310_rep(sr.*,sr2.*)   #070329 Marked By TSD.Jack
 
          #-->主類別名稱
          SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
          IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
          #-->部門名稱
          #SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.faj04   #MOD-810060
          SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr2.fan06   #MOD-810060
          IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
 
          EXECUTE insert_prep USING
                  sr.order1,sr.order2,sr.faj02,sr.faj022,
                  sr.faj04,sr.faj05,sr.faj06,sr.faj07,
                  sr2.type,sr2.fan03,sr2.fan04,sr2.fan05,sr2.fan06,sr2.fan07,
                  sr2.fan09,sr2.fan14,sr2.fan15,sr2.pre_d,sr2.curr_d,sr2.curr,
                  sr2.curr_val,sr2.curr_val2,sr2.fan17,
                  l_fab02,l_gem02,g_azi03,g_azi04,g_azi05 
         #070329 Modify By TSD.Jack ------(E)------
       END FOREACH
 
       #--->篩選部門(比較年月)
       FOREACH r310_csfan2
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r310_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
          LET sr2.curr = sr2.fan07
           FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[15]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[16]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                          LET g_descripe[g_i]=g_x[17]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                          LET g_descripe[g_i]=g_x[21]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
                                          LET g_descripe[g_i]=g_x[18]
                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fan06
                                          LET g_descripe[g_i]=g_x[19]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
        #070329 Modify By TSD.Jack ------(S)------
        # OUTPUT TO REPORT r310_rep(sr.*,sr2.*)
 
         #-->主類別名稱
         SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
         IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
         #-->部門名稱
         #SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.faj04   #MOD-810060
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr2.fan06   #MOD-810060
         IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
 
         EXECUTE insert_prep USING
                 sr.order1,sr.order2,sr.faj02,sr.faj022,
                 sr.faj04,sr.faj05,sr.faj06,sr.faj07,
                 sr2.type,sr2.fan03,sr2.fan04,sr2.fan05,sr2.fan06,sr2.fan07,
                 sr2.fan09,sr2.fan14,sr2.fan15,sr2.pre_d,sr2.curr_d,sr2.curr,
                 sr2.curr_val,sr2.curr_val2,sr2.fan17,
                 l_fab02,l_gem02,g_azi03,g_azi04,g_azi05 
        #070329 Modify By TSD.Jack ------(E)------
       END FOREACH
    END FOREACH
 
    #070329 Add By TSD.Jack --------(S)-------
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06')
            RETURNING tm.wc
       CALL cl_wcchp(tm.wc2,'fan06')
            RETURNING tm.wc2
       LET g_str = tm.wc CLIPPED,' ',tm.wc2
    ELSE
       LET g_str = " "
    END IF 
 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
 
    #            p1          p2          p3        p4         p5
    LET g_str = g_str,";",tm.yyyy,";",tm.mm,";",tm.yy1,";",tm.m1,";",
    #                        p6          p7            p8       
                          tm.difcost,";",tm.s[1,1],";",tm.s[2,2],";",
    #                        p9          p10         
                          tm.t,";",tm.c
    CALL cl_prt_cs3('afar310','afar310',g_sql,g_str)
    #070329 Add By TSD.Jack --------(E)-------
 
    #070329 Marked By TSD.Jack ----(S)----
    #FINISH REPORT r310_rep   
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #070329 Marked By TSD.Jack ----(E)----
END FUNCTION
 
#070329 Marked By TSD.Jack  ---------(S)---------
{
REPORT r310_rep(sr,sr2)
   DEFINE l_last_sw     LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr1000,               #No.FUN-680070 VARCHAR(40)
          sr            RECORD order1 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07     #英文名稱
                        END RECORD,
          sr2           RECORD
                               type      LIKE type_file.chr1,    #1/2       #No.FUN-680070 VARCHAR(1)
                               fan03     LIKE fan_file.fan03,    #年度
                               fan04     LIKE fan_file.fan04,    #月份
                               fan05     LIKE fan_file.fan05,    #分攤方式
                               fan06     LIKE fan_file.fan06,    #部門
                               fan07     LIKE fan_file.fan07,    #折舊金額
                               fan09     LIKE fan_file.fan09,    #被攤部門
                               fan14     LIKE fan_file.fan14,    #成本
                               fan15     LIKE fan_file.fan15,    #累折
                               pre_d     LIKE fan_file.fan15,    #前期折舊
                               curr_d    LIKE fan_file.fan15,    #本期折舊
                               curr      LIKE fan_file.fan15,    #本月折舊
                               curr_val  LIKE fan_file.fan15,    #帳面價值
                               curr_val2 LIKE fan_file.fan15,    #No.CHI-480001
                               fan17     LIKE fan_file.fan17     #No.CHI-480001
                        END RECORD,
          l_fab02                      LIKE fab_file.fab02,
          l_gem02                      LIKE gem_file.gem02,
          l_difcost                    LIKE fan_file.fan14,
          l_cost,l_tot_cost            LIKE fan_file.fan14,
          l_pre_d,l_tot_pre_d          LIKE fan_file.fan14,
          l_curr_d,l_tot_curr_d        LIKE fan_file.fan14,
          l_curr_1,l_tot_curr_1        LIKE fan_file.fan14,
          l_curr_2,l_tot_curr_2        LIKE fan_file.fan14,
          l_curr_val,l_tot_curr_val    LIKE fan_file.fan14,
          l_diff,l_tot_diff            LIKE fan_file.fan14
  DEFINE  l_curr_val2,l_tot_curr_val2  LIKE fan_file.fan17      #No.CHI-480001
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.faj04,sr2.fan06  #主類別/部門
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED    #No.TQC-6A0085
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=tm.yyyy USING '####',g_x[23] CLIPPED,tm.mm USING '##',g_x[24] CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1 CLIPPED))/2)+1 ,g_head1 CLIPPED   #No.TQC-6A0085
      #LET g_zaa[36].zaa08 = tm.yy1 USING '&&&&','/',tm.mm USING '&&',g_x[11] CLIPPED   #MOD-740044
      LET g_zaa[36].zaa08 = tm.yy1 USING '&&&&','/',tm.m1 USING '&&',g_x[11] CLIPPED   #MOD-740044
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41]
      PRINT g_dash1
      #No.CHI-480001
      LET l_last_sw = 'n'
#No.FUN-580010  --end
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_tot_cost     = 0
      LET l_tot_curr_1   = 0
      LET l_tot_curr_2   = 0
      LET l_tot_diff     = 0
      LET l_tot_pre_d    = 0
      LET l_tot_curr_d   = 0
      LET l_tot_curr_val = 0
      LET l_tot_curr_val2= 0         #No.CHI-480001
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   AFTER GROUP OF sr2.fan06  #部門
      #-->主類別名稱
      SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
      IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
      #-->部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.faj04
      IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
      #-->成本
        LET  l_cost  = GROUP SUM(sr2.fan14)  WHERE sr2.type = '1'
        IF cl_null(l_cost) THEN LET l_cost = 0 END IF
      #-->前期折舊
        LET  l_pre_d = GROUP SUM(sr2.pre_d)  WHERE sr2.type = '1'
        IF cl_null(l_pre_d) THEN LET l_pre_d = 0 END IF
      #-->本期折舊
        LET  l_curr_d= GROUP SUM(sr2.curr_d) WHERE sr2.type = '1'
        IF cl_null(l_curr_d) THEN LET l_curr_d = 0 END IF
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
        IF cl_null(l_curr_val) THEN LET l_curr_val = 0 END IF
        #No.CHI-480001
        #-->資產淨額
        LET l_curr_val2=GROUP SUM(sr2.curr_val2) WHERE sr2.type = '1'
        IF cl_null(l_curr_val2) THEN LET l_curr_val2 = 0 END IF
        #end
        IF l_difcost >= tm.difcost THEN
           PRINT
#No.FUN-580010  --start
           COLUMN  g_c[31],l_fab02[1,8],
           COLUMN  g_c[32],sr2.fan06,
           COLUMN  g_c[33],l_gem02,
           COLUMN  g_c[34],cl_numfor(l_cost,34,g_azi04),      #成本    #TQC-610106
           COLUMN  g_c[35],cl_numfor(l_curr_1,35,g_azi04),    #本月折舊(資料年月)
           COLUMN  g_c[36],cl_numfor(l_curr_2,36,g_azi04),    #本月折舊(比較年月)
           COLUMN  g_c[37],cl_numfor(l_diff,37,g_azi04),      #差異
           COLUMN  g_c[38],cl_numfor(l_pre_d,38,g_azi04),     #前期折舊
           COLUMN  g_c[39],cl_numfor(l_curr_d,39,g_azi04),    #本期折舊
           #No.CHI-480001
           COLUMN  g_c[40],cl_numfor(l_curr_val,40,g_azi04), #帳面價值
           COLUMN  g_c[41],cl_numfor(l_curr_val2,41,g_azi04)  #資產淨額
#No.FUN-580010  --end
           #end
           
           LET l_tot_cost     = l_tot_cost   + l_cost
           LET l_tot_curr_1   = l_tot_curr_1 + l_curr_1
           LET l_tot_curr_2   = l_tot_curr_2 + l_curr_2
           LET l_tot_diff     = l_tot_diff   + l_diff
           LET l_tot_pre_d    = l_tot_pre_d  + l_pre_d
           LET l_tot_curr_d   = l_tot_curr_d  + l_curr_d
           LET l_tot_curr_val = l_tot_curr_val  + l_curr_val
           LET l_tot_curr_val2= l_tot_curr_val2 + l_curr_val2    #No.CHI-480001
         END IF
 
   AFTER GROUP OF sr.order1
      IF tm.c[1,1] = 'Y'  THEN
         PRINTX name=S1
#No.FUN-580010  --start
           COLUMN  g_c[31], g_descripe[1],
           COLUMN  g_c[34],cl_numfor(l_tot_cost,34,g_azi05),   #成本
           COLUMN  g_c[35],cl_numfor(l_tot_curr_1,35,g_azi05), #本月折舊(資料年月)
           COLUMN  g_c[36],cl_numfor(l_tot_curr_2,36,g_azi05), #本月折舊(比較年月)
           COLUMN  g_c[37],cl_numfor(l_tot_diff,37,g_azi05),   #差異
           COLUMN  g_c[38],cl_numfor(l_tot_pre_d,38,g_azi05),  #前期折舊
           COLUMN  g_c[39],cl_numfor(l_tot_curr_d,39,g_azi05), #本期折舊
           COLUMN  g_c[40],cl_numfor(l_tot_curr_val,40,g_azi05),  #帳面價值
           COLUMN  g_c[41],cl_numfor(l_tot_curr_val2,41,g_azi05)  #資產淨額
#No.FUN-580010  --end
           #end
         PRINT
       END IF
 
   AFTER GROUP OF sr.order2
      IF tm.c[2,2] = 'Y'  THEN
         PRINTX name=S2
#No.FUN-580010  --start
           COLUMN  g_c[31],g_descripe[2],
           COLUMN  g_c[34],cl_numfor(l_tot_cost,34,g_azi05),   #成本
           COLUMN  g_c[35],cl_numfor(l_tot_curr_1,35,g_azi05), #本月折舊(資料年月)
           COLUMN  g_c[36],cl_numfor(l_tot_curr_2,36,g_azi05), #本月折舊(比較年月)
           COLUMN  g_c[37],cl_numfor(l_tot_diff,37,g_azi05),   #差異
           COLUMN  g_c[38],cl_numfor(l_tot_pre_d,38,g_azi05),  #前期折舊
           COLUMN  g_c[39],cl_numfor(l_tot_curr_d,39,g_azi05), #本期折舊
           COLUMN  g_c[40],cl_numfor(l_tot_curr_val,40,g_azi05),  #帳面價值
           COLUMN  g_c[41],cl_numfor(l_tot_curr_val2,41,g_azi05)  #資產淨額
#No.FUN-580010  --end
           #end
         PRINT ' '
       END IF
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,310
         THEN
              PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
              #IF tm.wc[001,120] > ' ' THEN                      # for 132
              #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,310] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[241,310] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610035 <> #
}
#070329 Marked By TSD.Jack  ---------(E)---------
