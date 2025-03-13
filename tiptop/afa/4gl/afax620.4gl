# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: afax620.4gl
# Descriptions...: 固定資產盤點差異分析表
# Date & Author..: 96/05/09 By Sophia
# Modify.........: No.FUN-510035 05/02/02 By Smapmin 報表轉XML格式
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-590099 05/09/26 By Smapmin 將報表改為單行格式
# Modify.........: No.MOD-650109 06/06/16 By rainy 勾選僅列印盤點差異者,列印欄位位置錯誤
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()
# Modify.........: No.MOD-720045 07/04/22 By TOPTSD 報表改寫由Crystal Report產出
# Modify.........: No.MOD-740074 07/04/22 By rainy 整合測試
# Modify.........: No.FUN-8A0055 09/01/04 By shiwuying   越南文報表處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加"族群"之欄位
# Modify.........: No.FUN-CA0132 12/11/05 By zhangweib CR轉XtraGrid
# Modify.........: No.TQC-D40018 13/04/08 By zhangweib 補過到正式區
# Modify.........: No.FUN-D40128 13/05/15 By wangrr 增加欄位開窗
# Modify.........: No.FUN-D40128 13/05/22 By yangtt 添加【列印条件】显示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                   # Print condition RECORD   #No.TQC-D40018
              wc       STRING,          # Where condition
              diff     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
              s        LIKE type_file.chr3,           # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t        LIKE type_file.chr3,           # Eject sw       #No.FUN-680070 VARCHAR(3)
              more     LIKE type_file.chr1            # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_desc    LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          g_yy      LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(4)
          g_mm      LIKE type_file.chr2         #No.FUN-680070 VARCHAR(2)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
 
