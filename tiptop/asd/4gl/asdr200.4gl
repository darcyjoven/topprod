# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr200.4gl
# Descriptions...: 工單領退明細表
# Date & Author..: 99/02/11 By Eric
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510037 05/01/24 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850086 08/05/21 By Sunyanchun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1         #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate         LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year           LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month          LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING      #NO.FUN-850086
DEFINE   g_str           STRING      #NO.FUN-850086 
DEFINE   l_table         STRING      #NO.FUN-850086 
DEFINE   l_table1        STRING      #NO.FUN-850086
DEFINE   l_table2        STRING      #NO.FUN-850086
MAIN
#     DEFINE  l_time  LIKE type_file.chr8             #No.FUN-6A0089
 
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
   #NO.FUN-850086----BEGIN----
   LET g_sql = "stf01.stf_file.stf01,",
                "stf04.stf_file.stf04,",
                "ima12.ima_file.ima12,",
                "sta07.sta_file.sta07,",
                "stf06.stf_file.stf06,",
                "stf05.stf_file.stf05,",
                "stf11.stf_file.stf11,",
                "stf07.stf_file.stf07,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "stf08.stf_file.stf08,",
                "stf09.stf_file.stf09,",
                "stf11_1.stf_file.stf10,",
                "stf12.stf_file.stf10,",
                "stf13.stf_file.stf10,",
                "stf14.stf_file.stf10,",
                "stf10.stf_file.stf10"
 
   LET l_table = cl_prt_temptable('asdr200',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "ima12.ima_file.ima12,",
                "ima131.ima_file.ima131,",
                "qty.stf_file.stf10,",
                "stf11.stf_file.stf10,",
                "stf12.stf_file.stf10,",
                "stf13.stf_file.stf10,",
                "stf14.stf_file.stf10,",
                "amt.stf_file.stf10"
 
   LET l_table1 = cl_prt_temptable('asdr200_1',g_sql)                              
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "ima131.ima_file.ima131,",
                "stf08.stf_file.stf08,",
                "t_stf11.stf_file.stf10,",
                "t_stf12.stf_file.stf10,",
                "t_stf13.stf_file.stf10,",
                "t_stf14.stf_file.stf10,",
                "s1.stf_file.stf10"
   LET l_table2 = cl_prt_temptable('asdr200_2',g_sql)                           
   IF l_table2 = -1 THEN EXIT PROGRAM END IF 
   #NO.FUN-850086----END------
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
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
 
   #-->依產品分類小計
#No.FUN-690010-------Begin----
#    CREATE TEMP TABLE r200_tmp
#      (ima131  VARCHAR(10),
#       stf08   DEC(14,2),
#       stf11   DEC(20,6),
#       stf12   DEC(20,6),
#       stf13   DEC(20,6),
#       stf14   DEC(20,6)
#      );
    CREATE TEMP TABLE r200_tmp(
       ima131  LIKE ima_file.ima131,
       stf08   LIKE stf_file.stf08,
       stf11   LIKE type_file.num20_6,
       stf12   LIKE type_file.num20_6,
       stf13   LIKE type_file.num20_6,
       stf14   LIKE type_file.num20_6);
      
#No.FUN-690010-------End----  
     create unique index r200_tmp on r200_tmp(ima131)  
   #-->依產品分類 + 成本分群小計 
#No.FUN-690010-------Begin----  
#    CREATE TEMP TABLE r200_tmp2
#      (ima12   VARCHAR(04),
#       ima131  VARCHAR(10),
#       qty     DEC(13,2),
#       stf11   DEC(20,6),
#       stf12   DEC(20,6),
#       stf13   DEC(20,6),
#       stf14   DEC(20,6),
#       amt     DEC(20,6))
    CREATE TEMP TABLE r200_tmp2(
       ima12   LIKE ima_file.ima12,
       ima131  LIKE ima_file.ima131,
       qty     LIKE stf_file.stf08,
       stf11   LIKE type_file.num20_6,
       stf12   LIKE type_file.num20_6,
       stf13   LIKE type_file.num20_6,
       stf14   LIKE type_file.num20_6,
       amt     LIKE type_file.num20_6);
 
#No.FUN-690010-------End----  
     create unique index r200_tmp2 on r200_tmp2(ima12,ima131)  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asdr200_tm()        # Input print condition
   ELSE 
      CALL asdr200()           # Read data and create out-file
   END IF
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
END MAIN
 
FUNCTION asdr200_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW asdr200_w AT p_row,p_col WITH FORM "asd/42f/asdr200" 
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
 #MOD-530125
     CONSTRUCT BY NAME tm.wc ON stf04,sta07,ima12,stf07 
##
#No.FUN-570244 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP                                                      
            IF INFIELD(stf07) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO stf07                             
               NEXT FIELD stf07                                                 
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
         WHERE zz01='asdr200'
        IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
          CALL cl_err('asdr200','9031',1)   
           
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
     
           CALL cl_cmdat('asdr200',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE   
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr200()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr200_w
 
END FUNCTION
 
FUNCTION asdr200()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima131  LIKE ima_file.ima131,
          l_ima12   LIKE ima_file.ima12,
          l_stb RECORD LIKE stb_file.*,
          l_stf11   LIKE stf_file.stf10,
          l_stf12   LIKE stf_file.stf10,
          l_stf13   LIKE stf_file.stf10,
          l_stf14   LIKE stf_file.stf10,
          sr RECORD LIKE stf_file.*
   #NO.FUN-850086---BEGIN----
   DEFINE l_s1      LIKE stf_file.stf10, 
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021, 
          l_sta07   LIKE sta_file.sta07,
          t_stf08   LIKE stf_file.stf08,
          t_stf11   LIKE stf_file.stf10,
          t_stf12   LIKE stf_file.stf10,
          t_stf13   LIKE stf_file.stf10,
          t_stf14   LIKE stf_file.stf10,
          l_stf04_t LIKE stf_file.stf04,
          sort RECORD
             ima12  LIKE ima_file.ima12,
             ima131 LIKE ima_file.ima131,
             qty    LIKE stf_file.stf10, 
             stf11  LIKE stf_file.stf10, 
             stf12  LIKE stf_file.stf10, 
             stf13  LIKE stf_file.stf10, 
             stf14  LIKE stf_file.stf10, 
             amt    LIKE stf_file.stf10
             END RECORD
     #NO.FUN-850086---END------
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #NO.FUN-850086----BEGIN------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?)" 
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep1 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?)"                                                                                             
     PREPARE insert_prep2 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep2:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     #NO.FUN-850086-----END------
 
     LET l_sql = "SELECT stf_file.* ",
                " FROM stf_file,sfb_file,ima_file,sta_file",
                 " WHERE stf02=",tm.yea,
                 "   AND stf03=",tm.mo,
                 "   AND stf04=sfb01 AND sfb05=ima01 AND sfb05=sta01 ",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
     END IF
     DECLARE asdr200_curs1 CURSOR FOR asdr200_prepare1
 
     #CALL cl_outnam('asdr200') RETURNING l_name    #NO.FUN-850086
 
     DELETE FROM r200_tmp  
     DELETE FROM r200_tmp2
     #START REPORT asdr200_rep TO l_name      #NO.FUN-850086
     LET g_pageno = 0
     FOREACH asdr200_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
       
       SELECT ima131,ima12 INTO l_ima131,l_ima12
         FROM ima_file WHERE ima01=sr.stf07
       IF l_ima131 IS NULL THEN LET l_ima131 = ' ' END IF
       IF l_ima12  IS NULL THEN LET l_ima12  = ' ' END IF
 
       #-->取本月標準成本 
       SELECT * INTO l_stb.* FROM stb_file
        WHERE stb01=sr.stf07 AND stb02=tm.yea AND stb03=tm.mo
        IF SQLCA.sqlcode THEN 
           LET l_stb.stb05 = 0
           LET l_stb.stb06 = 0
           LET l_stb.stb06a = 0
        END IF
       LET l_stf12 = l_stb.stb05  * sr.stf08           #本階直接人工    * 數量
       LET l_stf13 = l_stb.stb06  * sr.stf08           #本階間接製造費用* 數量
       LET l_stf14 = l_stb.stb06a * sr.stf08           #本階其他製造費用* 數量
       LET l_stf11 = sr.stf10-l_stf12-l_stf13-l_stf14  #標準成本
 
       #--->產生產品分類合計檔
       INSERT INTO r200_tmp VALUES(l_ima131, sr.stf08,l_stf11,
                                   l_stf12,l_stf13,l_stf14)
          IF SQLCA.sqlcode THEN 
              UPDATE r200_tmp SET stf08=stf08+sr.stf08,
                                  stf11=stf11+l_stf11, stf12=stf12+l_stf12,
                                  stf13=stf13+l_stf13, stf14=stf14+l_stf14
                           WHERE ima131=l_ima131
          END IF
 
       #--->產生產品分類+成本分群合計檔
       INSERT INTO r200_tmp2 VALUES(l_ima12,l_ima131,sr.stf08,
                                    l_stf11,l_stf12,l_stf13,l_stf14,sr.stf10)
          IF SQLCA.sqlcode THEN 
              UPDATE r200_tmp2 SET stf11=stf11+l_stf11, stf12=stf12+l_stf12,
                                   stf13=stf13+l_stf13, stf14=stf14+l_stf14,
                                   qty=qty+sr.stf08,amt=amt+sr.stf10
                           WHERE ima12=l_ima12 AND ima131=l_ima131
          END IF
        
       #NO.FUN-850086----BEGIN-----
       IF l_stf04_t = sr.stf04 OR cl_null(l_stf04_t) THEN
          SELECT ima12 INTO l_ima12 FROM ima_file,sfb_file
              WHERE sr.stf04=sfb01 AND sfb05=ima01
          IF SQLCA.sqlcode OR l_ima12 IS NULL THEN LET l_ima12 = ' ' END IF
       
          SELECT sta07 INTO l_sta07 FROM sta_file,sfb_file
              WHERE sr.stf04=sfb01 AND sfb05=sta01
          IF SQLCA.sqlcode OR l_sta07 IS NULL THEN LET l_sta07 = ' ' END IF
       END IF
       LET l_stf04_t = sr.stf04
 
       SELECT ima02,ima021 INTO l_ima02,l_ima021
           FROM ima_file WHERE ima01 = sr.stf07
       IF SQLCA.sqlcode THEN 
          LET l_ima02 = ' ' 
          LET l_ima021= ' '
       END IF
 
       EXECUTE insert_prep USING sr.stf01,sr.stf04,l_ima12,l_sta07,
                                 sr.stf06,sr.stf05,sr.stf11,sr.stf07,
                                 l_ima02,l_ima021,sr.stf08,sr.stf09,
                                 l_stf11,l_stf12,l_stf13,l_stf14,sr.stf10
       #OUTPUT TO REPORT asdr200_rep(sr.*,l_stf11,l_stf12,l_stf13,l_stf14)
       #NO.FUN-850086----END-----
     END FOREACH
     #NO.FUN-850086-----BEGIN----
     DECLARE r200_cur2 CURSOR FOR
        SELECT * FROM r200_tmp2 ORDER BY ima12,ima131
     FOREACH r200_cur2 INTO sort.* 
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep1 USING sort.ima12,sort.ima131,sort.qty,sort.stf11,
                                   sort.stf12,sort.stf13,sort.stf14,sort.amt
     END FOREACH
 
     DECLARE r200_cur CURSOR FOR
        SELECT * FROM r200_tmp ORDER BY ima131
     FOREACH r200_cur INTO l_ima131, t_stf08 ,t_stf11,t_stf12,t_stf13,t_stf14
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        LET l_s1 = t_stf11+t_stf12+t_stf13+t_stf14 
        EXECUTE insert_prep2 USING l_ima131,t_stf08,t_stf11,t_stf12,
                                   t_stf13,t_stf14,l_s1
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'stf04,sta07,ima12,stf07')
            RETURNING tm.wc
     ELSE
        LET tm.wc  = ""
     END IF
     LET g_str = tm.wc,";",tm.yea,";",tm.mo,";",g_azi03,";",g_azi04
     CALL cl_prt_cs3('asdr200','asdr200',g_sql,g_str)
     #FINISH REPORT asdr200_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-850086-------END-----
 
