# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr120.4glg
# Descriptions...: 內銷報稅明細表
# Date & Author..: 96/08/23 By STAR 
# Modify.........: No.FUN-530012 05/03/21 By kim 報表轉XML功能
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/23 By TSD.sar2436 報表改由CR產出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                 # Print condition RECORD
              wc      VARCHAR(1000),    # Where condition
              yea     LIKE type_file.num5,      #No.FUN-680062  smallint
              mo      LIKE type_file.num5,      #No.FUN-680062  smallint
              more    LIKE type_file.chr1       #No.FUN-680062  VARCHAR(1)
              END RECORD,
          g_mount       LIKE type_file.num10    #No.FUN-680062 integer
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
---FUN-850089 add ---start
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql = "bng01.bng_file.bng01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "bnf10.bnf_file.bnf10,",
             "ima25.ima_file.ima25,",
 
             "ima15.ima_file.ima15,",
             "bng06.bng_file.bng06,",
             "bng05.bng_file.bng05,",
             "bng07.bng_file.bng07,",
             "bng08.bng_file.bng08,",
 
             "ima25_2.ima_file.ima25,",
             "ima02_2.ima_file.ima02,",
             "ima021_2.ima_file.ima021"
 
             
        
 LET l_table = cl_prt_temptable('abxr120',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1)
    EXIT PROGRAM
 END IF
#------------------------------ CR (1) ------------------------------#
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-------------No.TQC-610081 modify
#  LET tm.wc = ARG_VAL(7)
   LET tm.yea = ARG_VAL(7)
   LET tm.mo    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#-------------No.TQC-610081 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr120_tm(4,15)        # Input print condition
      ELSE CALL abxr120()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr120_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col =22 
   ELSE LET p_row = 5 LET p_col =12 
   END IF
   OPEN WINDOW abxr120_w AT p_row,p_col
        WITH FORM "abx/42f/abxr120" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#  LET tm.wc = '1=1' 
WHILE TRUE
   INPUT BY NAME tm.yea,tm.mo,tm.more 
   WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
 
      AFTER FIELD yea
           IF cl_null(tm.yea) THEN NEXT FIELD yea END IF 
 
      AFTER FIELD mo
           IF cl_null(tm.mo) OR tm.mo >12 OR tm.mo < 1 THEN 
              NEXT FIELD mo 
           END IF 
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr120','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
#                        " '",tm.wc CLIPPED,"'",
                         " '",tm.yea     CLIPPED,"'",
                         " '",tm.mo      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                        
         CALL cl_cmdat('abxr120',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr120()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr120_w
END FUNCTION
 
FUNCTION abxr120()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name         #No.FUN-680062 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062char(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680062   VARCHAR(1)      
          l_za05    LIKE za_file.za05,            #No.FUN-680062   VARCHAR(40)
          l_ima021  LIKE ima_file.ima021,         #FUN-850089 add
          l_ima021_2  LIKE ima_file.ima021,         #FUN-850089 add
          sr               RECORD bng01  LIKE bng_file.bng01, #主件料件編號
                                  ima02h LIKE ima_file.ima02,
                                  bnf10  LIKE bnf_file.bnf10,
                                  ima25h LIKE ima_file.ima25,
                                  bng06  LIKE bng_file.bng06,
                                  bng05  LIKE bng_file.bng05,
                                  ima02  LIKE ima_file.ima02,
                                  ima25  LIKE ima_file.ima25,
                                  ima15  LIKE ima_file.ima15,
                                  bng07  LIKE bng_file.bng07,
                                  bng08  LIKE bng_file.bng08
                        END RECORD
 
#FUN-850089 add---START
DEFINE l_sql2    STRING
## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT bng01,' ',bnf10,' ',bng06,bng05,ima02,ima25,ima15, ",
                 "       bng07,bng08 ",
                 "  FROM bng_file,bnf_file,ima_file  ",
                 " WHERE bng05 = ima01 ",
         #       "   AND ima15 MATCHES '[13]' ",
                 "   AND bng01 = bnf01 ",
                 "   AND bng02 = bnf02 ",
                 "   AND bng03 = bnf03 ",
                 "   AND bng04 = bnf04 ",
                 "   AND bng03 = ",tm.yea,
                 "   AND bng04 = ",tm.mo  
     DISPLAY "l_sql:",l_sql
 
     PREPARE abxr120_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr120_curs1 CURSOR FOR abxr120_prepare1
 
     LET g_pageno = 0
     FOREACH abxr120_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bnf10) THEN LET sr.bnf10 = 0 END IF 
       IF cl_null(sr.bng07) THEN LET sr.bng07 = 0 END IF 
       IF cl_null(sr.bng08) THEN LET sr.bng08 = 0 END IF 
#      IF sr.ima15 MATCHES '[Yy]' THEN LET sr.ima15 = 'B' END IF 
       SELECT ima02,ima25 INTO sr.ima02h,sr.ima25h 
         FROM ima_file WHERE ima01 = sr.bng01 
       IF STATUS THEN LET sr.ima02h = ' ' LET sr.ima25h = ' ' END IF 
     #---FUN-850089 add---START
       LET l_ima021 = ''
       SELECT ima021 INTO l_ima021 
        FROM ima_file WHERE ima01 = sr.bng01
       LET l_ima021_2 = ''
       SELECT ima021 INTO l_ima021_2 
        FROM ima_file WHERE ima01 = sr.bng05
          
       EXECUTE insert_prep USING sr.bng01,   sr.ima02h,  l_ima021,  sr.bnf10,   sr.ima25h, 
                                 sr.ima15,   sr.bng06,   sr.bng05,  sr.bng07,   sr.bng08, 
                                 sr.ima25,   sr.ima02,   l_ima021_2
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
     #---FUN-850089 add---END
     END FOREACH
 
 #FUN-850089  ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql2= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'')
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
              
               #P1               #P2               #P3
   LET g_str = g_str,";",        tm.yea,";",    tm.mo
   CALL cl_prt_cs3('abxr120','abxr120',l_sql2,g_str)
   #------------------------------ CR (4) ------------------------------#
 #FUN-850089  ----end---
END FUNCTION
#NO.FUN-870144
