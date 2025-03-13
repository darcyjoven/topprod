# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr210.4gl
# Descriptions...: 工單入庫明細表
# Date & Author..: 99/02/11 By Eric
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850086 08/05/22 By Sunyanchun  老報表轉CR
#                                08/09/24 By Cockroach 21-->31 CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
         sort RECORD                 # Print condition RECORD
             ima12  LIKE ima_file.ima12,         # Prog. Version..: '5.30.06-13.03.12(04), #TQC-840066
             ima131 LIKE cre_file.cre08,         #No.FUN-690010CHAR(10),
             qty    LIKE ccq_file.ccq03,         #No.FUN-690010DEC(13,2),
             amt    LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
             END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING       #NO.FUN-850086
DEFINE   g_str           STRING       #NO.FUN-850086
DEFINE   l_table         STRING       #NO.FUN-850086
DEFINE   l_table1        STRING       #NO.FUN-850086
DEFINE   l_table2        STRING       #NO.FUN-850086
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD #FUN-BB0047 mark

   #NO.FUN-850086----BEGIN-----
   LET g_sql = "stg01.stg_file.stg01,",
               "stg04.stg_file.stg04,",
               "stg06.stg_file.stg06,",
               "stg05.stg_file.stg05,",
               "ima12.ima_file.ima12,",
               "sta07.sta_file.sta07,",
               "stg20.stg_file.stg20,",
               "sfb05.sfb_file.sfb05,",
               "ima02.ima_file.ima02,",
               "stg07.stg_file.stg07,",
               "l_std.stg_file.stg08,",
               "stg12.stg_file.stg12,",
               "stg13.stg_file.stg13,",
               "stg14.stg_file.stg14,",
               "stg15.stg_file.stg15,",
               "amt.stg_file.stg12,",
               "azi05.azi_file.azi05,",
               "azi04.azi_file.azi04"
   LET l_table = cl_prt_temptable('asdr210',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "ima12.ima_file.ima12,",
               "ima131.ima_file.ima131,",
               "qty.ccq_file.ccq03,",
               "amt.alb_file.alb06,",
               "azi05.azi_file.azi05,",
               "azi04.azi_file.azi04"
   LET l_table1 = cl_prt_temptable('asdr210_1',g_sql)                              
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
 
   LET g_sql = "ima131.ima_file.ima131,",
               "q1.stg_file.stg07,",
               "s1.stg_file.stg12,",
               "s2.stg_file.stg13,",
               "s3.stg_file.stg14,",
               "s4.stg_file.stg15,",
               "amt.stg_file.stg12,",
               "azi05.azi_file.azi05,",
               "azi04.azi_file.azi04"
   LET l_table2 = cl_prt_temptable('asdr210_2',g_sql)                           
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-850086-----END------
   
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.yea = ARG_VAL(8)
   LET tm.mo = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
   DROP TABLE r210tmp
   DROP TABLE r210_tmp1
   #-->依產品分類小計
#No.FUN-690010------Begin----
#   CREATE TEMP TABLE r210_tmp
#     (
#      ima131  VARCHAR(10),
#      stg07   DEC(14,2),   
#      stg12   DEC(20,6),   
#      stg13   DEC(20,6),   
#      stg14   DEC(20,6),   
#      stg15   DEC(20,6)    
#     );
   CREATE TEMP TABLE r210_tmp(
      ima131  LIKE ima_file.ima131,
      stg07   LIKE stg_file.stg07,   
      stg12   LIKE type_file.num20_6,  
      stg13   LIKE type_file.num20_6,  
      stg14   LIKE type_file.num20_6,  
      stg15   LIKE type_file.num20_6);    
     
#No.FUN-690010------End----  
     create unique index r210_tmp on r210_tmp(ima131)  
   #-->依產品分類 + 成本分群小計 
#No.FUN-690010------Begin----  
#    CREATE TEMP TABLE r210_tmp2
#     (ima12  VARCHAR(04),
#      ima131 VARCHAR(10),
#      qty    DEC(13,2),
#      amt    DEC(20,6)
#     );
    CREATE TEMP TABLE r210_tmp2(
      ima12  LIKE ima_file.ima12,
      ima131 LIKE ima_file.ima131,
      qty    LIKE stf_file.stf08,
      amt    LIKE type_file.num20_6);
     
     create unique index r210_tmp2 on r210_tmp2(ima12,ima131)  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL asdr210_tm()        # Input print condition
   ELSE 
      CALL asdr210()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD 
END MAIN
 
FUNCTION asdr210_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW asdr210_w AT p_row,p_col WITH FORM "asd/42f/asdr210" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today) - 1
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
     CONSTRUCT BY NAME tm.wc ON stg04,sta07,ima12,sfb05 
