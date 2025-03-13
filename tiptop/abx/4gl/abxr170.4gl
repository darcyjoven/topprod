# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr170.4gl
# Descriptions...: 替代料明細表
# Date & Author..: 96/09/10 By STAR 
# Modify.........: 05/02/23 By cate 報表標題標準化
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/22 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc     LIKE type_file.chr1000,   # Where condition  #No.FUN-680062char(1000)  
              a      LIKE type_file.chr1,                         #No.FUN-680062char(1)  
              more   LIKE type_file.chr1         # Input more condition(Y/N)  #No.FUN-680062  VARCHAR(1)
              END RECORD,
          g_mount     LIKE type_file.num10      #No.FUN-680062  integer
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE l_table        STRING                    #FUN-850089 add
DEFINE g_sql          STRING                    #FUN-850089 add
DEFINE g_str          STRING                    #FUN-850089 add
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
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "l_seq.type_file.num5,",       #序號
              "mea02.mea_file.mea02,",       #料件編號
              "ima02.ima_file.ima02,",       #品名
              "l_ima021.ima_file.ima021,",   #規格
              "bmb01.bmb_file.bmb01,",       #主件料件編號
              "bmb06.bmb_file.bmb06,",       #組成用量
              "bmb10.bmb_file.bmb10,",       #發料單位
              "bmb04.bmb_file.bmb04,",       #生效日期
              "bmb05.bmb_file.bmb05,",       #失效日期
              "ima15.ima_file.ima15,",       #保稅與否
              "mea01.mea_file.mea01 "        #流用代號
 
                                          #11 items
  LET l_table = cl_prt_temptable('abxr170',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610081 modify
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#------------No.TQC-610081 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr170_tm(4,15)        # Input print condition
      ELSE CALL abxr170()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr170_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr170_w AT p_row,p_col
        WITH FORM "abx/42f/abxr170" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a='Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON mea02  
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
 
#No.FUN-570243  --start-                                                                          
     ON ACTION CONTROLP                                                                          
            IF INFIELD(mea02) THEN                                                                
               CALL cl_init_qry_var()                                                             
               LET g_qryparam.form = "q_ima"                                                      
               LET g_qryparam.state = "c"                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                 
               DISPLAY g_qryparam.multiret TO mea02                                              
               NEXT FIELD mea02                                                                   
            END IF                                                                                
#No.FUN-570243 --end--  
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
         LET INT_FLAG = 0 CLOSE WINDOW abxr170_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr170_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr170'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr170','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",            #No.TQC-610081 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                        
         CALL cl_cmdat('abxr170',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr170_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr170()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr170_w
END FUNCTION
 
FUNCTION abxr170()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name       #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT   #No.FUN-680062 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,       #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,         #No.FUN-680062 VARCHAR(40) 
          xr               RECORD  
                                  bmb01       LIKE     bmb_file.bmb01,
                                  bmb06       LIKE     bmb_file.bmb06,
                                  bmb10       LIKE     bmb_file.bmb10,
                                  bmb04       LIKE     bmb_file.bmb04,
                                  bmb05       LIKE     bmb_file.bmb05,
                                  ima15       LIKE     ima_file.ima15
                        END RECORD,
          sr               RECORD  
                                  mea01       LIKE     mea_file.mea01,
                                  mea02       LIKE     mea_file.mea02,
                                  ima02       LIKE     ima_file.ima02,
                                  bmb01       LIKE     bmb_file.bmb01,
                                  bmb06       LIKE     bmb_file.bmb06,
                                  bmb10       LIKE     bmb_file.bmb10,
                                  bmb04       LIKE     bmb_file.bmb04,
                                  bmb05       LIKE     bmb_file.bmb05,
                                  ima15       LIKE     ima_file.ima15
                        END RECORD 
     
#FUN-850089 add---START
   DEFINE l_ima021 LIKE ima_file.ima021,
          l_mea01  LIKE mea_file.mea01,
          l_seq       LIKE type_file.num5                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET l_seq = 0 
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT mea01,mea02,ima02,' '  ,    0,' '  ,' '  , ",
                 "       ' '  ,' '      ",
                 "  FROM mea_file,OUTER ima_file ",
                 " WHERE mea_file.mea02 = ima_file.ima01 ",
                 "   AND ",tm.wc CLIPPED
     IF tm.a='Y' THEN LET l_sql=l_sql," AND ima15<>'N' " END IF
 
     PREPARE abxr170_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr170_curs1 CURSOR FOR abxr170_prepare1
 
     LET g_pageno = 0
     FOREACH abxr170_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
 
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
 
       DECLARE abxr170_curs2 CURSOR FOR
        SELECT bmb01,bmb06,bmb10,bmb04,bmb05,ima15 
          FROM bmb_file ,OUTER ima_file
         WHERE bmb03 = sr.mea02 
           AND bmb_file.bmb01 = ima_file.ima01 
         ORDER BY bmb01
       LET l_chr = '1' 
       FOREACH abxr170_curs2 INTO xr.* 
         IF SQLCA.sqlcode != 0 THEN 
      #---FUN-850089 add---START
         SELECT ima021 INTO l_ima021 FROM ima_file 
             WHERE ima01=sr.mea02
         IF SQLCA.sqlcode THEN 
             LET l_ima021 = NULL 
         END IF
 
         IF l_mea01 != sr.mea01 THEN 
            LET l_seq = l_seq+1 
            LET l_mea01 = sr.mea01
         END IF 
 
         IF l_chr = '1' THEN
            EXECUTE insert_prep USING    l_seq, sr.mea02, sr.ima02, l_ima021,
                                      sr.bmb01, sr.bmb06, sr.bmb10, sr.bmb04, 
                                      sr.bmb05, sr.ima15, sr.mea01 
         END IF
      #---FUN-850089 add---END
            EXIT FOREACH 
         END IF
         LET sr.bmb01 = xr.bmb01 
         LET sr.bmb06 = xr.bmb06 
         LET sr.bmb10 = xr.bmb10 
         LET sr.bmb04 = xr.bmb04 
         LET sr.bmb05 = xr.bmb05 
         LET sr.ima15 = xr.ima15 
         LET l_chr = ' '
 
      #---FUN-850089 add---START
         SELECT ima021 INTO l_ima021 FROM ima_file 
             WHERE ima01=sr.mea02
         IF SQLCA.sqlcode THEN 
             LET l_ima021 = NULL 
         END IF
 
         IF l_mea01 != sr.mea01 THEN 
            LET l_seq = l_seq+1 
            LET l_mea01 = sr.mea01
         END IF 
   
         EXECUTE insert_prep USING    l_seq, sr.mea02, sr.ima02, l_ima021,
                                   sr.bmb01, sr.bmb06, sr.bmb10, sr.bmb04, 
                                   sr.bmb05, sr.ima15, sr.mea01 
         IF SQLCA.sqlcode  THEN
            CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
         END IF
      #---FUN-850089 add---END
       END FOREACH 
     END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY mea01,mea02,bmb01,bmb04"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'mea02')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxr170','abxr170',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
END FUNCTION
#No.FUN-870144
