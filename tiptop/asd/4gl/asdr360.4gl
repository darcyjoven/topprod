# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asdr360.4gl
# Descriptions...: 期初存貨標準成本調整表
# Date & Author..: 99/07/12 By Eric
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570244  05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/07 By king 改正報表中有關錯誤
# Modify.........: No.FUN-810010 08/01/20 By baofei報表輸出改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              sw      LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
              sw1     LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
              s       LIKE ahe_file.ahe01,         #No.FUN-690010CHAR(3),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-810010---Begin
DEFINE g_sql     STRING
DEFINE g_str     STRING
DEFINE l_table  STRING
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD
#No.FUN-810010---Begin
   LET g_sql= " imk01.imk_file.imk01,",
              " imk02.imk_file.imk02,",
              " l_ima02.ima_file.ima02,",
              " l_ima021.ima_file.ima021,",
              " ima06.ima_file.ima06,",
              " ima12.ima_file.ima12,",
              " ima131.ima_file.ima131,",
              #" pstd.cqg_file.cqg06,",   #TQC-B90211
              #" std.cqg_file.cqg06,",    #TQC-B90211
              " pstd.type_file.num15_3,",   #TQC-B90211
              " std.type_file.num15_3,",    #TQC-B90211
              " bqty.imk_file.imk09,",
              " amt.alb_file.alb06,",
              " amt1.alb_file.alb06,",
              " amt2.alb_file.alb06"   
   LET l_table = cl_prt_temptable('asdr360',g_sql) CLIPPED                    
   IF l_table = -1 THEN EXIT PROGRAM END IF                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                     
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                      
     PREPARE insert_prep FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                       
     END IF                         
#No.FUN-810010---End
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yea = ARG_VAL(8)
   LET tm.mo  = ARG_VAL(9)
   LET tm.sw  = ARG_VAL(10)
   LET tm.sw1 = ARG_VAL(11)
   LET tm.s   = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #-->依產品分類
#No.FUN-690010-------Begin-------
#   CREATE TEMP TABLE r360_tmp
#    (
#          ima131  VARCHAR(10),
#          bqty    DEC(13,3),
#          amt     DEC(20,6),
#          amt1    DEC(20,6),
#          amt2    DEC(20,6)
#    );
#No.FUN-810010---Begin 
#   CREATE TEMP TABLE r360_tmp(
#          ima131  LIKE ima_file.ima131,
#          bqty    LIKE imk_file.imk09,
#          amt     LIKE type_file.num20_6,
#          amt1    LIKE type_file.num20_6,
#          amt2    LIKE type_file.num20_6);
    
##No.FUN-690010-------End--------
#     create unique index r360_tmp on r360_tmp(ima131)  
 
   #-->依產品分類+成本分群
#No.FUN-690010------Begin-------
#   CREATE TEMP TABLE r360_tmp2
#    (
#          ima131  VARCHAR(10),
#          ima12   VARCHAR(04),
#          bqty    DEC(13,3),
#          amt     DEC(20,6),
#          amt1    DEC(20,6),
#          amt2    DEC(20,6)
#    );
#   CREATE TEMP TABLE r360_tmp2(
#          ima131  LIKE ima_file.ima131,
#          ima12   LIKE ima_file.ima12,
#          bqty    LIKE imk_file.imk09,
#          amt     LIKE type_file.num20_6,
#          amt1    LIKE type_file.num20_6,
#          amt2    LIKE type_file.num20_6);
#    
#No.FUN-690010---------End--------
#     create unique index r360_tmp2 on r360_tmp2(ima131,ima12)   
#No.FUN-810010---end--
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr360_tm(4,12)        # Input print condition
      ELSE CALL asdr360()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr360_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW asdr360_w AT p_row,p_col WITH FORM "asd/42f/asdr360" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.sw   ='N'
   LET tm.sw1  ='N'
   LET tm.s    ='132'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   WHILE TRUE
 #MOD-530125
     CONSTRUCT BY NAME tm.wc ON ima12,ima131,ima06,imk01,imk02
