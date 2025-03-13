# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asdr240.4gl
# Descriptions...: 直接人工明細表
# Date & Author..: 99/07/01 By Eric
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850087 08/05/19 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
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
          tr  RECORD
              ste05     LIKE aab_file.aab02,       #No.FUN-690010char(06),          
              ste13     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),      
              stv05     LIKE oqv_file.oqv03         #No.FUN-690010decimal(10,2)      
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-850087 --Begin
DEFINE   g_str           LIKE type_file.chr1000
DEFINE   #g_sql           LIKE type_file.chr1000
         g_sql           STRING       #NO.FUN-910082  
DEFINE   l_table         STRING       #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#No.FUN-850087 --End
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
#No.FUN-850087 --Begin
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark
   LET g_sql="ima12.ima_file.ima12,",                                                                                       
             "sta07.sta_file.sta07,",                                                                                       
             "ste05.ste_file.ste05,",                                                                                       
             "ima02.ima_file.ima02,",                                                                                       
             "ima021.ima_file.ima021,",                                                                                     
             "ste04.ste_file.ste04,",                                                                                       
             "sfb82.sfb_file.sfb82,",                                                                                       
             "gem02.gem_file.gem02,",                                                                                       
             "ste13.ste_file.ste13,",                                                                                       
             "stv05.stv_file.stv05,",                                                                                       
             "ima131.ima_file.ima131"                                                                                       
  LET l_table=cl_prt_temptable('asdr240',g_sql)                                                                            
  IF l_table=-1 THEN EXIT PROGRAM END IF  
#No.FUN-850087 --End
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yea = ARG_VAL(8)
   LET tm.mo  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
    #-->依成本分群小計
#No.FUN-690010----Begin-----
#     CREATE TEMP TABLE r240_tmp
#      (
#       ima12     VARCHAR(04),          
#       ste13     decimal(20,6),      
#       stv05     decimal(10,2)      
#       );
     CREATE TEMP TABLE r240_tmp(
       ima12     LIKE ima_file.ima12,          
       ste13     LIKE type_file.num20_6,     
       stv05     LIKE stv_file.stv05);      
       
#No.FUN-690010-----End------
     create unique index r240_tmp on r240_tmp(ima12)   
 
    #-->依成本分群+主製程小計
#No.FUN-690010------Begin----
#     CREATE TEMP TABLE r240_tmp2
#      (
#       ima12     VARCHAR(04),          
#       sta07     VARCHAR(04),          
#       ste13     decimal(20,6),      
#       stv05     decimal(10,2)      
#       );
     CREATE TEMP TABLE r240_tmp2(
       ima12     LIKE ima_file.ima12,          
       sta07     LIKE sta_file.sta07,          
       ste13     LIKE type_file.num20_6,     
       stv05     LIKE stv_file.stv05);
 
#No.FUN-690010-----End-------       
     create unique index r240_tmp2 on r240_tmp2(ima12,sta07)   
 
    #-->依主製程小計
#No.FUN-690010-----Begin-------
#     CREATE TEMP TABLE r240_tmp3
#      (
#       sta07     VARCHAR(06),          
#       ste13     decimal(20,6),     
#       stv05     decimal(10,2)      
#       );
     CREATE TEMP TABLE r240_tmp3(
       sta07     LIKE sta_file.sta07,          
       ste13     LIKE type_file.num20_6,    
       stv05     LIKE stv_file.stv05);    
      
#No.FUN-690010----End----------
     create unique index r240_tmp3 on r240_tmp3(sta07) 
 
    #-->依部門小計  
#No.FUN-690010---Begin------
#     CREATE TEMP TABLE r240_tmp4
#      (
#       dept      VARCHAR(10),          
#       ste13     decimal(20,6),     
#       stv05     decimal(10,2)      
#       );
     CREATE TEMP TABLE r240_tmp4(
       dept      LIKE sfb_file.sfb82,          
       ste13     LIKE type_file.num20_6,    
       stv05     LIKE stv_file.stv05);
       
