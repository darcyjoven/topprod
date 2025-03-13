# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr109.4gl
# Descriptions...: 應付票據彙總表
# Input parameter:
# Return code....:
# Date & Author..: 99/05/09 By Iceman
# Reference File : nmd_file
# Modify.........: No.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-570382 05/08/08 By Smapmin 報表改成直式方式顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/21 By johnray 報表修改
# Modify.........: No.TQC-6B0155 06/12/05 By chenl   修正報表打印最后一頁時，打印接下頁的bug
# Modify.........: No.MOD-710056 07/01/08 By Smapmin 修改抓取資料條件
# Modify.........: No.FUN-720013 07/01/26 By TSD.c123k 修改為Crystal Report報表 
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-950092 09/05/12 By lilingyu QBE條件中的nmd20應改為nmd06
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_count     LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE g_count2    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(600)  # Where condition
              edate   LIKE type_file.dat,     #No.FUN-680107 DATE
              more    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) # Input more condition(Y/N)
          END RECORD
   DEFINE   l_table    STRING                 # TSD.c123k
   DEFINE   g_sql      STRING                 # TSD.c123k
   DEFINE   g_str      STRING                 # TSD.c123k
 
 #MOD-570382
#   DEFINE g_no1       smallint            #
#   DEFINE g_no2       smallint            #
#   DEFINE g_no3       smallint            #
#   DEFINE g_no4       smallint            #
#   DEFINE g_no5          smallint         # 總張數
#   DEFINE g_no_tot       smallint         # 總張數
#   DEFINE g_seq          smallint         #
#   DEFINE g_bank1        LIKE nmd_file.nmd26  #DECIMAL(15,1)
#   DEFINE g_bank2        LIKE nmd_file.nmd26  #DECIMAL(15,1)
#   DEFINE g_bank3        LIKE nmd_file.nmd26  #DECIMAL(15,1)
#   DEFINE g_bank4        LIKE nmd_file.nmd26  #DECIMAL(15,1)
#   DEFINE g_bank5        LIKE nmd_file.nmd26  #DECIMAL(15,1)
#   DEFINE g_tit          ARRAY[4] OF VARCHAR(14)
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
 #END MOD-570382
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #FUN-720013 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "nmd03.nmd_file.nmd03,",
               "nmd05.nmd_file.nmd05,",
               "nmd26.nmd_file.nmd26,",
               "l_nma02.nma_file.nma02,",
               "l_tot1.nmd_file.nmd26,",
               "l_tot2.nmd_file.nmd26,",
               "l_tot3.nmd_file.nmd26,",
               "l_no1.type_file.num5,",
               "l_no2.type_file.num5,",
               "l_no3.type_file.num5"
 
   LET l_table = cl_prt_temptable('anmr109',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-720013 - END
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL anmr109_tm(0,0)                 # Input print condition
      ELSE CALL anmr109()                       # Read data and create out-file
   END IF
   CLEAR SCREEN
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr109_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000  #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   LET p_row = 5 LET p_col = 12
 
   OPEN WINDOW anmr109_w AT p_row,p_col
        WITH FORM "anm/42f/anmr109"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET tm.edate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.edate
#  CONSTRUCT BY NAME tm.wc ON nmd05,nmd03,nmd20    #MOD-950092
   CONSTRUCT BY NAME tm.wc ON nmd05,nmd03,nmd06    #MOD-950092
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr109_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.edate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr109_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr109'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr109','9031',1)
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
                     " '",tm.edate CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr109',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr109_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   LET g_count = 0
   LET g_count2 = 0
   CALL cl_wait()
   CALL anmr109()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr109_w
END FUNCTION
 
FUNCTION anmr109()
   DEFINE l_name         LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time           LIKE type_file.chr8            #No.FUN-6A0082
          l_sql          LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1200)
#         l_aac01        VARCHAR(3),
 #MOD-570382
