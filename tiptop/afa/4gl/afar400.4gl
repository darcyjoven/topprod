# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar400.4gl
# Desc/riptions...: 固定資產折舊費用明細表
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-FUN-510035 05/03/05 By pengu 修改報表單價、金額欄位寬度
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-580010 05/08/12 By jackie 轉XML
# Modify.........: No.TQC-620042 06/02/15 By Smapmin 報表中耐用年限改抓稅簽的耐用年限
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-620031 06/06/30 By rainy 報表產生區分分攤前及分攤後
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 報表格式調整
# Modify.........: No.FUN-770052 07/07/25 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
# Modify.........: No.FUN-8A0055 08/12/31 By shiwuying 修改l_str只傳中文年月的問題
# Modify.........: No.MOD-920040 09/02/03 By Sarah 抓fao_file的SQL加上fao041='0' OR fao041='1'條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
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
                a       LIKE type_file.chr1,                  # 1:分攤前  2:分攤後       #No.FUN-680070 VARCHAR(1)
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt   #No.FUN-680070 VARCHAR(15)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING,              ### FUN-770052 ###                                                                    
         g_str           STRING,              ### FUN-770052 ###                                                                    
         g_sql           STRING               ### FUN-770052 ###  
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
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "faj04.faj_file.faj04,",                                                                                            
                "fao06.fao_file.fao06,",
                "faj02.faj_file.faj02,",  
                "faj022.faj_file.faj022,",  
                "faj26.faj_file.faj26,",
                "faj07.faj_file.faj07,",
                "faj64.faj_file.faj64,",
                "fao14.fao_file.fao14,",
                "fao15.fao_file.fao15,",
                "fao15b.fao_file.fao15,",
                "fao15c.fao_file.fao15,",
                "fao15d.fao_file.fao15,",
                "fao15e.fao_file.fao15,",
                "faj05.faj_file.faj05,",
                "faj06.faj_file.faj06"
    LET l_table = cl_prt_temptable('afar400',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?,                                                                     
                         ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------# 
 
 
 
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
   LET tm.a  = ARG_VAL(14)   #FUN-620031
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r400_tm(0,0)            # Input print condition
      ELSE CALL afar400()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r400_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r400_w AT p_row,p_col WITH FORM "afa/42f/afar400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '123'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.a    = '1'     #FUN-620031 add
   #No:A099
   LET tm.yyyy = g_faa.faa11
   LET tm.mm   = g_faa.faa12
   #end No:A099
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
         LET INT_FLAG = 0 CLOSE WINDOW r400_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME
            tm.yyyy,tm.mm,tm.a,tm2.s1,tm2.s2,tm2.s3,  #FUN-620031 add tm.a
            tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more
            WITHOUT DEFAULTS
         #No.FUN-890122 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
            END IF
        #FUN-620031 add start
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
        #FUN-620031 add end
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
         LET INT_FLAG = 0 CLOSE WINDOW r400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar400'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar400','9031',1)
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
                        " '",tm.a CLIPPED,"'",    #FUN-620031 add
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar400',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar400()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r400_w
END FUNCTION
 
FUNCTION afar400()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0069
          l_str         LIKE type_file.chr50,                #FUN-770052
          l_name1       LIKE type_file.chr20,                #FUN-770052
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,              #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE faj_file.faj06,     #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               faj02 LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,  #附號
                               faj04 LIKE faj_file.faj04,    #主類別
                               faj05 LIKE faj_file.faj05,    #次類別
                               faj06 LIKE faj_file.faj06,    #中文名稱
                               faj07 LIKE faj_file.faj07,    #英文名稱
                               faj20 LIKE faj_file.faj20,    #保管部門
                               faj23 LIKE faj_file.faj23,    #分攤方式
                               faj24 LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26 LIKE faj_file.faj26,    #入帳日期
                              #faj29 LIKE faj_file.faj29     #耐用年限   #TQC-620042
                               faj64 LIKE faj_file.faj64     #耐用年限   #TQC-620042
                        END RECORD,
          sr2           RECORD
                               fao03    LIKE fao_file.fao03,    #年度
                               fao04    LIKE fao_file.fao04,    #月份
                               fao05    LIKE fao_file.fao05,    #分攤方式
                               fao06    LIKE fao_file.fao06,    #部門
                               fao07    LIKE fao_file.fao07,    #折舊金額
                           #   fao09    LIKE fao_file.fao09,    #被攤部門
                               fao14    LIKE fao_file.fao14,    #成本
                               fao15    LIKE fao_file.fao15,    #累折
                               pre_d    LIKE fao_file.fao15,    #前期折舊
                               curr_d   LIKE fao_file.fao15,    #本期折舊
                               curr     LIKE fao_file.fao15,    #本月折舊
                               curr_val LIKE fao_file.fao15,    #帳面價值
                               cost     LIKE fao_file.fao15,    #No.CHI-480001
                               fao17    LIKE fao_file.fao17     #No.CHI-480001
                        END RECORD
 
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
 
     LET l_sql = "SELECT '','','',",
                 " faj02,faj022,faj04,faj05,faj06,faj07,faj20,",
                 #" faj23,faj24,faj26,faj29",   #TQC-620042
                 " faj23,faj24,faj26,faj64",   #TQC-620042
                 " FROM faj_file",
                 " WHERE ",tm.wc
     PREPARE r400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r400_cs1 CURSOR FOR r400_prepare1
 
     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fao03, fao04, fao05, fao06, fao07,",
                 "  fao14, fao15,0,fao08,0,0,fao17 ",     #No.CHI-480001
                 " FROM fao_file ",
                 " WHERE fao01 = ? AND fao02 = ? ",
                 "   AND fao03 = ", tm.yyyy," AND fao04=",tm.mm,
                 "   AND (fao041='0' OR fao041='1')",   #MOD-920040 add
                 "   AND ",tm.wc2
 
   #FUN-620031 add --start 
    CASE
      WHEN tm.a = '1' #--->分攤前
       LET l_sql = l_sql clipped ," AND fao05 != '3' " clipped
      WHEN tm.a = '2' #--->分攤後
       LET l_sql = l_sql clipped ," AND fao05 != '2' " clipped
      OTHERWISE EXIT CASE
    END CASE
   #FUN-620031 add --end
 
     PREPARE r400_prefao  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r400_csfao CURSOR FOR r400_prefao
 