END FUNCTION
#NO.FUN-850086----BEGIN-----
#REPORT asdr200_rep(sr,l_stf11,l_stf12,l_stf13,l_stf14)
#  DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_cnt     LIKE type_file.num5,     #No.FUN-690010 SMALLINT
#         l_s1      LIKE stf_file.stf10, 
#         l_ima02   LIKE ima_file.ima02,
#         l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#         l_ima131  LIKE ima_file.ima131,
#         l_ima12   LIKE ima_file.ima12,
#         l_sta07   LIKE sta_file.sta07,
#         t_stf08   LIKE stf_file.stf08,
#         t_stf11   LIKE stf_file.stf10,
#         t_stf12   LIKE stf_file.stf10,
#         t_stf13   LIKE stf_file.stf10,
#         t_stf14   LIKE stf_file.stf10,
#         l_stf11   LIKE stf_file.stf10,
#         l_stf12   LIKE stf_file.stf10,
#         l_stf13   LIKE stf_file.stf10,
#         l_stf14   LIKE stf_file.stf10,
#         sr RECORD LIKE stf_file.*,
#         sort RECORD                 # Print condition RECORD
#            ima12  LIKE ima_file.ima12,
#            ima131 LIKE ima_file.ima131,
#            qty    LIKE stf_file.stf10, 
#            stf11  LIKE stf_file.stf10, 
#            stf12  LIKE stf_file.stf10, 
#            stf13  LIKE stf_file.stf10, 
#            stf14  LIKE stf_file.stf10, 
#            amt    LIKE stf_file.stf10
#            END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.stf01,sr.stf04,sr.stf07,sr.stf06,sr.stf05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1= g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#           g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#           g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped,
#           g_x[43] clipped,g_x[44] clipped,g_x[45] clipped
#          ,g_x[46] clipped   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.stf01   #廠內/委外
#     SKIP TO TOP OF PAGE
 
