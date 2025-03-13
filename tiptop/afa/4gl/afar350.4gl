# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: afar350.4gl
# Descriptions...: 固定資產折舊費用彙總表
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-5A0130 05/10/21 By Rosayu 新增資料抓取fan_file 開帳資料
# Modify.........: No.MOD-640552 06/04/24 By Smapmin 修改SELECT條件
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-740026 07/04/10 By Smapmin 當月出售/銷帳有折舊時須顯示,以後則不可顯示
# Modify.........: No.FUN-7B0139 07/12/03 By zhaijie 改報表輸出為Crystal Report
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70018 10/07/02 By Carrier 折旧完后,再打印资产信息时,资产的原值会变为0
# Modify.........: No:CHI-B70033 11/09/26 By johung 需考慮當月有作折舊調整的fan資料
# Modify.........: No:TQC-C50093 12/05/10 By xuxz 414行参考MOD-890112
# Modify.........: No:MOD-C50069 12/05/15 By Polly 調整afar350的SQL邏輯與afar300一致
# Modify.........: No:MOD-CB0043 12/11/08 by Polly 調整抓取資產日期判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,                 # 資料年度       #No.FUN-680070 SMALLINT
                mm      LIKE type_file.num5,                 # 資料月份       #No.FUN-680070 SMALLINT
                s       LIKE type_file.chr3,                  # Order by sequence       #No.FUN-680070 VARCHAR(3)
                t       LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
                c       LIKE type_file.chr3,                  # subtotal       #No.FUN-680070 VARCHAR(3)
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt   #No.FUN-680070 VARCHAR(15)
          g_bdate,g_edate   LIKE type_file.dat          #No.FUN-680070 DATE
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_sql           STRING                  #NO.FUN-7B0139       
DEFINE   g_str           STRING                  #NO.FUN-7B0139
DEFINE   l_table         STRING                  #NO.FUN-7B0139
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
#NO.FUN-7B0139-----------start-------------
   LET g_sql = "faj04.faj_file.faj04,",
               "l_fab02.fab_file.fab02,",
               "faj05.faj_file.faj05,",
               "l_fac02.fac_file.fac02,",
               "cost.fan_file.fan14,",
               "fap54.fap_file.fap54,",
               "curr.fan_file.fan15,",
               "acct.fan_file.fan15,",
               "curr_val.fan_file.fan15"
   LET l_table = cl_prt_temptable('afar350',g_sql) CLIPPED                                                                          
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                          
#NO.FUN-7B0139-------end-----------------
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.yyyy  = ARG_VAL(9)
   LET tm.mm    = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)   #TQC-610055
   LET tm.t  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r350_tm(0,0)            # Input print condition
      ELSE CALL afar350()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r350_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r350_w AT p_row,p_col WITH FORM "afa/42f/afar350"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '12'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.yyyy = g_faa.faa07
   LET tm.mm   = g_faa.faa08
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
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj06
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
         LET INT_FLAG = 0 CLOSE WINDOW r350_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r350_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME
            tm.yyyy,tm.mm,tm2.s1,tm2.s2,
            tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.more
            WITHOUT DEFAULTS
         #No.FUN-890122 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
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
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.c = tm2.u1,tm2.u2
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
         LET INT_FLAG = 0 CLOSE WINDOW r350_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar350'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar350','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar350',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r350_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar350()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r350_w
END FUNCTION
 
