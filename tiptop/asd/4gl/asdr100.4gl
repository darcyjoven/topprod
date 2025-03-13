# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: asdr100.4gl
# Descriptions...: 驗收入庫明細表
# Date & Author..: 98/11/05 By Eric
# Modify.........: No.FUN-5100337 05/01/19 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850086 08/05/19 By Sunyancun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
              edate   LIKE type_file.dat,          #No.FUN-690010DATE,
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              a       LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING    #NO.FUN-850086
DEFINE   g_str           STRING    #NO.FUN-850086
DEFINE   l_table         STRING    #NO.FUN-850086
DEFINE   l_table1        STRING    #NO.FUN-850086
DEFINE   l_table2        STRING    #NO.FUN-850086
 
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
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #NO.FUN-850086-----BEGIN-----
   LET g_sql = "code.type_file.chr1,", 
               "ima12.ima_file.ima12,",
               "tlf01.tlf_file.tlf01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima131.ima_file.ima131,",
               "tlf036.tlf_file.tlf036,",
               "tlf06.tlf_file.tlf06,",
               "tlf031.tlf_file.tlf031,",
               "tlf10.tlf_file.tlf10,",
               "std.apb_file.apb08,",
               "amt01.apb_file.apb08,",
               "diff.apb_file.apb08,",
               "diffcost.apb_file.apb10,",
               "msg.type_file.chr1000,",
               "tlf907.tlf_file.tlf907,",
               "tlf65.tlf_file.tlf65"
   LET l_table = cl_prt_temptable('asdr100',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "ima131.ima_file.ima131,",
                "ima12.ima_file.ima12,",
                "qty1.tlf_file.tlf10,",
                "amt1.apb_file.apb10"
   LET l_table1 = cl_prt_temptable('asdr100_1',g_sql)                                                                                  
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "ima131.ima_file.ima131,",
                "qty1.tlf_file.tlf10,",
                "amt1.apb_file.apb10" 
   LET l_table2 = cl_prt_temptable('asdr100_2',g_sql)                                                                               
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-850086-----END--------
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.yea = ARG_VAL(10)
   LET tm.mo = ARG_VAL(11)
   LET tm.a = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      # If background job sw is off
      CALL asdr100_tm()     # Input print condition
   ELSE 
      CALL asdr100()        # Read data and create out-file
   END IF
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
END MAIN
 
FUNCTION asdr100_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW asdr100_w AT p_row,p_col WITH FORM "asd/42f/asdr100" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.edate=MDY(tm.mo,1,tm.yea)-1
   LET tm.bdate=MDY(MONTH(tm.edate),1,YEAR(tm.edate))
   LET tm.yea  = YEAR(tm.bdate)
   LET tm.mo   = MONTH(tm.bdate)
   LET tm.a    = '1'
 
   WHILE TRUE
     ERROR ''
 #MOD-530125
     CONSTRUCT BY NAME tm.wc ON ima12,ima06,ima08,tlf01,ima131
##
#No.FUN-570244 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP                                                      
            IF INFIELD(tlf01) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO tlf01                             
               NEXT FIELD tlf01                                                 
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
  
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.bdate,tm.edate,tm.yea,tm.mo,tm.a,tm.more
              WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD edate
           IF tm.edate < tm.bdate THEN
              LET tm.edate=tm.bdate
              NEXT FIELD edate
           END IF
 
        AFTER FIELD a
           IF NOT cl_null(tm.a) THEN 
              IF tm.a NOT MATCHES '[123]' THEN
                 LET tm.a='1'
                 NEXT FIELD a
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
         WHERE zz01='asdr100'
        IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
          CALL cl_err('asdr100','9031',1)  
           
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
                           " '",tm.bdate CLIPPED,"'",
                           " '",tm.edate CLIPPED,"'",
                           " '",tm.yea CLIPPED,"'",
                           " '",tm.mo CLIPPED,"'",
                           " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
           CALL cl_cmdat('asdr100',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE 
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr100()
 
     ERROR ""
 
  END WHILE
  CLOSE WINDOW asdr100_w
 
END FUNCTION
 
FUNCTION asdr100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(600)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_rvv04   LIKE rvv_file.rvv04,
          l_rvv05   LIKE rvv_file.rvv05,
          l_rvv38   LIKE rvv_file.rvv38,
          l_rva06   LIKE rva_file.rva06,
          l_pmm22   LIKE pmm_file.pmm22,
          l_pmm42   LIKE pmm_file.pmm42,
          sr               RECORD code   LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
                                  ima12  LIKE ima_file.ima12,
                                  ima131 LIKE ima_file.ima131,
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,   #FUN-5A0059
                                  tlf021 LIKE tlf_file.tlf021,
                                  tlf031 LIKE tlf_file.tlf031,
                                  tlf06  LIKE tlf_file.tlf06,
                                  tlf026 LIKE tlf_file.tlf026,
                                  tlf027 LIKE tlf_file.tlf027,
                                  tlf036 LIKE tlf_file.tlf036,
                                  tlf037 LIKE tlf_file.tlf037,
                                  tlf01 LIKE tlf_file.tlf01,
                                  tlf10 LIKE tlf_file.tlf10,
                                  tlf21 LIKE tlf_file.tlf21,
                                  tlf13 LIKE tlf_file.tlf13,
                                  tlf65 LIKE tlf_file.tlf65,
                                  tlf907 LIKE tlf_file.tlf907,
                                  amt01 LIKE apb_file.apb08,    #應付單價
                                  std   LIKE apb_file.apb08,    #標準單價
                                  diff  LIKE apb_file.apb08,    #差異單價
                                  diffcost LIKE apb_file.apb10  #差異金額
                        END RECORD
   
  DEFINE l_ima02      LIKE ima_file.ima02,     #NO.FUN-850086
         l_ima021     LIKE ima_file.ima021,    #NO.FUN-850086
         l_ima131     LIKE ima_file.ima131,    #NO.FUN-850086
         l_ima12      LIKE ima_file.ima12,     #NO.FUN-850086
         l_qty1       LIKE tlf_file.tlf10,     #NO.FUN-850086
         l_amt1       LIKE apb_file.apb10      #NO.FUN-850086
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #NO.FUN-850086----BEGIN----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep1 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
                 " VALUES(?, ?, ?)"                                                                                             
     PREPARE insert_prep2 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep2:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     #NO.FUN-850086-----END-----
     #--->依產品別小計
     DROP TABLE r100_tmp
     CREATE TEMP TABLE r100_tmp(
             ima131   LIKE cre_file.cre08,
             qty      LIKE alb_file.alb06,
             diffcost LIKE alb_file.alb06);
     create unique index r100_01 on r100_tmp (ima131);
 
     #--->依產品別+成本分群小計
     DROP TABLE r100_tmp2
     CREATE TEMP TABLE r100_tmp2(
             ima131    LIKE cre_file.cre08,
             ima12     LIKE ade_file.ade04,
             qty       LIKE alb_file.alb06,
             diffcost  LIKE alb_file.alb06);
     create unique index r100_02 on r100_tmp2 (ima131,ima12);
 
    #LET l_sql = "SELECT '',ima12,ima131,ima01,ima02,",          #FUN-5A0059 mark
     LET l_sql = "SELECT '',ima12,ima131,ima01,ima02,ima021,",   #FUN-5A0059
                 " tlf021,tlf031,tlf06,tlf026,tlf027,tlf036,tlf037,",
                 " tlf01,tlf10,tlf21,tlf13,tlf65,tlf907,0,0,0,0",
                 "  FROM tlf_file, ima_file",
                 " WHERE ima01 = tlf01",
                 "  AND ",tm.wc CLIPPED,
                 "  AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"
     CASE 
       WHEN tm.a = '1'
            LET l_sql = l_sql clipped," AND tlf13 = 'apmt150' " clipped
       WHEN tm.a = '2'
            LET l_sql = l_sql clipped," AND tlf13 = 'apmt1072'" clipped
       OTHERWISE   
            LET l_sql = l_sql clipped,
                        "  AND (tlf13 = 'apmt150' OR tlf13 = 'apmt1072')"
     END CASE
     PREPARE asdr100_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM 
     END IF
     DECLARE asdr100_curs1 CURSOR FOR asdr100_prepare1
 
     #CALL cl_outnam('asdr100') RETURNING l_name     #NO.FUN-850086
     #START REPORT asdr100_rep TO l_name             #NO.FUN-850086
     #LET g_pageno = 0                               #NO.FUN-850086
     FOREACH asdr100_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET sr.code=' '
       #-->採購入庫(內外購)
       IF sr.tlf13 = 'apmt150' THEN
          SELECT apb08  INTO sr.amt01 FROM apb_file
                 WHERE apb29='1'and  apb21=sr.tlf036
                   AND apb22=sr.tlf037 AND apb12=sr.tlf01
          IF STATUS THEN   #No.7926
             IF (sr.amt01 IS NULL) OR (sr.amt01 = 0) THEN 
                 SELECT ale08 INTO sr.amt01 FROM ale_file 
                  WHERE ale16=sr.tlf036 
                    AND ale17=sr.tlf037
                    AND ale11=sr.tlf01
                 IF STATUS THEN  #No.7926
                    LET sr.code='*'
                    #-->取採購單價
                    SELECT rvv04,rvv05,rvv38 INTO l_rvv04,l_rvv05,l_rvv38
                      FROM rvv_file 
                     WHERE rvv01=sr.tlf036 AND rvv02=sr.tlf037
                      IF STATUS = 0 THEN
                         SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                           FROM rvb_file,pmm_file,rva_file
                          WHERE rvb01=l_rvv04 AND rvb02=l_rvv05
                            AND pmm01=rvb04 AND rva01 = rvb01 AND pmm18 <> 'X'
                         IF STATUS <> 0 THEN
                            LET l_pmm22=' '
                            LET l_pmm42= 1
                         END IF
                         IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                         LET sr.amt01=l_rvv38*l_pmm42
                      END IF
                 END IF
             END IF
          END IF 
       END IF
       #-->倉庫退貨
       IF sr.tlf13 = 'apmt1072' THEN
          SELECT apb08 INTO sr.amt01 FROM apb_file
           WHERE apb29='3' and  apb21=sr.tlf026
             AND apb22=sr.tlf027 AND apb12=sr.tlf01
          LET sr.tlf10 = sr.tlf10 * sr.tlf907
          LET sr.amt01 = sr.amt01 * sr.tlf907
          LET sr.tlf031 = sr.tlf021
       END IF
       IF  cl_null(sr.amt01) THEN LET sr.amt01=0 END IF
       #-->取本月標準單價
       SELECT stb07+stb08+stb09+stb09a INTO sr.std FROM stb_file
        WHERE stb01 = sr.tlf01 AND stb02 = tm.yea AND stb03 = tm.mo
         IF SQLCA.sqlcode THEN LET sr.std=0 END IF
 
       LET  sr.diff = sr.amt01 - sr.std
       LET  sr.diffcost = sr.diff * sr.tlf10
       IF sr.ima131 IS NULL THEN LET sr.ima131 = ' ' END IF
       IF sr.ima12 IS NULL  THEN LET sr.ima12  = ' ' END IF
       #--->依產品別小計
       INSERT INTO r100_tmp VALUES(sr.ima131,sr.tlf10,sr.diffcost) 
       IF SQLCA.sqlcode THEN 
          UPDATE r100_tmp SET qty      = qty  + sr.tlf10,
                              diffcost = diffcost + sr.diffcost
                          WHERE ima131 = sr.ima131
       END IF
       #--->依產品別+成本分群小計
       INSERT INTO r100_tmp2 VALUES(sr.ima131,sr.ima12,sr.tlf10,sr.diffcost) 
       IF SQLCA.sqlcode THEN 
          UPDATE r100_tmp2 SET qty      = qty  + sr.tlf10, 
                               diffcost = diffcost + sr.diffcost
                          WHERE ima131 = sr.ima131
                            AND ima12  = sr.ima12 
       END IF
      
       #NO.FUN-850086----begin----
       SELECT ima02,ima021 INTO l_ima02,l_ima021
            FROM ima_file WHERE ima01=sr.tlf01
 
       LET g_msg=' '
       SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=sr.ima12 AND azf02='G'
       IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
       EXECUTE insert_prep USING sr.code,sr.ima12,sr.tlf01,l_ima02,
                                 l_ima021,sr.ima131,sr.tlf036,sr.tlf06,
                                 sr.tlf031,sr.tlf10,sr.std,sr.amt01,
                                 sr.diff,sr.diffcost,g_msg,sr.tlf907,
                                 sr.tlf65 
       #OUTPUT TO REPORT asdr100_rep(sr.*)     
       #NO.FUN-850086-----end-------
     END FOREACH
     #NO.FUN-850086----begin----
     DECLARE r100_cur2 CURSOR FOR
        SELECT * FROM r100_tmp2 ORDER BY ima12,ima131
     FOREACH r100_cur2 INTO l_ima131,l_ima12,l_qty1,l_amt1 
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep1 USING l_ima131,l_ima12,l_qty1,l_amt1
     END FOREACH
     
     DECLARE r100_cur1 CURSOR FOR
        SELECT * FROM r100_tmp ORDER BY ima131
     FOREACH r100_cur1 INTO l_ima131,l_qty1,l_amt1
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep2 USING l_ima131,l_qty1,l_amt1
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima06,ima08,tlf01,ima131')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",
                 tm.yea,";",tm.mo,";",g_azi03,";",g_azi04,";",tm.a
     CALL cl_prt_cs3('asdr100','asdr100',g_sql,g_str)
     #FINISH REPORT asdr100_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-850086-----end-------
END FUNCTION
#NO.FUN-850086-----BEGIN------
#REPORT asdr100_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_ima131     LIKE ima_file.ima131,
#         l_ima12      LIKE ima_file.ima12,
#         l_qty1       LIKE tlf_file.tlf10,
#         l_amt1       LIKE apb_file.apb10,
#         l_cnt        LIKE type_file.num5,     #No.FUN-690010 SMALLINT
#         l_ima02      LIKE ima_file.ima02,
#         l_ima021     LIKE ima_file.ima021,   #FUN-5A0059
#         l_prod       LIKE type_file.chr1000,      #No.FUN-690010CHAR(30),
#          sr           RECORD code   LIKE type_file.chr1,         #No.FUN-690010CHAR(01),  
#                              ima12  LIKE ima_file.ima12,
#                              ima131 LIKE ima_file.ima131,
#                              ima01  LIKE ima_file.ima01,
#                              ima02  LIKE ima_file.ima02,
#                              ima021 LIKE ima_file.ima021,   #FUN-5A0059
#                              tlf021 LIKE tlf_file.tlf021,
#                              tlf031 LIKE tlf_file.tlf031,
#                              tlf06  LIKE tlf_file.tlf06,
#                              tlf026 LIKE tlf_file.tlf026,
#                              tlf027 LIKE tlf_file.tlf027,
#                              tlf036 LIKE tlf_file.tlf036,
#                              tlf037 LIKE tlf_file.tlf037,
#                              tlf01  LIKE tlf_file.tlf01,
#                              tlf10  LIKE tlf_file.tlf10,
#                              tlf21  LIKE tlf_file.tlf21,
#                              tlf13  LIKE tlf_file.tlf13,
#                              tlf65  LIKE tlf_file.tlf65,
#                              tlf907 LIKE tlf_file.tlf907,
#                              amt01 LIKE apb_file.apb08,    #應付單價
#                              std   LIKE apb_file.apb08,    #標準單價
#                              diff  LIKE apb_file.apb08,    #差異單價
#                              diffcost LIKE apb_file.apb10  #差異金額
#                       END RECORD,
#     l_chr        LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
# ORDER BY sr.ima12,sr.tlf031,sr.tlf907,sr.tlf65,sr.tlf01,sr.tlf06
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[19] clipped,tm.bdate,'-',tm.edate,' ',g_x[20] clipped,tm.yea,'-',tm.mo
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#           g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#           g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped
#          ,g_x[43] clipped   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#    #SELECT ima02 INTO l_ima02                  #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021  #FUN-5A0059
#       FROM ima_file WHERE ima01=sr.tlf01
#     PRINT COLUMN g_c[31],sr.code,sr.ima12,                      #成本分群
#           COLUMN g_c[32],sr.tlf01,                              #料號
#           COLUMN g_c[33],l_ima02,                               #品名
#          #start FUN-5A0059
#           COLUMN g_c[34],l_ima021,                              #規格
#           COLUMN g_c[35],sr.ima131,                             #產品分類
#           COLUMN g_c[36],sr.tlf036,                             #入庫單號
#           COLUMN g_c[37],sr.tlf06,                              #入庫日期
#           COLUMN g_c[38],sr.tlf031,                             #倉庫
#           COLUMN g_c[39],cl_numfor(sr.tlf10,39,g_azi03),        #數量
#           COLUMN g_c[40],cl_numfor(sr.std,  40,g_azi03),        #標準單價
#           COLUMN g_c[41],cl_numfor(sr.amt01,41,g_azi03),        #採購單價
#           COLUMN g_c[42],cl_numfor(sr.diff, 42,g_azi03),        #差異單價
#           COLUMN g_c[43],cl_numfor(sr.diffcost,43,g_azi04)      #差異金額
#          #end FUN-5A0059
 
#  AFTER GROUP OF sr.ima12  
#     PRINT COLUMN 8, g_dash2 CLIPPED
#     LET g_msg=' '
#     SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818
#     IF SQLCA.sqlcode THEN LET g_msg = ' ' END IF
#     LET l_prod=g_x[15] CLIPPED,'(',g_msg CLIPPED,')'
#     PRINT COLUMN g_c[32],l_prod CLIPPED, 
#           COLUMN g_c[39], GROUP SUM(sr.tlf10) USING '--------------',   #FUN-5A0059
#           COLUMN g_c[43],cl_numfor(GROUP SUM(sr.diffcost),43,g_azi04)   #FUN-5A0059
#     PRINT COLUMN 8, g_dash2 CLIPPED
 
#  ON LAST ROW
#     PRINT COLUMN g_c[32],g_x[16] CLIPPED,
#           COLUMN g_c[39],SUM(sr.tlf10) USING '--------------',    #FUN-5A0059
#           COLUMN g_c[43],cl_numfor(SUM(sr.diffcost),43,g_azi04)   #FUN-5A0059
#     PRINT COLUMN 8, g_dash2 CLIPPED
#     PRINT g_dash2 CLIPPED
 
#     #-->列印產品分類與成本分群小計:
#     LET l_cnt = 0
#     DECLARE r100_cur2 CURSOR FOR
#       SELECT * FROM r100_tmp2 ORDER BY ima12,ima131
#     FOREACH r100_cur2 INTO l_ima131,l_ima12,l_qty1,l_amt1 
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[32],g_x[17] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[35],l_ima131,
#             COLUMN g_c[36],l_ima12,
#             COLUMN g_c[39],l_qty1 USING '--------------', 
#             COLUMN g_c[43],cl_numfor(l_amt1,43,g_azi04)
#      #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     IF l_cnt > 0 THEN PRINT g_dash2[1,g_len] END IF
 
#     #-->列印產品成本分群小計:
#     LET l_cnt = 0
#     DECLARE r100_cur1 CURSOR FOR
#       SELECT * FROM r100_tmp ORDER BY ima131
#     FOREACH r100_cur1 INTO l_ima131,l_qty1,l_amt1
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[32],g_x[18] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[35],l_ima131,
#             COLUMN g_c[39],l_qty1 USING '--------------', 
#             COLUMN g_c[43],cl_numfor(l_amt1 ,43,g_azi04)
#      #end FUN-5A0059
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
#NO.FUN-850086----END-----
#No.FUN-870144
