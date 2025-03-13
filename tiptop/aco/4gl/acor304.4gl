# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor304.4gl
# Descriptions...: 手冊成品出口數量表
# Date & Author..: 03/02/21 By Carrier
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 04/12/24 BY Carrier 修改cno10之后的影響
# Modify.........: NO.MOD-490398 05/02/28 BY Elva 修改數量
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.FUN-750026 07/05/28 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) #NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_line_1    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) #輸入打印報表頭的橫線
          g_coc03     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) #報表頭的g_line上的coc03
          g_cnp05     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) #on every row中的金額數
          g_no        LIKE type_file.num5,         #No.FUN-680069 SMALLINT #序號數
          g_t         LIKE type_file.num5,         #No.FUN-680069 SMALLINT #(7-((g_cnt+1) mod 7 ))+g_cnt
          g_cnp DYNAMIC ARRAY OF RECORD #coc03組合的矩陣
                coc03 LIKE coc_file.coc03   #MOD-490398
                END RECORD
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE l_table     STRING                       ### FUN-750026 add ###
DEFINE g_sql       STRING                       ### FUN-750026 add ###
DEFINE g_str       STRING                       ### FUN-750026 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   #str FUN-750026 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-750026 *** ##
   LET g_sql = "coe03.coe_file.coe03,",
               "cob02.cob_file.cob02,",
               "cob021.cob_file.cob021,",
               "cob09.cob_file.cob09,",
               "coe06.coe_file.coe06,",
               "coc03.coc_file.coc03,",
               "cnp05.cnp_file.cnp05"
 
   LET l_table = cl_prt_temptable('acor304',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
 
   INITIALIZE tm.* TO NULL                # Default condition
#-----------------No.TQC-610082 modify
#  LET tm.more = 'N'
#   LET tm.y = 'N'                         #MOD-490398
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------------No.TQC-610082 end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor304_tm(0,0)
      ELSE CALL acor304()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor304_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW acor304_w AT p_row,p_col WITH FORM "aco/42f/acor304"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
    LET tm.y = 'N'                         #MOD-490398
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON coc10,coc03,coc04,coc01,coc05,coe03   #MOD-490398
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS   #MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW acor304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor304'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor304','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.y     CLIPPED,"'",  #MOD-490398
                        #" '",tm.more  CLIPPED,"'",          #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor304',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor304_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor304()
   ERROR ""
END WHILE
   CLOSE WINDOW acor304_w
END FUNCTION
 
FUNCTION acor304()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50) # External(Disk) file name
          l_name1   LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(50)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05    LIKE za_file.za05,           #MOD-490398
          l_i       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len     LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_len1    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space1  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space2  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_space3  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_j       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_report  LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_temp    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
          l_cnp05   LIKE cnp_file.cnp05,
          l_total   LIKE cnp_file.cnp05,
          l_cmd,l_cmd1,l_cmd2  LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(400)
          sr        RECORD
                           coe03   LIKE coe_file.coe03,
                           cob02   LIKE cob_file.cob02,
                           cob021  LIKE cob_file.cob021,
                           cob09   LIKE cob_file.cob09,  #MOD-490398
                           coe06   LIKE coe_file.coe06,
                           l_amt   LIKE cnp_file.cnp05,
                           l_no    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
                           coc03_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(300)  #No.TQC-6A0085
                           cnp05_s LIKE zaa_file.zaa08,         #No.FUN-680069 VARCHAR(300)  #No.TQC-6A0085
                           line    LIKE zaa_file.zaa08          #No.FUN-680069 VARCHAR(300)  #No.TQC-6A0085
                    END RECORD
 
   #str FUN-750026  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-750026 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-750026  add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acor304'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-750026 add ###
 
#####sr丟到report
      #No.MOD-490398  --begin
     LET l_sql = "SELECT unique coe03,cob02,cob021,cob09,coe06,SUM(coe05)+SUM(coe10)-",
                 "SUM(coe051)-SUM(coe09)-SUM(coe101)-SUM(coe107)+",
                 "SUM(coe103)+SUM(coe104)+SUM(coe108)+SUM(coe109),",
                 " 0,'','','' ",
                 "  FROM coc_file,coe_file,cob_file",
                 " WHERE coc01 = coe01 ",
                 "   AND cocacti = 'Y' ",
                 "   AND coe03=cob01",
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY coe03,cob02,cob021,cob09,coe06 ",
                 " ORDER BY coe03,cob09,coe06 "
      #NO.MOD-490398  --end
 
     PREPARE acor304_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor304_curs1 CURSOR FOR acor304_prepare1
#####coc03丟到g_cnp矩陣中
     LET l_sql = "SELECT unique coc03 ",
                 "  FROM coc_file,coe_file  ",
                 " WHERE coc01 = coe01 ",
                 "   AND cocacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
     PREPARE acor304_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor304_cno1 CURSOR FOR acor304_prepare2