#No.FUN-570244 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP                                                      
            IF INFIELD(sfb05) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO sfb05                             
               NEXT FIELD sfb05                                                 
            END IF                                                              
#No.FUN-570244 --end             
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.yea,tm.mo,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yea
           IF NOT cl_null(tm.yea) THEN 
              IF tm.yea=0 THEN
                  NEXT FIELD yea
              END IF
           END IF
        AFTER FIELD mo
           IF NOT cl_null(tm.mo) THEN 
              IF tm.mo=0 THEN
                  NEXT FIELD mo
              END IF
           END IF
        AFTER FIELD more
           IF tm.more = 'Y' THEN 
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
        LET INT_FLAG = 0
        EXIT WHILE   
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='asdr210'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr210','9031',1)   
           
           CONTINUE WHILE 
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
                       " '",tm.yea CLIPPED,"'",
                       " '",tm.mo CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr210',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE  
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr210()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr210_w
 
END FUNCTION
 
FUNCTION asdr210()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010 SMALLINT,
          l_ima131  LIKE ima_file.ima131,
          l_ima12   LIKE ima_file.ima12,
          l_stg13   LIKE stg_file.stg13,
          l_stg14   LIKE stg_file.stg14,
          l_stg15   LIKE stg_file.stg15,
          sr RECORD LIKE stg_file.*
     #NO.FUN-850086-----BEGIN-----
  DEFINE  l_ima02   LIKE ima_file.ima02,
          l_sfb05   LIKE sfb_file.sfb05,
          l_q1      LIKE stg_file.stg07,
          l_s1      LIKE stg_file.stg12,
          l_s2      LIKE stg_file.stg13,
          l_s3      LIKE stg_file.stg14,
          l_s4      LIKE stg_file.stg15,
          l_std     LIKE stg_file.stg08,
          l_amt     LIKE stg_file.stg12,
          l_sta07   LIKE sta_file.sta07
     #NO.FUN-850086-----END-----               
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #NO.FUN-850086-----BEGIN-----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep1 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
     PREPARE insert_prep2 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep2:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     #NO.FUN-850086-----END------- 
     
           
     DELETE FROM r210tmp
     LET l_sql = "SELECT stg_file.* FROM stg_file,sfb_file,ima_file,sta_file",
                 " WHERE stg02=",tm.yea,
                 "   AND stg03=",tm.mo,
                 "   AND stg04=sfb01 AND sfb05=sta01 AND sfb05=ima01",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM  
       
     END IF
     DECLARE asdr210_curs1 CURSOR FOR asdr210_prepare1
 
#     CALL cl_outnam('asdr210') RETURNING l_name     #NO.FUN-850086
#     START REPORT asdr210_rep TO l_name             #NO.FUN-850086 
#     LET g_pageno = 0                               #NO.FUN-850086
     FOREACH asdr210_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       SELECT ima131,ima12 INTO l_ima131,l_ima12 FROM ima_file ,sfb_file
        WHERE ima01 = sfb05 AND sfb01 = sr.stg04
        IF l_ima131 IS NULL THEN LET l_ima131=' ' END IF
        IF l_ima12  IS NULL THEN LET l_ima12=' '  END IF
 
       #--->產生產品分類合計檔
       INSERT INTO r210_tmp VALUES(l_ima131,sr.stg07,sr.stg12,
                                   sr.stg13,sr.stg14,sr.stg15)
          IF SQLCA.sqlcode THEN 
              UPDATE r210_tmp SET stg12=stg12+sr.stg12,stg13=stg13+sr.stg13,
                                  stg14=stg14+sr.stg14,stg15=stg15+sr.stg15,
                                  stg07=stg07+sr.stg07
                           WHERE ima131=l_ima131
          END IF
 
       #--->產生產品分類+成本分群合計檔
       LET sort.ima131=l_ima131
       LET sort.ima12 =l_ima12
       LET sort.qty   =sr.stg07
       LET sort.amt   = sr.stg12+ sr.stg13+ sr.stg14+ sr.stg15
       INSERT INTO r210_tmp2 VALUES(sort.*)
          IF SQLCA.sqlcode THEN 
              UPDATE r210_tmp2 SET qty=qty+sort.qty,amt=amt+sort.amt
                             WHERE ima12=sort.ima12 AND ima131=sort.ima131
          END IF
       #NO.FUN-850086----BEGIN-----
       SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=sr.stg21
       SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.stg04
       IF SQLCA.sqlcode THEN LET l_sfb05 = ' ' END IF
       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_sfb05
       IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF
       LET l_std = sr.stg08+sr.stg09+sr.stg10+sr.stg11 
       LET l_amt = sr.stg12 + sr.stg13 + sr.stg14 + sr.stg15 
     
       EXECUTE insert_prep USING sr.stg01,sr.stg04,sr.stg06,sr.stg05,
                                 l_ima12,l_sta07,sr.stg20,l_sfb05,
                                 l_ima02,sr.stg07,l_std,sr.stg12,
                                 sr.stg13,sr.stg14,sr.stg15,l_amt,
                                 t_azi05,t_azi04
       #OUTPUT TO REPORT asdr210_rep(sr.*,l_ima12,l_ima131)
       #NO.FUN-850086----END-------
     END FOREACH
     #NO.FUN-850086----BEGIN-----
     DECLARE r210_cur2 CURSOR FOR
        SELECT * FROM r210_tmp2 ORDER BY ima12,ima131
     FOREACH r210_cur2 INTO sort.* 
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep1 USING sort.ima12,sort.ima131,sort.qty,sort.amt,
                                   t_azi05,t_azi04
     END FOREACH
   
     DECLARE r210_cur CURSOR FOR
        SELECT * FROM r210_tmp ORDER BY ima131
     FOREACH r210_cur INTO l_ima131, l_q1 ,l_s1,l_s2,l_s3,l_s4
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        LET l_amt = l_s1 + l_s2 + l_s3 + l_s4  
        EXECUTE insert_prep2 USING l_ima131,l_q1,l_s1,l_s2,l_s3,l_s4,l_amt,
                                   t_azi05,t_azi04
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'stg04,sta07,ima12,sfb05')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",tm.yea,";",tm.mo
     CALL cl_prt_cs3('asdr210','asdr210',g_sql,g_str)     