#No.FUN-690010-------End-------------
     create unique index r240_tmp4 on r240_tmp4(dept) 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      # If background job sw is off
      CALL asdr240_tm()        # Input print condition
   ELSE 
      CALL asdr240()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-850087
END MAIN
 
FUNCTION asdr240_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW asdr240_w AT p_row,p_col WITH FORM "asd/42f/asdr240" 
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
   LET tm.more  = 'N'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ste04,ima131,ima12,sta07 
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
 
     INPUT BY NAME tm.yea,tm.mo,tm.more WITHOUT DEFAULTS 
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
         WHERE zz01='asdr240'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr240','9031',1)   
           
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
    
           CALL cl_cmdat('asdr240',g_time,l_cmd)    # Execute cmd at later time
        END IF
        EXIT WHILE  
     END IF
 
     CALL cl_wait()
     CALL asdr240()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr240_w
 
END FUNCTION
 
FUNCTION asdr240()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_stv05   like stv_file.stv05 ,
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_i       LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima12   LIKE ima_file.ima12,
          l_ima131  LIKE ima_file.ima131,
          l_ima02   LIKE ima_file.ima02,
          l_gem02   LIKE gem_file.gem02,
          l_ima021  LIKE ima_file.ima021,
          l_sta07   LIKE sta_file.sta07,
          l_sfb82   LIKE sfb_file.sfb82,
          sr RECORD LIKE ste_file.*
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
 
#No.FUN-850087 --Begin
     CALL cl_del_data(l_table)
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN                                                                                                                 
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
         EXIT PROGRAM                                                                    
     END IF 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asdr240'
#No.FUN-850087 --End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DELETE FROM r240_tmp
     DELETE FROM r240_tmp2
     DELETE FROM r240_tmp3
     DELETE FROM r240_tmp4
     LET l_sql = "SELECT ste_file.* ",
                 " FROM ste_file,ima_file,sta_file",
                 " WHERE ste02=",tm.yea," AND ste03=",tm.mo,
                 "   AND ste13 <> 0 ",
                 "   AND ste05=ima01 AND ste05=sta01 ",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE asdr240_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr240_curs1 CURSOR FOR asdr240_prepare1
 
#No.FUN-850087 --Begin
#     CALL cl_outnam('asdr240') RETURNING l_name
 
#    START REPORT asdr240_rep TO l_name
#    LET g_pageno = 0
#No.FUN-850087 --End
     FOREACH asdr240_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #-->取成本分群與產品分類
       LET l_ima131=' '  LET l_ima12=' '
       SELECT ima12,ima131 INTO l_ima12,l_ima131 
         FROM ima_file WHERE ima01=sr.ste05
         IF SQLCA.sqlcode  THEN LET l_ima131=' ' LET l_ima12=' ' END IF
         IF l_ima131 IS NULL THEN LET l_ima131=' ' END IF
         IF l_ima12  IS NULL THEN LET l_ima12=' '  END IF
 
       #-->取主製程
       LET l_sta07=' '
       SELECT sta07 INTO l_sta07 FROM sta_file WHERE sta01=sr.ste05
          IF SQLCA.sqlcode THEN LET l_sta07=' ' END IF
          IF l_sta07 IS NULL THEN LET l_sta07=' ' END IF
 
       #-->總投入人工工時
       SELECT stv05 INTO l_stv05 FROM stv_file 
        WHERE stv01=tm.yea AND stv02=tm.mo AND stv03=sr.ste04
       IF STATUS <> 0 THEN LET l_stv05=0 END IF
    
       #-->依成本分群小計
#No.FUN-850087 --Begin
#      INSERT INTO r240_tmp VALUES(l_ima12,sr.ste13,l_stv05)
#      IF SQLCA.sqlcode THEN 
#         UPDATE r240_tmp SET ste13=ste13+sr.ste13, stv05=stv05+l_stv05
#                       WHERE ima12 = l_ima12
#      END IF
 
       #-->依成本分群+主製程小計