FUNCTION afar350()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0069
          #l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)   #MOD-740026
          l_sql         STRING,  #MOD-740026
          l_chr         LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_flag        LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,              #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE faj_file.faj04,     #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               faj02 LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,  #附號
                               faj04 LIKE faj_file.faj04,    #主類別
                               faj05 LIKE faj_file.faj05,    #次類別
                               faj06 LIKE faj_file.faj06,    #中文名稱
                               faj07 LIKE faj_file.faj07,    #英文名稱
                               faj14 LIKE faj_file.faj14,    #本幣成本
                               faj20 LIKE faj_file.faj20,    #保管部門
                               faj23 LIKE faj_file.faj23,    #分攤方式
                               faj24 LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26 LIKE faj_file.faj26,    #入帳日期
                               faj29 LIKE faj_file.faj29,    #耐用年限
                               faj32 LIKE faj_file.faj32     #累積折舊
                        END RECORD,
          sr2           RECORD
                               fan03    LIKE fan_file.fan03,    #年度
                               fan04    LIKE fan_file.fan04,    #月份
                               fan05    LIKE fan_file.fan05,    #分攤方式
                               fan06    LIKE fan_file.fan06,    #部門
                               fan07    LIKE fan_file.fan07,    #折舊金額
                               fan09    LIKE fan_file.fan09,    #被攤部門
                               fan14    LIKE fan_file.fan14,    #成本
                               acct_d   LIKE fan_file.fan15,    #累積折舊
                               pre_d    LIKE fan_file.fan15,    #前期折舊
                               curr_d   LIKE fan_file.fan15,    #本期折舊
                               curr     LIKE fan_file.fan15,    #本月折舊
                               curr_val LIKE fan_file.fan15,    #帳面價值
                               fap54    LIKE fap_file.fap54,    #改良成本
                               cost     LIKE fan_file.fan14     #資產合計
                        END RECORD
   DEFINE l_faj27  LIKE faj_file.faj27   #MOD-740026
   DEFINE l_faj272 LIKE type_file.chr6   #MOD-C50069 add
   DEFINE l_fab02  LIKE fab_file.fab02   #FUN-7B0139
   DEFINE l_fac02  LIKE fac_file.fac02   #FUN-7B0139
   DEFINE l_count  LIKE type_file.num5   #TQC-C50093 add
    
   #No.MOD-A70018  --Begin                                                         
   DEFINE l_fan03       LIKE type_file.chr4                                        
   DEFINE l_fan04       LIKE type_file.chr2                                        
   DEFINE l_fan03_fan04 LIKE type_file.chr6                                        
   DEFINE l_fan15       LIKE fan_file.fan15                                        
   #No.MOD-A70018  --End

   #CHI-B70033 -- begin --
   DEFINE l_cnt         LIKE type_file.num5,
          l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_File.fan07,
          l_adj_fap54   LIKE fap_file.fap54
   #CHI-B70033 -- end --

     CALL cl_del_data(l_table)                                  #NO.FUN-7B0139 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar350' #NO.FUN-7B0139
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                        #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                        #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     LET l_faj27 = tm.yyyy||(tm.mm USING '&&')  #MOD-740026
     LET l_faj272 = tm.yyyy||tm.mm              #MOD-C50069 add
 
     LET l_sql = "SELECT '','','',",
                 " faj02,faj022,faj04,faj05,faj06,faj07,faj14+faj141-faj59,",
                 " faj20,faj23,faj24,faj26,faj29,faj32",
                 " FROM faj_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND fajconf = 'Y'",
                 "   AND faj28 <> '0'",   #MOD-640552
                #-----MOD-740026---------
                #" AND ((faj27[1,4]='",tm.yyyy USING '&&&&',"' ",
                #"      AND faj27[5,6]<='",tm.mm USING '&&',"')",
                #"      OR (faj27[1,4]<'",tm.yyyy USING '&&&&',"'))"
                 " AND faj27 <= '",l_faj27,"'",
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                #"      WHERE CONVERT(CHAR(6),fap04,112) <= '",l_faj27,"'",  #No.MOD-A70018
                #"      WHERE LTRIM(RTRIM(YEAR(fap04))) ||LTRIM(RTRIM(MONTH(fap04))) <= '",l_faj27,"'",   #No.MOD-A70018 #MOD-C50069 mark
                #"      WHERE LTRIM(RTRIM(YEAR(fap04))) ||LTRIM(RTRIM(MONTH(fap04))) <= '",l_faj272,"'",                      #MOD-C50069 add #MOD-CB0043 mark
                 "      WHERE ((YEAR(fap04) < ",tm.yyyy,") OR (YEAR(fap04) = ",tm.yyyy," AND MONTH(fap04) < ",tm.mm,"))",     #MOD-CB0043 add
                 "      AND fap77 IN ('5','6') AND fap021 = faj022) ",#TQC-C50093 add AND fap021 = faj022
                 "      OR faj02 IN (SELECT fan01 FROM fan_file ",
                 "      WHERE fan03 = ",tm.yyyy," AND fan04 = ",tm.mm,
                 "        AND fan07 > 0 AND fan02 =faj022)) " #TQC-C50093 add AND fan02 =faj022
                #-----END MOD-740026-----
     PREPARE r350_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r350_cs1 CURSOR FOR r350_prepare1
 
     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fan03, fan04, fan05, fan06, fan07,",
                 " fan09, fan14, fan15,0,fan08,0,0,0,0",
                 " FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                 #"   AND fan041 = '1'", #FUN-5A0130 mark
                 "   AND (fan041 = '1' OR fan041 = '0') ",  #FUN-5A0130 add
                 "   AND ",tm.wc2  clipped,
                 "   AND fan05 != '3' "
     PREPARE r350_prefan  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r350_csfan CURSOR FOR r350_prefan
 