#    CALL cl_outnam('afar400') RETURNING l_name               #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------#      
#No.FUN-580010 --start--
     IF g_aza.aza26='2' THEN
        LET g_zaa[43].zaa06="N"
        LET l_name1 = 'afar400'                             #FUN-770052
     ELSE
        LET g_zaa[43].zaa06="Y"
        LET l_name1 = 'afar400_1'                               #FUN-770052
     END IF
#    CALL cl_prt_pos_len()                                    #FUN-770052
#No.FUN-580010  --end--
#    START REPORT r400_rep TO l_name                          #FUN-770052
     LET g_pageno = 0
     FOREACH r400_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #--->篩選部門
       FOREACH r400_csfao
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r400_csfao:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #--->本月折舊
          LET sr2.curr = sr2.fao07
          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d   = sr2.fao15 - sr2.curr_d
          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fao14-sr2.fao15
          #No.CHI-480001
          IF cl_null(sr2.fao17) THEN LET sr2.fao17 = 0 END IF
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.cost = sr2.curr_val - sr2.fao17
          #end
         { FOR g_i = 1 TO 3                                          #FUN-770052
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[15]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[16]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                          LET g_descripe[g_i]=g_x[18]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                          LET g_descripe[g_i]=g_x[21]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
                                          LET g_descripe[g_i]=g_x[19]
                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fao06
                                          LET g_descripe[g_i]=g_x[20]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
#         OUTPUT TO REPORT r400_rep(sr.*,sr2.*) }                   #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.faj04,sr2.fao06,sr.faj02,sr.faj022,sr.faj26,sr.faj07,sr.faj64,
                   sr2.fao14,sr2.pre_d,sr2.curr_d,sr2.curr,sr2.curr_val,sr2.cost,
                   sr.faj05,sr.faj06
          #------------------------------ CR (3) ------------------------------# 
       END FOREACH
    END FOREACH
 
#   FINISH REPORT r400_rep                                          #FUN-770052
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)                     #FUN-770072
#No.FUN-770052--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06,fao02 ')                                                                                   
              RETURNING tm.wc                                                                                                       
#        CALL cl_prt_pos_wc(tm.wc)                                  #FUN-770052                                                      
      END IF                                                                                                                        
 #   LET l_str=tm.yyyy  USING '####','年',tm.mm    USING '##','月'   #FUN-770052  #FUN-8A0055