DEFINE   t4              LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE    l_table     STRING,                 ### MOD-710080 ###
          g_str       STRING,                 ### MOD-710080 ###
          g_sql       STRING                  ### MOD-710080 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
   LET g_sql =  " fca01.fca_file.fca01,",
                " fca01_1.type_file.chr50,",   #No.FUN-CA0132   Add
                " fca02.fca_file.fca02,",
                " fca03.fca_file.fca03,",
                " fca03_1.type_file.chr50,",   #No.FUN-CA0132   Add
                " fca031.fca_file.fca031,",
                " faj26.faj_file.faj26,",
                " faj07.faj_file.faj07,",
                " faj06.faj_file.faj06,",
                " faj08.faj_file.faj08,",
                " fcaqty.type_file.num5,",
                " fca09.fca_file.fca09,",
                " fca10.fca_file.fca10,",
                " fca11.fca_file.fca11,",
                " fca12.fca_file.fca12,",
                " faj04.faj_file.faj04,",
                " fca05.fca_file.fca05,",
                " fca06.fca_file.fca06,",
                " fca07.fca_file.fca07,",
                " fca21.fca_file.fca21"                  #FUN-9A0036 add 
               ,",gen02.gen_file.gen02,",  #FUN-D40128
                " gem02.gem_file.gem02,",  #FUN-D40128
                " faf02.faf_file.faf02"    #FUN-D40128

   LET l_table = cl_prt_temptable('afax620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #MOD-740074
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    #MOD-740074
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #FUN-9A0036 add ? #No.FUN-cA0132 Add ?,? #FUN-D40128 add 3?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-710080 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.diff  = ARG_VAL(8)
   LET tm.s     = ARG_VAL(9)
   LET tm.t     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL x620_tm(0,0)         # Input print condition
      ELSE CALL x620()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION x620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW x620_w AT p_row,p_col WITH FORM "afa/42f/afax620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
   LET tm.s    = '123'
   LET tm.t    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_yy = YEAR(g_today)
   LET g_mm = MONTH(g_today)
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fca01,faj04,fca03,fca05,fca06,fca07
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
      #FUN-D40128--add--str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(fca01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_fca"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fca01
               NEXT FIELD fca01
            WHEN INFIELD(faj04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_faj04_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj04
               NEXT FIELD faj04
            WHEN INFIELD(fca03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_fca03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fca03
               NEXT FIELD fca03
            WHEN INFIELD(fca05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_fca05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fca05
               NEXT FIELD fca05
            WHEN INFIELD(fca06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_fca06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fca06
               NEXT FIELD fca06
            WHEN INFIELD(fca07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_faf"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fca07
               NEXT FIELD fca07
         END CASE
      #FUN-D40128--add--end 
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
         LET INT_FLAG = 0 CLOSE WINDOW x620_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc =  " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm.diff,tm2.s1,tm2.s2,tm2.s3,
                    tm2.t1,tm2.t2,tm2.t3,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD diff
               IF cl_null(tm.diff) OR tm.diff NOT MATCHES '[YN]' THEN
                  NEXT FIELD diff
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
           AFTER INPUT
              LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
              LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
         LET INT_FLAG = 0 CLOSE WINDOW x620_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afax620'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afax620','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.diff CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afax620',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW x620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL x620()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW x620_w
END FUNCTION
 
FUNCTION x620()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fca_file.fca01,     #No.FUN-680070 VARCHAR(30)
          sr        RECORD order1 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           order2 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           order3 LIKE fca_file.fca01,   #No.FUN-680070 VARCHAR(20)
                           fca01  LIKE fca_file.fca01,   #盤點編號
                           fca02  LIKE fca_file.fca02,   #盤點序號
                           fca03  LIKE fca_file.fca03,   #財產編號
                           fca031 LIKE fca_file.fca031,  #財產附號
                           faj04  LIKE faj_file.faj04,   #資產類別
                           faj26  LIKE faj_file.faj26,   #入帳日期
                           faj07  LIKE faj_file.faj07,   #英文名稱
                           faj06  LIKE faj_file.faj06,   #中文名稱
                           faj08  LIKE faj_file.faj08,   #規格型號
                           fcaqty LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                           fca05  LIKE fca_file.fca05,   #保管部門
                           fca06  LIKE fca_file.fca06,   #保管人
                           fca07  LIKE fca_file.fca07,   #保管位置
                           fca09  LIKE fca_file.fca09,   #盤點數量
                           fca10  LIKE fca_file.fca10,   #實際保管部門
                           fca11  LIKE fca_file.fca11,   #實際保管人
                           fca12  LIKE fca_file.fca12,   #實際保管位置
                           flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
                          ,fca21  LIKE fca_file.fca21         #FUN-9A0036 add 
                    END RECORD
   DEFINE l_fca01   LIKE type_file.chr50   #No.FUN-CA0132   Add
   DEFINE l_fca03   LIKE type_file.chr50   #No.FUN-CA0132   Add
   DEFINE l_gen02   LIKE gen_file.gen02    #FUN-D40128
   DEFINE l_gem02   LIKE gem_file.gem02    #FUN-D40128
   DEFINE l_faf02   LIKE faf_file.faf02    #FUN-D40128

     #str FUN-710080 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-710080 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #end FUN-710080 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### TSD.liquor add ###
 
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
 
 
     LET l_sql = "SELECT '','','',",           #組SQL
                 "fca01,fca02,fca03,fca031,faj04,faj26,faj07,faj06,faj08,",
                 "faj17-faj58,fca05,fca06,fca07,fca09,fca10,fca11,fca12,'Y',fca21",    #FUN-9A0036 add fca21
                 "  FROM fca_file,faj_file",
                 " WHERE fca03 = faj02 ",
                 "   AND fca031 = faj022 ",
                 "   AND ",tm.wc
 
     PREPARE x620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE x620_curs1 CURSOR FOR x620_prepare1
  #   CALL cl_outnam('afax620') RETURNING l_name     #FUN-8A0055 mark
 
     LET g_pageno = 0
 
     FOREACH x620_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #str FUN-710080 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> MOD-710080 *** ##
      LET l_fca01 = sr.fca01," ",sr.fca02 USING "<<<<<" CLIPPED   #No.FUN-CA0132   Add
      LET l_fca03 = sr.fca03," ",sr.fca031 USING "<<<<" CLIPPED   #No.FUN-CA0132   Add
      #FUN-D40128--add--str--
      LET l_gen02=''
      LET l_gem02=''
      LET l_faf02=''
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fca10
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fca11
      SELECT faf02 INTO l_faf02 FROM faf_file WHERE faf01=sr.fca12
      #FUN-D40128--add--end
      IF tm.diff = 'Y' THEN
         IF (sr.fca09 != sr.fcaqty) OR  (sr.fca10 != sr.fca05) OR
            (sr.fca11 != sr.fca06 ) OR  (sr.fca12 != sr.fca07) THEN
             EXECUTE insert_prep USING 
              #sr.fca01,sr.fca02,sr.fca03,sr.fca031,sr.faj26,sr.faj07,   #No.FUN-CA0132   Mark
               sr.fca01,l_fca01,sr.fca02,sr.fca03,l_fca03,sr.fca031,sr.faj26,sr.faj07,   #No.FUN-CA0132   Add
               sr.faj06,sr.faj08,sr.fcaqty,sr.fca09,sr.fca10,sr.fca11,
               sr.fca12,sr.faj04,sr.fca05,sr.fca06,sr.fca07,sr.fca21       #FUN-9A0036 add fca21
              ,l_gen02,l_gem02,l_faf02 #FUN-D40128
         END IF
      ELSE
        EXECUTE insert_prep USING 
       #sr.fca01,sr.fca02,sr.fca03,sr.fca031,sr.faj26,sr.faj07,   #No.FUN-CA0132   Mark
        sr.fca01,l_fca01,sr.fca02,sr.fca03,l_fca03,sr.fca031,sr.faj26,sr.faj07,   #No.FUN-CA0132   Add
        sr.faj06,sr.faj08,sr.fcaqty,sr.fca09,sr.fca10,sr.fca11,
        sr.fca12,sr.faj04,sr.fca05,sr.fca06,sr.fca07,sr.fca21             #FUN-9A0036 add fca21
       ,l_gen02,l_gem02,l_faf02 #FUN-D40128
      END IF
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720045 add
     END FOREACH
   #str FUN-720045 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> MOD-720045 **** ##
   LET g_str = '' 
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'fca01,faj04,fca03,fca04,fca06,fca05,fca07')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
###XtraGrid###   LET g_str = g_str,";",tm.s,";",tm.t,";",g_yy,";",g_mm        
###XtraGrid###   CALL cl_prt_cs3('afax620','afax620',l_sql,g_str)   
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"fca01,faj04,fca03,fca05,fca06,fca07,fca21")
    IF tm.s[1,1] = '1' OR tm.s[2,2] = '1' OR tm.s[3,3] = '1' THEN
       LET g_xgrid.order_field = cl_replace_str(g_xgrid.order_field,'fca01','fca01,fca02')
    END IF
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"fca01,faj04,fca03,fca05,fca06,fca07,fca21")
   #LET g_xgrid.condition= tm.wc   #FUN-D40128
    LET g_xgrid.condition= cl_getmsg('lib-160',g_lang),tm.wc  #FUN-D40128
    LET g_xgrid.footerinfo1=cl_getmsg('afa-198',g_lang)
    CALL cl_xg_view()    ###XtraGrid###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720045 add
 
 
END FUNCTION
 
#MOD-740074


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