#     CALL cl_outnam('afar350') RETURNING l_name       #NO.FUN-7B0139
     CALL s_azn01(tm.yyyy,tm.mm) RETURNING g_bdate,g_edate
 
#     START REPORT r350_rep TO l_name                  #NO.FUN-7B0139
#     LET g_pageno = 0                                 #NO.FUN-7B0139
 
     FOREACH r350_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_flag = 'Y'
       IF cl_null(sr.faj05) THEN LET sr.faj05 = ' ' END IF
#NO.FUN-7B0139----------------START-----MARK-----------------------
#       FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
#                                       LET g_descripe[g_i]=g_x[15]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
#                                       LET g_descripe[g_i]=g_x[16]
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#NO.FUN-7B0139-----------END---------------------------------
       #TQC-C50093---add---satrt---
      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022
          AND fap77 IN ('5','6')
         #AND (YEAR(fap04)||MONTH(fap04)) < l_faj27               #MOD-C50069 mark
         #AND (YEAR(fap04)||MONTH(fap04)) < l_faj272                                           #MOD-C50069 add #MOD-CB0043 mark
          AND ((YEAR(fap04) < tm.yyyy) OR (YEAR(fap04) = tm.yyyy AND MONTH(fap04) < tm.mm))    #MOD-CB0043 add
      #上線前已銷帳者，應不可印出
      #-------------------------MOD-C50069----------------(S)
      #IF l_count=0 THEN
      #   SELECT COUNT(*) INTO l_count FROM faj_file
      #    WHERE faj02=sr.faj02 AND faj022=sr.faj022
      #      AND faj43='6'
      #      AND (YEAR(fap04)||MONTH(fap04)) <= l_faj27
      #END IF
      #-------------------------MOD-C50069----------------(E)
       IF l_count > 0 THEN
          CONTINUE FOREACH
       END IF
      #TQC-C50093---add---end---
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH r350_csfan
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r350_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_flag = 'N'
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 =0 END IF
          IF cl_null(sr2.fan14) THEN LET sr2.fan14 =0 END IF
          IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF
          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d =0 END IF
 
          #CHI-B70033 -- 程式搬移 begin --
          SELECT SUM(fan15) INTO sr2.acct_d FROM fan_file
           WHERE fan01 = sr.faj02
             AND fan02 = sr.faj022
             AND fan03 = sr2.fan03
             AND fan04 = sr2.fan04
             AND (fan041 = '1' OR fan041 = '0') #FUN-5A0130 add
             AND fan05 != '3'
          IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF
          #CHI-B70033 -- 程式搬移 end --

          #CHI-B70033 -- begin --
          LET l_adj_fan07 = 0
          LET l_adj_fap54 = 0
          CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.acct_d)
             RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
          LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1
          LET sr2.fan14 = sr2.fan14 + l_adj_fap54
          LET sr2.acct_d = sr2.acct_d + l_adj_fan07
          #CHI-B70033 -- end --

          #--->本月折舊
          LET sr2.curr = sr2.fan07
 
#CHI-B70033 -- 程式搬移 mark begin --
###----1999/07/22 Modify By Sophia
#         SELECT SUM(fan15) INTO sr2.acct_d FROM fan_file
#          WHERE fan01 = sr.faj02
#            AND fan02 = sr.faj022
#            AND fan03 = sr2.fan03
#            AND fan04 = sr2.fan04
#            AND (fan041 = '1' OR fan041 = '0') #FUN-5A0130 add
#            AND fan05 != '3'
#         IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF
###-------------------------------
#CHI-B70033 -- 程式搬移 mark end -- 

          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d = sr2.acct_d - sr2.curr_d
 
          #--->未折減額  = (成本 - 累期折舊)
          LET sr2.curr_val = sr2.fan14- sr2.acct_d
 
          #--->改良成本
          SELECT SUM(fap54) INTO sr2.fap54 FROM fap_file
             WHERE fap03 IN ('7')
               AND fap02=sr.faj02 AND fap021=sr.faj022
               AND fap04 between g_bdate AND  g_edate
          IF cl_null(sr2.fap54) THEN LET sr2.fap54=0  END IF
 
          #--->資產合計  = 成本 - 改良成本
          LET sr2.cost   = sr2.fan14 - sr2.fap54
