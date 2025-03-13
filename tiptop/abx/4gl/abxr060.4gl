# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxr060.4gl
# Descriptions...: 內銷登記簿
# Date & Author..: 96/07/30 By STAR 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima02
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-550033 05/05/20 By wujie 單據編號加大
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/19 By TSD.odyliao 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-BC0224 11/12/22 By ck2yuan 修改sql語法
# Modify.........: No.MOD-CC0169 12/12/26 By Elise 放大"保稅異動原因"欄寬
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD
              wc     LIKE type_file.chr1000,   # Where condition   #No.FUN-680062 VARCHAR(1000)
             #a      LIKE type_file.chr2,      #No.FUN-680062      VARCHAR(2) #MOD-CC0169 mark
              a      LIKE bxi_file.bxi08,      #MOD-CC0169
              bdate  LIKE type_file.dat,       #No.FUN-680062      date     
              edate  LIKE type_file.dat,      #No.FUN-680062      date    
              more   LIKE type_file.chr1      # Input more condition(Y/N)    #No.FUN-680062       VARCHAR(1)
           END RECORD,
       g_bxr02       LIKE bxr_file.bxr02
 
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose     #No.FUN-680062       smallint
DEFINE g_sql           STRING   #FUN-850089 add
DEFINE g_str           STRING   #FUN-850089 add
DEFINE l_table         STRING   #FUN-850089 add
 
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
   LET g_sql = "bxi02.bxi_file.bxi02,",
               "bxi03.bxi_file.bxi03,",
               "name.occ_file.occ02,",
               "bnb01.bnb_file.bnb01,",
               "bxi01.bxi_file.bxi01,",
               "bxi04.bxi_file.bxi04,",
               "bxi06.bxi_file.bxi06,",
               "bxj04.bxj_file.bxj04,",
               "ima02.ima_file.ima02,",
               "bxj06.bxj_file.bxj06,",
               "oga23.oga_file.oga23,",
               "ogb14.ogb_file.ogb14,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "ima021.ima_file.ima021"
  
      LET l_table = cl_prt_temptable('abxr060',g_sql) CLIPPED
      IF l_table = -1 THEN EXIT PROGRAM END IF
  
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
  
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
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.a      = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr060_tm(4,15)        # Input print condition
      ELSE CALL abxr060()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr060_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,      #No.FUN-680062 smallint     
          l_cmd         LIKE type_file.chr1000    #No.FUN-680062 VARCHAR(1000)      
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW abxr060_w AT p_row,p_col
        WITH FORM "abx/42f/abxr060" 
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
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more 
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
           IF cl_null(tm.edate) OR tm.edate < tm.bdate
           THEN NEXT FIELD edate END IF 
          
      AFTER FIELD a
           IF cl_null(tm.a) THEN NEXT FIELD a END IF 
           SELECT bxr02 INTO g_bxr02 FROM bxr_file WHERE bxr01 = tm.a
           IF STATUS THEN 
