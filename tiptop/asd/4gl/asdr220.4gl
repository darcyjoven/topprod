# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr220.4gl
# Descriptions...: 成本結轉表-1
# Date & Author..: 99/03/24 By Eric
# Modify.........: No.FUN-510037 05/02/17 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-810010 07/01/30 By baofei報表輸出改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010 VARCHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010 SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010 SMALLINT,
              jump    LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          tr  RECORD
              ste05     LIKE cre_file.cre08,         #No.FUN-690010 VARCHAR(10),          
              ste06     LIKE oqu_file.oqu12,         #No.FUN-690010 decimal(12,2),     
              ste07     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),     
              ste08     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),     
              ste09     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),    
              ste10     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),    
              ste11     LIKE oqu_file.oqu12,         #No.FUN-690010 decimal(12,2),    
              ste12     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),      
              ste13     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),      
              ste14     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),      
              ste15     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),      
              ste26     LIKE oqu_file.oqu12,         #No.FUN-690010 decimal(12,2),     
              ste27     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),     
              ste28     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),     
              ste29     LIKE alb_file.alb06,         #No.FUN-690010 decimal(20,6),     
              ste30     LIKE alb_file.alb06          #No.FUN-690010 decimal(20,6)      
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010 VARCHAR(50)
          g_year    LIKE type_file.num5,         #No.FUN-690010 SMALLINT
          g_month   LIKE type_file.num5          #No.FUN-690010 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-810010---Begin                                                          