#          OUTPUT TO REPORT r350_rep(sr.*,sr2.*)               #NO.FUN-7B0139
#NO.FUN-7B0139-------------------start------------------------
          SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01= sr.faj04
          IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
          SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01= sr.faj05
          IF SQLCA.sqlcode THEN LET l_fac02 = ' ' END IF
          EXECUTE insert_prep USING
             sr.faj04,l_fab02,sr.faj05,l_fac02,sr2.cost,sr2.fap54,
             sr2.curr,sr2.acct_d,sr2.curr_val
#NO.FUN-7B0139--------------end--------
       END FOREACH
       IF l_flag ='Y' THEN
          #No.MOD-A70018  --Begin                                               
          #--->若已折毕,抓取每笔资产最後一次折旧资料                            
          LET l_sql = " SELECT MAX(fan03*100+fan04) FROM fan_file ",   #MOD-7100
                      "  WHERE fan01 = ? AND fan02 = ?",                        
                      "   AND (fan041 = '1' OR fan041 = '0') ",
                      "   AND fan05 != '3' ",                                   
                      "   AND ",tm.wc2                                          
          PREPARE pre_fan03_fan04 FROM l_sql                                    
          EXECUTE pre_fan03_fan04 USING sr.faj02,sr.faj022 INTO l_fan03_fan04   
          LET l_fan03 = l_fan03_fan04[1,4]                                      
          LET l_fan04 = l_fan03_fan04[5,6]                                      
                                                                                
         #str MOD-920105 mod                                                    
          IF l_fan03 = tm.yyyy THEN                                             
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",              
                         " fan09, fan14, fan15,0,fan08,0,0,0,fan17 "            
          ELSE                                                                  
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",              
                         " fan09, fan14, fan15,fan08,0,0,0,0,fan17 "            
          END IF                                                     
         #end MOD-920105 mod                                                    
          LET l_sql = l_sql CLIPPED,                                            
                      " FROM fan_file ",                                        
                      " WHERE fan01 = ? AND fan02 = ? ",                        
                      "   AND fan03 = ? AND fan04 = ? ",                        
                      "   AND (fan041 = '1' OR fan041 = '0') ",
                      "   AND fan05 != '3' ",                                   
                      "   AND ",tm.wc2                                          
          PREPARE r300_prefan2  FROM l_sql                                      
          IF SQLCA.sqlcode != 0 THEN                                            
             CALL cl_err('prepare:',SQLCA.sqlcode,1)                            
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113      
             EXIT PROGRAM                                                       
          END IF                                                                
          DECLARE r300_csfan2 CURSOR FOR r300_prefan2                           
                                                                                
          FOREACH r300_csfan2 USING sr.faj02,sr.faj022,l_fan03,l_fan04          
             INTO sr2.*                                                         
          #-----END TQC-630111-----                                             
             IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF              
             IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF                
             IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF          
             IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
             IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF                
                                                                                
             #CHI-B70033 -- begin --
             LET l_adj_fan07 = 0
             LET l_adj_fap54 = 0
             CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.acct_d)
                RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
             LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1
             LET sr2.fan14 = sr2.fan14 + l_adj_fap54
             LET sr2.acct_d = sr2.acct_d + l_adj_fan07
             #CHI-B70033 -- end --

             #累积折旧                                                          
             LET sr2.acct_d = sr.faj32                                          
             IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF               
                                                                                
             #--->本月折旧                                                      
             LET sr2.curr = sr2.fan07                                           
                                                                                
             #-----MOD-620069---------                                          
             #--->前期折旧 = (累折 - 本期累折)                                  
             IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN       
                LET sr2.pre_d = 0                                               
             ELSE                                                               
                LET sr2.pre_d = sr2.acct_d - sr2.curr_d   #MOD-730123           
             END IF                                                             
             #-----END MOD-620069-----                                          
                                                                                
             #--->未折减额  = (成本 - 累期折旧)                                 
             LET sr2.curr_val = sr2.fan14 - sr2.acct_d                          
                                                                                
             #--->改良成本                                                      
             SELECT SUM(fap54) INTO sr2.fap54 FROM fap_file
                WHERE fap03 matches '[7]'                                       
                  AND fap02=sr.faj02 AND fap021=sr.faj022                       
                  AND fap04 between g_bdate AND  g_edate                        
             IF cl_null(sr2.fap54) THEN LET sr2.fap54=0  END IF                 
                                                                                
             #--->资产合计  = 成本 - 改良成本                                   
             LET sr2.cost   = sr2.fan14 - sr2.fap54                             
                                                                                
          #No.MOD-A70018  --End

