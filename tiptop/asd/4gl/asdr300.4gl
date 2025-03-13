# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr300.4gl
# Descriptions...: 存貨明細表
# Date & Author..: 99/07/06 By Eric
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP 
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: NO.FUN-850090 08/05/20 By zhaijie老報表修改為cr
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              sw      LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
              s       LIKE ahe_file.ahe01,         #No.FUN-690010CHAR(03),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#NO.FUN-850090--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
DEFINE l_table1      STRING
DEFINE l_table2      STRING
#NO.FUN-850090--END---
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
#NO.FUN-850090--START---
   LET g_sql = "ima06.ima_file.ima06,",
               "ima08.ima_file.ima08,",
               "ima12.ima_file.ima12,",
               "ima131.ima_file.ima131,",
               "imk01.imk_file.imk01,",
               "imk02.imk_file.imk02,",
               "imk03.imk_file.imk03,",
               "imk04.imk_file.imk04,",
               "bqty.imk_file.imk09,",
               "eqty.imk_file.imk09,",
               "qty.imk_file.imk09,",
               "std.alb_file.alb06,",
               "bamt.alb_file.alb06,",
               "eamt.alb_file.alb06,",
               "amt.alb_file.alb06,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021"
   LET l_table = cl_prt_temptable('asdr300',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "l_ima12.ima_file.ima12,",
               "l_ima131.ima_file.ima131,",
               "l_bqty.ade_file.ade05,",
               "l_eqty.ade_file.ade05,",
               "l_qty.ade_file.ade05,",
               "l_bamt.alb_file.alb06,",
               "l_eamt.alb_file.alb06,",
               "l_amt.alb_file.alb06"
   LET l_table1 = cl_prt_temptable('asdr3001',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "l_ima131.ima_file.ima131,",
               "l_bqty.ade_file.ade05,",
               "l_eqty.ade_file.ade05,",
               "l_qty.ade_file.ade05,",
               "l_bamt.alb_file.alb06,",
               "l_eamt.alb_file.alb06,",
               "l_amt.alb_file.alb06"
   LET l_table2 = cl_prt_temptable('asdr3002',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF 
#NO.FUN-850090--END---
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
   LET tm.sw = ARG_VAL(10)
   LET tm.s = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
 
   #-->依產品分類
#No.FUN-690010------Begin------
#   CREATE TEMP TABLE r300_tmp
#    (
#          ima131  VARCHAR(10),
#          qty     DEC(13,3),
#          amt     DEC(20,6),
#          bqty    DEC(13,3),
#          bamt    DEC(20,6),
#          eqty    DEC(13,3),
#          eamt    DEC(20,6)
#    );
   CREATE TEMP TABLE r300_tmp(
          ima131  LIKE ima_file.ima131,
          qty     LIKE imk_file.imk09,
          amt     LIKE type_file.num20_6,
          bqty    LIKE imk_file.imk09,
          bamt    LIKE type_file.num20_6,
          eqty    LIKE imk_file.imk09,
          eamt    LIKE type_file.num20_6);
    
#No.FUN-690010--------End------
     create unique index r300_tmp on r300_tmp(ima131)  
 
   #-->依產品分類 + 成本分群小計 
#No.FUN-690010--------Begin-----
#   CREATE TEMP TABLE r300_tmp2
#    (
#          ima131  VARCHAR(10),
#          ima12   VARCHAR(04),
#          qty     DEC(13,3),
#          amt     DEC(20,6),
#          bqty    DEC(13,3),
#          bamt    DEC(20,6),
#          eqty    DEC(13,3),
#          eamt    DEC(20,6)
#    );
   CREATE TEMP TABLE r300_tmp2(
          ima131  LIKE ima_file.ima131,
          ima12   LIKE ima_file.ima12,
          qty     LIKE imk_file.imk09,
          amt     LIKE type_file.num20_6,
          bqty    LIKE type_file.num20_6,
          bamt    LIKE type_file.num20_6,
          eqty    LIKE imk_file.imk09,
          eamt    LIKE type_file.num20_6);
    
#No.FUN-690010------End-----
     create unique index r300_tmp2 on r300_tmp2(ima131,ima12)  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr300_tm(4,12)        # Input print condition
      ELSE CALL asdr300()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW asdr300_w AT p_row,p_col WITH FORM "asd/42f/asdr300" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.sw   ='N'
   LET tm.s    = '132'
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
     CONSTRUCT BY NAME tm.wc ON ima12,ima06,ima08,imk01,ima131
##
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
 
#No.FUN-570244  --start-                                                                          
      ON ACTION CONTROLP                                                                          
            IF INFIELD(imk01) THEN                                                                
               CALL cl_init_qry_var()                                                             
               LET g_qryparam.form = "q_ima"                                                      
               LET g_qryparam.state = "c"                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                 
               DISPLAY g_qryparam.multiret TO imk01                                               
               NEXT FIELD imk01                                                                  
            END IF                                                                                
#No.FUN-570244 --end--  
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
 
     INPUT BY NAME tm.yea,tm.mo,tm.sw,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm.more 
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
         WHERE zz01='asdr300'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr300','9031',1)   
           
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
                           " '",tm.mo  CLIPPED,"'",
                           " '",tm.sw  CLIPPED,"'",
                           " '",tm.s   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr300',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr300_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL asdr300()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr300_w
 
END FUNCTION
 
FUNCTION asdr300()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          last_y    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          last_m    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_order	ARRAY[6] OF LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
          sr RECORD
             order1 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
             order2 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
             order3 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
             ima06  LIKE ima_file.ima06,     #主分群
             ima08  LIKE ima_file.ima08,     #來源碼
             ima12  LIKE ima_file.ima12,     #成本分群
             ima131 LIKE ima_file.ima131,    #產品分類
             imk01  LIKE imk_file.imk01,     #料號
             imk02  LIKE imk_file.imk02,     #倉庫
             imk03  LIKE imk_file.imk03,     #儲位
             imk04  LIKE imk_file.imk04,     #批號
             bqty   LIKE imk_file.imk09,     #期初數量
             eqty   LIKE imk_file.imk09,     #期未數量
             qty    LIKE imk_file.imk09,     #異動數量
             std    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #標準單價
             bamt   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #期初金量
             eamt   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #期未金額
             amt    LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)                #異動金額
             END RECORD
#NO.FUN-850090-----START--
DEFINE       l_ima02  LIKE ima_file.ima02
DEFINE       l_ima021 LIKE ima_file.ima021
DEFINE       l_ima12  LIKE ima_file.ima12
DEFINE       l_ima131 LIKE ima_file.ima131
DEFINE       l_bqty,l_eqty,l_qty  LIKE ade_file.ade05
DEFINE       l_bamt,l_eamt,l_amt  LIKE alb_file.alb06
    CALL cl_del_data(l_table)                                   #NO.FUN-850090
    CALL cl_del_data(l_table1)                                  #NO.FUN-850090
    CALL cl_del_data(l_table2)                                  #NO.FUN-850090
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asdr300' #NO.FUN-850090
        
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
      EXIT PROGRAM
   END IF
#NO.FUN-850090-----END---
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DELETE FROM r300_tmp
     DELETE FROM r300_tmp2
     IF tm.mo=1 THEN
        LET last_y=tm.yea-1
        LET last_m=12
     ELSE
        LET last_y=tm.yea
        LET last_m=tm.mo-1
     END IF
 
     LET l_sql = "SELECT '','','',ima06,ima08,ima12,ima131,",
                 " imk01,imk02,imk03,imk04,0,imk09,0,0,0,0,0",
                 " FROM imk_file,ima_file,imd_file",
                 " WHERE imk05=",tm.yea,
                   " AND imk06=",tm.mo,
                   " AND imk01=ima01",
                   " AND imk02=imd01",
                   " AND imd09='Y'  ",
                   " AND ",tm.wc CLIPPED
     PREPARE asdr300_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE asdr300_curs1 CURSOR FOR asdr300_prepare1
 
#      CALL cl_outnam('asdr300') RETURNING l_name          #NO.FUN-850090
 
#     START REPORT asdr300_rep TO l_name                   #NO.FUN-850090
#     LET g_pageno = 0                                     #NO.FUN-850090
     FOREACH asdr300_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.ima12  IS NULL THEN LET sr.ima12=' '  END IF
       IF sr.ima131 IS NULL THEN LET sr.ima131=' ' END IF
       IF sr.imk02  IS NULL THEN LET sr.imk02=' '  END IF
       IF sr.imk03  IS NULL THEN LET sr.imk03=' '  END IF
       IF sr.imk04  IS NULL THEN LET sr.imk04=' '  END IF
       IF tm.sw='N' THEN
          IF sr.bqty=0 AND sr.eqty=0 THEN CONTINUE FOREACH END IF
       END IF
       #-->取上月期未數量(本月期初數量)
       SELECT imk09 INTO sr.bqty FROM imk_file
        WHERE imk01=sr.imk01 AND imk02=sr.imk02
          AND imk03=sr.imk03 AND imk04=sr.imk04
          AND imk05=last_y   AND imk06=last_m
         IF SQLCA.sqlcode OR sr.bqty IS NULL THEN LET sr.bqty=0 END IF
 
       #-->取本月標準單價
       SELECT stb07+stb08+stb09+stb09a INTO sr.std FROM stb_file
        WHERE stb01 = sr.imk01 AND stb02 = tm.yea AND stb03 = tm.mo
         IF SQLCA.sqlcode OR sr.std IS NULL THEN LET sr.std=0 END IF
 
       #-->期初金額  
       LET sr.bamt=sr.bqty*sr.std
       #-->期未金額  
       LET sr.eamt=sr.eqty*sr.std
 
       #-->異動數量  
       LET sr.qty = sr.eqty-sr.bqty
       #-->異動金額  
       LET sr.amt = sr.eamt-sr.bamt
 
       #--->產生產品分類合計檔
       INSERT INTO r300_tmp VALUES(sr.ima131,sr.qty,sr.amt,
                                   sr.bqty,sr.bamt,sr.eqty,sr.eamt)
          IF SQLCA.sqlcode THEN 
              UPDATE r300_tmp SET qty =qty +sr.bqty, amt = amt+sr.amt,
                                  bqty=bqty+sr.bqty, bamt=bamt+sr.bamt,
                                  eqty=eqty+sr.eqty, eamt=eamt+sr.eamt
                           WHERE ima131=sr.ima131
          END IF
 
       #--->產生產品分類+成本分群合計檔
       INSERT INTO r300_tmp2 VALUES(sr.ima131,sr.ima12,sr.qty,sr.amt,
                                    sr.bqty,sr.bamt,sr.eqty,sr.eamt)
          IF SQLCA.sqlcode THEN 
              UPDATE r300_tmp2 SET qty =qty +sr.bqty, amt =amt +sr.amt,
                                   bqty=bqty+sr.bqty, bamt=bamt+sr.bamt,
                                   eqty=eqty+sr.eqty, eamt=eamt+sr.eamt
                           WHERE ima131=sr.ima131 AND ima12=sr.ima12
          END IF
#NO.FUN-850090-----START---MARK--
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima12
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.imk01 
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima06 
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima131
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08 
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT asdr300_rep(sr.*)
#NO.FUN-850090-----END----MARK--
#NO.FUN-850090-----START--
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file WHERE ima01=sr.imk01
      DECLARE r300_cur2 CURSOR FOR
        SELECT * FROM r300_tmp2 ORDER BY ima12,ima131
      FOREACH r300_cur2 INTO l_ima131,l_ima12,
                             l_qty,l_amt,l_bqty,l_bamt,l_eqty,l_eamt 
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep1 USING
          l_ima131,l_ima12,l_bqty,l_eqty,l_qty,l_bamt,l_eamt,l_amt
      END FOREACH
 
      #-->列印產品分類小計
      DECLARE r300_cur CURSOR FOR
        SELECT * FROM r300_tmp ORDER BY ima131
      FOREACH r300_cur INTO l_ima131,l_qty,l_amt,l_bqty,l_bamt,l_eqty,l_eamt 
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep2 USING
          l_ima131,l_bqty,l_eqty,l_qty,l_bamt,l_eamt,l_amt
      END FOREACH
      EXECUTE insert_prep USING 
        sr.ima06,sr.ima08,sr.ima12,sr.ima131,sr.imk01,sr.imk02,sr.imk03,
        sr.imk04,sr.bqty,sr.eqty,sr.qty,sr.std,sr.bamt,sr.eamt,sr.amt,
        l_ima02,l_ima021
#NO.FUN-850090-----END--
     END FOREACH
#     FINISH REPORT asdr300_rep                        #NO.FUN-850090
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #NO.FUN-850090
#NO.FUN-850090--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ima12,ima06,ima08,imk01,ima131')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",g_azi03,";",g_azi04,";",g_azi05,";",
                 tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.yea,";",tm.mo
     CALL cl_prt_cs3('asdr300','asdr300',g_sql,g_str) 
#NO.FUN-850090----end----
END FUNCTION
 
#REPORT asdr300_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_bqty,l_eqty,l_qty  LIKE imk_file.imk09,         #No.FUN-690010DEC(15,3), #TQC-840066
#         l_bamt,l_eamt,l_amt  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#         l_ima131 LIKE ima_file.ima131,
#         l_ima12  LIKE ima_file.ima12,
#         l_ima02  LIKE ima_file.ima02,
#         l_ima021 LIKE ima_file.ima021,   #FUN-5A0059
#         l_cnt    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#         sr RECORD
#            order1 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
#            order2 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
#            order3 LIKE type_file.chr1000,      #No.FUN-690010CHAR(40), #FUN-5B0105 20->40
#            ima06  LIKE ima_file.ima06,     #主分群
#            ima08  LIKE ima_file.ima08,     #來源碼
#            ima12  LIKE ima_file.ima12,     #成本分群
#            ima131 LIKE ima_file.ima131,    #產品分類
#            imk01  LIKE imk_file.imk01,     #料號
#            imk02  LIKE imk_file.imk02,     #倉庫
#            imk03  LIKE imk_file.imk03,     #儲位
#            imk04  LIKE imk_file.imk04,     #批號
#            bqty   LIKE imk_file.imk09,     #期初數量
#            eqty   LIKE imk_file.imk09,     #期未數量
#            qty    LIKE imk_file.imk09,     #異動數量
#            std    LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #標準單價
#            bamt   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #期初金量
#            eamt   LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),               #期未金額
#            amt    LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)                #異動金額
#            END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.ima12,sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#           g_x[43] CLIPPED,g_x[44] CLIPPED
#          ,g_x[45] CLIPPED   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.ima12
#     PRINT COLUMN g_c[31],sr.ima12;
 
#  ON EVERY ROW
#    #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#       FROM ima_file WHERE ima01=sr.imk01
#     PRINT COLUMN g_c[32],sr.ima131,                       #產品分類
#           COLUMN g_c[33],sr.imk01,                        #料號
#           COLUMN g_c[34],l_ima02,                         #品名
#          #start FUN-5A0059
#           COLUMN g_c[35],l_ima021,                        #規格
#           COLUMN g_c[36],sr.imk02,                        #倉庫
#           COLUMN g_c[37],sr.imk03,                        #儲位
#           COLUMN g_c[38],sr.imk04[1,10],                  #批號
#           COLUMN g_c[39],cl_numfor(sr.std  ,39,g_azi03),  #標準單價
#           COLUMN g_c[40],cl_numfor(sr.bqty ,40,2),        #期初數量
#           COLUMN g_c[41],cl_numfor(sr.bamt ,41,g_azi04),  #期初金額
#           COLUMN g_c[42],cl_numfor(sr.qty  ,42,2),        #異動數量
#           COLUMN g_c[43],cl_numfor(sr.amt  ,43,g_azi04),  #異動金額
#           COLUMN g_c[44],cl_numfor(sr.eqty ,44,2),        #期未數量
#           COLUMN g_c[45],cl_numfor(sr.eamt ,45,g_azi04)   #期未金額
#          #end FUN-5A0059
 
#  AFTER GROUP OF sr.ima12
#     LET l_bqty = GROUP SUM(sr.bqty)
#     LET l_bamt = GROUP SUM(sr.bamt)
#     LET l_eqty = GROUP SUM(sr.eqty)
#     LET l_eamt = GROUP SUM(sr.eamt)
#     LET l_qty  = GROUP SUM(sr.qty)
#     LET l_amt  = GROUP SUM(sr.amt)
#     PRINT ' '
#     PRINT COLUMN g_c[34],g_x[15] clipped,
#          #start FUN-5A0059
#           COLUMN g_c[40],cl_numfor(l_bqty ,40,2),          #期初數量
#           COLUMN g_c[41],cl_numfor(l_bamt ,41,g_azi05),    #期初金額
#           COLUMN g_c[42],cl_numfor(l_qty  ,42,2),          #異動數量
#           COLUMN g_c[43],cl_numfor(l_amt  ,43,g_azi05),    #異動金額
#           COLUMN g_c[44],cl_numfor(l_eqty ,44,2),          #期未數量
#           COLUMN g_c[45],cl_numfor(l_eamt ,45,g_azi05)     #期未金額
#          #end FUN-5A0059
 
#  ON LAST ROW
#     #-->列印總計
#     LET l_bqty = SUM(sr.bqty)
#     LET l_bamt = SUM(sr.bamt)
#     LET l_eqty = SUM(sr.eqty)
#     LET l_eamt = SUM(sr.eamt)
#     LET l_qty  = SUM(sr.qty)
#     LET l_amt  = SUM(sr.amt)
#     PRINT ' '
#     PRINT COLUMN g_c[34],g_x[16] clipped,
#          #start FUN-5A0059
#           COLUMN g_c[40],cl_numfor(l_bqty ,40,2),          #期初數量
#           COLUMN g_c[41],cl_numfor(l_bamt ,41,g_azi05),    #期初金額
#           COLUMN g_c[42],cl_numfor(l_qty  ,42,2),          #異動數量
#           COLUMN g_c[43],cl_numfor(l_amt  ,43,g_azi05),    #異動金額
#           COLUMN g_c[44],cl_numfor(l_eqty ,44,2),          #期未數量
#           COLUMN g_c[45],cl_numfor(l_eamt ,45,g_azi05)     #期未金額
#          #end FUN-5A0059
#     PRINT g_dash[1,g_len]
 
#     #-->列印產品分類與成本分群小計:
#     LET l_cnt = 0
#     DECLARE r300_cur2 CURSOR FOR
#       SELECT * FROM r300_tmp2 ORDER BY ima12,ima131
#     FOREACH r300_cur2 INTO l_ima131,l_ima12,
#                            l_qty,l_amt,l_bqty,l_bamt,l_eqty,l_eamt 
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[17] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[40],cl_numfor(l_bqty ,40,2),          #期初數量
#             COLUMN g_c[41],cl_numfor(l_bamt ,41,g_azi05),    #期初金額
#             COLUMN g_c[42],cl_numfor(l_qty  ,42,2),          #異動數量
#             COLUMN g_c[43],cl_numfor(l_amt  ,43,g_azi05),    #異動金額
#             COLUMN g_c[44],cl_numfor(l_eqty ,44,2),          #期未數量
#             COLUMN g_c[45],cl_numfor(l_eamt ,45,g_azi05)     #期未金額
#      #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len] CLIPPED
 
#     #-->列印產品分類小計:
#     LET l_cnt = 0
#     DECLARE r300_cur CURSOR FOR
#       SELECT * FROM r300_tmp ORDER BY ima131
#     FOREACH r300_cur INTO l_ima131,l_qty,l_amt,l_bqty,l_bamt,l_eqty,l_eamt 
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[18] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[40],cl_numfor(l_bqty ,40,2),          #期初數量
#             COLUMN g_c[41],cl_numfor(l_bamt ,41,g_azi05),    #期初金額
#             COLUMN g_c[42],cl_numfor(l_qty  ,42,2),          #異動數量
#             COLUMN g_c[43],cl_numfor(l_amt  ,43,g_azi05),    #異動金額
#             COLUMN g_c[44],cl_numfor(l_eqty ,44,2),          #期未數量
#             COLUMN g_c[45],cl_numfor(l_eamt ,45,g_azi05)     #期未金額
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
