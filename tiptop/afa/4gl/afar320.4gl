# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afar320.4gl
# Desc/riptions...: 固定資產折舊費用兩期比較明細表
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No:7661 03/07/18 By Wiky 列印的英文名稱改為中文名稱
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-580010 05/08/02 By vivien  憑証類報表轉XML
# Modify.........: No.FUN-5B0008 05/11/04 By Sarah 新增資料抓取fan_file開帳資料(fan041='1' OR fan041='0')
# Modify.........: No.TQC-610106 06/01/20 By Smapmin 成本欄位依金額方式取位
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720045 07/04/10 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
# Modify.........: No.MOD-960093 09/06/06 By Sarah 資料年月或比較年月若沒有fan_file資料時,報表的成本、累計折舊金額等欄位會錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40084 10/04/20 By Carrier 赋初值
# Modify.........: No:MOD-AB0127 10/11/12 By Dido tm.a 應改變 fan05 條件 
# Modify.........: No:MOD-B90090 11/09/13 By Carrier pcntfan增加tm.wc2的条件
# Modify.........: NO.CHI-CA0063 12/11/02 By Belle 修改折舊金額計算方式
# Modify.........: No:FUN-C90088 12/12/18 By Belle  列印年限需有回溯功能
# Modify.........: NO.CHI-CB0023 13/01/30 By Lori 固資有調整帳時應併入一起計算
 
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
 
DEFINE tm         RECORD                           # Print condition RECORD
                   wc      STRING,                 # Where condition
                   wc2     STRING,                 # Where condition
                   yyyy    LIKE type_file.num5,    # 資料年度           #No.FUN-680070 SMALLINT
                   mm      LIKE type_file.num5,    # 資料月份           #No.FUN-680070 SMALLINT
                   yy1     LIKE type_file.num5,    # 比較年度           #No.FUN-680070 SMALLINT
                   m1      LIKE type_file.num5,    # 比較月份           #No.FUN-680070 SMALLINT
                   difcost LIKE type_file.num5,    # 差異金額大於       #No.FUN-680070 SMALLINT
                   a       LIKE type_file.chr1,                         #No.FUN-680070 VARCHAR(1)
                   s       LIKE type_file.chr3,    # Order by sequence  #No.FUN-680070 VARCHAR(3)
                   t       LIKE type_file.chr3,    # Eject sw           #No.FUN-680070 VARCHAR(3)
                   c       LIKE type_file.chr3,    # subtotal           #No.FUN-680070 VARCHAR(3)
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
                  END RECORD 