#NO.FUN-7B0139-------------------start------------------------
             SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01= sr.faj04
             IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
             SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01= sr.faj05
             IF SQLCA.sqlcode THEN LET l_fac02 = ' ' END IF
    
             EXECUTE insert_prep USING
                sr.faj04,l_fab02,sr.faj05,l_fac02,sr2.cost,sr2.fap54,
                sr2.curr,sr2.acct_d,sr2.curr_val
          END FOREACH    #No.MOD-A70018
#NO.FUN-7B0139--------------end--------
        END IF
    END FOREACH
 
#    FINISH REPORT r350_rep                                     #NO.FUN-7B0139
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                #NO.FUN-7B0139
#NO.FUN-7B0139--------------start---------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj06,fan06')                                                                 
       RETURNING tm.wc                                                                                                             
     END IF                                                                                                                         
     LET g_str = tm.wc,";",tm.yyyy,";",tm.mm,";",tm.t[1,1],";",tm.t[2,2],";",
                 tm.s[1,1],";",tm.s[2,2],";",                                             
                 g_azi04,";",g_azi05,";",tm.c[1,1],";",tm.c[2,2]                                                                                                
     CALL cl_prt_cs3('afar350','afar350',g_sql,g_str)
#NO.FUN-7B0139----------------end----------
END FUNCTION

#CHI-B70033 -- begin --
#判斷是否要回傳調整金額
FUNCTION r300_chk_adj(p_faj02,p_faj022,p_fan15)
   DEFINE p_faj02       LIKE faj_file.faj02,
          p_faj022      LIKE faj_file.faj022,
          p_fan15       LIKE fan_file.fan15,
          l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_file.fan07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15,
          l_cnt         LIKE type_file.num5

   LET l_cnt = 0
   LET l_adj_fan07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '1'

   #調整折舊
   SELECT fan07 INTO l_adj_fan07 FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '2'
   IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF
   LET l_adj_fan07_1 = l_adj_fan07
   #調整成本
   SELECT fap54 INTO l_adj_fap54 FROM fap_file
    WHERE fap02 = p_faj02 AND fap021 = p_faj022
      AND YEAR(fap04) = tm.yyyy AND MONTH(fap04) = tm.mm
   IF cl_null(l_adj_fap54) THEN LET l_adj_fap54 = 0 END IF

   IF l_cnt > 0 THEN
      IF g_aza.aza26 <> '2' THEN
         LET l_adj_fan07 = 0
         LET l_adj_fap54 = 0
      ELSE
         #大陸版有可能先折舊再調整
         SELECT fan15 INTO l_pre_fan15 FROM fan_file
          WHERE fan01 = p_faj02 AND fan02 = p_faj022
            AND fan041 = '1'
            AND fan03 || fan04 IN (
                  SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                   WHERE fan01 = p_faj02 AND fan02 = p_faj022
                     AND ((fan03 < tm.yyyy) OR (fan03 = tm.yyyy AND fan04 < tm.mm))
                     AND fan041 = '1')

         SELECT fan07 INTO l_curr_fan07 FROM fan_file
          WHERE fan01 = p_faj02 AND fan02 = p_faj022
            AND fan03 = tm.yyyy AND fan04 = tm.mm
            AND fan041 = '1'
         IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF

         IF p_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
            LET l_adj_fan07 = 0
            LET l_adj_fap54 = 0
         END IF
      END IF
   END IF
   RETURN l_adj_fan07,l_adj_fan07_1,l_adj_fap54
END FUNCTION
#CHI-B70033 -- end --

