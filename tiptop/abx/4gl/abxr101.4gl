# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr101.4gl
# Descriptions...: 轉運用品帳列印作業
# Date & Author..: 2006/10/16 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/19 By TSD.lucasyeh  轉CR報表
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50082 11/07/19 By sabrina 進倉價值未帶出 
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE b_part       LIKE ima_file.ima01
DEFINE e_part       LIKE ima_file.ima01
DEFINE b_date       DATE
DEFINE e_date       DATE
DEFINE ware         LIKE bnf_file.bnf02
DEFINE p_page       LIKE type_file.num5
DEFINE last_yy,last_mm  LIKE type_file.num5
DEFINE l_c          LIKE type_file.chr1
DEFINE l_d          LIKE type_file.chr1
DEFINE p_ima        RECORD LIKE ima_file.*
DEFINE yy,mm        LIKE type_file.num5
 
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_sql      STRING,      #FUN-850089 add
         g_str      STRING,      #FUN-850089 add
         l_table    STRING,      #FUN-850089 add
         l_table1   STRING       #FUN-850089 add
DEFINE tm  RECORD                #FUN-850089 Print condition RECORD
       wc           LIKE type_file.chr1000      # Where condition
           END RECORD
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-850089 add---start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "bnf07.bnf_file.bnf07,",
               "sum1.bxj_file.bxj06,",
               "sum2.bxj_file.bxj06"
                                                #7 items
   LET l_table = cl_prt_temptable('abxr101',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "bxr11.bxr_file.bxr11,",
               "bxr12.bxr_file.bxr12,",      #MOD-B50082 add
               "bxr13.bxr_file.bxr13,",
               "bxr21.bxr_file.bxr21,",
               "bxr24.bxr_file.bxr24,",
               "bxr31.bxr_file.bxr31,",
               "bxr41.bxr_file.bxr41,",
               "bxr51.bxr_file.bxr51,",
               "bxr60.bxr_file.bxr60,",
               "bxr61.bxr_file.bxr61,",
               "bxr62.bxr_file.bxr62,",
               "bxr63.bxr_file.bxr63,",
               "bxi01.bxi_file.bxi01,",
               "bxi02.bxi_file.bxi02,",
               "bxi06.bxi_file.bxi06,",
               "bxj01.bxj_file.bxj01,",
               "bxj04.bxj_file.bxj04,",
               "bxj06.bxj_file.bxj06,",
               "bxj10.bxj_file.bxj10,",
               "bxj11.bxj_file.bxj11,", 
               "bxj15.bxj_file.bxj15"       #MOD-B50082 add
                                       #19 items
   LET l_table1 = cl_prt_temptable('abxr1011',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   #------------------------------ CR (1) ------------------------------#
 
   INITIALIZE tm.* TO NULL                # Default condition
#---FUN-850089 add---end

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add-- 
   CALL r101_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
 
END MAIN
 
FUNCTION r101_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 11 END IF
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 11
   END IF
   OPEN WINDOW r101_w AT p_row,p_col
        WITH FORM "abx/42f/abxr101"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   LET g_pdate = g_today
   LET b_date = g_today
   LET e_date = g_today
   LET p_page= 1
   LET l_c = 'N'
   LET l_d = 'N'
 
WHILE TRUE
 
   LET b_part=NULL
   LET e_part=NULL
 
   INPUT b_part,e_part,b_date,e_date,g_pdate,p_page,l_c,l_d
                 WITHOUT DEFAULTS
    FROM b_part,e_part,b_date,e_date,g_pdate,p_page,l_c,l_d
 
      ON ACTION locale
         CALL cl_show_fld_cont()                 
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD b_part
        IF NOT cl_null(b_part) THEN 
           SELECT count(*) INTO g_cnt FROM ima_file
              WHERE ima01 = b_part 
           IF g_cnt = 0 THEN
              CALL cl_err(b_part,'mfg3403',0)
              NEXT FIELD b_part
           END IF
           IF NOT cl_null(b_part) THEN
              IF b_part > e_part THEN 
                 CALL cl_err('','abx-038',0)
                 NEXT FIELD b_part
              END IF
           END IF
        END IF 
      AFTER FIELD e_part
        IF NOT cl_null(e_part) THEN 
           SELECT count(*) INTO g_cnt FROM ima_file
              WHERE ima01 = e_part 
           IF g_cnt = 0 THEN
              CALL cl_err(e_part,'mfg3403',0)
              NEXT FIELD e_part
           END IF
           IF NOT cl_null(e_part) THEN
              IF b_part > e_part THEN 
                 CALL cl_err('','abx-038',0)
                 NEXT FIELD e_part
              END IF
           END IF
        END IF 
      AFTER FIELD b_date 
        IF b_date > e_date THEN
           CALL cl_err('','mfg9234',0)
           NEXT FIELD b_date
        END IF
      AFTER FIELD e_date 
        IF e_date < b_date THEN
           CALL cl_err('','mfg9234',0) 
           NEXT FIELD e_date
        END IF
      AFTER FIELD l_c
        IF cl_null(l_c) OR l_c NOT MATCHES '[YN]' THEN NEXT FIELD l_c END IF
      AFTER FIELD l_d
        IF cl_null(l_d) OR l_d NOT MATCHES '[YN]' THEN NEXT FIELD l_d END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help       
         CALL cl_show_help()
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(b_part)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.default1 = b_part
             CALL cl_create_qry() RETURNING b_part
             DISPLAY BY NAME b_part
             NEXT FIELD b_part
 
          WHEN INFIELD(e_part)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.default1 = e_part
             CALL cl_create_qry() RETURNING e_part
             DISPLAY BY NAME e_part
             NEXT FIELD e_part
       END CASE
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   LET ware=' '
   IF p_page<1 THEN LET p_page=1 END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
END WHILE
   CLOSE WINDOW r101_w
END FUNCTION
 
FUNCTION r101()
DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0062
DEFINE l_sql     STRING        # RDSQL STATEMENT
DEFINE l_flag       LIKE type_file.chr1        #FUN-850089 add
DEFINE l_factor     LIKE type_file.num5        #FUN-850089 add
DEFINE p_bxi RECORD LIKE bxi_file.*,           #FUN-850089 add
       p_bxj RECORD LIKE bxj_file.*,           #FUN-850089 add
       p_bxr RECORD LIKE bxr_file.*            #FUN-850089 add
DEFINE sr   RECORD
            ima01  LIKE ima_file.ima01,
            ima02  LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima25  LIKE ima_file.ima25,
            bnf07  LIKE bnf_file.bnf07,
            sum1   LIKE bxj_file.bxj06,
            sum2   LIKE bxj_file.bxj06 
            END RECORD 
 
#FUN-850089 add---start
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     #------------------------------ CR (2) ------------------------------#
#FUN-850089 add---end
     
     #No.FUN-B80082--mark--Begin--- 
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0062
     #No.FUN-B80082--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog         #FUN-850089 add
 
#---FUN-850089 add---start
     #報表
     LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
 
     #子報表
     LET g_sql = "INSERT INTO ",g_cr_db_str,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"  #MOD-B50082 add ?, ?
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
#---FUN-850089 add--end-
 
     IF cl_null(b_part) THEN LET b_part=' ' END IF
     IF cl_null(e_part) OR e_part = ' ' THEN
        LET e_part='zzzzzzzzzzzzzzzzzzzz'
     END IF
 
     LET l_sql ="SELECT ima01,ima02,ima021,ima25,0 ",
                "  FROM ima_file ",
                " WHERE ima01>= '",b_part,"' AND ima01<= '",e_part,"'", 
                "   AND ima106 = '7' " 
     IF l_c = 'Y' THEN
        LET l_sql = l_sql CLIPPED," AND ima15 = 'Y' "
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY ima01 "
     PREPARE r101_pre FROM l_sql
     IF STATUS THEN
        CALL cl_err('r101_pre',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
        EXIT PROGRAM
     END IF
     #抓前期期末餘額
     LET yy = YEAR(b_date) 
     LET mm = MONTH(b_date) - 1
     IF mm = 0 THEN LET yy = yy - 1 LET mm = 12 END IF 
     DECLARE r101_curs1 CURSOR FOR r101_pre
 
 
     #保留指定倉庫的寫法,目前都不指定06/07/19
     FOREACH r101_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('fore1:',STATUS,1) EXIT FOREACH END IF
 
       #FUN-850089 add---START
       LET l_sql="SELECT bxi_file.*,bxj_file.* FROM bxj_file,bxi_file ",
                 " WHERE bxj04 = '",sr.ima01,"' ",
                 "   AND bxj01 = bxi01 ",
                 "   AND bxi02 >= '",b_date,"' ",
                 "   AND bxi02 <= '",e_date,"' ",
                 "   AND bxiconf = 'Y' " 
       IF NOT cl_null(ware) THEN
          LET l_sql=l_sql CLIPPED," AND bxj07 = '",ware,"'"
       END IF
       LET l_sql=l_sql CLIPPED," ORDER BY bxi02,bxi06,bxi01 "
       PREPARE r101_p1cr FROM l_sql
       DECLARE r101_s1_cr CURSOR FOR r101_p1cr
       #FUN-850089 add---END
 
       IF cl_null(ware) THEN
          SELECT SUM(bnf07) INTO sr.bnf07 FROM bnf_file
           WHERE bnf01=sr.ima01 AND bnf03=yy AND bnf04=mm
       ELSE
          SELECT SUM(bnf07) INTO sr.bnf07 FROM bnf_file
           WHERE bnf01=sr.ima01 AND bnf03=yy AND bnf04=mm
             AND bnf02 = ware
       END IF
       IF cl_null(sr.bnf07) THEN LET sr.bnf07=0 END IF
 
#---p_zl 2008050503---bug start
#      SELECT SUM(bnf08+bnf09+bnf005+bnf009),
#             SUM(bnf008+bnf10+bnf001+bnf004+bnf007+bnf010+bnf011)
#        INTO sr.sum1,sr.sum2
#        FROM bnf_file
#       WHERE bnf01 = sr.ima01 
#         AND bnf03*12+bnf04 BETWEEN YEAR(b_date)*12 AND YEAR(e_date)*12+MONTH(e_date)
#---p_zl 2008050503---bug end 
      
#---p_zl 2008050503---fix start
       SELECT SUM(bnf08+bnf09+bnf25+bnf29),
              SUM(bnf28+bnf10+bnf21+bnf24+bnf27+bnf30+bnf31)
         INTO sr.sum1,sr.sum2
         FROM bnf_file
        WHERE bnf01 = sr.ima01 
          AND bnf03*12+bnf04 BETWEEN YEAR(b_date)*12 AND
                                     YEAR(e_date)*12+MONTH(e_date)
#---p_zl 2008050503---fix start
 
 
       IF cl_null(sr.sum1) THEN LET sr.sum1 = 0 END IF
       IF cl_null(sr.sum2) THEN LET sr.sum2 = 0 END IF
 
       SELECT COUNT(*) INTO g_cnt FROM bxj_file,bxi_file 
          WHERE bxj04 = sr.ima01
            AND bxj01 = bxi01
            AND bxi02 >= b_date
            AND bxi02 <= e_date
            AND bxiconf = 'Y'
 
       #使用者不列印期初為零且當期無異動的資料
       IF l_d = 'N' AND sr.bnf07 = 0 AND g_cnt = 0 THEN
          CONTINUE FOREACH
       ELSE
 
         #FUN-850089 add----start
           FOREACH r101_s1_cr INTO p_bxi.*,p_bxj.*
             IF STATUS THEN CALL cl_err('s1_c:',STATUS,1) EXIT FOREACH END IF
             CALL s_umfchk(p_bxj.bxj04,p_bxj.bxj05,sr.ima25)
             RETURNING g_cnt,l_factor
             IF cl_null(l_factor) THEN LET l_factor=1 END IF
             LET p_bxj.bxj06 = p_bxj.bxj06 * l_factor
             IF STATUS THEN CALL cl_err('s1_c:',STATUS,1) EXIT FOREACH END IF
             INITIALIZE p_bxr.* TO NULL
             SELECT bxr_file.* INTO p_bxr.* FROM bxr_file
#             WHERE bxr01 = p_bxj.bxj021           #p_zl-2008050503 bug
              WHERE bxr01 = p_bxj.bxj21            #p_zl-2008050503 fix
             IF SQLCA.SQLCODE = 100 THEN 
                SELECT bxr_file.* INTO p_bxr.* FROM bxr_file
                 WHERE bxr01 = p_bxi.bxi08
             END IF
 
             EXECUTE insert_prep1 USING p_bxr.bxr11, p_bxr.bxr12, p_bxr.bxr13, p_bxr.bxr21,     #MOD-B50082 add bxr12
                                        p_bxr.bxr24, p_bxr.bxr31, p_bxr.bxr41,
                                        p_bxr.bxr51, p_bxr.bxr60, p_bxr.bxr61,
                                        p_bxr.bxr62, p_bxr.bxr63,
                                        p_bxi.bxi01, p_bxi.bxi02, p_bxi.bxi06,
                                        p_bxj.bxj01, p_bxj.bxj04, p_bxj.bxj06,
                                        p_bxj.bxj10, p_bxj.bxj11, p_bxj.bxj15        #MOD-B50082 add bxj15
            IF SQLCA.sqlcode  THEN
               CALL cl_err('insert_prep1:',STATUS,1)
               EXIT FOREACH
            END IF
 
         END FOREACH
 
         ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850089 START ##
         EXECUTE insert_prep USING sr.*
         IF SQLCA.sqlcode  THEN
            CALL cl_err('insert_prep:',STATUS,1)
            EXIT FOREACH
         END IF
         ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850089 END ##
         #FUN-850089 add----end
 
       END IF
     END FOREACH
 
#---FUN-850089 add ----start
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'')
             RETURNING g_str
     ELSE
        LET g_str = ''
     END IF
     LET g_str = g_str,";",b_date,";",e_date,";",g_bxz.bxz100,";",g_bxz.bxz101
     CALL cl_prt_cs3('abxr101','abxr101',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
#---FUN-850089 add ----end
      
      #No.FUN-B80082--mark--Begin---
      # CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0062
      #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
