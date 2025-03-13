# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acor301.4gl
# Descriptions...: 半成品/成品折合原料明細表列印 
# Date & Author..: 02/12/27 By Leagh
# Modify.........: NO.MOD-490398 04/11/24 BY Elva add HS Code,去掉ima75,LIKE定義方式
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗 
# Modify.........: No.FUN-590110 05/09/27 by wujie  報表轉xml  
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err峈cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl 類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.MOD-710195 07/02/07 By wujie 修正單行順序打印會報錯
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-840238 08/05/28 By TSD.liquor 傳統報表轉Crystal Report
# Modify.........: No.FUN-870029 08/07/10 By TSD.hoho   傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.TQC-960271 09/06/25 By destiny 選擇coa_file資料時where缺少條件 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(500) # Where condition
              a       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) # Input condition(1/2/3)
              b       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) # Input condition(1/2/3)
              c       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) # Input (y/n)
              y       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) # NO.MOD-490398
              more    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
              END RECORD,
          g_counter   LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE  g_sql       STRING,      #FUN-840238 add
        g_str       STRING,      #FUN-840238 add
        l_table     STRING       #FUN-840238 add No.FUN-870029
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
 
#---FUN-840238 add ---start
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "cob09.cob_file.cob09,",
               "coq01.coq_file.coq01,",
               "coq02.coq_file.coq02,",
               "ima25.ima_file.ima25,",
               "coq03.coq_file.coq03,",
               "coq04.coq_file.coq04,",
               "coq05.coq_file.coq05,",
               "coq06.coq_file.coq06,",
               "coq07.coq_file.coq07,",
               "coq08.coq_file.coq08,",
               "cob04.cob_file.cob04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima02_m.ima_file.ima02,",
               "ima021_m.ima_file.ima021,",  
               "count.coa_file.coa04,",  
               "coq10.coq_file.coq10,",
               "coa04.coa_file.coa04,", 
               "count2.coa_file.coa04"
 
   LET l_table = cl_prt_temptable('acor211',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #------------------------------ CR (1) ------------------------------#
#---FUN-840238 add ---end
 
 
   INITIALIZE tm.* TO NULL                # Default condition
#-----------------No.TQC-610082 modify
#  LET tm.more = 'N'
#  LET tm.a    = '1'
#  LET tm.b    = '1'
#  LET tm.c    = 'N'
#   LET tm.y    = 'N'    #NO.MOD-490398
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
#  LET tm.wc    = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(10)
   LET tm.y    = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
#-----------------No.TQC-610082 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL acor301_tm(0,0)               # Input print condition
   ELSE 
      CALL acor301()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor301_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW acor301_w AT p_row,p_col WITH FORM "aco/42f/acor301" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
    LET tm.y   = 'N'    #NO.MOD-490398
#-----------------No.TQC-610082 add
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET tm.a    = '1'
   LET tm.b    = '1'
   LET tm.c    = 'N'
   LET tm.y    = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#-----------------No.TQC-610082 end
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON coq02,coq01,coq03,coq04,coq05 
#No.FUN-570243 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP                                                                                              
            IF INFIELD(coq01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO coq01                                                                                 
               NEXT FIELD coq01                                                                                                     
            END IF  
            IF INFIELD(coq02) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO coq02                                                                                 
               NEXT FIELD coq02                                                                                                     
            END IF  
#No.FUN-570243 --end-- 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor301_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME tm.a,tm.b,tm.c,tm.y,tm.more WITHOUT DEFAULTS #NO.MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[12]" OR cl_null(tm.a)
            THEN NEXT FIELD a
         END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[12]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)
            THEN NEXT FIELD c
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW acor301_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor301'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('acor301','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.y CLIPPED,"'" ,             #No.TQC-610082 add
                        #" '",tm.more CLIPPED,"'"  ,         #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acor301',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor301_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor301()
   ERROR ""
END WHILE
   CLOSE WINDOW acor301_w
END FUNCTION
 
FUNCTION acor301()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,           # NO.MOD-490398
          l_flag    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_fac     LIKE ima_file.ima31_fac,         #No.FUN-680069 DEC(16,8)
          l_count   LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_coq00   LIKE coq_file.coq00,# NO.MOD-490398 
          l_coq01   LIKE coq_file.coq01,
          l_coq     RECORD
                    coq02     LIKE coq_file.coq02,
                    coq03     LIKE coq_file.coq03,
                    coq04     LIKE coq_file.coq04,
                    coq05     LIKE coq_file.coq05,
                    coq07     LIKE coq_file.coq07 
                    END RECORD,
          l_coq_t   RECORD
                    coq02     LIKE coq_file.coq02,
                    coq03     LIKE coq_file.coq03,
                    coq04     LIKE coq_file.coq04,
                    coq05     LIKE coq_file.coq05,
                    coq07     LIKE coq_file.coq07 
                    END RECORD,
#No.FUN-590110--begin
          sr_t     RECORD        
                    coq02     LIKE coq_file.coq02,
                    coq01     LIKE coq_file.coq01 
                    END RECORD,
          sr        RECORD        
                    coq01     LIKE coq_file.coq01,
                    coq02     LIKE coq_file.coq02,
                    ima25     LIKE ima_file.ima25,
                    coq03     LIKE coq_file.coq03,
                    coq04     LIKE coq_file.coq04,
                    coq05     LIKE coq_file.coq05,
                    coq06     LIKE coq_file.coq06,
                    coq07     LIKE coq_file.coq07,
                    coq08     LIKE coq_file.coq08,
                    cob04     LIKE cob_file.cob04,
                    ima02_m   LIKE ima_file.ima02,
                    ima021_m  LIKE ima_file.ima021,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    count     LIKE coa_file.coa04,        #No.FUN-680069 DEC(15,3)
                    coq10     LIKE coq_file.coq10,
 #                  ima77     LIKE ima_file.ima77, #NO.MOD-490398
                    coa04     LIKE coa_file.coa04, #NO.MOD-490398
                    count2    LIKE coa_file.coa04        #No.FUN-680069 DEC(15,3)
                    END RECORD 
   #FUN-840238 add----------------------
   DEFINE l_cob09   LIKE cob_file.cob09,
          l_coa03   LIKE coa_file.coa03
   #FUN-840238 add end------------------  
   
     #FUN-840238 add 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #其他列印條件
     #FUN-840238 add end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF SQLCA.sqlcode THEN 
#     CALL cl_err('',SQLCA.sqlcode,0) #No.TQC-660045
      CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.SQLCODE,"","",0) #NO.TQC-660045 
     END IF     
     IF tm.a = '1' THEN LET l_coq00 = '2' ELSE LET l_coq00 = '3' END IF
     IF tm.b = '1' THEN     #依成品
        IF tm.c = 'N' THEN 
           LET l_sql="SELECT UNIQUE coq01,coq02,ima25,'','','',coq06,'',coq08,",
                     "       '',ima02,'','','',0,coq10,'',0",
                     "  FROM coq_file,ima_file ",
                     " WHERE coq02 = ima01 AND coq00 = ? ",
                     "   AND ",tm.wc CLIPPED,
                     " ORDER BY coq01,coq02 "
        ELSE 
           LET l_sql="SELECT coq01,coq02,ima25,coq03,coq04,coq05,",
                     "       coq06,coq07,coq08,'',ima02,'','','',0,coq10,",
                     "       '',0",
                     "  FROM coq_file,ima_file ",
                     " WHERE coq02 = ima01 AND coq00 = ? ",
                     "   AND ",tm.wc CLIPPED,
                     " ORDER BY coq01,coq02,coq03,coq04,coq05 "
        END IF
     ELSE 
        IF tm.c = 'N' THEN   #依原料
 #NO.MOD-490398--begin
           LET l_sql="SELECT UNIQUE coq01,coq02,ima25,'','','',coq06,coq07,coq08,cob04,",
                     "       ima02,'','','',0,coq10,coa04,0 ",
                     "  FROM coq_file,ima_file,cob_file,coa_file LEFT OUTER JOIN coz_file ON coa05 = coz02 ",
                     " WHERE coq01 = ima01",
                     "   AND cob01 = coa03 AND coa01 = ima01 ",
                     "   AND coq00 = ? AND ",tm.wc CLIPPED,
 #NO.MOD-490398--end
                     " ORDER BY coq01,coq02  "
        ELSE                 #依原料
 #NO.MOD-490398--begin
