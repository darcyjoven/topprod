# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr050.4gl
# Descriptions...: 委外工單補料記錄
# Date & Author..: 96/07/29 By STAR 
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-550033 05/05/20 By wujie 單據編號加大
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/22 By TSD.odyliao 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition #No.FUN-680062   VARCHAR(1000)
              ba      LIKE type_file.chr2,                        #No.FUN-680062   VARCHAR(2)
              ea      LIKE type_file.chr2,                        #No.FUN-680062   VARCHAR(2)  
              bsfb01  LIKE type_file.chr20,    #No.FUN-550033     #No.FUN-680062   VARCHAR(16)
              esfb01  LIKE type_file.chr20,    #No.FUN-550033     #No.FUN-680062   VARCHAR(16)
              more    LIKE type_file.chr1      # Input more condition(Y/N)  #No.FUN-680062  VARCHAR(1) 
              END RECORD,
          g_mount    LIKE type_file.num10      #No.FUN-680062   integer 
 
DEFINE   g_i         LIKE type_file.num5       #count/index for any purpose        #No.FUN-680062  smallint
DEFINE   g_sql           STRING   #FUN-850089 add
DEFINE   g_str           STRING   #FUN-850089 add
DEFINE   l_table         STRING   #FUN-850089 add
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
 
   #FUN-850089 ----START---- add
   LET g_sql = "code.type_file.chr1,",
               "bnb08.bnb_file.bnb08,",
               "bnb13.bnb_file.bnb13,",
               "bnb16.bnb_file.bnb16,",
               "bnc03.bnc_file.bnc03,",
               "ima02.bnc_file.bnc04,",
               "sfa05.sfa_file.sfa05,",
               "sfa06.sfa_file.sfa06,",
               "bnb02.bnb_file.bnb02,",
               "bnc06.bnc_file.bnc06,",
               "bnb01.bnb_file.bnb01,",
               "ima021.ima_file.ima021"
  
      LET l_table = cl_prt_temptable('abxr050',g_sql) CLIPPED
      IF l_table = -1 THEN EXIT PROGRAM END IF
  
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
  
   PREPARE insert_prep FROM g_sql
  
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-850089 ----END----  add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bsfb01 = ARG_VAL(8)
   LET tm.esfb01 = ARG_VAL(9)
   LET tm.ba     = ARG_VAL(10)
   LET tm.ea     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr050_tm(4,15)        # Input print condition
      ELSE CALL abxr050()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr050_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col       LIKE type_file.num5,       #No.FUN-680062  smallint
          l_cmd          LIKE type_file.chr1000     #No.FUN-680062  VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
 
   OPEN WINDOW abxr050_w AT p_row,p_col
        WITH FORM "abx/42f/abxr050" 
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
   LET tm.wc = '1=1' 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bnb08,bnb13,bnb02,bnb16
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr050_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr050_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr050'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr050','9031',1)
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
                         " '",tm.bsfb01  CLIPPED,"'",
                         " '",tm.esfb01  CLIPPED,"'",
                         " '",tm.ba      CLIPPED,"'",
                         " '",tm.ea      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                        
         CALL cl_cmdat('abxr050',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr050_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr050()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr050_w
END FUNCTION
 
FUNCTION abxr050()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680062 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680062 VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40)  
          l_bnc06   LIKE bnc_file.bnc06,          #No.FUN-680062 integer  
          l_ima021  LIKE ima_file.ima021,   #FUN-850089
          l_bnc03   LIKE bnc_file.bnc03,               
          sr               RECORD code   LIKE type_file.chr1,       #No.FUN-680062   VARCHAR(1)
                                  bnb08  LIKE bnb_file.bnb08,
                                  bnb13  LIKE bnb_file.bnb13,
                                  bnb16  LIKE bnb_file.bnb16,
                                  bnc03  LIKE bnc_file.bnc03,
                                  ima02  LIKE bnc_file.bnc04,
                                  sfa05  LIKE sfa_file.sfa05,
                                  sfa06  LIKE sfa_file.sfa06,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnb01  LIKE bnb_file.bnb01
                        END RECORD
 
  #FUN-850089 ----START---- add
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
  #FUN-850089 ----END---- add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ' ',bnb08,",
                 "bnb13,bnb16,bnc03,bnc04,sfa05,sfa06,bnb02,bnc06,bnb01 ",
                 "  FROM bnc_file, bnb_file, sfa_file ",
                 " WHERE bnb01 = bnc01 ",
            #    "   AND bnb08 = '10'  ",          #NO:2808
                 "   AND bnb16 = sfa01 ",
                 "   AND bnc03 = sfa03 ",
                 "   AND ",tm.wc CLIPPED,
                 "   ORDER BY bnb16,bnb02,bnc03  " 
#No.CHI-6A0004-begin
#     SELECT azi03,azi04,azi05 
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-end
 
     PREPARE abxr050_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr050_curs1 CURSOR FOR abxr050_prepare1
 
     LET g_pageno = 0
     LET l_bnc03 = ' '
     FOREACH abxr050_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.sfa05) THEN LET sr.sfa05 = 0 END IF 
       IF cl_null(sr.bnc06) THEN LET sr.bnc06 = 0 END IF 
   #   IF l_bnc03 != sr.bnc03 THEN LET l_bnc06 = 0 END IF 
   #   LET l_bnc06 = l_bnc06 + sr.bnc06
   #   IF sr.sfa05 = l_bnc06 THEN LET sr.code = 'Y' END IF 
 
    #FUN-850089 ------START-----
 
        LET l_bnc06=0
        SELECT bnc06 INTO l_bnc06 FROM bnc_file,bnb_file
           WHERE bnc03=sr.bnc03 AND bnc01=bnb01 AND bnb16=sr.bnb16
           AND bnb08='02'
        LET sr.sfa05=sr.sfa05-l_bnc06 #缺料數=應發數-委外加工數
        LET l_bnc06=0 #補料合計
        SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file,bnb_file
           WHERE bnc03=sr.bnc03 AND bnc01=bnb01 AND bnb16=sr.bnb16
           AND bnb08='10'
        IF l_bnc06=sr.sfa05 THEN LET sr.code='Y' END IF
 
         SELECT ima021 INTO l_ima021 FROM ima_file 
             WHERE ima01=sr.bnc03
         IF SQLCA.sqlcode THEN 
             LET l_ima021 = NULL 
         END IF
         EXECUTE insert_prep USING sr.*,l_ima021 
    #FUN-850089 ------END-----
 
   #   LET l_bnc03 = sr.bnc03 
     END FOREACH
 
  #FUN-840139  ----START---- add
   SELECT zz05 INTO g_zz05 FROM zz_file
       WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'') RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = ''
   END IF
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
 
    CALL cl_prt_cs3('abxr050','abxr050',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
  #FUN-840139  -----END----- add
 
END FUNCTION
#No.FUN-870144
