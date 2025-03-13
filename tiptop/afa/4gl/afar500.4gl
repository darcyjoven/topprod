# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar500.4gl
# Descriptions...: 保險單保費彙總表
# Date & Author..: 97/08/28 By Sophia
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720045 07/02/02 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                    # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1             # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD
 
DEFINE    l_table     STRING,                 ### MOD-720045 ###
          g_str       STRING,                 ### MOD-720045 ###
          g_sql       STRING                  ### MOD-720045 ###
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
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
 
   #str FUN-720045 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
   LET g_sql =  " fdd01.fdd_file.fdd01,",
                " fdd03.fdd_file.fdd03,", #年
                " fdd033.fdd_file.fdd033,",#月
                " fda02.fda_file.fda02,",
                " fda08.fda_file.fda08,",
                " fdc10.fdc_file.fdc10,",
                " fdd05.fdd_file.fdd05,", #本期保費
                " fdc11.fdc_file.fdc11,",  #已攤保費
                " fda03.fda_file.fda03,",
                " fda04.fda_file.fda04 "
 
   LET l_table = cl_prt_temptable('afar500',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ? )"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720045 add
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar500_tm(0,0)        # Input print condition
      ELSE CALL afar500()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar500_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col =18
 
   OPEN WINDOW afar500_w AT p_row,p_col WITH FORM "afa/42f/afar500"
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
      CONSTRUCT BY NAME tm.wc ON fdd01,fdd03,fdd033
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
         LET INT_FLAG=0 CLOSE WINDOW afar500_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.more WITHOUT DEFAULTS
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
         LET INT_FLAG = 0 CLOSE WINDOW afar500_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar500'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar500','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar500',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar500()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar500_w
END FUNCTION
 
FUNCTION afar500()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr        RECORD
                    fdd01    LIKE fdd_file.fdd01,
                    fdd03    LIKE fdd_file.fdd03,  #年
                    fdd033   LIKE fdd_file.fdd033, #月
                    fda02    LIKE fda_file.fda02,
                    fda08    LIKE fda_file.fda08,
                    fdc10    LIKE fdc_file.fdc10,
                    fdd05    LIKE fdd_file.fdd05,  #本期保費
                    fdc11    LIKE fdc_file.fdc11,  #已攤保費
                    fda03    LIKE fda_file.fda03,
                    fda04    LIKE fda_file.fda04
                    END RECORD
 
   #str FUN-720045 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720045 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720045 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### MOD-720045 add ###
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND fdduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND fddgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND fddgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fdduser', 'fddgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT fdd01,fdd03,fdd033,'','',0,",
               "SUM(fdd05),0,'',''",
               "  FROM fdd_file",
               " WHERE ", tm.wc CLIPPED,
               " GROUP BY fdd01,fdd03,fdd033"
 
   PREPARE afar500_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afar500_curs1 CURSOR FOR afar500_prepare1
 
   LET g_pageno = 0
   FOREACH afar500_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT fda02,fda03,fda04,fda08 INTO sr.fda02,sr.fda03,sr.fda04,sr.fda08
        FROM fda_file
       WHERE fda01 = sr.fdd01
      SELECT SUM(fdc10),SUM(fdc11) INTO sr.fdc10,sr.fdc11
        FROM fdc_file
       WHERE fdc01 = sr.fdd01
      
      #str FUN-720045 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> MOD-720045 *** ##
      EXECUTE insert_prep USING 
         sr.fdd01,sr.fdd03,sr.fdd033,sr.fda02,sr.fda08,sr.fdc10,
         sr.fdd05,sr.fdc11,sr.fda03 ,sr.fda04
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720045 add
   END FOREACH
 
   #str FUN-720045 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> MOD-720045 **** ##
   LET g_str = '' 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'fdd01,fdd03,fdd033') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_azi04,";",g_azi05          #FUN-710080 add
   CALL cl_prt_cs3('afar500','afar500',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720045 add
 
END FUNCTION