#  BEFORE GROUP OF sr.stf04   #工單編號
#    #-->工單生產料號成本分群
#    SELECT ima12 INTO l_ima12 FROM ima_file,sfb_file
#     WHERE sr.stf04=sfb01 AND sfb05=ima01
#     IF SQLCA.sqlcode OR l_ima12 IS NULL THEN LET l_ima12 = ' ' END IF
 
#    #-->取主製程
#    SELECT sta07 INTO l_sta07 FROM sta_file,sfb_file
#     WHERE sr.stf04=sfb01 AND sfb05=sta01
#     IF SQLCA.sqlcode OR l_sta07 IS NULL THEN LET l_sta07 = ' ' END IF
 
#     PRINT COLUMN g_c[31],sr.stf04,
#           COLUMN g_c[32],l_ima12,
#           COLUMN g_c[33],l_sta07;
 
#  ON EVERY ROW
 
#   #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#    SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#      FROM ima_file WHERE ima01 = sr.stf07
#    IF SQLCA.sqlcode THEN 
#       LET l_ima02 = ' ' 
#       LET l_ima021= ' '    #FUN-5A0059
#    END IF
#    PRINT COLUMN g_c[34],sr.stf06,                       #領退日期
#          COLUMN g_c[35],sr.stf05,                       #異動單據
#          COLUMN g_c[36],sr.stf11,                       #倉庫
#          COLUMN g_c[37],sr.stf07,                       #料號
#          COLUMN g_c[38],l_ima02 CLIPPED,                #品名 #MOD-4A0238
#         #start FUN-5A0059
#          COLUMN g_c[39],l_ima021 CLIPPED,               #規格
#          COLUMN g_c[40],cl_numfor(sr.stf08,40,0),       #數量
#          COLUMN g_c[41],cl_numfor(sr.stf09,41,g_azi03), #單位成本
#          COLUMN g_c[42],cl_numfor(l_stf11 ,42,g_azi04), #材料成本
#          COLUMN g_c[43],cl_numfor(l_stf12 ,43,g_azi04), #人工成本
#          COLUMN g_c[44],cl_numfor(l_stf13 ,44,g_azi04), #製費成本
#          COLUMN g_c[45],cl_numfor(l_stf14 ,45,g_azi04), #其他成本
#          COLUMN g_c[46],cl_numfor(sr.stf10,46,g_azi04)  #標準成本
#         #end FUN-5A0059
 