#         l_aac01        VARCHAR(5),           #No.FUN-550057
#         l_za05         LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
#         l_i            LIKE type_file.num5,          #No.FUN-680107 SMALLINT
#         l_nmd03        LIKE nmd_file.nmd03,
#         l_nma02        LIKE nma_file.nma02,
 #END MOD-570382
          l_tot1,l_tot2  LIKE nmd_file.nmd26,    # TSD.c123k add 
          l_tot3         LIKE nmd_file.nmd26,    # TSD.c123k add 
          l_no1,l_no2    LIKE type_file.num5,    # TSD.c123k add 
          l_no3          LIKE type_file.num5,    # TSD.c123k add 
          l_nma02        LIKE nma_file.nma02,    # TSD.c123k add
          sr            RECORD
 #                         bank  SMALLINT,            #MOD-570382
                           nmd03 LIKE nmd_file.nmd03,
                           nmd05 LIKE nmd_file.nmd05,
                           nmd26 LIKE nmd_file.nmd26
                        END RECORD
 
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ----------------------------------#
     #FUN-720013 - START
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
 #     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 92 END IF   #MOD-570382
 #     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR     #MOD-570382
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
 
 #     LET l_sql = "SELECT 0,nmd03, nmd05, nmd26 ",   #MOD-570382
      LET l_sql = "SELECT nmd03, nmd05, nmd26 ",    #MOD-570382
                 "  FROM nmd_file " ,
                 " WHERE nmd30 <> 'X' ",
                 #-----MOD-710056---------
                 #"   AND nmd05 <= '",tm.edate,"'", #NO:3547
                 #"   AND nmd12 matches '[1X]' AND  ",tm.wc CLIPPED  ,
              ## "   AND (nmd12 MATCHES '[1X]' OR",
                 "   AND (nmd12 IN ('1','X') OR",
                 "   (nmd12 = '8' AND nmd29 > '",tm.edate,"'))",
                 "   AND ",tm.wc CLIPPED,
                 #-----END MOD-710056-----
 #                 "  ORDER BY nmd03"   #MOD-570382
                  "  ORDER BY nmd03,nmd05"   #MOD-570382
 
     PREPARE anmr109_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1)
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
                EXIT PROGRAM
         END IF
     DECLARE anmr109_curs1 CURSOR FOR anmr109_prepare1
 
     LET g_pageno = 0
 #MOD-570382
#     LET g_seq = 0
#     LET l_nmd03  = '*'
#     LET g_no1 = 0
#     LET g_no2 = 0
#     LET g_no3 = 0
#     LET g_no4 = 0
#     LET g_no5 = 0
#     LET g_bank1 = 0
#     LET g_bank2 = 0
#     LET g_bank3 = 0
#     LET g_bank4 = 0
#     LET g_bank5 = 0
#     FOR l_i = 1 TO 4
#         LET g_tit[l_i]=' '
#     END FOR
 #END MOD-570382
     FOREACH anmr109_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0
            THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 #MOD-570382
#        IF sr.nmd03 != l_nmd03 THEN
#           LET g_seq = g_seq + 1
#           IF g_seq > 4 THEN
#              EXIT FOREACH
#           END IF
           ##modi in 01/08/10 (以銀行基本資料為主非全省銀行檔)
#           SELECT nma02 INTO  l_nma02 FROM nma_file WHERE nma01=sr.nmd03
#           IF cl_null(l_nma02) THEN
#              LET g_tit[g_seq]=' '
#           ELSE
#              LET g_tit[g_seq]=l_nma02[1,14]
#           END IF
#        END IF
#        LET sr.bank = g_seq
       # OUTPUT TO REPORT anmr109_rep(sr.*)  #TSD.c123k mark
#        LET l_nmd03 = sr.nmd03
 #END MOD-570382
 
         #FUN-720013 - START
         LET l_nma02 = NULL
         SELECT nma02 INTO  l_nma02 FROM nma_file WHERE nma01 = sr.nmd03
  
         IF sr.nmd26 IS NULL THEN LET sr.nmd26 = 0 END IF
 
         LET l_tot1 = 0
         LET l_tot2 = 0
         LET l_tot3 = 0
         LET l_no1 = 0
         LET l_no2 = 0
         LET l_no3 = 0
        
         LET l_no1 = l_no1 + 1
         LET l_tot1 = l_tot1 + sr.nmd26
         LET l_no2 = l_no2 + 1
         LET l_tot2 = l_tot2 + sr.nmd26
         LET l_no3 = l_no3 + 1
         LET l_tot3 = l_tot3 + sr.nmd26
 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
         EXECUTE insert_prep USING
             sr.nmd03,  sr.nmd05,   sr.nmd26,   l_nma02, 
             l_tot1,  l_tot2,  l_tot3,   l_no1,   l_no2,   l_no3
         #------------------------------ CR (3) --------------------------------#
         #FUN-720013 - END
     END FOREACH
 
     #FUN-720013 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmd05,nmd03,nmd06')     #MOD-950092 nmd20->nmd06
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",g_azi04,";",g_azi05          #FUN-710080 add
     CALL cl_prt_cs3('anmr109','anmr109',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
     #FUN-720013 - END
 
END FUNCTION