#          LET l_sql="SELECT coq01,coq02,ima25,coq03,coq04,coq05,coq06,",
#                    "       coq07,coq08,cob04,ima02,'','','',0,coq10,coa04,",
#                    "       coq10*coa04 ",
#                    "  FROM coq_file,ima_file,cob_file,coa_file LEFT OUTER JOIN coz_file ON coa05 = coz02 ",
#                    " WHERE coq01 = ima01 ",
#                    "   AND cob01 = coa03 AND coa01 = ima01 ",
#                    "   AND coq00 = ? AND ",tm.wc CLIPPED,
           LET l_sql="SELECT coq01,coq02,ima25,coq03,coq04,coq05,coq06,",
                     "       coq07,coq08,'',ima02,'','','',0,coq10,'',",
#No.FUN-590110--end   
                     "       '' ",
                     "  FROM coq_file,ima_file ",
                     " WHERE coq01 = ima01  ",
                     "   AND coq00 = ? AND ",tm.wc CLIPPED,
 #NO.MOD-490398--end
                     " ORDER BY coq01,coq02,coq03,coq04,coq05  "
       END IF
     END IF
     DISPLAY "l_sql:",l_sql
     DISPLAY "l_coq00:",l_coq00
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acor301'
     PREPARE acor301_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor301_curs1 CURSOR FOR acor301_prepare1