#  AFTER GROUP OF sr.stf04  #工單編號 
#     LET l_s1=GROUP SUM(sr.stf10)
#     LET t_stf08 = GROUP SUM(sr.stf08 )
#     LET t_stf11 = GROUP SUM(l_stf11)
#     LET t_stf12 = GROUP SUM(l_stf12)
#     LET t_stf13 = GROUP SUM(l_stf13)
#     LET t_stf14 = GROUP SUM(l_stf14)
 
#    #start FUN-5A0059
#     PRINT COLUMN g_c[39], g_x[16] CLIPPED,
#           COLUMN g_c[40],cl_numfor(t_stf08,40,2),        #數量
#           COLUMN g_c[42],cl_numfor(t_stf11,42,g_azi04),  #材料成本
#           COLUMN g_c[43],cl_numfor(t_stf12,43,g_azi04),  #人工成本
#           COLUMN g_c[44],cl_numfor(t_stf13,44,g_azi04),  #製費成本
#           COLUMN g_c[45],cl_numfor(t_stf14,45,g_azi04),  #其他成本
#           COLUMN g_c[46],cl_numfor(l_s1,46,g_azi04)      #標準成本
#    #end FUN-5A0059
#     PRINT ' '
 
#  ON LAST ROW
#     LET l_s1 = SUM(sr.stf10)
#     LET t_stf08 = SUM(sr.stf08)
#     LET t_stf11 = SUM(l_stf11)
#     LET t_stf12 = SUM(l_stf12)
#     LET t_stf13 = SUM(l_stf13)
#     LET t_stf14 = SUM(l_stf14)
#    #start FUN-5A0059
#     PRINT COLUMN g_c[39], g_x[17] CLIPPED,
#           COLUMN g_c[40],cl_numfor(t_stf08,40,2),          #數量
#           COLUMN g_c[42],cl_numfor(t_stf11,42,g_azi04),    #材料成本
#           COLUMN g_c[43],cl_numfor(t_stf12,43,g_azi04),    #人工成本
#           COLUMN g_c[44],cl_numfor(t_stf13,44,g_azi04),    #製費成本
#           COLUMN g_c[45],cl_numfor(t_stf14,45,g_azi04),    #其他成本
#           COLUMN g_c[46],cl_numfor(l_s1,46,g_azi04)        #標準成本
#    #end FUN-5A0059
 
