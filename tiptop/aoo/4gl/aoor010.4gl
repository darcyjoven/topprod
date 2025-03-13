# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Descriptions...: 程式使用率分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 94/07/26 By Danny
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.FUN-640166 06/04/11 By Alexstar 新增日期合理性檢查程式段
# Modify.........: No.TQC-660018 06/06/06 By Smapmin 依不同語言別抓取程式名稱
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-740014 07/04/03 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-C30804 12/03/21 By Vampire l_sql段抓取的時間格式，oracle並不適用
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
   DEFINE tm  RECORD                    # Print condition RECORD
           #   wc      VARCHAR(1000),        # Where condition
              wc      STRING,     #TQC-630166   # Where condition
              b_date  LIKE type_file.dat,                #使用時間        #No.FUN-680102 DATE
              e_date  LIKE type_file.dat,           #No.FUN-680102 DATE
              t       LIKE type_file.chr1,           #No.FUN-680102CHAR(1),   #使用者匯總
              s       LIKE type_file.chr1,           #No.FUN-680102CHAR(1),          #排列順序
              a       LIKE type_file.num5,           #No.FUN-680102    SMALLINT,     #最少使用時間
              b       LIKE type_file.num5,           #No.FUN-680102   SMALLINT,    #最少次數
              more    LIKE type_file.chr1            #No.FUN-680102   VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal   LIKE ccp_file.ccp03       #No.FUN-680102 SMALLINT,     # User defined variable
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_head1         STRING
DEFINE l_table     STRING                       ### FUN-740014 add ###
DEFINE g_sql       STRING                       ### FUN-740014 add ###
DEFINE g_str       STRING                       ### FUN-740014 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80035   ADD #FUN-BB0047 mark
 
   #str FUN-740014 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740014 *** ##
   LET g_sql = "order1.type_file.chr20,",
               "zu01.zu_file.zu01,",
               "zz02.zz_file.zz02,",
               "zu04.zu_file.zu04,",
               "zx02.zx_file.zx02,",
               "zu05.zu_file.zu05,",
               "sr01.type_file.num5 "
 
   LET l_table = cl_prt_temptable('aoor010',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date=ARG_VAL(8)  
   LET tm.e_date=ARG_VAL(9)  
   LET tm.t  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.a  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aoor010_tm(0,0)             # Input print condition
      ELSE CALL aoor010()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
END MAIN
 
FUNCTION aoor010_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680102 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680102CHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 32
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW aoor010_w AT p_row,p_col WITH FORM "aoo/42f/aoor010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                 # Default condition
   LET tm.b_date=g_today   
   LET tm.e_date=g_today
   LET tm.t    = 'N'
   LET tm.s    = '1'
   LET tm.a    = 0
   LET tm.b    = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON zu01
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
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aoor010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.t,tm.s,tm.a,tm.b,tm.more     
   INPUT BY NAME tm.b_date,tm.e_date,tm.a,tm.b,tm.t,tm.s,tm.more
         WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b_date
        IF cl_null(tm.b_date) THEN NEXT FIELD b_date END IF 
      AFTER FIELD e_date
        IF tm.e_date<tm.b_date THEN 
           CALL cl_err('','ams-820',0)  #FUN-640166
           NEXT FIELD e_date   
        END IF
        IF cl_null(tm.e_date) THEN LET tm.e_date=g_today END IF
      AFTER FIELD s  
        IF tm.s NOT MATCHES '[1,2,3,4]' OR tm.s IS NULL THEN
           NEXT FIELD tm.s
        END IF
      AFTER FIELD a
        IF cl_null(tm.a) THEN NEXT FIELD a  END IF 
      AFTER FIELD b
        IF cl_null(tm.b) THEN NEXT FIELD b  END IF   
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW aoor010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aoor010'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aoor010','9031',1)    
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
                         " '",tm.b_date CLIPPED,"'",
                         " '",tm.e_date CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aoor010',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aoor010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aoor010()
   ERROR ""
END WHILE
   CLOSE WINDOW aoor010_w
END FUNCTION
 
FUNCTION aoor010()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680102CHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(40)
          sr        RECORD 
                    order1   LIKE type_file.chr20,          #No.FUN-680102CHAR(20),
                    zu01   LIKE zu_file.zu01,    #程式編號
                    zz02   LIKE zz_file.zz02,    #程式名稱
                    zu04   LIKE zu_file.zu04,    #使用者編號
                    zx02   LIKE zx_file.zx02,    #使用者名稱
                    zu05   LIKE zu_file.zu05,    #使用時間
                    sr01   LIKE type_file.num5           #No.FUN-680102SMALLINT       #count
                    END RECORD 
 
   #str FUN-740014  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-740014  add
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   #No.FUN-BB0047--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740014 add ###
     
    IF tm.t='Y' THEN
    LET l_sql = "SELECT ' ',zu01,' ',zu04,' ',SUM(zu05),COUNT(*) ",
                " FROM zu_file ",
                #" WHERE zu02 between cast('",tm.b_date,"' AS DATETIME) AND cast('",tm.e_date,"' AS DATETIME)", #MOD-C30804 mark
                " WHERE zu02 between '",tm.b_date,"' AND '",tm.e_date,"'", #MOD-C30804 add
                " AND ",tm.wc CLIPPED,
" GROUP BY zu01,zu04 ",
                " ORDER BY 1"
    ELSE 
    LET l_sql = "SELECT ' ',zu01,' ',' ',' ',SUM(zu05),COUNT(*) ",
                " FROM zu_file ",
                #" WHERE zu02 between cast('",tm.b_date,"' AS DATETIME) AND cast('",tm.e_date,"' AS DATETIME)", #MOD-C30804 mark
                " WHERE zu02 between '",tm.b_date,"' AND '",tm.e_date,"'", #MOD-C30804 add
                " AND ",tm.wc CLIPPED,
" GROUP BY zu01 ",
                " ORDER BY 1"
    END IF
     PREPARE aoor010_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
        EXIT PROGRAM
     END IF
     DECLARE aoor010_c1 CURSOR FOR aoor010_p1
 
     LET g_pageno = 0
 
     FOREACH aoor010_c1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time              #FUN-B80035   ADD
          EXIT PROGRAM
       END IF
       IF tm.s='1' THEN LET sr.order1=sr.zu01 END IF
       IF tm.s='2' THEN LET sr.order1=sr.zu04 END IF
       IF tm.s='3' THEN LET sr.order1=sr.zu05 USING "###&.&" END IF
       IF tm.s='4' THEN LET sr.order1=sr.sr01 USING "####" END IF
       IF sr.zu05 > tm.a AND sr.sr01 > tm.b THEN
       #str FUN-740014 add 
       IF tm.t = 'Y' THEN
          SELECT gaz03 INTO sr.zz02 FROM gaz_file
             WHERE gaz01 = sr.zu01 AND gaz02 = g_lang
          SELECT zx02 INTO sr.zx02 FROM zx_file
             WHERE zx01 = sr.zu04
       ELSE
          SELECT gaz03 INTO sr.zz02 FROM gaz_file
             WHERE gaz01 = sr.zu01 AND gaz02 = g_lang
       END IF
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.zu01,sr.zz02,sr.zu04,sr.zx02,
         sr.zu05  ,sr.sr01
       #------------------------------ CR (3) ------------------------------#
       #end FUN-740014 add 
       END IF
     END FOREACH
 
   #str FUN-740014 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'zu01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.b_date,";",tm.e_date
   CALL cl_prt_cs3('aoor010','aoor010',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740014 add 
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   #No.FUN-BB0047--mark--End-----    
END FUNCTION