#####當前coc03,cno10丟到g_cnp矩陣中
#    LET l_sql = "SELECT SUM(coe05)+SUM(coe10)-SUM(coe09)-SUM(coe101)+SUM(coe104) ",
     LET l_sql = "SELECT SUM(coe05)+SUM(coe10)-SUM(coe051)-SUM(coe09)-SUM(coe101)-SUM(coe107)",
                 " +SUM(coe103)+SUM(coe104)+SUM(coe108)+SUM(coe109)  ",
                 "  FROM coc_file,coe_file  ",
                 " WHERE coc01 = coe01 AND coe03 = ? ",
                 "   AND coe06 = ?",
                 "   AND coc03 = ? AND cocacti = 'Y' ",
                 "   AND ",tm.wc CLIPPED
     PREPARE acor304_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor304_cno2 CURSOR FOR acor304_prepare3
 
     LET g_len = 202
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR l_i = 1 TO 200
         INITIALIZE g_cnp[l_i] TO NULL
     END FOR
     LET l_i = 1
####coc03
     FOREACH acor304_cno1 INTO g_cnp[l_i].*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET l_i = l_i + 1
     END FOREACH
     LET g_cnt = l_i - 1   #coc03總數
 
     LET g_no = 1
     LET g_pageno = 0
####g_t=6-((g_cnt+1) mod 6) + (g_cnt+1) 多出的1指的是最后打印的小計
     LET l_i = (g_cnt + 1)/ 6
     IF (g_cnt+ 1) MOD 6 = 0 THEN
        LET g_t = g_cnt + 1
     ELSE
        LET g_t = (l_i + 1) * 6
     END IF
 
   FOR l_i = 1 TO g_t STEP 6   #每次6個coc03
         LET g_coc03=''
         LET g_line_1 = '--------------- ---------------------------------------- ---------------------------------------- --------'
         LET l_space1 = 0
         FOR l_j = 0 TO 5 #組g_coc03,g_line_1
             LET g_coc03=g_coc03 CLIPPED,' ',l_space1 SPACES,
                         g_cnp[l_i+l_j].coc03 CLIPPED
             LET l_len = 0
             LET l_space1 = 0
             LET l_len  = LENGTH(g_cnp[l_i+l_j].coc03)
             LET l_space1 = 15 - l_len
             IF l_space1 <> 15 THEN LET l_space3 = l_space1 END IF
             IF l_len <>0 THEN
                LET g_line_1 = g_line_1 CLIPPED,' ---------------'
             END IF
         END FOR
     FOREACH acor304_curs1 INTO sr.*
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       LET g_cnp05 = ''
       LET l_cnp05 = 0
       FOR l_j = 0 TO 5
           #當前coc03,cno10,cno06的cnp05
           FOREACH acor304_cno2 USING sr.coe03,sr.coe06,
                             g_cnp[l_i+l_j].coc03
                  INTO l_cnp05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
              END IF
           END FOREACH
           IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
           #不打多余的0
           IF l_i + l_j <= g_cnt THEN
              LET g_cnp05 = g_cnp05 CLIPPED,l_cnp05 USING " ---,---,--&.&&&"
           END IF
       END FOR
       LET sr.l_no = l_i
       LET sr.cnp05_s = g_cnp05
       LET sr.coc03_s = g_coc03
       LET sr.line = g_line_1
       #打完全部coc03之后的小計
       IF l_i > (g_cnt+1) - 6 THEN
          IF l_i = g_cnt + 1 THEN   #該行只有小計
             LET sr.coc03_s = sr.coc03_s CLIPPED,' ',g_x[12] CLIPPED
          ELSE
             LET sr.coc03_s = sr.coc03_s CLIPPED,' ',l_space3 SPACES,g_x[12] CLIPPED
          END IF
          LET sr.cnp05_s = sr.cnp05_s CLIPPED,sr.l_amt USING " ---,---,--&.&&&"
          LET sr.line = sr.line CLIPPED,' ---------------'
       END IF
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-750026 *** ##
    IF l_i = 1 THEN
       FOR l_j = 1 TO g_cnt
           FOREACH acor304_cno2 USING sr.coe03,sr.coe06,
                             g_cnp[l_j].coc03
                  INTO l_cnp05
              IF SQLCA.sqlcode  THEN
                 CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
              END IF
           END FOREACH
           IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
 
           EXECUTE insert_prep USING 
           sr.coe03, sr.cob02, sr.cob021 , sr.cob09  , sr.coe06,
           g_cnp[l_j].coc03,l_cnp05
              
       END FOR
    END IF
       #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
   END FOR
 
   #str FUN-750026 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750026 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'coc10,coc03,coc04,coc01,coc05,coe03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.y
   CALL cl_prt_cs3('acor304','acor304',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