#     PRINT g_dash[1,g_len]
 
#     #-->列印產品分類與成本分群小計:
#     LET l_cnt = 0
#     DECLARE r200_cur2 CURSOR FOR
#       SELECT * FROM r200_tmp2 ORDER BY ima12,ima131
#     FOREACH r200_cur2 INTO sort.* 
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN 6,g_x[18] CLIPPED END IF
#       PRINT COLUMN g_c[32], sort.ima12,
#             COLUMN g_c[34],sort.ima131,
#            #start FUN-5A0059
#             COLUMN g_c[40],cl_numfor(sort.qty  ,40,2),          #數量
#             COLUMN g_c[42],cl_numfor(sort.stf11,42,g_azi04),    #材料成本
#             COLUMN g_c[43],cl_numfor(sort.stf12,43,g_azi04),    #人工成本
#             COLUMN g_c[44],cl_numfor(sort.stf13,44,g_azi04),    #製費成本
#             COLUMN g_c[45],cl_numfor(sort.stf14,45,g_azi04),    #其他成本
#             COLUMN g_c[46],cl_numfor(sort.amt,46,g_azi04)       #標準成本
#            #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len] CLIPPED
 
#     #-->列印產品分類小計:
#     LET l_cnt = 0
#     DECLARE r200_cur CURSOR FOR
#       SELECT * FROM r200_tmp ORDER BY ima131
#     FOREACH r200_cur INTO l_ima131, t_stf08 ,t_stf11,t_stf12,t_stf13,t_stf14
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN 6,g_x[19] CLIPPED END IF
#       LET l_s1 = t_stf11+t_stf12+t_stf13+t_stf14 
#       PRINT COLUMN g_c[34],l_ima131,
#            #start FUN-5A0059
#             COLUMN g_c[40],cl_numfor(t_stf08,40,2),         #數量
#             COLUMN g_c[42],cl_numfor(t_stf11,42,g_azi04),   #材料成本
#             COLUMN g_c[43],cl_numfor(t_stf12,43,g_azi04),   #人工成本
#             COLUMN g_c[44],cl_numfor(t_stf13,44,g_azi04),   #製費成本
#             COLUMN g_c[45],cl_numfor(t_stf14,45,g_azi04),   #其他成本
#             COLUMN g_c[46],cl_numfor(l_s1,46,g_azi04)       #標準成本
#            #end FUN-5A0059
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
#NO.FUN-850086----END----
#No.FUN-870144