DEFINE l_table        STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                   
#No.FUN-810010---End 
 
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
#No.FUN-810010---Begin
   LET g_sql = " l_ima02.ima_file.ima02,",
               " l_ima021.ima_file.ima021,",
               " l_ima12.ima_file.ima12,",
               " l_ima131.ima_file.ima131,",
               " ste04.ste_file.ste04,", 
               " ste05.ste_file.ste05,",
               " ste06.ste_file.ste06,",
               " ste07.ste_file.ste07,",
               " ste08.ste_file.ste08,",
               " ste09.ste_file.ste09,",
               " ste10.ste_file.ste10,",
               " ste11.ste_file.ste11,",
               " ste12.ste_file.ste12,",
               " ste13.ste_file.ste13,",
               " ste14.ste_file.ste14,",
               " ste15.ste_file.ste15,",
               " ste26.ste_file.ste26,",
               " ste27.ste_file.ste27,",
               " ste28.ste_file.ste28,",
               " ste29.ste_file.ste29,",
               " ste30.ste_file.ste30,",
               " l_sfb08.sfb_file.sfb08" 
   LET l_table = cl_prt_temptable('asdr220',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF   
#No.FUN-810010--End
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.yea = ARG_VAL(8)
   LET tm.mo  = ARG_VAL(9)
   LET tm.jump = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610079-end
   #-->依產品分類
#No.FUN-690010------Begin-----
#   CREATE TEMP TABLE r220_tmp
#    (
#     ima131    VARCHAR(10), 
#     ste06     decimal(12,2),     
#     ste07     decimal(20,6),     
#     ste08     decimal(20,6),     
#     ste09     decimal(20,6),    
#     ste10     decimal(20,6),    
#     ste11     decimal(12,2),    
#     ste12     decimal(20,6),      
#     ste13     decimal(20,6),      
#     ste14     decimal(20,6),      
#     ste15     decimal(20,6),      
#     ste26     decimal(12,2),     
#     ste27     decimal(20,6),     
#     ste28     decimal(20,6),     
#     ste29     decimal(20,6),     
#     ste30     decimal(20,6)      
#    );
#No.FUN-810010---Begin
#   CREATE TEMP TABLE r220_tmp(
#     ima131    LIKE ima_file.ima131, 
#     ste06     LIKE ste_file.ste06,     
#     ste07     LIKE type_file.num20_6,    
#     ste08     LIKE type_file.num20_6,    
#     ste09     LIKE type_file.num20_6,   
#     ste10     LIKE type_file.num20_6,   
#     ste11     LIKE type_file.num20_6,   
#     ste12     LIKE type_file.num20_6,     
#     ste13     LIKE type_file.num20_6,     
#     ste14     LIKE type_file.num20_6,     
#     ste15     LIKE type_file.num20_6,     
#     ste26     LIKE type_file.num20_6,    
#     ste27     LIKE type_file.num20_6,    
#     ste28     LIKE type_file.num20_6,    
#     ste29     LIKE type_file.num20_6,    
#     ste30     LIKE type_file.num20_6);
 
#No.FUN-690010-------End------    
#     create unique index r220_tmp  on r220_tmp(ima131) 
#No.FUN-810010---End
 
   #-->依成本分群
#No.FUN-690010-------Begin------
#   CREATE TEMP TABLE r220_tmp2
#    (
#     ima12     VARCHAR(04), 
#     ste06     decimal(12,2),     
#     ste07     decimal(20,6),     
#     ste08     decimal(20,6),     
#     ste09     decimal(20,6),    
#     ste10     decimal(20,6),    
#     ste11     decimal(12,2),    
#     ste12     decimal(20,6),      
#     ste13     decimal(20,6),      
#     ste14     decimal(20,6),      
#     ste15     decimal(20,6),      
#     ste26     decimal(12,2),     
#     ste27     decimal(20,6),     
#     ste28     decimal(20,6),     
#     ste29     decimal(20,6),     
#     ste30     decimal(20,6)      
#    );
#No.FUN-810010---Begin
#   CREATE TEMP TABLE r220_tmp2(
#     ima12     LIKE ima_file.ima12,
#     ste06     LIKE ste_file.ste06,     
#     ste07     LIKE type_file.num20_6,    
#     ste08     LIKE type_file.num20_6,    
#     ste09     LIKE type_file.num20_6,   
#     ste10     LIKE type_file.num20_6,   
#     ste11     LIKE type_file.num20_6,  
#     ste12     LIKE type_file.num20_6,     
#     ste13     LIKE type_file.num20_6,     
#     ste14     LIKE type_file.num20_6,     
#     ste15     LIKE type_file.num20_6,     
#     ste26     LIKE type_file.num20_6,    
#     ste27     LIKE type_file.num20_6,    
#     ste28     LIKE type_file.num20_6,    
#     ste29     LIKE type_file.num20_6,    
#     ste30     LIKE type_file.num20_6);      
    
#No.FUN-690010-------End-------
#     create unique index r220_tmp2  on r220_tmp2(ima12) 
#No.FUN-810010---End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL asdr220_tm()        # Input print condition
   ELSE 
      CALL asdr220()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD 
END MAIN
 
FUNCTION asdr220_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW asdr220_w AT p_row,p_col WITH FORM "asd/42f/asdr220" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.more = 'N'
   LET tm.jump = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ste04,ima12,ste31,ima131 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
  
     INPUT BY NAME tm.yea,tm.mo,tm.jump,tm.more WITHOUT DEFAULTS 
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
 
        AFTER FIELD jump
           IF NOT cl_null(tm.jump) THEN
              IF tm.jump NOT MATCHES '[YN]' THEN
                 LET tm.jump='Y'
                 NEXT FIELD jump
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
         WHERE zz01='asdr220'
        IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
          CALL cl_err('asdr220','9031',1)   
          
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           #TQC-610079-begin
                           " '",tm.yea CLIPPED,"'",
                           " '",tm.mo CLIPPED,"'",
                           " '",tm.jump CLIPPED,"'",
                           #TQC-610079-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           CALL cl_cmdat('asdr220',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE  
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr220()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr220_w
 
END FUNCTION
 
FUNCTION asdr220()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
          g_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_i       LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima12   LIKE ima_file.ima12,
          l_ima131  LIKE ima_file.ima131,
          l_ima02   LIKE ima_file.ima02,      #No.FUN-810010                                                                                         
          l_ima021  LIKE ima_file.ima021,     #No.FUN-810010
          l_sfb08   LIKE sfb_file.sfb08,      #No.FUN-810010
          l_k       LIKE type_file.chr1000,   #No.FUN-810010      
          sr RECORD LIKE ste_file.*
 
       CALL cl_del_data(l_table)               #No.FUN-810010
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-810010
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     DELETE FROM r220_tmp        #No.FUN-810010 
#     DELETE FROM r220_tmp2       #No.FUN-810010 
     LET l_sql = "SELECT ste_file.* FROM ste_file,ima_file",
                 " WHERE ste02=",tm.yea," AND ste03=",tm.mo,
                 "   AND ste05=ima01 ", 
                 "   AND ",tm.wc CLIPPED
 
     PREPARE asdr220_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM   
       
     END IF
     DECLARE asdr220_curs1 CURSOR FOR asdr220_prepare1
 
#      CALL cl_outnam('asdr220') RETURNING l_name          #NO.FUN-810010
 
#     START REPORT asdr220_rep TO l_name                   #NO.FUN-810010
#     LET g_pageno = 0                                     #NO.FUN-810010
     FOREACH asdr220_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_ima131=' '    LET l_ima12=' '
       SELECT ima12,ima131 INTO l_ima12,l_ima131 
         FROM ima_file WHERE ima01=sr.ste05
       IF SQLCA.sqlcode THEN LET l_ima131=' ' LET l_ima12=' ' END IF
       IF l_ima131 IS NULL THEN LET l_ima131=' ' END IF
       IF l_ima12 IS NULL THEN LET l_ima12=' ' END IF
       #-->依產品分類小計 
#No.FUN-810010---Begin
#       INSERT INTO r220_tmp VALUES(l_ima131,
#                        sr.ste06,sr.ste07,sr.ste08,sr.ste09,sr.ste10,
#                        sr.ste11,sr.ste12,sr.ste13,sr.ste14,sr.ste15,
#                        sr.ste26,sr.ste27,sr.ste28,sr.ste29,sr.ste30)
#       IF SQLCA.sqlcode THEN 
#          UPDATE r220_tmp
#             SET ste06=ste06+sr.ste06, ste07=ste07+sr.ste07,
#                 ste08=ste08+sr.ste08, ste09=ste09+sr.ste09,
#                 ste10=ste10+sr.ste10, ste11=ste11+sr.ste11,
#                 ste12=ste12+sr.ste12, ste13=ste13+sr.ste13,
#                 ste14=ste14+sr.ste14, ste15=ste15+sr.ste15,
#                 ste26=ste26+sr.ste26, ste27=ste27+sr.ste27, 
#                 ste28=ste28+sr.ste28, ste29=ste29+sr.ste29, 
#                 ste30=ste30+sr.ste30
#          WHERE ima131=l_ima131
#       END IF
 
       #-->依成本分群小計 
#       INSERT INTO r220_tmp2 VALUES(l_ima12,
#                        sr.ste06,sr.ste07,sr.ste08,sr.ste09,sr.ste10,
#                        sr.ste11,sr.ste12,sr.ste13,sr.ste14,sr.ste15,
#                        sr.ste26,sr.ste27,sr.ste28,sr.ste29,sr.ste30)
#       IF SQLCA.sqlcode THEN 
#          UPDATE r220_tmp2
#             SET ste06=ste06+sr.ste06, ste07=ste07+sr.ste07,
#                 ste08=ste08+sr.ste08, ste09=ste09+sr.ste09,
#                 ste10=ste10+sr.ste10, ste11=ste11+sr.ste11,
#                 ste12=ste12+sr.ste12, ste13=ste13+sr.ste13,
#                 ste14=ste14+sr.ste14, ste15=ste15+sr.ste15,
#                 ste26=ste26+sr.ste26, ste27=ste27+sr.ste27, 
#                 ste28=ste28+sr.ste28, ste29=ste29+sr.ste29, 
#                 ste30=ste30+sr.ste30
#          WHERE ima12=l_ima12 
#       END IF
 
#       OUTPUT TO REPORT asdr220_rep(l_ima12,l_ima131,sr.*)
    SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
      FROM ima_file WHERE ima01=sr.ste05
    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
    IF SQLCA.sqlcode THEN LET l_sfb08 =0 END IF
        EXECUTE insert_prep USING l_ima02,l_ima021,l_ima12,l_ima131,sr.ste04,sr.ste05,
                                  sr.ste06,sr.ste07,sr.ste08,sr.ste09,sr.ste10,
                                  sr.ste11,sr.ste12,sr.ste13,sr.ste14,sr.ste15,
                                  sr.ste26,sr.ste27,sr.ste28,sr.ste29,sr.ste30,
                                  l_sfb08
#No.FUN-810010---End
     END FOREACH
#No.FUN-810010---Begin
#     FINISH REPORT asdr220_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ste04,ima12,ste31,ima131')                         
              RETURNING tm.wc                                                   
      END IF          
      LET l_k = tm.yea USING '&&&&','/',tm.mo USING '&&'                                                          
      LET g_str=tm.wc ,";",l_k,";",tm.jump,";",g_azi04,";",g_azi05
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('asdr220','asdr220',l_sql,g_str)
#No.FUN-810010---End
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #No.FUN-BB0047--mark--End-----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #No.FUN-810010 
END FUNCTION
#No.FUN-810010 ---Begin
#REPORT asdr220_rep(l_ima12,l_ima131,sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#          l_cnt        LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#          l_cls        LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#          l_line1      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_line2      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_line3      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_bamt, l_camt,l_eamt LIKE type_file.num20_6, #No.FUN-690010 DECIMAL(20,6)
#          l_ima02   LIKE ima_file.ima02,
#          l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#          l_ima12   LIKE ima_file.ima12 ,
#          l_ima131  LIKE ima_file.ima131,
#          l_sfb08   LIKE sfb_file.sfb08,
#          sr RECORD LIKE ste_file.*,
#          tt RECORD LIKE ste_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY l_ima12,l_ima131,sr.ste05,sr.ste04
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN (g_c[37]+(g_w[37]+g_w[38]-FGL_WIDTH(g_x[21]))/2),g_x[21] CLIPPED,
#            COLUMN (g_c[43]+(g_w[43]+g_w[44]-FGL_WIDTH(g_x[22]))/2),g_x[22] CLIPPED,
#            COLUMN (g_c[49]+(g_w[49]+g_w[50]-FGL_WIDTH(g_x[23]))/2),g_x[23] CLIPPED
#      LET l_line1=g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]
#      LET l_line2=g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+g_w[47]
#      LET l_line3=g_w[48]+g_w[49]+g_w[50]+g_w[51]+g_w[52]+g_w[53]
#      PRINT COLUMN g_c[36],g_dash2[1,l_line1],
#            COLUMN g_c[42],g_dash2[1,l_line2],
#            COLUMN g_c[48],g_dash2[1,l_line3]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
#            g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED,g_x[50] CLIPPED,
#            g_x[51] CLIPPED,g_x[52] CLIPPED
#           ,g_x[53] CLIPPED   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF l_ima12 #成本分群
#     IF tm.jump='Y' THEN SKIP TO TOP OF PAGE END IF
#
#   ON EVERY ROW
#    #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#       FROM ima_file WHERE ima01=sr.ste05
#     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
#     IF SQLCA.sqlcode THEN LET l_sfb08 =0 END IF
#     LET l_bamt = sr.ste07+sr.ste08+sr.ste09+sr.ste10
#     LET l_camt = sr.ste12+sr.ste13+sr.ste14+sr.ste15 
#     LET l_eamt = sr.ste27+sr.ste28+sr.ste29+sr.ste30 
#     PRINT COLUMN g_c[31],sr.ste05,                         #料號
#           COLUMN g_c[32],l_ima02,                          #品名
#          #start FUN-5A0059
#           COLUMN g_c[33],l_ima021,                         #規格
#           COLUMN g_c[34],sr.ste04,                         #工單編號
#           COLUMN g_c[35],cl_numfor(l_sfb08,35,0),          #生產數量
#           COLUMN g_c[36],cl_numfor(sr.ste06 ,36,g_azi04),  #期初數量
#           COLUMN g_c[37],cl_numfor(sr.ste07 ,37,g_azi04),  #期初材料
#           COLUMN g_c[38],cl_numfor(sr.ste08 ,38,g_azi04),  #期初人工
#           COLUMN g_c[39],cl_numfor(sr.ste09 ,39,g_azi04),  #期初製費一
#           COLUMN g_c[40],cl_numfor(sr.ste10 ,40,g_azi04),  #期初製費二
#           COLUMN g_c[41],cl_numfor(l_bamt   ,41,g_azi05),  #合計
#           COLUMN g_c[42],cl_numfor(sr.ste11 ,42,g_azi04),  #本月投入數量
#           COLUMN g_c[43],cl_numfor(sr.ste12 ,43,g_azi04),  #本月投入材料
#           COLUMN g_c[44],cl_numfor(sr.ste13 ,44,g_azi04),  #本月投入人工 
#           COLUMN g_c[45],cl_numfor(sr.ste14 ,45,g_azi04),  #本月投入製費一
#           COLUMN g_c[46],cl_numfor(sr.ste15 ,46,g_azi04),  #本月投入製費二
#           COLUMN g_c[47],cl_numfor(l_camt   ,47,g_azi05),  #合計
#           COLUMN g_c[48],cl_numfor(sr.ste26 ,48,g_azi04),  #期末數量
#           COLUMN g_c[49],cl_numfor(sr.ste27 ,49,g_azi04),  #期末材料
#           COLUMN g_c[50],cl_numfor(sr.ste28 ,50,g_azi04),  #期末人工
#           COLUMN g_c[51],cl_numfor(sr.ste29 ,51,g_azi04),  #期末製費一
#           COLUMN g_c[52],cl_numfor(sr.ste30 ,52,g_azi04),  #期末材料
#           COLUMN g_c[53],cl_numfor(l_eamt   ,53,g_azi05)   #合計
#          #end FUN-5A0059
#                                             
#   AFTER GROUP OF l_ima12   
#         LET tr.ste06=GROUP SUM(sr.ste06)
#         LET tr.ste07=GROUP SUM(sr.ste07)
#         LET tr.ste08=GROUP SUM(sr.ste08)
#         LET tr.ste09=GROUP SUM(sr.ste09)
#         LET tr.ste10=GROUP SUM(sr.ste10)
#         LET tr.ste11=GROUP SUM(sr.ste11)
#         LET tr.ste12=GROUP SUM(sr.ste12)
#         LET tr.ste13=GROUP SUM(sr.ste13)
#         LET tr.ste14=GROUP SUM(sr.ste14)
#         LET tr.ste15=GROUP SUM(sr.ste15)
#         LET tr.ste26=GROUP SUM(sr.ste26)
#         LET tr.ste27=GROUP SUM(sr.ste27)
#         LET tr.ste28=GROUP SUM(sr.ste28)
#         LET tr.ste29=GROUP SUM(sr.ste29)
#         LET tr.ste30=GROUP SUM(sr.ste30)
#         LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10
#         LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#         LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30
#      #-->列印小計
#         PRINT ' '
#         LET l_cls=g_x[17] CLIPPED,'(',l_ima12,')'
#         PRINT COLUMN g_c[32],l_cls,
#              #start FUN-5A0059 
#               COLUMN g_c[36],cl_numfor(tr.ste06 ,36,g_azi05),
#               COLUMN g_c[37],cl_numfor(tr.ste07 ,37,g_azi05),
#               COLUMN g_c[38],cl_numfor(tr.ste08 ,38,g_azi05),
#               COLUMN g_c[39],cl_numfor(tr.ste09 ,39,g_azi05),
#               COLUMN g_c[40],cl_numfor(tr.ste10 ,40,g_azi05),
#               COLUMN g_c[41],cl_numfor(l_bamt   ,41,g_azi05),
#               COLUMN g_c[42],cl_numfor(tr.ste11 ,42,g_azi05),
#               COLUMN g_c[43],cl_numfor(tr.ste12 ,43,g_azi05),
#               COLUMN g_c[44],cl_numfor(tr.ste13 ,44,g_azi05),
#               COLUMN g_c[45],cl_numfor(tr.ste14 ,45,g_azi05),
#               COLUMN g_c[46],cl_numfor(tr.ste15 ,46,g_azi05),
#               COLUMN g_c[47],cl_numfor(l_camt   ,47,g_azi05),
#               COLUMN g_c[48],cl_numfor(tr.ste26 ,48,g_azi05),
#               COLUMN g_c[49],cl_numfor(tr.ste27 ,49,g_azi05),
#               COLUMN g_c[50],cl_numfor(tr.ste28 ,50,g_azi05),
#               COLUMN g_c[51],cl_numfor(tr.ste29 ,51,g_azi05),
#               COLUMN g_c[52],cl_numfor(tr.ste30 ,52,g_azi05),
#               COLUMN g_c[53],cl_numfor(l_eamt   ,53,g_azi05) 
#              #end FUN-5A0059
#                                       
#   ON LAST ROW
#      LET tr.ste06=SUM(sr.ste06)
#      LET tr.ste07=SUM(sr.ste07)
#      LET tr.ste08=SUM(sr.ste08)
#      LET tr.ste09=SUM(sr.ste09)
#      LET tr.ste10=SUM(sr.ste10)
#      LET tr.ste11=SUM(sr.ste11)
#      LET tr.ste12=SUM(sr.ste12)
#      LET tr.ste13=SUM(sr.ste13)
#      LET tr.ste14=SUM(sr.ste14)
#      LET tr.ste15=SUM(sr.ste15)
#      LET tr.ste26=SUM(sr.ste26)
#      LET tr.ste27=SUM(sr.ste27)
#      LET tr.ste28=SUM(sr.ste28)
#      LET tr.ste29=SUM(sr.ste29)
#      LET tr.ste30=SUM(sr.ste30)
#      #-->列印總計
#      PRINT g_dash2[1,g_len]
#      LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#      LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#      LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
#      PRINT COLUMN g_c[32],g_x[19] CLIPPED,
#           #start FUN-5A0059
#            COLUMN g_c[36],cl_numfor(tr.ste06 ,36,g_azi05),
#            COLUMN g_c[37],cl_numfor(tr.ste07 ,37,g_azi05),
#            COLUMN g_c[38],cl_numfor(tr.ste08 ,38,g_azi05),
#            COLUMN g_c[39],cl_numfor(tr.ste09 ,39,g_azi05),
#            COLUMN g_c[40],cl_numfor(tr.ste10 ,40,g_azi05),
#            COLUMN g_c[41],cl_numfor(l_bamt   ,41,g_azi05),
#            COLUMN g_c[42],cl_numfor(tr.ste11 ,42,g_azi05),
#            COLUMN g_c[43],cl_numfor(tr.ste12 ,43,g_azi05),
#            COLUMN g_c[44],cl_numfor(tr.ste13 ,44,g_azi05),
#            COLUMN g_c[45],cl_numfor(tr.ste14 ,45,g_azi05),
#            COLUMN g_c[46],cl_numfor(tr.ste15 ,46,g_azi05),
#            COLUMN g_c[47],cl_numfor(l_camt   ,47,g_azi05),
#            COLUMN g_c[48],cl_numfor(tr.ste26 ,48,g_azi05),
#            COLUMN g_c[49],cl_numfor(tr.ste27 ,49,g_azi05),
#            COLUMN g_c[50],cl_numfor(tr.ste28 ,50,g_azi05),
#            COLUMN g_c[51],cl_numfor(tr.ste29 ,51,g_azi05),
#            COLUMN g_c[52],cl_numfor(tr.ste30 ,52,g_azi05),
#            COLUMN g_c[53],cl_numfor(l_eamt   ,53,g_azi05) 
#           #end FUN-5A0059
#
#      PRINT g_dash[1,g_len]
#      #-->列印產品分類小計
#      LET l_cnt = 0
#      DECLARE r220_cur1 CURSOR FOR
#        SELECT * FROM r220_tmp ORDER BY ima131
#      FOREACH r220_cur1 INTO tr.*
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT column 12,g_x[24] clipped END IF
#        LET l_cnt = l_cnt + 1
#        LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#        LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#        LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
#        PRINT COLUMN g_c[32],tr.ste05,
#             #start FUN-5A0059
#              COLUMN g_c[36],cl_numfor(tr.ste06 ,36,g_azi05),
#              COLUMN g_c[37],cl_numfor(tr.ste07 ,37,g_azi05),
#              COLUMN g_c[38],cl_numfor(tr.ste08 ,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(tr.ste09 ,39,g_azi05),
#              COLUMN g_c[40],cl_numfor(tr.ste10 ,40,g_azi05),
#              COLUMN g_c[41],cl_numfor(l_bamt   ,41,g_azi05),
#              COLUMN g_c[42],cl_numfor(tr.ste11 ,42,g_azi05),
#              COLUMN g_c[43],cl_numfor(tr.ste12 ,43,g_azi05),
#              COLUMN g_c[44],cl_numfor(tr.ste13 ,44,g_azi05),
#              COLUMN g_c[45],cl_numfor(tr.ste14 ,45,g_azi05),
#              COLUMN g_c[46],cl_numfor(tr.ste15 ,46,g_azi05),
#              COLUMN g_c[47],cl_numfor(l_camt   ,47,g_azi05),
#              COLUMN g_c[48],cl_numfor(tr.ste26 ,48,g_azi05),
#              COLUMN g_c[49],cl_numfor(tr.ste27 ,49,g_azi05),
#              COLUMN g_c[50],cl_numfor(tr.ste28 ,50,g_azi05),
#              COLUMN g_c[51],cl_numfor(tr.ste29 ,51,g_azi05),
#              COLUMN g_c[52],cl_numfor(tr.ste30 ,52,g_azi05),
#              COLUMN g_c[53],cl_numfor(l_eamt   ,53,g_azi05) 
#             #end FUN-5A0059
#      END FOREACH
#
#      #-->列印成本分群小計
#      PRINT g_dash2[1,g_len]
#      LET l_cnt = 0
#      DECLARE r221_cur1 CURSOR FOR
#        SELECT * FROM r220_tmp2 ORDER BY ima12
#      FOREACH r221_cur1 INTO tr.*
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT column 12,g_x[25] clipped END IF
#        LET l_cnt = l_cnt + 1
#        LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#        LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#        LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
#        PRINT COLUMN g_c[32],tr.ste05,
#             #start FUN-5A0059
#              COLUMN g_c[36],cl_numfor(tr.ste06 ,36,g_azi05),
#              COLUMN g_c[37],cl_numfor(tr.ste07 ,37,g_azi05),
#              COLUMN g_c[38],cl_numfor(tr.ste08 ,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(tr.ste09 ,39,g_azi05),
#              COLUMN g_c[40],cl_numfor(tr.ste10 ,40,g_azi05),
#              COLUMN g_c[41],cl_numfor(l_bamt   ,41,g_azi05),
#              COLUMN g_c[42],cl_numfor(tr.ste11 ,42,g_azi05),
#              COLUMN g_c[43],cl_numfor(tr.ste12 ,43,g_azi05),
#              COLUMN g_c[44],cl_numfor(tr.ste13 ,44,g_azi05),
#              COLUMN g_c[45],cl_numfor(tr.ste14 ,45,g_azi05),
#              COLUMN g_c[46],cl_numfor(tr.ste15 ,46,g_azi05),
#              COLUMN g_c[47],cl_numfor(l_camt   ,47,g_azi05),
#              COLUMN g_c[48],cl_numfor(tr.ste26 ,48,g_azi05),
#              COLUMN g_c[49],cl_numfor(tr.ste27 ,49,g_azi05),
#              COLUMN g_c[50],cl_numfor(tr.ste28 ,50,g_azi05),
#              COLUMN g_c[51],cl_numfor(tr.ste29 ,51,g_azi05),
#              COLUMN g_c[52],cl_numfor(tr.ste30 ,52,g_azi05),
#              COLUMN g_c[53],cl_numfor(l_eamt   ,53,g_azi05) 
#             #end FUN-5A0059
#      END FOREACH
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
##END REPORT
#No.FUN-810010 ----End
