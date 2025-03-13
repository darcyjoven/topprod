# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar940.4gl
# Descriptions...: 未抵押資產明細表
# Descriptions...: 扺押彙總表
# Date & Author..: 96/06/11 By STAR
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-570043 05/08/04 By Smapmin c type 改為 LIKE type_file.num20_6      #No.FUN-680070 dec(20,6)
# Modify.........: No.MOD-590097 05/09/08 By Tracy 報表畫線寫入zaa
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-6A0075 06/10/18 By Smapmin 移除與flag1相關程式段
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: No.MOD-720045 07/04/10 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              date1   LIKE type_file.dat          #No.FUN-680070 DATE
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
 
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
   LET g_sql = "faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,",
               "faj04.faj_file.faj04,",
               "faj47.faj_file.faj47,",
               "faj88.faj_file.faj88,",
               "faj91.faj_file.faj91,",
               "faj14.faj_file.faj14,",
               "faj141.faj_file.faj141,",
               "fan14.fan_file.fan14,",
               "fan15.fan_file.fan15,",
               "flag.type_file.chr1,",
               "azi05.azi_file.azi05,",
               "fab02.fab_file.fab02"
 
   LET l_table = cl_prt_temptable('afar940',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?)"
 
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
   LET tm.date1  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar940_tm(0,0)        # Input print condition
      ELSE CALL afar940()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar940_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar940_w AT p_row,p_col WITH FORM "afa/42f/afar940"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj14,faj47
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
         LET INT_FLAG = 0 CLOSE WINDOW afar940_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.date1,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD date1
            IF cl_null(tm.date1) THEN
               NEXT FIELD date1
            END IF
         AFTER FIELD more
            IF cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
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
         LET INT_FLAG = 0 CLOSE WINDOW afar940_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar940'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar940','9031',1)
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
                            " '",tm.date1  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('afar940',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar940_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar940()
   END WHILE
 
   CLOSE WINDOW afar940_w
END FUNCTION
 
FUNCTION afar940()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_mon     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          sr               RECORD
                                  faj02  LIKE faj_file.faj02,
                                  faj022 LIKE faj_file.faj022,
                                  faj04  LIKE faj_file.faj04,
                                  faj47  LIKE faj_file.faj47,
                                  faj88  LIKE faj_file.faj88,
                                  faj91  LIKE faj_file.faj91,
                                  faj14  LIKE faj_file.faj14,
                                  faj141 LIKE faj_file.faj141,
                                  fan14  LIKE fan_file.fan14,
                                  fan15  LIKE fan_file.fan15,
                                  flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                                  fab02  LIKE fab_file.fab02
                        END RECORD
 
   #str MOD-720045  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end MOD-720045  add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### MOD-720045 add ###
 
     #====>資料權限的檢查
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
 
     LET l_sql = "SELECT faj02,faj022,faj04,    ",
                 "       faj47,faj88,faj91,faj14,faj141,0,0,'','' ",
                 "  FROM faj_file ",
                 " WHERE fajconf = 'Y' ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE afar940_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar940_curs1 CURSOR FOR afar940_prepare1
 
     # 取本期的成本以及累折
     LET l_sql = " SELECT fan14 FROM fan_file ",
                 "  WHERE fan01 = ? ",
                 "    AND fan02 = ? ",
                 "    AND fan03 = ? ",
                 "    AND fan04 = ? ",
                 "    AND fan041 = '1'"
 
      PREPARE afar940_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar940_curs2 SCROLL CURSOR FOR afar940_prepare2
     LET l_sql = " SELECT SUM(fan15) FROM fan_file ",
                 "  WHERE fan01 = ? ",
                 "    AND fan02 = ? ",
                 "    AND fan03 = ? ",
                 "    AND fan04 = ? "
 
      PREPARE afar940_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar940_curs3 SCROLL CURSOR FOR afar940_prepare3
 
     LET g_pageno = 0
 
     LET l_year = YEAR(tm.date1)
     LET l_mon  = MONTH(tm.date1)
     FOREACH afar940_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF sr.faj88 < tm.date1 AND ( sr.faj91 is null OR sr.faj91 >= tm.date1)
          THEN LET sr.flag = '1'      #------- 表示已抵押 -----#
          ELSE LET sr.flag="2"
       END IF
 
       OPEN afar940_curs2 USING sr.faj02,sr.faj022,l_year,l_mon
       FETCH FIRST afar940_curs2 INTO sr.fan14
       CLOSE afar940_curs2
       OPEN afar940_curs3 USING sr.faj02,sr.faj022,l_year,l_mon
       FETCH FIRST afar940_curs3 INTO sr.fan15
       CLOSE afar940_curs3
 
       # 還沒有折舊資料
       IF cl_null(sr.fan14) OR cl_null(sr.fan15) THEN
          IF cl_null(sr.faj14) THEN LET sr.faj14 = 0 END IF
          IF cl_null(sr.faj141) THEN LET sr.faj141 = 0 END IF
          LET sr.fan14 = sr.faj14 + sr.faj141
          LET sr.fan15 = 0
       END IF
     
       SELECT fab02 INTO sr.fab02 FROM fab_file
        WHERE fab01=sr.faj04
       IF sqlca.sqlcode =100 THEN LET sr.fab02="" END IF
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
         EXECUTE insert_prep USING 
         sr.faj02,sr.faj022,sr.faj04 ,sr.faj47,sr.faj88,
         sr.faj91,sr.faj14 ,sr.faj141,sr.fan14,sr.fan15,
         sr.flag ,g_azi05,sr.fab02
       #------------------------------ CR (3) ------------------------------#
       #end FUN-74001 add 
 
     END FOREACH
   #str MOD-720045 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'faj04,faj05,faj14,faj47')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.date1
   CALL cl_prt_cs3('afar940','afar940',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end MOD-720045 add 
 
END FUNCTION