#No.FUN-590110--begin
#    IF tm.c = 'N' THEN 
#       IF cl_null(g_len) THEN LET g_len = 109 END IF
#    ELSE 
#       LET g_len = 132
#    END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-590110--end   
     LET g_pageno = 0
     INITIALIZE l_coq.*,l_coq_t.*,l_coq01 TO NULL
     CASE 
         WHEN tm.b = '1' AND tm.c = 'N' #依成品
              INITIALIZE sr.* TO NULL
              FOREACH acor301_curs1 USING l_coq00 INTO sr.*
                  IF SQLCA.sqlcode != 0 THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
                  END IF
 
 #NO.MOD-490398--begin
#                 SELECT ima02,ima77,cob04
#                   INTO sr.ima02_m,sr.ima77,sr.cob04
#                   FROM ima_file,OUTER cob_file
#                  WHERE ima01 = sr.coq01 AND cob_file.cob01 = ima75
 
                SELECT ima02,coa04,cob04 INTO sr.ima02_m,sr.coa04,sr.cob04 
                  FROM ima_file LEFT OUTER JOIN (coa_file LEFT OUTER JOIN cob_file ON cob01=coa03 LEFT OUTER JOIN coz_file 
                    ON coa05=coz02) ON ima01=coa01 AND coa02=1 
                 WHERE ima01=sr.coq01 
                  IF l_coq01 = sr.coq01 AND l_coq.coq02 = sr.coq02 THEN 
                    CONTINUE FOREACH
                  ELSE 
                    SELECT SUM(coq10) INTO sr.coq10 FROM coq_file 
                     WHERE coq00 = l_coq00  AND coq01 = sr.coq01
                       AND coq02 = sr.coq02
                    LET sr.count2 = sr.coq10 * sr.coa04
                    IF cl_null(sr.count2) THEN LET sr.count2= 0 END IF
 
                    DECLARE acor301_sr1 CURSOR FOR  
                     SELECT coq02,coq03,coq04,coq05,coq07 FROM coq_file 
                      WHERE coq00 = l_coq00 AND coq02 = sr.coq02
                      ORDER BY coq02,coq03,coq04,coq05
                      FOREACH acor301_sr1 INTO l_coq.*
                         IF SQLCA.sqlcode != 0 THEN 
                            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                         END IF
                         CALL s_umfchk(sr.coq01,sr.coq06,sr.ima25) RETURNING l_flag,l_fac
                         IF l_flag THEN LET l_fac = 1 END IF
 
                         IF l_coq.coq02 = l_coq_t.coq02
                            AND l_coq.coq03 = l_coq_t.coq03 
                            AND l_coq.coq04 = l_coq_t.coq04 
                            AND l_coq.coq05 = l_coq_t.coq05
                            THEN CONTINUE FOREACH
                         ELSE 