DEFINE g_descripe ARRAY[3] OF LIKE type_file.chr20 # Report Heading & prompt  #No.FUN-680070 VARCHAR(15)
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose          #No.FUN-680070 SMALLINT
DEFINE g_head1    LIKE type_file.chr1000  #No.FUN-680070 VARCHAR(400)
#No.FUN-580010  --end
DEFINE l_table    STRING                  ### MOD-720045 ###
DEFINE g_str      STRING                  ### MOD-720045 ###
DEFINE g_sql      STRING                  ### MOD-720045 ###
DEFINE g_bdate    LIKE type_file.dat      #MOD-960093 add
DEFINE g_edate    LIKE type_file.dat      #MOD-960093 add
DEFINE g_fap661   LIKE fap_file.fap661    #MOD-960093 add
DEFINE g_fap10    LIKE fap_file.fap10     #MOD-960093 add
DEFINE g_fap54_7  LIKE fap_file.fap54     #MOD-960093 add
DEFINE g_fap561   LIKE fap_file.fap56     #MOD-960093 add
DEFINE g_fap57    LIKE fap_file.fap57     #MOD-960093 add
 
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
 
   #str FUN-720045 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
   LET g_sql = "faj02.faj_file.faj02,",    #財編
               "faj022.faj_file.faj022,",  #附號
               "faj04.faj_file.faj04,",    #主類別
               "faj05.faj_file.faj05,",    #次類別
               "faj06.faj_file.faj06,",    #中文名稱
               "faj07.faj_file.faj07,",    #英文名稱
               "faj26.faj_file.faj26,",    #入帳日期
               "faj29.faj_file.faj29,",    #耐用年限
               "type.type_file.chr1,",     #No.FUN-680070 VARCHAR(1)
               "fan03.fan_file.fan03,",    #年度
               "fan04.fan_file.fan04,",    #月份
               "fan05.fan_file.fan05,",    #分攤方式
               "fan06.fan_file.fan06,",    #部門
               "gem02.gem_file.gem02,",    #部門名稱
               "fan07.fan_file.fan07,",    #折舊金額
               "fan09.fan_file.fan09,",    #被攤部門
               "l_cost.fan_file.fan14,", 
               "l_acct_d.fan_file.fan14,", 
               "l_curr_val.fan_file.fan14,",
               "l_curr_val2.fan_file.fan14,",
               "l_curr_1.fan_file.fan14,",
               "l_curr_2.fan_file.fan14,",
               "l_diff.fan_file.fan14,",
               "l_fab02.fab_file.fab02,",
               "g_azi04.azi_file.azi04,",
               "g_azi05.azi_file.azi05 " 
 
   LET l_table = cl_prt_temptable('afar320',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720045 add
 
   LET g_pdate  = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
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
      THEN CALL r320_tm(0,0)            # Input print condition
      ELSE CALL afar320()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r320_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r320_w AT p_row,p_col WITH FORM "afa/42f/afar320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.a    = '1'
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
         LET INT_FLAG = 0 CLOSE WINDOW r320_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r320_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r320_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar320'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar320','9031',1)
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
            CALL cl_cmdat('afar320',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r320_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar320()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r320_w
END FUNCTION
 
FUNCTION afar320()
   DEFINE l_name        LIKE type_file.chr20,            # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#         l_time        LIKE type_file.chr8              #No.FUN-6A0069
         #l_sql         LIKE type_file.chr1000,          # RDSQL STATEMENT                #No.FUN-680070 CHAR(1000) #MOD-AB0127 mark
          l_sql         STRING,                          #MOD-AB0127
          l_chr         LIKE type_file.chr1,             #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,          #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE faj_file.faj06, #No.FUN-680070 VARCHAR(20)
          l_i,l_cnt     LIKE type_file.num5,             #No.FUN-680070 SMALLINT
          l_zaa02       LIKE zaa_file.zaa02,
          l_fab02       LIKE fab_file.fab02,
          l_cnt1,l_cnt2 LIKE type_file.num5,             #MOD-960093 add
          l_fan06       LIKE fan_file.fan06,     #部門   #MOD-AB0127
          sr            RECORD
                         order1 LIKE faj_file.faj06,     #No.FUN-680070 VARCHAR(20)
                         order2 LIKE faj_file.faj06,     #No.FUN-680070 VARCHAR(20)
                         order3 LIKE faj_file.faj06,     #No.FUN-680070 VARCHAR(20)
                         faj02  LIKE faj_file.faj02,     #財編
                         faj022 LIKE faj_file.faj022,    #附號
                         faj04  LIKE faj_file.faj04,     #主類別
                         faj05  LIKE faj_file.faj05,     #次類別
                         faj06  LIKE faj_file.faj06,     #中文名稱
                         faj07  LIKE faj_file.faj07,     #英文名稱
                         faj26  LIKE faj_file.faj26,     #入帳日期
                         faj29  LIKE faj_file.faj29,     #耐用年限
                         faj14  LIKE faj_file.faj14,     #本幣成本          #MOD-960093 add
                         faj141 LIKE faj_file.faj141,    #調整成本          #MOD-960093 add
                         faj59  LIKE faj_file.faj59,     #銷帳成本          #MOD-960093 add
                         faj32  LIKE faj_file.faj32,     #累積折舊          #MOD-960093 add
                         faj101 LIKE faj_file.faj101,    #已提列減值準備    #MOD-960093 add
                         faj34  LIKE faj_file.faj34,     #折畢再提          #MOD-960093 add
                         faj20  LIKE faj_file.faj20,     #保管部門          #MOD-960093 add
                         faj23  LIKE faj_file.faj23,     #分攤方式          #MOD-960093 add
                         faj24  LIKE faj_file.faj24      #分攤部門/分攤類別 #MOD-960093 add
                        END RECORD,
          sr2           RECORD
                         type   LIKE type_file.chr1,     #年度       #No.FUN-680070 VARCHAR(1)
                         fan03  LIKE fan_file.fan03,     #年度
                         fan04  LIKE fan_file.fan04,     #月份
                         fan05  LIKE fan_file.fan05,     #分攤方式
                         fan06  LIKE fan_file.fan06,     #部門
                         gem02  LIKE gem_file.gem02,     #部門名稱
                         fan07  LIKE fan_file.fan07,     #折舊金額
                         fan09  LIKE fan_file.fan09,     #被攤部門
                         fan14  LIKE fan_file.fan14,     #成本
                         fan15  LIKE fan_file.fan15,     #累折
                         pre_d  LIKE fan_file.fan15,     #前期折舊
                         curr_d LIKE fan_file.fan15,     #本期折舊
                         curr   LIKE fan_file.fan15,     #本月折舊
                         curr_val LIKE fan_file.fan15,   #帳面價值
                         curr_val2 LIKE fan_file.fan15,  #No.CHI-480001
                         fan17  LIKE fan_file.fan17      #No.CHI-480001
                        END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720045 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720045 add ###
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CALL s_azn01(tm.yyyy,tm.mm) RETURNING g_bdate,g_edate   #MOD-960093 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT '','','',",
               "       faj02,faj022,faj04,faj05,faj06,faj07,faj26,faj29 ",
               "      ,faj14,faj141,faj59,faj32,faj101,faj34,faj20,faj23,faj24 ",   #MOD-960093 add
               "  FROM faj_file",
               " WHERE ",tm.wc
   PREPARE r320_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE r320_cs1 CURSOR FOR r320_prepare1
 
#str MOD-960093 mark
#  #--->取每筆資產本年度月份折舊(資料年月)
#  LET l_sql = " SELECT '1',fan03,fan04,fan05,fan06,gem02,fan07,",
#              "        fan09,fan14,fan15,0,fan08,0,0,0,fan17 ", #No.CHI-480001
#              "  FROM fan_file ,OUTER gem_file",
#              " WHERE fan_file.fan06=gem_file.gem02 ",
#              "   AND fan01 = ? AND fan02 = ? ",
#              "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
#             #"   AND fan041= '1'",                   #FUN-5B0008 mark
#              "   AND (fan041='1' OR fan041='0') ",   #FUN-5B0008
#              "   AND ",tm.wc2
#  CASE
#     WHEN tm.a = '1' #--->分攤前
#        LET l_sql = l_sql clipped ," AND fan05 != '3' " CLIPPED
#     WHEN tm.a = '2' #--->分攤後
#        LET l_sql = l_sql clipped ," AND fan05 != '2' " CLIPPED
#     OTHERWISE EXIT CASE
#  END CASE
  #-MOD-AB0127-add-
   #--->取每筆分攤資產折舊
   LET l_sql = " SELECT fan06 ",
               "  FROM fan_file ",
               " WHERE fan01 = ? AND fan02 = ? ",
               "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
               "   AND (fan041='1' OR fan041='0') ",   
               "   AND fan05 = '3' ", 
               "   AND ",tm.wc2
   PREPARE r320_prefan  FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r320_csfan CURSOR FOR r320_prefan
  #-MOD-AB0127-end-
#
#  #--->取每筆資產本年度月份折舊(比較年月)
#  LET l_sql = " SELECT '2',fan03,fan04,fan05,fan06,gem02,fan07,",
#              "        fan09,fan14,fan15,0,fan08,0,0,0,fan17 ", #No.CHI-480001
#              " FROM fan_file ,OUTER gem_file",
#              " WHERE fan_file.fan06=gem_file.gem02 ",
#              "   AND fan01 = ? AND fan02 = ? ",
#              "   AND fan03 = ", tm.yy1," AND fan04=",tm.m1,
#             #"   AND fan041= '1'",                   #FUN-5B0008 mark
#              "   AND (fan041='1' OR fan041='0') ",   #FUN-5B0008
#              "   AND ",tm.wc2
#  CASE
#     WHEN tm.a = '1' #--->分攤前
#        LET l_sql = l_sql clipped ," AND fan05 != '3' " CLIPPED
#     WHEN tm.a = '2' #--->分攤後
#        LET l_sql = l_sql clipped ," AND fan05 != '2' " CLIPPED
#     OTHERWISE EXIT CASE
#  END CASE
#  PREPARE r320_prefan2  FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
#     EXIT PROGRAM
#  END IF
#  DECLARE r320_csfan2 CURSOR FOR r320_prefan2
#
#  #No.FUN-580010 --start
#  IF g_aza.aza26 = '2' THEN
#     LET g_zaa[41].zaa06 = "N"
#  ELSE
#     LET g_zaa[41].zaa06 = "Y"
#  END IF
#  CALL cl_prt_pos_len()
#  #No.FUN-580010 --end
#
#  LET g_pageno = 0
#  LET l_name = 'afar320.out'
#  START REPORT r320_rep TO l_name
#end MOD-960093 mark
 
   FOREACH r320_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
  #str MOD-960093 add
      LET l_cnt1 = 0   LET l_cnt2 = 0
     #-MOD-AB0127-add-
     #SELECT COUNT(*) INTO l_cnt1 FROM fan_file
     # WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
     #   AND fan03 = tm.yyyy AND fan04 = tm.mm 
     #   AND fan041 IN ('0','1') 
     #   AND fan05 IN ('1','2') 
     #SELECT COUNT(*) INTO l_cnt2 FROM fan_file
     # WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
     #   AND fan03 = tm.yy1 AND fan04 = tm.m1
     #   AND fan041 IN ('0','1') 
     #   AND fan05 IN ('1','2') 
      LET l_sql = " SELECT COUNT(*) ",
                  "  FROM fan_file ",
                  " WHERE fan01 = ? AND fan02 = ? ",
                  "   AND fan03 = ? AND fan04 = ? ",
                  "   AND ",tm.wc2,                     #No.MOD-B90090
                  "   AND (fan041='1' OR fan041='0') " 
      CASE
         WHEN tm.a = '1' #--->分攤前
            LET l_sql = l_sql clipped ," AND fan05 != '3' " CLIPPED
         WHEN tm.a = '2' #--->分攤後
            LET l_sql = l_sql clipped ," AND fan05 != '2' " CLIPPED
         OTHERWISE EXIT CASE
      END CASE
      PREPARE r320_pcntfan  FROM l_sql
      DECLARE r320_cscntfan SCROLL CURSOR FOR r320_pcntfan
      OPEN r320_cscntfan USING sr.faj02,sr.faj022,tm.yyyy,tm.mm
      FETCH r320_cscntfan INTO l_cnt1
      CLOSE r320_cscntfan
      OPEN r320_cscntfan USING sr.faj02,sr.faj022,tm.yy1,tm.m1
      FETCH r320_cscntfan INTO l_cnt2
      CLOSE r320_cscntfan
     #-MOD-AB0127-end-
      IF cl_null(l_cnt1) THEN LET l_cnt1=0 END IF
      IF cl_null(l_cnt2) THEN LET l_cnt2=0 END IF
 
      IF l_cnt1 > 0 OR l_cnt2 > 0  THEN
        #-MOD-AB0127-add-
         IF l_cnt1 > 1 OR l_cnt2 > 1 THEN
            FOREACH r320_csfan USING sr.faj02,sr.faj022 INTO l_fan06 
               CALL afar320_fan(sr.*,l_fan06,'Y')
            END FOREACH
         ELSE
            CALL afar320_fan(sr.*,'','N')
         END IF
        #-MOD-AB0127-end-
      END IF
   END FOREACH
  #end MOD-960093 add
 
#str MOD-960093 mark
#     #--->篩選部門(資料年月)
#     FOREACH r320_csfan USING sr.faj02,sr.faj022 INTO sr2.*
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('r320_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
#        END IF
#        IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
#        #--->本月折舊
#        LET sr2.curr = sr2.fan07
#       ##1999/07/22 Modify By Sophia
#       #SELECT SUM(fan15) INTO sr2.fan15 FROM fan_file
#       # WHERE fan01 = sr.faj02
#       #   AND fan02 = sr.faj022
#       #   AND fan03 = sr2.fan03
#       #   AND fan04 = sr2.fan04
#       #   AND fan05 != '3'
#        IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
#       ##----------------------------
#        #--->前期折舊 = (累折 - 本期折舊)
#        LET sr2.pre_d   = sr2.fan15 - sr2.curr_d
#        #--->帳面價值 = (成本 - 累折)
#        LET sr2.curr_val = sr2.fan14-sr2.fan15
#        #No.CHI-480001
#        #--->資產淨額 = (帳面價值 - 減值準備)
#        LET sr2.curr_val2 = sr2.curr_val - sr2.fan17
#        #end
#        FOR g_i = 1 TO 3
#           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
#                                         LET g_descripe[g_i]=g_x[15]
#                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
#                                         LET g_descripe[g_i]=g_x[16]
#                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#                                         LET g_descripe[g_i]=g_x[18]
#                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
#                                         LET g_descripe[g_i]=g_x[21]
#                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
#                                         LET g_descripe[g_i]=g_x[19]
#                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fan06
#                                         LET g_descripe[g_i]=g_x[20]
#                OTHERWISE                LET l_order[g_i] = '-'
#           END CASE
#        END FOR
#        LET sr.order1 = l_order[1]
#        LET sr.order2 = l_order[2]
#        LET sr.order3 = l_order[3]
#        OUTPUT TO REPORT r320_rep(sr.*,sr2.*)
#     END FOREACH
#
#     #--->篩選部門(比較年月)
#     FOREACH r320_csfan2 USING sr.faj02,sr.faj022 INTO sr2.*
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('r320_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
#        END IF
#        IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
#        LET sr2.curr = sr2.fan07
#        FOR g_i = 1 TO 3
#           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
#                                         LET g_descripe[g_i]=g_x[15]
#                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
#                                         LET g_descripe[g_i]=g_x[16]
#                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#                                         LET g_descripe[g_i]=g_x[18]
#                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
#                                         LET g_descripe[g_i]=g_x[21]
#                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
#                                         LET g_descripe[g_i]=g_x[19]
#                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fan06
#                                         LET g_descripe[g_i]=g_x[20]
#                OTHERWISE                LET l_order[g_i] = '-'
#           END CASE
#        END FOR
#        LET sr.order1 = l_order[1]
#        LET sr.order2 = l_order[2]
#        LET sr.order3 = l_order[3]
#        OUTPUT TO REPORT r320_rep(sr.*,sr2.*)
#     END FOREACH
#  END FOREACH
#  FINISH REPORT r320_rep
#end MOD-960093 mark
 
   #str FUN-720045 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> MOD-720045 **** ##
   LET g_str = '' 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";"
                         ,tm.c,";",tm.yyyy,";",tm.mm,";",tm.yy1,";",tm.m1 
   IF g_aza.aza26 = '2' THEN
      CALL cl_prt_cs3('afar320','afar320_1',l_sql,g_str)   #FUN-710080 modify
   ELSE 
      CALL cl_prt_cs3('afar320','afar320',l_sql,g_str)   #FUN-710080 modify
   END IF 
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720045 add
 
END FUNCTION
 
#str MOD-960093 mark
#REPORT r320_rep(sr,sr2)
#  DEFINE l_last_sw     LIKE type_file.chr1,               #No.FUN-680070 VARCHAR(1)
#         l_str         LIKE type_file.chr50,              #No.FUN-680070 VARCHAR(50)
#         sr            RECORD
#                        order1  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
#                        order2  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
#                        order3  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
#                        faj02   LIKE faj_file.faj02,      #財編
#                        faj022  LIKE faj_file.faj022,     #附號
#                        faj04   LIKE faj_file.faj04,      #主類別
#                        faj05   LIKE faj_file.faj05,      #次類別
#                        faj06   LIKE faj_file.faj06,      #中文名稱
#                        faj07   LIKE faj_file.faj07,      #英文名稱
#                        faj26   LIKE faj_file.faj26,      #入帳日期
#                        faj29   LIKE faj_file.faj29       #耐用年限
#                       END RECORD,
#         sr2           RECORD
#                        type      LIKE type_file.chr1,    #1/2       #No.FUN-680070 VARCHAR(1)
#                        fan03     LIKE fan_file.fan03,    #年度
#                        fan04     LIKE fan_file.fan04,    #月份
#                        fan05     LIKE fan_file.fan05,    #分攤方式
#                        fan06     LIKE fan_file.fan06,    #部門
#                        gem02     LIKE gem_file.gem02,    #部門名稱
#                        fan07     LIKE fan_file.fan07,    #折舊金額
#                        fan09     LIKE fan_file.fan09,    #被攤部門
#                        fan14     LIKE fan_file.fan14,    #成本
#                        fan15     LIKE fan_file.fan15,    #累折
#                        pre_d     LIKE fan_file.fan15,    #前期折舊
#                        curr_d    LIKE fan_file.fan15,    #本期折舊
#                        curr      LIKE fan_file.fan15,    #本月折舊
#                        curr_val  LIKE fan_file.fan15,    #帳面價值
#                        curr_val2 LIKE fan_file.fan15,    #No.CHI-480001
#                        fan17     LIKE fan_file.fan17     #No.CHI-480001
#                       END RECORD,
#         l_fab02                  LIKE fab_file.fab02,
#         l_difcost                LIKE fan_file.fan14,
#         l_cost                   LIKE fan_file.fan14,
#         l_pre_d                  LIKE fan_file.fan14,
#         l_curr_d                 LIKE fan_file.fan14,
#         l_acct_d                 LIKE fan_file.fan14,
#         l_curr_1                 LIKE fan_file.fan14,
#         l_curr_2                 LIKE fan_file.fan14,
#         l_curr_val               LIKE fan_file.fan14,
#         l_tot1_curr_val          LIKE fan_file.fan14,
#         l_diff                   LIKE fan_file.fan14,
#         l_curr_val2              LIKE fan_file.fan14, #No.CHI-480001
#         l_tot1_curr_val2         LIKE fan_file.fan14  #No.CHI-480001
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#
# ORDER BY sr.order1,sr.order2,sr.order3,sr.faj02,sr.faj022
#
# FORMAT
#  PAGE HEADER
#  AFTER GROUP OF sr.faj022
#     #-->主類別名稱
#     SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
#     IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
#
#     #-->成本
#     LET  l_cost  = GROUP SUM(sr2.fan14)  WHERE sr2.type = '1'
#     IF cl_null(l_cost) THEN LET l_cost = 0 END IF
#    
#     #-->前期折舊
#     LET  l_pre_d = GROUP SUM(sr2.pre_d)  WHERE sr2.type = '1'
#     IF cl_null(l_pre_d) THEN LET l_pre_d = 0 END IF
#
#     #-->本期折舊
#     LET  l_curr_d = GROUP SUM(sr2.curr_d)  WHERE sr2.type = '1'
#     IF cl_null(l_curr_d) THEN LET l_curr_d = 0 END IF
#
#     #-->累積折舊
#     LET  l_acct_d = l_pre_d + l_curr_d
#
#     #-->本月折舊(資料年月)(比較年月)
#     LET  l_curr_1  = GROUP SUM(sr2.curr)  WHERE sr2.type = '1'
#     IF cl_null(l_curr_1) THEN LET l_curr_1 = 0 END IF
#     LET  l_curr_2  = GROUP SUM(sr2.curr)  WHERE sr2.type = '2'
#     IF cl_null(l_curr_2) THEN LET l_curr_2 = 0 END IF
#
#     #-->差異(資料年月)(比較年月)
#     LET  l_diff = l_curr_1 - l_curr_2
#     IF l_diff < 0 THEN
#        LET l_difcost = l_diff * -1
#     ELSE
#        LET l_difcost = l_diff
#     END IF
#
#     #-->帳面價值
#     LET l_curr_val=GROUP SUM(sr2.curr_val) WHERE sr2.type = '1'
#
#     #-->資產淨額
#     LET l_curr_val2=GROUP SUM(sr2.curr_val2) WHERE sr2.type = '1'   #No.CHI-480001
#
#     IF l_difcost >= tm.difcost THEN
#        #str FUN-720045 add
#        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> MOD-720045 *** ##
#        EXECUTE insert_prep USING 
#           sr.faj02 ,sr.faj022,sr.faj04 ,sr.faj05  ,sr.faj06   ,
#           sr.faj07 ,sr.faj26 ,sr.faj29 ,sr2.type  ,sr2.fan03  ,
#           sr2.fan04,sr2.fan05,sr2.fan06,sr2.gem02 ,sr2.fan07  ,
#           sr2.fan09,l_cost   ,l_acct_d ,l_curr_val,l_curr_val2,
#           l_curr_1 ,l_curr_2 ,l_diff   ,l_fab02   ,g_azi04    ,
#           g_azi05
#        #------------------------------ CR (3) ------------------------------#
#        #end FUN-720045 add
#     END IF 
#  PAGE TRAILER
#
#END REPORT
#end MOD-960093 mark
 
#str MOD-960093 add
#FUNCTION afar320_fan(sr)                  #MOD-AB0127 mark
FUNCTION afar320_fan(sr,p_fan06,p_flag)    #MOD-AB0127
   DEFINE sr            RECORD
                         order1  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
                         order2  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
                         order3  LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
                         faj02   LIKE faj_file.faj02,      #財編
                         faj022  LIKE faj_file.faj022,     #附號
                         faj04   LIKE faj_file.faj04,      #主類別
                         faj05   LIKE faj_file.faj05,      #次類別
                         faj06   LIKE faj_file.faj06,      #中文名稱
                         faj07   LIKE faj_file.faj07,      #英文名稱
                         faj26   LIKE faj_file.faj26,      #入帳日期
                         faj29   LIKE faj_file.faj29,      #耐用年限
                         faj14   LIKE faj_file.faj14,      #本幣成本
                         faj141  LIKE faj_file.faj141,     #調整成本
                         faj59   LIKE faj_file.faj59,      #銷帳成本
                         faj32   LIKE faj_file.faj32,      #累積折舊
                         faj101  LIKE faj_file.faj101,     #已提列減值準備
                         faj34   LIKE faj_file.faj34,      #折畢再提
                         faj20   LIKE faj_file.faj20,      #保管部門
                         faj23   LIKE faj_file.faj23,      #分攤方式
                         faj24   LIKE faj_file.faj24       #分攤部門/分攤類別
                        END RECORD,
          l_fan03       LIKE fan_file.fan03,   #折舊年度
          l_fan04       LIKE fan_file.fan04,   #折舊月份
          l_curr_1      LIKE fan_file.fan07,   #本月折舊(資料年月)
          l_curr_2      LIKE fan_file.fan07,   #本月折舊(比較年月) 
          l_cost        LIKE fan_file.fan14,   #成本
          l_acct_d      LIKE fan_file.fan15,   #累折
          l_fan17       LIKE fan_file.fan15,   #減值準備
          l_fan06       LIKE fan_file.fan06,
          l_fan07       LIKE fan_file.fan07,
          l_fan09       LIKE fan_file.fan09,
          l_fan14       LIKE fan_file.fan14,
          l_fab02       LIKE fab_file.fab02, 
          l_gem02       LIKE gem_file.gem02, 
          l_type        LIKE type_file.chr1,
          l_diff        LIKE fan_file.fan14,
          l_curr_val    LIKE fan_file.fan14,
          l_curr_val2   LIKE fan_file.fan14,
          l_difcost     LIKE fan_file.fan14, 
          p_fan06       LIKE fan_file.fan06,                #MOD-AB0127
          p_flag        LIKE type_file.chr1,                #MOD-AB0127
          l_sql         STRING                              #MOD-AB0127
   DEFINE l_fan07_sum   LIKE fan_file.fan07                 #CHI-CB0023
   DEFINE l_fan07_sum1  LIKE fan_file.fan07                 #CHI-CB0023
   DEFINE l_fap93       LIKE fap_file.fap93                 #FUN-C90088
   #FUN-C90088--B--
   LET l_sql = " SELECT fap93 FROM fap_file"
              ,"  WHERE fap03 ='9'"
              ,"    AND fap02 = ? AND fap021= ? AND fap04 < ?"
              ,"  ORDER BY fap04 desc"
   PREPARE r320_p01 FROM l_sql
   DECLARE r320_c01 SCROLL CURSOR WITH HOLD FOR r320_p01
   #FUN-C90088--E--
 
   #成本
   #成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-
   #     大於當期(改良)+大於當期(銷帳成本)
   CALL afar320_cal(sr.faj02,sr.faj022)
   LET l_cost=sr.faj14+sr.faj141-sr.faj59-(g_fap661-g_fap10)-g_fap54_7+g_fap561
 
   #本月折舊(資料年月),累計折舊,減值準備
   LET l_curr_1 = 0   LET l_acct_d = 0   LET l_fan17 = 0
  #-MOD-AB0127-add-
   IF p_flag = 'N' THEN
      #SELECT SUM(fan07),SUM(fan15),SUM(fan17)    #CHI-CB0023 mark
      SELECT SUM(fan15),SUM(fan17)                #CHI-CB0023 add
        #INTO l_curr_1,l_acct_d,l_fan17           #CHI-CB0023 mark
        INTO l_acct_d,l_fan17                     #CHI-CB0023 add
        FROM fan_file
       WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
         AND fan03 = tm.yyyy AND fan04 = tm.mm 
        #AND fan041 IN ('0','1')                  #CHI-CB0023 mark
         AND fan05 IN ('1','2') 
#---CHI-CB0023 start-------
      SELECT SUM(fan07)
        INTO l_curr_1
        FROM fan_file
       WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
         AND fan03 = tm.yyyy AND fan04 <= tm.mm
         AND fan05 IN ('1','2')
#---CHI-CB0023 end------
   ELSE
      #LET l_sql = " SELECT fan07,fan14,fan15,fan17 ",    #CHI-CB0023 mark
      LET l_sql = " SELECT fan14,fan17",                  #CHI-CB0023 add
                  "  FROM fan_file ",
                  " WHERE fan01 = ? AND fan02 = ? ",
                  "   AND fan03 = ",tm.yyyy," AND fan04 = ",tm.mm,
                  "   AND (fan041='1' OR fan041='0') ",   
                  "   AND fan05 = '3' ", 
                  "   AND fan06 = ? " 
      PREPARE r320_pfan01  FROM l_sql
      DECLARE r320_cfan01 SCROLL CURSOR FOR r320_pfan01
      OPEN r320_cfan01 USING sr.faj02,sr.faj022,p_fan06
      #FETCH r320_cfan01 INTO l_curr_1,l_cost,l_acct_d,l_fan17     #CHI-CB0023 mark
      FETCH r320_cfan01 INTO l_cost,l_fan17                        #CHI-CB0023 add
      CLOSE r320_cfan01
#---CHI-CB0023 start--
      IF tm.a = '2' THEN
          SELECT SUM(fan07) INTO l_curr_1
            FROM fan_file
            WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
              AND fan03 = tm.yyyy AND fan04 <= tm.mm
              AND fan05 = '3'
              AND fan06 = p_fan06
          SELECT SUM(fan07) INTO l_acct_d
            FROM fan_file
            WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
              AND ((fan03 < tm.yyyy) OR (fan03 = tm.yyyy AND fan04 <= tm.mm))
              AND fan05 = '3'
              AND fan06 = p_fan06
      ELSE
           SELECT fan07,fan15  INTO l_curr_1,l_acct_d
             FROM fan_file
            WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
              AND fan03 = tm.yyyy AND fan04 = tm.mm
              AND (fan041='1' OR fan041='0')
              AND fan05 = '3'
              AND fan06 = p_fan06
      END IF
#---CHI-CB0023 end-----
   END IF  
  #-MOD-AB0127-end-
   IF SQLCA.sqlcode OR cl_null(l_curr_1) THEN
      LET l_fan03 = 0   LET l_fan04 = 0     #No.TQC-A40084
      IF sr.faj34 = 'Y' THEN   #折畢再提,不考慮年度往前抓最後一期折舊年月
        #-MOD-AB0127-add-
         IF p_flag = 'N' THEN
            SELECT MAX(fan03),MAX(fan04) INTO l_fan03,l_fan04 FROM fan_file
             WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
               AND fan03*12+fan04 <= tm.yyyy*12+tm.mm
               AND fan041 IN ('0','1') 
               AND fan05 IN ('1','2')
         ELSE
            LET l_sql = " SELECT MAX(fan03),MAX(fan04) ",
                        "  FROM fan_file ",
                        " WHERE fan01 = ? AND fan02 = ? ",
                        "   AND fan03*12+fan04 <= ",tm.yyyy*12+tm.mm,
                       #"   AND (fan041='1' OR fan041='0') ",                 #CHI-CB0023 mark
                        "   AND fan05 = '3' ", 
                        "   AND fan06 = ? " 
            PREPARE r320_pfan02  FROM l_sql
            DECLARE r320_cfan02 SCROLL CURSOR FOR r320_pfan02
            OPEN r320_cfan02 USING sr.faj02,sr.faj022,p_fan06
            FETCH r320_cfan02 INTO l_fan03,l_fan04 
            CLOSE r320_cfan02
         END IF
        #-MOD-AB0127-end-
      ELSE                    #無折畢再提,抓當年最後一期折舊年月
        #-MOD-AB0127-add-
         IF p_flag = 'N' THEN
            SELECT MAX(fan03),MAX(fan04) INTO l_fan03,l_fan04 FROM fan_file
             WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
               AND fan03 = tm.yyyy  AND fan04 < tm.mm
               AND fan041 IN ('0','1') 
               AND fan05 IN ('1','2')
         ELSE
            LET l_sql = " SELECT MAX(fan03),MAX(fan04) ",
                        "  FROM fan_file ",
                        " WHERE fan01 = ? AND fan02 = ? ",
                        "   AND fan03 = ",tm.yyyy," AND fan04 < ",tm.mm,
                        "   AND (fan041='1' OR fan041='0') ",   
                        "   AND fan05 = '3' ", 
                        "   AND fan06 = ? " 
            PREPARE r320_pfan03  FROM l_sql
            DECLARE r320_cfan03 SCROLL CURSOR FOR r320_pfan03
            OPEN r320_cfan03 USING sr.faj02,sr.faj022,p_fan06
            FETCH r320_cfan03 INTO l_fan03,l_fan04 
            CLOSE r320_cfan03
         END IF
        #-MOD-AB0127-end-
      END IF
      IF cl_null(l_fan03) THEN LET l_fan03 = 0 END IF
      IF cl_null(l_fan04) THEN LET l_fan04 = 0 END IF
 
      IF SQLCA.sqlcode OR l_fan04 = 0 THEN
        #-MOD-AB0127-add-
         IF p_flag = 'N' THEN
            SELECT MIN(fan03),MIN(fan04) INTO l_fan03,l_fan04 FROM fan_file
             WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
               AND fan03*12+fan04 >= tm.yyyy*12+tm.mm
               AND fan041 = '0'
               AND fan05 IN ('1','2')
         ELSE
            LET l_sql = " SELECT MIN(fan03),MIN(fan04) ",
                        "  FROM fan_file ",
                        " WHERE fan01 = ? AND fan02 = ? ",
                        "   AND fan03*12+fan04 >= ",tm.yyyy*12+tm.mm,
                        "   AND fan041 ='0' ",   
                        "   AND fan05 = '3' ", 
                        "   AND fan06 = ? " 
            PREPARE r320_pfan04  FROM l_sql
            DECLARE r320_cfan04 SCROLL CURSOR FOR r320_pfan04
            OPEN r320_cfan04 USING sr.faj02,sr.faj022,p_fan06
            FETCH r320_cfan04 INTO l_fan03,l_fan04 
            CLOSE r320_cfan04
         END IF
        #-MOD-AB0127-end-
         IF cl_null(l_fan03) THEN LET l_fan03 = 0 END IF
         IF cl_null(l_fan04) THEN LET l_fan04 = 0 END IF
         IF l_fan03 != 0 AND l_fan04 != 0 THEN
           #-MOD-AB0127-add-
            IF p_flag = 'N' THEN
               #資料年月這個月份前都還沒有開始提列折舊,抓看看有沒有開帳的資料
               SELECT SUM(fan15),SUM(fan17) INTO l_acct_d,l_fan17 FROM fan_file
                WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                  AND fan03 = l_fan03 AND fan04= l_fan04
                  AND fan041= '0'
                  AND fan05 IN ('1','2')
            ELSE
               LET l_sql = " SELECT SUM(fan15),SUM(fan17) ",
                           "  FROM fan_file ",
                           " WHERE fan01 = ? AND fan02 = ? ",
                           "   AND fan03 = ",l_fan03," AND fan04 = ",l_fan04,
                           "   AND fan041 ='0' ",   
                           "   AND fan05 = '3' ", 
                           "   AND fan06 = ? " 
               PREPARE r320_pfan05  FROM l_sql
               DECLARE r320_cfan05 SCROLL CURSOR FOR r320_pfan05
               OPEN r320_cfan05 USING sr.faj02,sr.faj022,p_fan06
               FETCH r320_cfan05 INTO l_acct_d,l_fan17 
               CLOSE r320_cfan05
            END IF
           #-MOD-AB0127-end-
         END IF
      ELSE
        #-MOD-AB0127-add-
         IF p_flag = 'N' THEN
            SELECT SUM(fan15),SUM(fan17) INTO l_acct_d,l_fan17 FROM fan_file
             WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
               AND fan03 = l_fan03 AND fan04= l_fan04
               AND fan05 IN ('1','2')
         ELSE
            LET l_sql = " SELECT SUM(fan15),SUM(fan17) ",
                        "  FROM fan_file ",
                        " WHERE fan01 = ? AND fan02 = ? ",
                        "   AND fan03 = ",l_fan03," AND fan04 = ",l_fan04,
                        "   AND fan05 = '3' ", 
                        "   AND fan06 = ? " 
            PREPARE r320_pfan06  FROM l_sql
            DECLARE r320_cfan06 SCROLL CURSOR FOR r320_pfan06
            OPEN r320_cfan06 USING sr.faj02,sr.faj022,p_fan06
            FETCH r320_cfan06 INTO l_acct_d,l_fan17 
            CLOSE r320_cfan06
         END IF
        #-MOD-AB0127-end-
      END IF
   END IF
   IF cl_null(l_curr_1) THEN LET l_curr_1 = 0 END IF
   IF cl_null(l_acct_d) THEN LET l_acct_d = 0 END IF
   IF cl_null(l_fan17)  THEN LET l_fan17 = 0  END IF
 
   #本月折舊(比較年月)
   LET l_curr_2 = 0
  #-MOD-AB0127-add-
   IF p_flag = 'N' THEN
      SELECT SUM(fan07) INTO l_curr_2 FROM fan_file
       WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
         AND fan03 = tm.yy1 AND fan04 = tm.m1
        #AND fan041 IN ('0','1')                  #CHI-CA0063 mark 
         AND fan05 IN ('1','2') 
   ELSE
     #LET l_sql = " SELECT fan07 ",		          #CHI-CA0063 mark
      LET l_sql = " SELECT SUM(fan07) ",		  #CHI-CA0063
                  "  FROM fan_file ",
                  " WHERE fan01 = ? AND fan02 = ? ",
                  "   AND fan03 = ",tm.yy1," AND fan04 = ",tm.m1,
                 #"   AND (fan041='1' OR fan041='0') ",    #CHI-CA0063 mark 
                  "   AND fan05 = '3' ", 
                  "   AND fan06 = ? " 
      PREPARE r320_pfan07  FROM l_sql
      DECLARE r320_cfan07 SCROLL CURSOR FOR r320_pfan07
      OPEN r320_cfan07 USING sr.faj02,sr.faj022,p_fan06
      FETCH r320_cfan07 INTO l_curr_2 
      CLOSE r320_cfan07
   END IF
  #-MOD-AB0127-end-
   IF cl_null(l_curr_2) THEN LET l_curr_2 = 0 END IF
 
   #-->差異(資料年月)(比較年月)
   LET l_diff = l_curr_1 - l_curr_2
   IF l_diff < 0 THEN
      LET l_difcost = l_diff * -1
   ELSE
      LET l_difcost = l_diff
   END IF
 
   #帳面價值
   LET l_curr_val = l_cost - l_acct_d
 
   #資產淨額
   LET l_curr_val2= l_curr_val - l_fan17
 
   IF l_difcost >= tm.difcost THEN
      #主類別名稱
      SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
      IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
 
      #部門
      IF sr.faj23 = '1' THEN
         LET l_fan06 = sr.faj24   # 單一部門  -> 折舊部門
      ELSE
        #LET l_fan06 = sr.faj20   # 多部門分攤-> 保管部門   #MOD-AB0127 mark
         LET l_fan06 = p_fan06    # 多部門分攤-> 保管部門   #MOD-AB0127
      END IF
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_fan06
 
      LET l_type=' '
      LET l_fan07=0
      LET l_fan09=0
      #FUN-C90088--B--
      #耐用年限回溯
      LET l_fap93 = ""
      OPEN r320_c01 USING sr.faj02 ,sr.faj022,g_edate
      FETCH FIRST r320_c01 INTO l_fap93
      IF NOT cl_null(l_fap93) THEN LET sr.faj29 = l_fap93 END IF
      #FUN-C90088--E--
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720045 *** ##
      EXECUTE insert_prep USING 
         sr.faj02,sr.faj022,sr.faj04,sr.faj05  ,sr.faj06,
         sr.faj07,sr.faj26 ,sr.faj29,l_type    ,l_fan03,
         l_fan04 ,sr.faj23 ,l_fan06 ,l_gem02   ,l_fan07,
         l_fan09 ,l_cost   ,l_acct_d,l_curr_val,l_curr_val2,
         l_curr_1,l_curr_2 ,l_diff  ,l_fab02   ,g_azi04,
         g_azi05
      #------------------------------ CR (3) ------------------------------#
   END IF 
END FUNCTION
 
FUNCTION afar320_cal(p_faj02,p_faj022)
   DEFINE p_faj02      LIKE faj_file.faj02,
          p_faj022     LIKE faj_file.faj022 
 
   LET g_fap661  = 0 
   LET g_fap10   = 0  
   LET g_fap54_7 = 0
   LET g_fap561  = 0 
   LET g_fap57   = 0 
 
   #----調整(金額)
   SELECT SUM(fap661),SUM(fap10) INTO g_fap661,g_fap10 FROM fap_file
    WHERE fap03 IN ('9')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----改良(金額)
   SELECT SUM(fap54) INTO g_fap54_7 FROM fap_file
    WHERE fap03 IN ('7')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----銷帳成本
   SELECT SUM(fap56) INTO g_fap561 FROM fap_file
    WHERE fap03 IN ('4','5','6','7','8','9')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----銷帳累折
   SELECT SUM(fap57) INTO g_fap57 FROM fap_file
    WHERE fap03 IN ('2','4','5','6')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 BETWEEN g_bdate AND g_edate
 
   IF cl_null(g_fap661)  THEN LET g_fap661 = 0  END IF
   IF cl_null(g_fap10)   THEN LET g_fap10 = 0   END IF
   IF cl_null(g_fap54_7) THEN LET g_fap54_7 = 0 END IF
   IF cl_null(g_fap561)  THEN LET g_fap561 = 0  END IF
   IF cl_null(g_fap57)   THEN LET g_fap57 = 0   END IF
   
END FUNCTION
#end MOD-960093 add
#Patch....NO.TQC-610035 <> #