#No.FUN-770052--end  
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
  #    LET g_str = l_str,";",g_azi05,";",tm.wc,";",g_azi04,";",tm.s[1,1],";",  #FUN-8A0055
    LET g_str = tm.yyyy,";",g_azi05,";",tm.wc,";",g_azi04,";",tm.s[1,1],";", #FUN-8A0055
                tm.s[2,2],";",tm.s[3,3],";",
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",tm.mm   #FUN-8A0055 ADD tm.mm
    CALL cl_prt_cs3('afar400',l_name1,l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
{REPORT r400_rep(sr,sr2)                                           #FUN-770052
   DEFINE l_last_sw     LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_str         LIKE type_file.chr50,                #列印排列順序說明       #No.FUN-680070 VARCHAR(50)
          sr            RECORD order1 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(20)
                               faj02 LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,  #附號
                               faj04 LIKE faj_file.faj04,    #主類別
                               faj05 LIKE faj_file.faj05,    #次類別
                               faj06 LIKE faj_file.faj06,    #中文名稱
                               faj07 LIKE faj_file.faj07,    #英文名稱
                               faj20 LIKE faj_file.faj20,    #保管部門
                               faj23 LIKE faj_file.faj23,    #分攤方式
                               faj24 LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26 LIKE faj_file.faj26,    #入帳日期
                              #faj29 LIKE faj_file.faj29     #耐用年限   #TQC-620042
                               faj64 LIKE faj_file.faj64     #耐用年限   #TQC-620042
                        END RECORD,
          sr2           RECORD
                               fao03    LIKE fao_file.fao03,    #年度
                               fao04    LIKE fao_file.fao04,    #月份
                               fao05    LIKE fao_file.fao05,    #分攤方式
                               fao06    LIKE fao_file.fao06,    #部門
                               fao07    LIKE fao_file.fao07,    #折舊金額
                             # fao09    LIKE fao_file.fao09,    #被攤部門
                               fao14    LIKE fao_file.fao14,    #成本
                               fao15    LIKE fao_file.fao15,    #累折
                               pre_d    LIKE fao_file.fao15,    #前期折舊
                               curr_d   LIKE fao_file.fao15,    #本期折舊
                               curr     LIKE fao_file.fao15,    #本月折舊
                               curr_val LIKE fao_file.fao15,    #帳面價值
                               cost     LIKE fao_file.fao15,    #No.CHI-480001
                               fao17    LIKE fao_file.fao17     #No.CHI-480001
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #No.TQC-6C0009 mark
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #No.TQC-6C0009
      LET l_str=tm.yyyy  USING '####','年',tm.mm    USING '##','月'
      PRINT COLUMN (g_len-FGL_WIDTH(l_str))/2 ,l_str CLIPPED #,
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
      PRINT g_dash1
#No.FUN-580010 --end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#No.FUN-580010 --start--
   ON EVERY ROW
         PRINTX name=D1
               COLUMN g_c[31],sr.faj04,                               #主類別
               COLUMN g_c[32],sr2.fao06,                             #部門
               COLUMN g_c[33],sr.faj02,                              #財產編號
               COLUMN g_c[34],sr.faj022,                             #附號
               COLUMN g_c[35],YEAR(sr.faj26) USING '####','/',       #入帳年月
                      MONTH(sr.faj26) USING '&&',
               COLUMN g_c[36],sr.faj07,                              #英文名稱
               #COLUMN g_c[37],sr.faj29 USING '###&',g_x[20] clipped,#耐用年限   #TQC-620042
               COLUMN g_c[37],sr.faj64 USING '###&',g_x[20] clipped,#耐用年限   #TQC-620042
               COLUMN g_c[38],cl_numfor(sr2.fao14 ,38,g_azi04),     #成本
               COLUMN g_c[39],cl_numfor(sr2.pre_d ,39,g_azi04),     #前期折舊
               COLUMN g_c[40],cl_numfor(sr2.curr_d,40,g_azi04),   #本期折舊
               COLUMN g_c[41],cl_numfor(sr2.curr  ,41,g_azi04),     #本月折舊
               COLUMN g_c[42],cl_numfor(sr2.curr_val,42,g_azi04), #帳面價值
               COLUMN g_c[43],cl_numfor(sr2.cost,43,g_azi04)  #資產淨額
 
   AFTER GROUP OF sr.order1
      IF tm.c[1,1] = 'Y'  THEN
         PRINTX name=S1
               COLUMN g_c[31],g_descripe[1],
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr2.fao14) ,38,g_azi05),     #成本
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.pre_d) ,39,g_azi05),     #前期折舊
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.curr_d),40,g_azi05),   #本期折舊
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr)  ,41,g_azi05),     #本月折舊
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr_val),42,g_azi05),
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.cost),43,g_azi05)
         PRINT
       END IF
 
   AFTER GROUP OF sr.order2
      IF tm.c[2,2] = 'Y' THEN
         PRINTX name=S1
               COLUMN g_c[31],g_descripe[2],
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr2.fao14) ,38,g_azi05),     #成本
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.pre_d) ,39,g_azi05),     #前期折舊
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.curr_d),40,g_azi05),   #本期折舊
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr)  ,41,g_azi05),     #本月折舊
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr_val),42,g_azi05),
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.cost),43,g_azi05)
         PRINT
       END IF
 
   AFTER GROUP OF sr.order3
      IF tm.c[3,3] = 'Y'  THEN
         PRINTX name=S1
               COLUMN g_c[31],g_descripe[3],
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr2.fao14) ,38,g_azi05),     #成本
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.pre_d) ,39,g_azi05),     #前期折舊
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.curr_d),40,g_azi05),   #本期折舊
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr)  ,41,g_azi05),     #本月折舊
               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr_val),42,g_azi05),
               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.cost),43,g_azi05)
         PRINT
       END IF
#No.FUN-580010 --end--
ON LAST ROW
      IF g_zz05 = 'Y'     # (80)-70,140,210,280   /   (132)-120,240,400
         THEN PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
              #IF tm.wc[001,120] > ' ' THEN                      # for 132
              #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,400] > ' ' THEN
              #   PRINT COLUMN 10,     tm.wc[241,400] CLIPPED END IF
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
END REPORT}                                                                 #FUN-770052
#Patch....NO.TQC-610035 <> #