#NO.FUN-7B0139-----------------start----mark------------------------
#REPORT r350_rep(sr,sr2)
#   DEFINE l_last_sw     LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
#          l_str         LIKE type_file.chr50,                 #列印排列順序說明       #No.FUN-680070 VARCHAR(50)
#          sr            RECORD order1 LIKE faj_file.faj04,    #No.FUN-680070 VARCHAR(20)
#                               order2 LIKE faj_file.faj04,    #No.FUN-680070 VARCHAR(20)
#                               order3 LIKE faj_file.faj04,    #No.FUN-680070 VARCHAR(20)
#                               faj02  LIKE faj_file.faj02,    #財編
#                               faj022 LIKE faj_file.faj022,   #附號
#                               faj04  LIKE faj_file.faj04,    #主類別
#                               faj05  LIKE faj_file.faj05,    #次類別
#                               faj06  LIKE faj_file.faj06,    #中文名稱
#                               faj07  LIKE faj_file.faj07,    #英文名稱
#                               faj14  LIKE faj_file.faj14,    #本幣成本
#                               faj20  LIKE faj_file.faj20,    #保管部門
#                               faj23  LIKE faj_file.faj23,    #分攤方式
#                               faj24  LIKE faj_file.faj24,    #分攤部門(類別)
#                               faj26  LIKE faj_file.faj26,    #入帳日期
#                               faj29  LIKE faj_file.faj29,    #耐用年限
#                               faj32  LIKE faj_file.faj32     #累積折舊
#                        END RECORD,
#          sr2           RECORD
#                               fan03    LIKE fan_file.fan03,    #年度
#                               fan04    LIKE fan_file.fan04,    #月份
#                               fan05    LIKE fan_file.fan05,    #分攤方式
#                               fan06    LIKE fan_file.fan06,    #部門
#                               fan07    LIKE fan_file.fan07,    #折舊金額
#                               fan09    LIKE fan_file.fan09,    #被攤部門
#                               fan14    LIKE fan_file.fan14,    #成本
#                               acct_d   LIKE fan_file.fan15,    #累積折舊
#                               pre_d    LIKE fan_file.fan15,    #前期折舊
#                               curr_d   LIKE fan_file.fan15,    #本期折舊
#                               curr     LIKE fan_file.fan15,    #本月折舊
#                               curr_val LIKE fan_file.fan15,    #帳面價值
#                               fap54    LIKE fap_file.fap54,    #改良成本
#                               cost     LIKE fan_file.fan14     #資產合計
#                        END RECORD,
#          l_fab02     LIKE fab_file.fab02,
#          l_fac02     LIKE fac_file.fac02,
#          l_cost,l_cost_1,l_cost_2             LIKE fan_file.fan15,
#          l_fap54,l_fap54_1,l_fap54_2          LIKE fan_file.fan15,
#          l_curr,l_curr_1,l_curr_2             LIKE fan_file.fan15,
#          l_acct_d,l_acct_d1,l_acct_d2         LIKE fan_file.fan15,
#          l_curr_val,l_curr_val1,l_curr_val2   LIKE fan_file.fan15
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.faj05
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET l_str=g_x[13],tm.yyyy USING '####',g_x[11], tm.mm USING '##',g_x[12]
#      PRINT l_str
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   AFTER GROUP OF sr.faj05  #次類別
#         SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01= sr.faj04
#         IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
#         SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01= sr.faj05
#         IF SQLCA.sqlcode THEN LET l_fac02 = ' ' END IF
#
#         LET l_cost      = GROUP SUM(sr2.cost)
#         LET l_fap54     = GROUP SUM(sr2.fap54)
#         LET l_curr      = GROUP SUM(sr2.curr)
#         LET l_acct_d    = GROUP SUM(sr2.acct_d)
#         LET l_curr_val  = GROUP SUM(sr2.curr_val)
#         PRINT COLUMN g_c[31],sr.faj04,         #主類別
#               COLUMN g_c[32],l_fab02[1,10],    #名稱
#               COLUMN g_c[33],sr.faj05,        #次類別
#               COLUMN g_c[34],l_fac02[1,10] ,   #名稱
#               COLUMN g_c[35],cl_numfor(l_cost,35,g_azi05),     #資產合計
#               COLUMN g_c[36],cl_numfor(l_fap54,36,g_azi05),    #改良合計
#               COLUMN g_c[37],cl_numfor(l_curr,37,g_azi04),     #本月折舊
#               COLUMN g_c[38],cl_numfor(l_acct_d,38,g_azi04),   #累計折舊
#               COLUMN g_c[39],cl_numfor(l_curr_val,39,g_azi04) #未折減額
 