##
#No.FUN-570244 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP                                                                                                 
            IF INFIELD(imk01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO imk01                                                                                 
               NEXT FIELD imk01                                                                                                     
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
 
     INPUT BY NAME tm.yea,tm.mo,tm.sw,tm.sw1,tm2.s1,tm2.s2,tm2.s3,tm.more
      WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yea
           IF tm.yea IS NULL OR tm.yea=0 THEN
              NEXT FIELD yea
           END IF
        AFTER FIELD mo
           IF tm.mo IS NULL OR tm.mo=0 THEN
              NEXT FIELD mo
           END IF
        AFTER FIELD sw
           IF tm.sw NOT MATCHES '[YN]' THEN
              NEXT FIELD sw
           END IF
        AFTER FIELD sw1
           IF tm.sw1 NOT MATCHES '[YN]' THEN
              NEXT FIELD sw1
           END IF
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
  
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
        AFTER INPUT 
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
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
         WHERE zz01='asdr360'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr360','9031',1)   
           
           CONTINUE WHILE 
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
                           " '",tm.mo  CLIPPED,"'",
                           " '",tm.sw  CLIPPED,"'",
                           " '",tm.sw1 CLIPPED,"'",
                           " '",tm.s   CLIPPED,"'",
                           #TQC-610079-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           CALL cl_cmdat('asdr360',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE  
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr360()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr360_w
 
END FUNCTION
 
FUNCTION asdr360()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
          last_y    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          last_m    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          sr RECORD
             order1 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
             order2 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
             order3 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
             ima06  LIKE ima_file.ima06,
             ima12  LIKE ima_file.ima12,
             ima131 LIKE ima_file.ima131,
             imk01  LIKE imk_file.imk01,
             imk02  LIKE imk_file.imk02,
             imk03  LIKE imk_file.imk03,
             imk04  LIKE imk_file.imk04,
             bqty   LIKE imk_file.imk09,
             #pstd   LIKE cqg_file.cqg06,       #No.FUN-690010DEC(10,2),   #TQC-B90211
             #std    LIKE cqg_file.cqg06,       #No.FUN-690010DEC(10,2),   #TQC-B90211
             pstd   LIKE type_file.num15_3,       #No.FUN-690010DEC(10,2),   #TQC-B90211
             std    LIKE type_file.num15_3,       #No.FUN-690010DEC(10,2),   #TQC-B90211
             amt    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
             amt1   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
             amt2   LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
             END RECORD
DEFINE    l_ima02   LIKE ima_file.ima02         #No.FUN-810010                                                                                    
DEFINE    l_ima021  LIKE ima_file.ima021        #No.FUN-810010
 
       CALL cl_del_data(l_table)                                #No.FUN-810010                     
       SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-810010 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     IF tm.mo=1 THEN
        LET last_y=tm.yea-1
        LET last_m=12
     ELSE
        LET last_y=tm.yea
        LET last_m=tm.mo-1
     END IF
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     DELETE FROM r360_tmp                                 #NO.FUN-810010
#     DELETE FROM r360_tmp2                                #NO.FUN-810010
     LET l_sql = "SELECT '','','',ima06,ima12,ima131,",
                 " imk01,imk02,imk03,imk04,imk09,0,0,0",
                 " FROM imk_file,ima_file,imd_file",
                 " WHERE imk05=",last_y,
                 "   AND imk06=",last_m,
                 "   AND imk01=ima01",
                 "   AND imk02=imd01 AND imd09='Y'",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr360_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr360_curs1 CURSOR FOR asdr360_prepare1
       CALL cl_outnam('asdr360') RETURNING l_name
 
#     START REPORT asdr360_rep TO l_name                   #NO.FUN-810010
#     LET g_pageno = 0                                     #NO.FUN-810010
     FOREACH asdr360_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.ima06)  THEN LET sr.ima06=' '  END IF
       IF cl_null(sr.ima12)  THEN LET sr.ima12=' '  END IF
       IF cl_null(sr.ima131) THEN LET sr.ima131=' ' END IF
 
       IF tm.sw1='N' AND sr.bqty=0 THEN CONTINUE FOREACH END IF
       #-->取上月單價 
       SELECT stb07+stb08+stb09+stb09a INTO sr.pstd FROM stb_file
        WHERE stb01 = sr.imk01 AND stb02 = last_y AND stb03 = last_m
       IF STATUS <> 0 THEN LET sr.std=0 END IF
 
       #-->取本月單價 
       SELECT stb07+stb08+stb09+stb09a INTO sr.std FROM stb_file
        WHERE stb01 = sr.imk01 AND stb02 = tm.yea AND stb03 = tm.mo
       IF STATUS <> 0 THEN LET sr.std=0 END IF
 
       LET sr.amt1=sr.bqty*sr.pstd
       LET sr.amt2=sr.bqty*sr.std
       LET sr.amt=sr.amt2-sr.amt1
       IF tm.sw='N' THEN
          IF sr.amt=0 THEN CONTINUE FOREACH END IF
       END IF