#IF cl_confirm(l_fac) THEN END IF
                            LET sr.count = sr.count + l_coq.coq07*l_fac
                            LET l_coq_t.* = l_coq.*
                         END IF
 
                      END FOREACH
 
                    IF cl_null(sr.count)  THEN LET sr.count= 0 END IF
                    LET sr_t.coq01 = sr.coq01
                    LET sr_t.coq02 = sr.coq02
 
                    SELECT cob01,cob02 INTO sr.coq01,sr.ima02_m
                      FROM ima_file LEFT OUTER join (coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03) ON coa01 = ima01   
                     WHERE ima01 = sr.coq01 
                    IF tm.a = '2' THEN  #成品
                       LET sr.ima02 = '' 
                       LET sr.ima021 = '' 
                       #maggie add cob04
                       SELECT cob01,cob02,cob04 
                         INTO sr.coq02,sr.ima02,sr.ima25
                       #end maggie
                         FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                        WHERE ima01 = sr.coq02 
                    END IF
 
                     #FUN-840238 add
                     CALL s_coa03(sr.coq01,' ') RETURNING l_coa03
                     SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=l_coa03
                     SELECT ima021 INTO sr.ima021 FROM ima_file
                       WHERE ima02 = sr.ima02
                     SELECT ima021 INTO sr.ima021_m FROM ima_file
                       WHERE ima02 = sr.ima02_m
                     EXECUTE insert_prep USING l_cob09,sr.*
                     #FUN-840238 add end  
 
                    LET l_coq01     = sr_t.coq01
                    LET l_coq.coq02 = sr_t.coq02
                  END IF
              END FOREACH
 
         WHEN tm.b = '1' AND tm.c = 'Y' #依成品
              FOREACH acor301_curs1 USING l_coq00 INTO sr.*
                  IF SQLCA.sqlcode != 0 THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
                  END IF
 
                SELECT ima02,coa04,cob04 INTO sr.ima02_m,sr.coa04,sr.cob04 
                  FROM ima_file LEFT OUTER JOIN (coa_file LEFT OUTER JOIN cob_file ON cob01=coa03 LEFT OUTER JOIN coz_file 
                    ON coa05=coz02) ON ima01=coa01 AND coa02=1 
                 WHERE ima01=sr.coq01 
                  SELECT SUM(coq07) INTO sr.count FROM coq_file 
                   WHERE coq00 = l_coq00  AND coq01 = sr.coq01
                    AND coq02 = sr.coq02 AND coq03 = sr.coq03
                    AND coq04 = sr.coq04 AND coq05 = sr.coq05 
 
                  LET sr.count2 = sr.coq10 * sr.coa04
                  IF cl_null(sr.count)  THEN LET sr.count= 0 END IF
                  IF cl_null(sr.count2) THEN LET sr.count2= 0 END IF
 
                  SELECT cob01,cob02 INTO sr.coq01,sr.ima02_m
                    FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                   WHERE ima01 = sr.coq01 
                  IF tm.a = '2' THEN 
                     SELECT cob01,cob02 INTO sr.coq02,sr.ima02
                       FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                      WHERE ima01 = sr.coq02 
                  END IF
 
                   #FUN-840238 add
                   CALL s_coa03(sr.coq01,' ') RETURNING l_coa03
                   SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=l_coa03
                   SELECT ima021 INTO sr.ima021 FROM ima_file
                     WHERE ima02 = sr.ima02
                   SELECT ima021 INTO sr.ima021_m FROM ima_file
                     WHERE ima02 = sr.ima02_m
                   EXECUTE insert_prep USING l_cob09,sr.*
                   #FUN-840238 add end  
 
                  LET g_counter = g_counter + 1
              END FOREACH
 
         WHEN tm.b = '2' AND tm.c = 'N' #依原料
              INITIALIZE sr.* TO NULL
              FOREACH acor301_curs1 USING l_coq00 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
                 END IF
                 IF l_coq01 = sr.coq01 AND l_coq.coq02 = sr.coq02 THEN 
                    CONTINUE FOREACH
                 ELSE 
 
                    SELECT COUNT(*) INTO l_count FROM coq_file 
                     WHERE coq00 = l_coq00  AND coq01 = sr.coq01
                       AND coq02 = sr.coq02
                    IF l_count > 1 THEN 
                       SELECT SUM(coq10) INTO sr.coq10 FROM coq_file 
                        WHERE coq00 = l_coq00  AND coq01 = sr.coq01
                          AND coq02 = sr.coq02 #modify by leagh
                       LET sr.count2 = sr.coq10*sr.coa04
                       DECLARE acor301_sr CURSOR FOR  
                        SELECT coq07 FROM coq_file 
                         WHERE coq00 = l_coq00  AND coq01 = sr.coq01
                           AND coq02 = sr.coq02
                          FOREACH acor301_sr INTO sr.coq07
                             IF SQLCA.sqlcode != 0 THEN 
                                CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                             END IF
                             IF cl_null(sr.coq07) THEN LET sr.coq07 = 0 END IF
                             CALL s_umfchk(sr.coq01,sr.coq06,sr.ima25) RETURNING l_flag,l_fac
                             IF l_flag THEN LET l_fac = 1 END IF
                             LET sr.count = sr.count + sr.coq07*l_fac
                          END FOREACH
                    ELSE 
                       CALL s_umfchk(sr.coq01,sr.coq06,sr.ima25) RETURNING l_flag,l_fac
                       IF l_flag THEN LET l_fac = 1 END IF
                       LET sr.count = sr.coq07 * l_fac
                       LET sr.count2 = sr.coq10* sr.coa04
                    END IF
 
                    IF cl_null(sr.count)  THEN LET sr.count= 0 END IF
                    IF cl_null(sr.count2) THEN LET sr.count2= 0 END IF
 
                    LET sr_t.coq01 = sr.coq01
                    LET sr_t.coq02 = sr.coq02
 
                    SELECT cob01,cob02 INTO sr.coq01,sr.ima02_m
                      FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                     WHERE ima01 = sr.coq01 
                    IF tm.a = '2' THEN 
                       #maggie
                       SELECT cob01,cob02,cob04 
                         INTO sr.coq02,sr.ima02,sr.ima25
                       #end maggie
                         FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                        WHERE ima01 = sr.coq02 
                    ELSE 
                       SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.coq02
                    END IF
 
                    #FUN-840238 add
                    CALL s_coa03(sr.coq01,' ') RETURNING l_coa03
                    SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=l_coa03
                    SELECT ima021 INTO sr.ima021 FROM ima_file
                      WHERE ima02 = sr.ima02
                    SELECT ima021 INTO sr.ima021_m FROM ima_file
                      WHERE ima02 = sr.ima02_m
                    EXECUTE insert_prep USING l_cob09,sr.*
                    #FUN-840238 add end 
 
                    LET l_coq01    = sr_t.coq01
                    LET l_coq.coq02= sr_t.coq02
                 END IF
              END FOREACH
 
         WHEN tm.b = '2' AND tm.c = 'Y' #依原料
              INITIALIZE sr.* TO NULL
              FOREACH acor301_curs1 USING l_coq00 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
                 END IF
                 SELECT cob04,coa04,coq10*coa04 INTO sr.cob04,sr.coa04,sr.count2
                  FROM coq_file,ima_file,cob_file,coa_file LEFT OUTER JOIN coz_file ON coa05 = coz02 
                 WHERE coq01 = sr.coq01  
                   AND cob01 = coa03 AND coa01 = coq01 
                   AND coq00 = l_coq00 AND coq02 = sr.coq02
                   AND coq03 = sr.coq03 AND coq04 = sr.coq04
                   AND coq05 = sr.coq05
 
                 IF (l_coq01     != sr.coq01 AND l_coq.coq02 != sr.coq02 AND 
                     l_coq.coq03 != sr.coq03 AND l_coq.coq04 != sr.coq04 AND 
                     l_coq.coq05 != sr.coq05) OR cl_null(l_coq01) THEN 
 
                    SELECT COUNT(*) INTO l_count FROM coq_file 
                     WHERE coq00 = l_coq00   AND coq01 = sr.coq01
                       AND coq02 = sr.coq02 AND coq03 = sr.coq03
                       AND coq04 = sr.coq04 AND coq05 = sr.coq05
 
                    IF l_count>1 THEN 
                       SELECT SUM(coq07) INTO sr.count FROM coq_file 
                        WHERE coq00 = l_coq00   AND coq01 = sr.coq01
                          AND coq02 = sr.coq02 AND coq03 = sr.coq03
                          AND coq04 = sr.coq04 AND coq05 = sr.coq05
                    END IF
 
                 END IF
 
                 IF cl_null(sr.count)  THEN LET sr.count= 0 END IF
                 IF cl_null(sr.count2) THEN LET sr.count2= 0 END IF
 
                 SELECT cob01,cob02 INTO sr.coq01,sr.ima02_m
                   FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                  WHERE ima01 = sr.coq01 
                 IF tm.a = '2' THEN 
                    SELECT cob01,cob02 INTO sr.coq02,sr.ima02
                      FROM ima_file LEFT OUTER join coa_file left OUTER join coz_file ON coa05 = coz02 left OUTER join cob_file ON cob01 = coa03 ON coa01 = ima01   
                     WHERE ima01 = sr.coq02 
 #NO.MOD-490398--end
                 ELSE 
                    SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.coq02
                 END IF 
 
                  #FUN-840238 add
                  CALL s_coa03(sr.coq01,' ') RETURNING l_coa03
                  SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=l_coa03
                  SELECT ima021 INTO sr.ima021 FROM ima_file
                    WHERE ima02 = sr.ima02
                  SELECT ima021 INTO sr.ima021_m FROM ima_file
                    WHERE ima02 = sr.ima02_m
                  EXECUTE insert_prep USING l_cob09,sr.*
                  #FUN-840238 add end 
 
              END FOREACH
         OTHERWISE EXIT CASE
     END CASE
 
     #FUN-840238 add
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coq02,coq01,coq03,coq04,coq05')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.a,";",tm.b,";",tm.c,";",tm.y
     CALL cl_prt_cs3('acor301','acor301',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     #FUN-840238 add end
 
END FUNCTION
#No.FUN-870144
 