#             CALL cl_err('err bxr01  ' ,STATUS,0)   #No.FUN-660052
              CALL cl_err3("sel","bxr_file",tm.a,"",STATUS,"","err bxr01  ",0) 
              NEXT FIELD a      
           END IF  
           IF cl_null(g_bxr02) THEN LET g_bxr02 = tm.a END IF 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr060_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr060'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr060','9031',1)
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
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.a       CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                        
         CALL cl_cmdat('abxr060',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr060_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr060()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr060_w
END FUNCTION
 
FUNCTION abxr060()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name    #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT     #No.FUN-680062 VARCHAR(1000)
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1,   #No.FUN-680062   VARCHAR(1)  
          l_za05    LIKE za_file.za05,      #No.FUN-680062   VARCHAR(40)
          l_bnb14   LIKE bnb_file.bnb14,   #No.FUN-680062   integer
          l_ima021  LIKE ima_file.ima021,  #FUN-850089
          l_sfa03   LIKE sfa_file.sfa03,
          sr               RECORD 
                                  bxi02  LIKE bxi_file.bxi02,
                                  bxi03  LIKE bxi_file.bxi03,
                                  name   LIKE occ_file.occ02,      #No.FUN-680062  VARCHAR(24)
                                  bnb01  LIKE bnb_file.bnb01,
                                  bxi01  LIKE bxi_file.bxi01,
                                  bxi04  LIKE bxi_file.bxi04,
                                  bxi06  LIKE bxi_file.bxi06,
                                  bxj04  LIKE bxj_file.bxj04,
                                  ima02  LIKE ima_file.ima02,
                                  bxj06  LIKE bxj_file.bxj06,
                                  oga23  LIKE oga_file.oga23,
                                  ogb14  LIKE ogb_file.ogb14
                        END RECORD
 
  #FUN-850089 ----START---- add
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
  #FUN-850089 ----START---- add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

  #----------------MOD-BC0224 str --------------------- 
   # LET l_sql = "SELECT bxi02,bxi03,' ',bnb01,bxi01,bxi04,bxi06, ",
   #             "       bxj04,ima02,bxj06,oga23,ogb14   ",
   #             "  FROM ima_file,bxi_file LEFT OUTER JOIN oga_file ",
   #             "                           ON bxi01 = oga01  ",
   #             "                          AND ogaconf != 'X' ",
   #             "                         LEFT OUTER JOIN bnb_file ",
   #             "                           ON bxi01 = bnb04,",
   #             "                bxj_file LEFT OUTER JOIN ogb_file ",
   #             "                           ON bxj04 = ogb04 ",
   #             "                          AND bxj03 = ogb03 ",
   #             "                         LEFT OUTER JOIN bnc_file ",
   #             "                           ON bxj04 = bnc03  ",
   #             "                          AND bxj06 = bnc06  ",
   #             " WHERE bxi08 = '",tm.a ,"'",
   #             "   AND bxi02 BETWEEN '",tm.bdate,"'",
   #             "   AND '",tm.edate,"'",
   #             "   AND bxi01 = bxj01 ",
   #             "   AND bxj04 = ima01 ",
   #             "   AND oga_file.oga01 = ogb_file.ogb01 ",
   #             "   AND bnb_file.bnb01 = bnc_file.bnc01 ",
   #             "   AND ",tm.wc CLIPPED,
   #             " ORDER BY bxi02,bnb01,bxi01,bxj04 "

     LET l_sql = "SELECT bxi02,bxi03,' ',bnb01,bxi01,bxi04,bxi06, ",
                 "       bxj04,ima02,bxj06,oga23,ogb14   ",
                 "  FROM ima_file,(bxi_file INNER JOIN bxj_file ON bxi01 = bxj01 ) ",
                 "  LEFT OUTER JOIN (oga_file INNER JOIN ogb_file ON oga01 = ogb01) ",
                 "   ON  bxi01 = oga01 AND ogaconf != 'X' and  bxj04 = ogb04 AND bxj03 = ogb03 ",
                 "  LEFT OUTER JOIN (bnb_file INNER JOIN bnc_file ON bnb01 = bnc01) ",
                 "   ON  bxi01 = bnb04 AND bxj04 = bnc03  AND bxj06 = bnc06 ",
                 " WHERE bxi08 = '",tm.a ,"'",
                 "   AND bxi02 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND bxj04 = ima01 ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY bxi02,bnb01,bxi01,bxj04 "

  #----------------MOD-BC0224 end ---------------------


#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05 
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE abxr060_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr060_curs1 CURSOR FOR abxr060_prepare1
 
     LET g_pageno = 0
     FOREACH abxr060_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.bxj06) THEN LET sr.bxj06 = 0 END IF 
       IF cl_null(sr.ogb14) THEN LET sr.ogb14 = 0 END IF 
#      SELECT pmc03 INTO sr.name FROM pmc_file WHERE pmc01=sr.bxi03
#      IF SQLCA.SQLCODE THEN
          SELECT occ02 INTO sr.name FROM occ_file WHERE occ01=sr.bxi03
#      END IF
       IF cl_null(sr.name) THEN LET sr.name = ' ' END IF 
 
  #FUN-850089 ------START-----
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
       FROM azi_file WHERE azi01=sr.oga23
     LET l_ima021 = ''
     SELECT ima021 INTO l_ima021 FROM ima_file
         WHERE ima01=sr.bxj04
     IF SQLCA.sqlcode THEN
         LET l_ima021 = NULL
     END IF
 
     EXECUTE insert_prep USING 
         sr.*,t_azi03,t_azi04,t_azi05,l_ima021
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
 
    LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.a,";",g_bxr02
    CALL cl_prt_cs3('abxr060','abxr060',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
  #FUN-840139  -----END----- add
 
END FUNCTION
#No.FUN-870144