#No.FUN-810010---Begin
       #--->產生產品分類合計檔
#       INSERT INTO r360_tmp VALUES(sr.ima131,sr.bqty,sr.amt,sr.amt1,sr.amt2)
#          IF SQLCA.sqlcode THEN 
#              UPDATE r360_tmp SET bqty=bqty+sr.bqty, amt=amt+sr.amt,
#                                 amt1=amt1+sr.amt1, amt2=amt2+sr.amt2
#                           WHERE ima131=sr.ima131
#          END IF
 
       #--->產生產品分類+成本分群合計檔
#       INSERT INTO r360_tmp2
#                VALUES(sr.ima131,sr.ima12,sr.bqty,sr.amt,sr.amt1,sr.amt2)
#          IF SQLCA.sqlcode THEN 
#              UPDATE r360_tmp2 SET bqty=bqty+sr.bqty, amt=amt+sr.amt,
#                                   amt1=amt1+sr.amt1, amt2=amt2+sr.amt2
#                           WHERE ima131=sr.ima131 AND ima12=sr.ima12
#          END IF
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima12
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.imk01 
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima131
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.imk02 
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima06 
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT asdr360_rep(sr.*)
      SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                    
      FROM ima_file WHERE ima01=sr.imk01 
        EXECUTE insert_prep USING sr.imk01,sr.imk02,l_ima02,l_ima021,sr.ima06,
                                  sr.ima12,sr.ima131,sr.pstd,sr.std,sr.bqty,
                                  sr.amt,sr.amt1,sr.amt2
#No.FUN-810010----end-----
     END FOREACH
#No.FUN-810010---Begin 
#      FINISH REPORT asdr360_rep  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ima12,ima131,ima06,imk01,imk02')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.s[1,1],";", tm.s[2,2],";",
                      tm.s[3,3],";",tm.yea,";",tm.mo,";",g_azi04,";",
                      g_azi05
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('asdr360','asdr360',l_sql,g_str)
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-810010---End 
 
END FUNCTION
 
#No.FUN-810010---Begin 
#REPORT asdr360_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#          l_s1      LIKE alb_file.alb06,         #No.FUN-690010decimal(14,2) ,
#          l_s2      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6) ,
#          l_s3      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6) ,
#          l_s4      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6) ,
#          l_s5      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6) ,
#          l_s6      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6) ,
#          l_ima02   LIKE ima_file.ima02,
#          l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#          l_ima131  LIKE ima_file.ima131,
#          l_ima12   LIKE ima_file.ima12,
#          l_sta07   LIKE sta_file.sta07,
#          l_sfb05   like sfb_file.sfb05 ,
#          l_cnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#          sr RECORD
#             order1 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#             order2 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#             order3 LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#             ima06  LIKE ima_file.ima06,
#             ima12  LIKE ima_file.ima12,
#             ima131 LIKE ima_file.ima131,
#             imk01  LIKE imk_file.imk01,
#             imk02  LIKE imk_file.imk02,
#             imk03  LIKE imk_file.imk03,
#             imk04  LIKE imk_file.imk04,
#             bqty   LIKE imk_file.imk09,
#             pstd   LIKE feb_file.feb10,         #No.FUN-690010DEC(10,2),
#             std    LIKE feb_file.feb10,         #No.FUN-690010DEC(10,2),
#             amt    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#             amt1   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#             amt2   LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
#             END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
 