#     FINISH REPORT asdr210_rep 
#     CALL cl_used('asdr210' ,g_time ,2) RETURNING g_time         #No.FUN-6A0089
#     CALL cl_prt(l_name ,g_prtway ,g_copies ,g_len)
     #NO.FUN-850086----END-------
END FUNCTION
 
#NO.FUN-850086----BEGIN-------
#REPORT asdr210_rep(sr,l_ima12,l_ima131)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_q1      LIKE stg_file.stg07,
#         l_s1      LIKE stg_file.stg12,
#         l_s2      LIKE stg_file.stg13,
#         l_s3      LIKE stg_file.stg14,
#         l_s4      LIKE stg_file.stg15,
#         l_std     LIKE stg_file.stg08,
#         l_amt     LIKE stg_file.stg12,
#         l_cnt     LIKE type_file.num5,     #No.FUN-690010 SMALLINT
#         l_ima02   LIKE ima_file.ima02,
#         l_ima131  LIKE ima_file.ima131,
#         l_ima12   LIKE ima_file.ima12,
#         l_sta07   LIKE sta_file.sta07,
#         l_sfb05   like sfb_file.sfb05,
#         sr RECORD LIKE stg_file.*
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.stg01 ,sr.stg04 ,sr.stg06 ,sr.stg05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     LET g_head1=g_x[10] CLIPPED ,tm.yea USING '&&&&' ,'/' ,tm.mo USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#           g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#           g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped,
#           g_x[43] clipped,g_x[44] clipped,g_x[45] clipped
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.stg04
#    #-->取主製程
#    SELECT sta07 INTO l_sta07 FROM sta_file,sfb_file
#     WHERE sr.stg04=sfb01 AND sfb05=sta01
#    IF STATUS <> 0 OR l_sta07 IS NULL THEN LET l_sta07=' ' END IF
 
#    PRINT COLUMN g_c[31],sr.stg04,
#          COLUMN g_c[32],l_ima12,
#          COLUMN g_c[33],l_sta07;
 
#  ON EVERY ROW
#    SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=sr.stg21
#    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.stg04
#    IF SQLCA.sqlcode THEN LET l_sfb05 = ' ' END IF
#    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_sfb05
#    IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF
#    LET l_std = sr.stg08+sr.stg09+sr.stg10+sr.stg11 
#    LET l_amt = sr.stg12 + sr.stg13 + sr.stg14 + sr.stg15  
#    PRINT COLUMN g_c[34],sr.stg06,        #入退日期
#          COLUMN g_c[35],sr.stg20,        #倉庫
#          COLUMN g_c[36],sr.stg05,        #入退庫單號
#          COLUMN g_c[37],l_sfb05,         #生產料號
#           COLUMN g_c[38],l_ima02 CLIPPED,         #品名規格  #MOD-4A0238
#          COLUMN g_c[39],cl_numfor(sr.stg07 ,39 ,t_azi05),     #數量
#          COLUMN g_c[40],cl_numfor(l_std    ,40 ,t_azi04),    #單位成本 
#          COLUMN g_c[41],cl_numfor(sr.stg12 ,41 ,t_azi04),    #材料成本
#          COLUMN g_c[42],cl_numfor(sr.stg13 ,42 ,t_azi04),    #人工成本
#          COLUMN g_c[43],cl_numfor(sr.stg14 ,43 ,t_azi04),    #製費成本
#          COLUMN g_c[44],cl_numfor(sr.stg15 ,44 ,t_azi04),    #其他製費
#          COLUMN g_c[45],cl_numfor(l_amt    ,45 ,t_azi04)    #標準成本
 