#      INSERT INTO r240_tmp2 VALUES(l_ima12,l_sta07,sr.ste13,l_stv05)
#      IF SQLCA.sqlcode THEN 
#         UPDATE r240_tmp2 SET ste13=ste13+sr.ste13, stv05=stv05+l_stv05
#                       WHERE ima12 = l_ima12 AND sta07 = l_sta07
#     END IF
 
       #-->依據主製程小計
#      INSERT INTO r240_tmp3 VALUES(l_sta07,sr.ste13,l_stv05)
#      IF SQLCA.sqlcode THEN  
#         UPDATE r240_tmp3 SET ste13=ste13+sr.ste13, stv05=stv05+l_stv05
#                       WHERE sta07 = l_sta07
#      END IF
#No.FUN-850054 --End
       #-->依據部門小計
       SELECT sfb82 INTO l_sfb82 FROM sfb_file WHERE sfb01 = sr.ste04
       IF SQLCA.sqlcode THEN LET l_sfb82 = ' ' END IF
       IF l_sfb82 IS NULL THEN LET l_sfb82 = ' ' END IF 
       SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059                                                                        
         FROM ima_file WHERE ima01=sr.ste05                                                                                           
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_sfb82
#No.FUN-850018 --Begin
#      INSERT INTO r240_tmp4 VALUES(l_sfb82,sr.ste13,l_stv05)
#      IF SQLCA.sqlcode THEN  
#         UPDATE r240_tmp4 SET ste13=ste13+sr.ste13, stv05=stv05+l_stv05
#                       WHERE dept=l_sfb82  
#      END IF
#      OUTPUT TO REPORT asdr240_rep(l_ima12,l_ima131,l_sta07,
#                                   sr.*,l_stv05,l_sfb82)
       EXECUTE insert_prep USING l_ima12,l_sta07,sr.ste05,l_ima02,l_ima021,
                                 sr.ste04,l_sfb82,l_gem02,sr.ste13,l_stv05,
                                 l_ima131 
#No.FUN-850087 --End
     END FOREACH
#No.FUN-850087 --Begin
#    FINISH REPORT asdr240_rep
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
                 " SELECT ima12,sta07,sfb82,ste13,stv05,ima131,ste05,ste04 FROM ",
                 g_cr_db_str CLIPPED,l_table CLIPPED,'|',
                 " SELECT ima12,sta07,sfb82,ste13,stv05,ima131,ste05,ste04 FROM ",
                 g_cr_db_str CLIPPED,l_table CLIPPED,'|',
                 " SELECT ima12,sta07,sfb82,ste13,stv05,ima131,ste05,ste04 FROM ",                                                  
                 g_cr_db_str CLIPPED,l_table CLIPPED,'|',
                 " SELECT ima12,sta07,sfb82,ste13,stv05,ima131,ste05,ste04 FROM ",                                                  
                 g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ste04,ima131,ima12,sta07')
                 RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_str=tm.wc,';',tm.yea,';',tm.mo
     CALL cl_prt_cs3('asdr240','asdr240',g_sql,g_str)
#No.FUN-850087 --End
END FUNCTION
 
#No.FUN-850087 --Begin
#REPORT asdr240_rep(l_ima12,l_ima131,l_sta07,sr,l_stv05,l_sfb82)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_cnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#         l_stv05   LIKE stv_file.stv05,
#         l_gem02   LIKE gem_file.gem02,
#         l_ima02   LIKE ima_file.ima02,
#         l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#         l_ima12   LIKE ima_file.ima12,
#         l_ima131  LIKE ima_file.ima131,
#         l_sta07   LIKE sta_file.sta07,
#         l_ste13   LIKE ste_file.ste13,
#         l_sfb13   LIKE sfb_file.sfb13,
#         l_sfb82   LIKE sfb_file.sfb82,
#         l_dept    LIKE gem_file.gem01, 
#         sr RECORD LIKE ste_file.*
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY l_ima12,l_ima131,l_sta07,sr.ste05,sr.ste04
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
#           g_x[39] CLIPPED
#          ,g_x[40] CLIPPED   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF l_sta07     #主製程
#     PRINT COLUMN g_c[31],l_ima12,
#           COLUMN g_c[32],l_sta07;
 