#  ORDER BY sr.ima12,sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0087 add CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#            g_x[39] clipped,g_x[40] clipped,g_x[41] clipped
#           ,g_x[42] clipped   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ima12
#      PRINT COLUMN g_c[31],sr.ima12;
#
#   ON EVERY ROW
#    #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#       FROM ima_file WHERE ima01=sr.imk01
#     PRINT COLUMN g_c[32],sr.imk01,                        #料號
#           COLUMN g_c[33],l_ima02,                         #品名
#          #start FUN-5A0059
#           COLUMN g_c[34],l_ima021,                        #規格
#           COLUMN g_c[35],sr.ima131,                       #產品分類
#           COLUMN g_c[36],sr.imk02,                        #倉庫編號
#           COLUMN g_c[37],cl_numfor(sr.pstd,37,g_azi05),   #舊標準單價
#           COLUMN g_c[38],cl_numfor(sr.std ,38,g_azi05),   #舊標準單價
#           COLUMN g_c[39],cl_numfor(sr.bqty,39,2),         #庫存數量
#           COLUMN g_c[40],cl_numfor(sr.amt1,40,g_azi04),   #調整前金額
#           COLUMN g_c[41],cl_numfor(sr.amt2,41,g_azi04),   #調後前金額
#           COLUMN g_c[42],cl_numfor(sr.amt ,42,g_azi04)    #調整差異金額
#          #end FUN-5A0059
#
#   AFTER GROUP OF sr.ima12
#         LET l_s1 = GROUP SUM(sr.bqty)
#         LET l_s2 = GROUP SUM(sr.amt)
#         LET l_s3 = GROUP SUM(sr.amt1)
#         LET l_s4 = GROUP SUM(sr.amt2)
#         PRINT COLUMN g_c[32],g_x[15] CLIPPED,
#              #start FUN-5A0059
#               COLUMN g_c[39],cl_numfor(l_s1 , 39,2),          #庫存數量
#               COLUMN g_c[40],cl_numfor(l_s3 , 40,g_azi05),    #調整前金額
#               COLUMN g_c[41],cl_numfor(l_s4 , 41,g_azi05),    #調後前金額
#               COLUMN g_c[42],cl_numfor(l_s2 , 42,g_azi05)     #調整差異金額
#              #end FUN-5A0059
#         PRINT ' '
#
#   ON LAST ROW
#      PRINT g_dash2[1,g_len]
#      LET l_s1 = SUM(sr.bqty)
#      LET l_s2 = SUM(sr.amt)
#      LET l_s3 = SUM(sr.amt1)
#      LET l_s4 = SUM(sr.amt2)
#      #-->列印總計
#      PRINT COLUMN g_c[32],g_x[16] CLIPPED,
#           #start FUN-5A0059
#            COLUMN g_c[39],cl_numfor(l_s1 , 39,2),          #庫存數量
#            COLUMN g_c[40],cl_numfor(l_s3 , 40,g_azi05),    #調整前金額
#            COLUMN g_c[41],cl_numfor(l_s4 , 41,g_azi05),    #調後前金額
#            COLUMN g_c[42],cl_numfor(l_s2 , 42,g_azi05)     #調整差異金額
#          #end FUN-5A0059
#     PRINT g_dash[1,g_len]
#
#      #-->列印產品分類與成本分群小計:
#      LET l_cnt = 0
#     DECLARE r360_cur2 CURSOR FOR
#        SELECT * FROM r360_tmp2 ORDER BY ima12,ima131
#      FOREACH r360_cur2 INTO l_ima131,l_ima12,l_s1,l_s2,l_s3,l_s4
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT COLUMN g_c[32],g_x[17] CLIPPED END IF
#       #start FUN-5A0059
#        PRINT COLUMN g_c[35],l_ima131,
#              COLUMN g_c[36],l_ima12,
#              COLUMN g_c[39],cl_numfor(l_s1 , 39,2),          #庫存數量
#              COLUMN g_c[40],cl_numfor(l_s3 , 40,g_azi05),    #調整前金額
#              COLUMN g_c[41],cl_numfor(l_s4 , 41,g_azi05),    #調後前金額
#              COLUMN g_c[42],cl_numfor(l_s2 , 42,g_azi05)     #調整差異金額
#       #end FUN-5A0059
#        LET l_cnt = l_cnt + 1
#      END FOREACH
#      IF l_cnt > 0 THEN PRINT g_dash2[1,g_len] END IF
#
      #-->列印產品成本分群小計:
#      LET l_cnt = 0
#      DECLARE r360_cur1 CURSOR FOR
#        SELECT * FROM r360_tmp ORDER BY ima131
#      FOREACH r360_cur1 INTO l_ima131,l_s1,l_s2,l_s3,l_s4
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT COLUMN g_c[32],g_x[18] CLIPPED END IF    
       #start FUN-5A0059
#        PRINT COLUMN g_c[35],l_ima131,
#              COLUMN g_c[39],cl_numfor(l_s1 , 39,2),          #庫存數量
#              COLUMN g_c[40],cl_numfor(l_s3 , 40,g_azi05),    #調整前金額
#              COLUMN g_c[41],cl_numfor(l_s4 , 41,g_azi05),    #調後前金額
#              COLUMN g_c[42],cl_numfor(l_s2 , 42,g_azi05)     #調整差異金額
#       #end FUN-5A0059
#        LET l_cnt = l_cnt + 1
#      END FOREACH
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#  PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-810010---END----