#  AFTER GROUP OF sr.stg04   #工單編號
#     LET l_q1 = GROUP SUM(sr.stg07)
#     LET l_s1 = GROUP SUM(sr.stg12)
#     LET l_s2 = GROUP SUM(sr.stg13)
#     LET l_s3 = GROUP SUM(sr.stg14)
#     LET l_s4 = GROUP SUM(sr.stg15)
#     LET l_amt = l_s1 + l_s2 + l_s3 + l_s4 
#     PRINT COLUMN g_c[34] ,g_x[16] CLIPPED ,
#           COLUMN g_c[39],cl_numfor(l_q1,39,t_azi05),       #數量
#           COLUMN g_c[41],cl_numfor(l_s1 ,41 ,t_azi04),     #材料成本
#           COLUMN g_c[42],cl_numfor(l_s2 ,42 ,t_azi04),     #人工成本
#           COLUMN g_c[43],cl_numfor(l_s3 ,43 ,t_azi04),     #製費成本
#           COLUMN g_c[44],cl_numfor(l_s4 ,44 ,t_azi04),     #其他製費
#           COLUMN g_c[45],cl_numfor(l_amt,45 ,t_azi04)      #標準成本
#     PRINT ' '
 
#  ON LAST ROW
#     LET l_q1 = SUM(sr.stg07)
#     LET l_s1 = SUM(sr.stg12)
#     LET l_s2 = SUM(sr.stg13)
#     LET l_s3 = SUM(sr.stg14)
#     LET l_s4 = SUM(sr.stg15)
#     LET l_amt = l_s1 + l_s2 + l_s3 + l_s4 
 
#     #-->列印總計
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN g_c[34] ,g_x[17] CLIPPED ,
#           COLUMN g_c[39],cl_numfor(l_q1,39,t_azi05),       #數量
#           COLUMN g_c[41],cl_numfor(l_s1 ,41 ,t_azi04),     #材料成本
#           COLUMN g_c[42],cl_numfor(l_s2 ,42 ,t_azi04),     #人工成本
#           COLUMN g_c[43],cl_numfor(l_s3 ,43 ,t_azi04),     #製費成本
#           COLUMN g_c[44],cl_numfor(l_s4 ,44 ,t_azi04),     #其他製費
#           COLUMN g_c[45],cl_numfor(l_amt,45 ,t_azi04)      #標準成本
#     PRINT g_dash[1,g_len]
 
#     #-->列印產品分類與成本分群小計:
#     LET l_cnt = 0
#     DECLARE r210_cur2 CURSOR FOR
#       SELECT * FROM r210_tmp2 ORDER BY ima12,ima131
#     FOREACH r210_cur2 INTO sort.* 
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[18] CLIPPED END IF
#       PRINT COLUMN g_c[36],sort.ima12,
#             COLUMN g_c[37],sort.ima131,
#             COLUMN g_c[39],cl_numfor(sort.qty,39,t_azi05),    #數量
#             COLUMN g_c[45],cl_numfor(sort.amt,45,t_azi04)    #標準成本
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len] CLIPPED
 
#     #-->列印產品分類小計
#     LET l_cnt = 0
#     DECLARE r210_cur CURSOR FOR
#       SELECT * FROM r210_tmp ORDER BY ima131
#     FOREACH r210_cur INTO l_ima131, l_q1 ,l_s1,l_s2,l_s3,l_s4
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[19] CLIPPED END IF
#       LET l_amt = l_s1 + l_s2 + l_s3 + l_s4  
#       PRINT COLUMN g_c[37],l_ima131,
#             COLUMN g_c[39],cl_numfor(l_q1,39,t_azi05),       #數量
#             COLUMN g_c[41],cl_numfor(l_s1 ,41 ,t_azi04),     #材料成本
#             COLUMN g_c[42],cl_numfor(l_s2 ,42 ,t_azi04),     #人工成本
#             COLUMN g_c[43],cl_numfor(l_s3 ,43 ,t_azi04),     #製費成本
#             COLUMN g_c[44],cl_numfor(l_s4 ,44 ,t_azi04),     #其他製費
#             COLUMN g_c[45],cl_numfor(l_amt,45 ,t_azi04)      #標準成本
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash[1,g_len] CLIPPED
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-850086----END-------