#  ON EVERY ROW
#   #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#    SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#      FROM ima_file WHERE ima01=sr.ste05
#    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_sfb82
#    PRINT COLUMN g_c[33],sr.ste05,                         #料號
#          COLUMN g_c[34],l_ima02,                          #品名
#         #start FUN-5A0059
#          COLUMN g_c[35],l_ima021,                         #規格
#          COLUMN g_c[36],sr.ste04,                         #工單編號
#          COLUMN g_c[37],l_sfb82[1,6],                     #製造部門
#          COLUMN g_c[38],l_gem02,
#          COLUMN g_c[39],cl_numfor(sr.ste13,39,g_azi04),   #本月投入金額
#          COLUMN g_c[40],l_stv05  USING '###,##&.&&'       #本月投入工時
#         #end FUN-5A0059
 
#  AFTER GROUP OF l_sta07     #主製程
#     LET l_ste13 =GROUP SUM(sr.ste13)
#     LET l_stv05 =GROUP SUM(l_stv05)
#     PRINT COLUMN g_c[34],g_x[13] CLIPPED,
#           COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),   #本月投入金額   #FUN-5A0059
#           COLUMN g_c[40],l_stv05  USING '###,##&.&&'      #本月投入工時   #FUN-5A0059
#     PRINT ' '
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     #-->列印總計
#     LET l_ste13 =SUM(sr.ste13)
#     LET l_stv05 =SUM(l_stv05)
#     PRINT COLUMN g_c[34],g_x[14] CLIPPED,
#           COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),   #本月投入金額   #FUN-5A0059
#           COLUMN g_c[40],l_stv05  USING '###,##&.&&'      #本月投入工時   #FUN-5A0059
#     PRINT g_dash2[1,g_len]
 
#     #-->依主製程小計
#     LET l_cnt =0
#     DECLARE r240_cur1 CURSOR FOR
#       SELECT * FROM r240_tmp3 ORDER BY sta07
#     FOREACH r240_cur1 INTO l_sta07,l_ste13,l_stv05
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[15] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[37],l_sta07,                        #主製程 
#             COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),  #本月投入金額
#             COLUMN g_c[40],l_stv05  USING '###,##&.&&'     #本月投入工時
#      #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len]
 
#     #-->依成本分群小計
#     LET l_cnt =0
#     DECLARE r221_cur1 CURSOR FOR
#       SELECT * FROM r240_tmp ORDER BY ima12
#     FOREACH r221_cur1 INTO l_ima12,l_ste13,l_stv05
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[16] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[37],l_ima12,                        #成本分群
#             COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),  #本月投入金額
#             COLUMN g_c[40],l_stv05  USING '###,##&.&&'     #本月投入工時
#      #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len]
 
#     #-->依成本分群+主製程小計
#     LET l_cnt =0
#     DECLARE r221_cur2 CURSOR FOR
#       SELECT * FROM r240_tmp2 ORDER BY ima12
#     FOREACH r221_cur2 INTO l_ima12,l_sta07,l_ste13,l_stv05
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[17] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[37],l_ima12,
#             COLUMN g_c[38],l_sta07,                        #成本分群/主製程
#             COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),  #本月投入金額
#             COLUMN g_c[40],l_stv05  USING '###,##&.&&'     #本月投入工時
#      #end FUN-5A0059
#       LET l_cnt = l_cnt + 1
#     END FOREACH
#     PRINT g_dash2[1,g_len]
 
#     #-->依部門小計
#     LET l_cnt =0
#     DECLARE r221_cur3 CURSOR FOR
#       SELECT * FROM r240_tmp4 ORDER BY dept 
#     FOREACH r221_cur3 INTO l_dept,l_ste13,l_stv05
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[18] CLIPPED END IF
#      #start FUN-5A0059
#       PRINT COLUMN g_c[37],l_dept,                         #部門
#             COLUMN g_c[39],cl_numfor(l_ste13,39,g_azi05),  #本月投入金額
#             COLUMN g_c[40],l_stv05  USING '###,##&.&&'     #本月投入工時
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
#No.FUN-850087 --End
#No.FUN-870144