#   AFTER GROUP OF sr.order1
#      IF tm.c[1,1] = 'Y' THEN
#         LET l_cost_1    = GROUP SUM(sr2.cost)
#         LET l_fap54_1   = GROUP SUM(sr2.fap54)
#         LET l_curr_1    = GROUP SUM(sr2.curr)
#         LET l_acct_d1   = GROUP SUM(sr2.acct_d)
#         LET l_curr_val1 = GROUP SUM(sr2.curr_val)
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_cost_1,35,g_azi05),     #資產合計
#               COLUMN g_c[36],cl_numfor(l_fap54_1,36,g_azi05),    #改良合計
#               COLUMN g_c[37], cl_numfor(l_curr_1,37,g_azi05),    #本月折舊
#               COLUMN g_c[38], cl_numfor(l_acct_d1,38,g_azi05),   #累計折舊
#               COLUMN g_c[39],cl_numfor(l_curr_val1,39,g_azi05)  #未折減額
#         PRINT
#       END IF
 
#   AFTER GROUP OF sr.order2
#      IF tm.c[2,2] = 'Y' THEN
#         LET l_cost_1    = GROUP SUM(sr2.cost)
#         LET l_fap54_1   = GROUP SUM(sr2.fap54)
#         LET l_curr_1    = GROUP SUM(sr2.curr)
#         LET l_acct_d1   = GROUP SUM(sr2.acct_d)
#         LET l_curr_val1 = GROUP SUM(sr2.curr_val)
 
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_cost_1,35,g_azi05),    #資產合計
#               COLUMN g_c[36],cl_numfor(l_fap54_1,36,g_azi05),   #改良合計
#               COLUMN g_c[37],cl_numfor(l_curr_1,37,g_azi05),    #本月折舊
#               COLUMN g_c[38],cl_numfor(l_acct_d1,38,g_azi05),   #累計折舊
#               COLUMN g_c[39],cl_numfor(l_curr_val1,39,g_azi05) #未折減額
#         PRINT
#       END IF
 
#   AFTER GROUP OF sr.order3
#      IF tm.c[3,3] = 'Y' THEN
#         LET l_cost_1    = GROUP SUM(sr2.cost)
#         LET l_fap54_1   = GROUP SUM(sr2.fap54)
#         LET l_curr_1    = GROUP SUM(sr2.curr)
#         LET l_acct_d1   = GROUP SUM(sr2.acct_d)
#         LET l_curr_val1 = GROUP SUM(sr2.curr_val)
#         PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_cost_1,35,g_azi05),    #資產合計
#               COLUMN g_c[36],cl_numfor(l_fap54_1,36,g_azi05),   #改良合計
#               COLUMN g_c[37],cl_numfor(l_curr_1,37,g_azi05),    #本月折舊
#               COLUMN g_c[38],cl_numfor(l_acct_d1,38,g_azi05),   #累計折舊
#               COLUMN g_c[39],cl_numfor(l_curr_val1,39,g_azi05) #未折減額
#         PRINT
#       END IF
 
#ON LAST ROW
#         LET l_cost_2    =  SUM(sr2.cost)
#         LET l_fap54_2   =  SUM(sr2.fap54)
#         LET l_curr_2    =  SUM(sr2.curr)
#         LET l_acct_d2   =  SUM(sr2.acct_d)
#         LET l_curr_val2 =  SUM(sr2.curr_val)
#         PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#               COLUMN g_c[35],cl_numfor(l_cost_2,35,g_azi05),     #資產合計
#               COLUMN g_c[36],cl_numfor(l_fap54_2,36,g_azi05),    #改良合計
#               COLUMN g_c[37],cl_numfor(l_curr_2,37,g_azi05),     #本月折舊
#               COLUMN g_c[38],cl_numfor(l_acct_d2,38,g_azi05),    #累計折舊
#               COLUMN g_c[39],cl_numfor(l_curr_val2,39,g_azi05)  #未折減額
#         PRINT ' '
#      IF g_zz05 = 'Y'     # (80)-70,140,210,280   /   (132)-120,240,350
#         THEN PRINT g_dash[1,g_len]
#            #-- TQC-630166 begin
              #IF tm.wc[001,120] > ' ' THEN                      # for 132
              #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,350] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[241,350] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINES
#     END IF
#END REPORT
#NO.FUN-7B0139----------end---------------
