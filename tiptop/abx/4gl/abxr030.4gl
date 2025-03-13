# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abxr030.4gl
# Descriptions...: 放行單已銷案明細表
# Date & Author..: 96/07/26 By STAR 
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-550033 05/05/120By wujie 單據編號加大
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/19 By TSD.odyliao 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990118 09/10/15 By lilingyu CR報表中欄位"備注"未帶出相應的資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc     LIKE type_file.chr1000,   # Where condition          #No.FUN-680062   VARCHAR(1000)
              bdate  LIKE type_file.dat,                                  #No.FUN-680062   date
              edate  LIKE type_file.dat,                                  #No.FUN-680062   date
              bdate1 LIKE type_file.dat,                                  #No.FUN-680062   date
              edate1 LIKE type_file.dat,                                  #No.FUN-680062   date  
              more   LIKE type_file.chr1,    # Input more condition(Y/N)  #No.FUN-680062   VARCHAR(1)
              s      LIKE type_file.chr3,          # Order by sequence    #No.FUN-680062   VARCHAR(3)
              t      LIKE type_file.chr3           # Eject sw             #No.FUN-680062   VARCHAR(3)    
              END RECORD,
          g_mount  LIKE type_file.num10               #No.FUN-680062 integer
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062  smallint
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
 
#FUN-850089 ----START----  add
    LET g_sql = "bnb02.bnb_file.bnb02,", #出區日期
                "bnb01.bnb_file.bnb01,", #放行單號
                "bnb12.bnb_file.bnb12,", #應返日期
                "bnb13.bnb_file.bnb13,", #銷案日期
                "bnb03.bnb_file.bnb03,", #資料來源
                "bnb04.bnb_file.bnb04,", #原始單據號碼
#               "bnb16.bnb_file.bnb16"   #工單號碼          #TQC-990118 
                "bnb16.bnb_file.bnb16,", #工單號碼          #TQC-990118 
                "bnb15.bnb_file.bnb15"                      #TQC-990118 
 
    LET l_table = cl_prt_temptable('abxr030',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
 
 LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
#             " VALUES(?,?,?,?,?,?,?)"       #TQC-990118 
              " VALUES(?,?,?,?,?,?,?,?)"     #TQC-990118 
 
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
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.bdate  = ARG_VAL(10)
   LET tm.edate  = ARG_VAL(11)
#---------------No.TQC-610081 modify
   LET tm.bdate1 = ARG_VAL(12)
   LET tm.edate1 = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
#---------------No.TQC-610081 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr030_tm(4,10)        # Input print condition
      ELSE CALL abxr030()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr030_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062  smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062  VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW abxr030_w AT p_row,p_col WITH FORM "abx/42f/abxr030" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.bdate1= g_today
   LET tm.edate1= g_today
   LET tm.s  = '321'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
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
   INPUT BY NAME tm.bdate,tm.edate,tm.bdate1,tm.edate1,
                 tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm.more
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
 
 
   
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF 
 
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate<tm.bdate 
           THEN NEXT FIELD edate END IF 
 
      AFTER FIELD bdate1
           IF cl_null(tm.bdate1) THEN NEXT FIELD bdate1 END IF 
 
      AFTER FIELD edate1
           IF cl_null(tm.edate1) OR tm.edate1<tm.bdate1 
           THEN NEXT FIELD edate1 END IF 
 
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
 
     AFTER INPUT   #FUN-850089 ------ Mod 產中bug我來改
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr030_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr030'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr030','9031',1)
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
                         " '",tm.s  CLIPPED,"'",
                         " '",tm.t  CLIPPED,"'",
                         " '",tm.bdate  CLIPPED,"'",
                         " '",tm.edate  CLIPPED,"'",
                         " '",tm.bdate1 CLIPPED,"'",
                         " '",tm.edate1 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                         
         CALL cl_cmdat('abxr030',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr030_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr030()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr030_w
END FUNCTION
 
FUNCTION abxr030()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680062  VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680062    VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680062 VARCHAR(40) 
          l_order   ARRAY[3] OF LIKE bnb_file.bnb01,             #No.FUN-550033  #No.FUN-680062  VARCHAR(16)
          sr               RECORD order1 LIKE bnb_file.bnb01,    #No.FUN-550033  #No.FUN-680062  VARCHAR(16) 
                                  order2 LIKE bnb_file.bnb01,    #No.FUN-550033  #No.FUN-680062  VARCHAR(16) 
                                  order3 LIKE bnb_file.bnb01,    #No.FUN-550033  #No.FUN-680062  VARCHAR(16) 
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb12  LIKE bnb_file.bnb12,
                                  bnb13  LIKE bnb_file.bnb13,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb16  LIKE bnb_file.bnb16,
                                  bnb15  LIKE bnb_file.bnb15      #TQC-990118                                  
                        END RECORD
  #FUN-850089 ----START---- add
 
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','','',bnb02,bnb01,bnb12,bnb13,bnb03,  ",
                 "       bnb04,bnb16,bnb15 ",      #TQC-990118 add bnb15
                 "  FROM bnb_file ",
                 " WHERE bnb02 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND bnb13 BETWEEN '",tm.bdate1,"'",
                 "   AND '",tm.edate1,"'"
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05 
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE abxr030_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr030_curs1 CURSOR FOR abxr030_prepare1
 
     LET g_pageno = 0                             #FUN-850089 Mark
     LET g_mount = 0                              #FUN-850089 Mark 
     FOREACH abxr030_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bnb16) THEN LET sr.bnb16 = ' ' END IF 
   #FUN-850089 Marked --START--
       FOR g_i = 1 TO 3
          CASE 
           WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bnb02 USING 'yyyymmdd'
           WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bnb13 USING 'yyyymmdd'
           WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.bnb01
           OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
   #FUN-850089 Marked --END--
    #FUN-850089 ------START-----
       LET g_mount = g_mount + 1   #FUN-850089 Mark
 
       EXECUTE insert_prep USING 
           sr.bnb02,sr.bnb01,sr.bnb12,sr.bnb13,
           sr.bnb03,sr.bnb04,sr.bnb16,sr.bnb15            #TQC-990118 add bnb15
    #FUN-850089 ------END-----
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
 
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",
                tm.bdate,";",tm.edate,";",
                tm.bdate1,";",tm.edate1
    CALL cl_prt_cs3('abxr030','abxr030',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
  #FUN-840139  -----END----- add
 
END FUNCTION
#No.FUN-870144
