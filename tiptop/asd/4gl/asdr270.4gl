# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdr270.4gl
# Descriptions...: 委外工單入庫明細表
# Date & Author..: 99/07/05 By Eric
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/07 By king 改正報表中有關錯誤
# Modify.........: No.FUN-850087 08/05/20 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
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
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-850087 --Begin
DEFINE   g_str           LIKE type_file.chr1000
DEFINE   #g_sql           LIKE type_file.chr1000
         g_sql        STRING       #NO.FUN-910082  
DEFINE   l_table         STRING    #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD #FUN-BB0047 mark
 
#No.FUN-850087 --Begin
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark
   LET g_sql="stg04.stg_file.stg04,",
             "ima12.ima_file.ima12,",
             "sta07.sta_file.sta07,",
             "stg06.stg_file.stg06,",
             "stg20.stg_file.stg20,",
             "stg05.stg_file.stg05,",
             "sfb05.sfb_file.sfb05,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "stg07.stg_file.stg07,",
             "stg21.stg_file.stg21,",
             "stg22.stg_file.stg22,",
             "stg23.stg_file.stg23,",
             "stg24.stg_file.stg24,",
             "stg25.stg_file.stg25,",
             "stg01.stg_file.stg01,",
             "ima131.ima_file.ima131,",
             "azi07.azi_file.azi07 "  #No.FUN-870151
   LET l_table=cl_prt_temptable('asdr270',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850087 --End
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
 
#No.FUN-850087 --Begin
#  #-->產品分類小計
##No.FUN-690010------Begin-----
##   CREATE TEMP TABLE r270_tmp
##    (
##     ima131   VARCHAR(10),
##     stg25   DEC(20,5)
##    );
#   CREATE TEMP TABLE r270_tmp(
#     ima131   LIKE ima_file.ima131,
#     stg25    LIKE type_file.num20_6);
 
##No.FUN-690010-----End-----
#    create unique index r270_tmp on r270_tmp(ima131)   
 
#  #-->成本分群+產品分類小計
##No.FUN-690010------Begin------
##   CREATE TEMP TABLE r270_tmp2
##    ( 
##     ima12  VARCHAR(04),
##     ima131 VARCHAR(10),
##     qty    DEC(13,2),
##     amt    DEC(20,5)
##    );
#   CREATE TEMP TABLE r270_tmp2(
#     ima12  LIKE ima_file.ima12,
#     ima131 LIKE ima_file.ima131,
#     qty    LIKE stg_file.stg07, 
#     amt    LIKE type_file.num20_6);
#   
##No.FUN-690010----End------- 
#    create unique index r270_tmp2 on r270_tmp2(ima12,ima131)   
#No.FUN-850087 --End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr270_tm(4,12)        # Input print condition
      ELSE CALL asdr270()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr270_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW asdr270_w AT p_row,p_col WITH FORM "asd/42f/asdr270" 
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
         WHERE zz01='asdr270'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr270','9031',1)   
           
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
                           " '",tm.mo  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
     
           CALL cl_cmdat('asdr270',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE    
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr270()
 
     ERROR ""
   END WHILE
 
   CLOSE WINDOW asdr270_w
 
END FUNCTION
 
FUNCTION asdr270()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima131  LIKE ima_file.ima131,
          l_ima12   LIKE ima_file.ima12,
          l_stg13   LIKE stg_file.stg13,
          l_stg14   LIKE stg_file.stg14,
          l_stg15   LIKE stg_file.stg15,
#No.FUN-850087 --Begin
          l_sta07   LIKE sta_file.sta07,
          l_sfb05   LIKE sfb_file.sfb05,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
#No.FUN-850087
          sr RECORD LIKE stg_file.*
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
#No.FUN-850087 --Begin
     LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"          #FUN-870151 Add "?"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN 
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01="asdr270"
#No.FUN-850087 --End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-850087 --Begin
#    DELETE FROM r270_tmp
#    DELETE FROM r270_tmp2
#No.FUN-850087 --End
     LET l_sql = "SELECT stg_file.* FROM ",
                 " stg_file,sfb_file,ima_file,sta_file",
                 " WHERE stg02=",tm.yea,
                 "   AND stg03=",tm.mo,
                 "   AND stg01='7'",
                 "   AND stg04=sfb01 AND sfb05=sta01 AND sfb05=ima01",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr270_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr270_curs1 CURSOR FOR asdr270_prepare1
#No.FUN-850087 --Begin
#     CALL cl_outnam('asdr270') RETURNING l_name
 
#    START REPORT asdr270_rep TO l_name
#    LET g_pageno = 0
#No.FUN-850087 --End
     FOREACH asdr270_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima131,ima12 INTO l_ima131,l_ima12 FROM ima_file ,sfb_file
        WHERE ima01 = sfb05 AND sfb01 = sr.stg04
        IF SQLCA.sqlcode THEN LET l_ima131=' ' LET l_ima12 = ' ' END IF
        IF l_ima12 IS NULL THEN LET l_ima12 = ' ' END IF
        IF l_ima131 IS NULL THEN LET l_ima131 = ' ' END IF
 
#No.FUN-850087 --Begin
        SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059                                                                        
         FROM ima_file WHERE ima01 = l_sfb05                                                                                          
        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file WHERE azi01=sr.stg21                                       
        IF SQLCA.sqlcode THEN                                                                                                          
           LET l_ima02 = ' '                                                                                                           
           LET l_ima021= ' '                                                                                      
        END IF               
        SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.stg04                                                                      
        IF SQLCA.sqlcode THEN LET l_sfb05 = ' ' END IF 
        SELECT sta07 INTO l_sta07 FROM sta_file,sfb_file                                                                               
        WHERE sr.stg04=sfb01 AND sfb05=sta01                                                                                          
        IF SQLCA.sqlcode OR l_sta07 IS NULL THEN LET l_sta07=' ' END IF
#       #-->依產品分類小計
#        INSERT INTO r270_tmp VALUES(l_ima131,sr.stg25)
#         IF SQLCA.sqlcode THEN 
#            UPDATE r270_tmp SET stg25=stg25+sr.stg25
#                          WHERE ima131=l_ima131
#         END IF
#       #-->依成本分群+產品分類小計
#        INSERT INTO r270_tmp2 VALUES(l_ima12,l_ima131,sr.stg07,sr.stg25)
#         IF SQLCA.sqlcode THEN 
#            UPDATE r270_tmp2 SET qty=qty+sr.stg07,amt=amt+sr.stg25 
#                            WHERE ima12=l_ima12 AND ima131=l_ima131
#         END IF
#      OUTPUT TO REPORT asdr270_rep(sr.*,l_ima12)
       EXECUTE insert_prep USING sr.stg04,l_ima12,l_sta07,sr.stg06,sr.stg20,
                                 sr.stg05,l_sfb05,l_ima02,l_ima021,sr.stg07,
                                 sr.stg21,sr.stg22,sr.stg23,sr.stg24,sr.stg25,
                                 sr.stg01,l_ima131,t_azi07                           #No.FUN-870151 Add azi07
#No.FUN-850087 --End
 
     END FOREACH
#No.FUN-850087 --Begin 
#     FINISH REPORT asdr270_rep  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql=" SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               " SELECT ima131,ima12,stg01,stg04,stg06,stg05,stg07,stg25 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               " SELECT ima131,ima12,stg01,stg04,stg06,stg05,stg07,stg25 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'stg01,stg04,stg06,stg05')
                 RETURNING tm.wc
     ELSE 
         LET tm.wc=""
     END IF
     LET g_str=tm.wc,';',tm.yea,';',tm.mo
     CALL cl_prt_cs3('asdr270','asdr270',g_sql,g_str)
#No.FUN-850087 --End
END FUNCTION
#No.FUN-850087 --Begin
#REPORT asdr270_rep(sr,l_ima12)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_cnt     LIKE type_file.num5,     #No.FUN-690010 SMALLINT
#         l_ima02   LIKE ima_file.ima02,
#         l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#         l_ima12   LIKE ima_file.ima12,
#         l_ima131  LIKE ima_file.ima131,
#         l_qty     LIKE stg_file.stg07,
#         l_amt     LIKE stg_file.stg25,
#         l_stg07   LIKE stg_file.stg07,
#         l_stg25   LIKE stg_file.stg25,
#         l_sta07   LIKE sta_file.sta07,
#         l_sfb05   like sfb_file.sfb05 ,
#         sr RECORD LIKE stg_file.*
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.stg01,sr.stg04,sr.stg06,sr.stg05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.TQC-6A0087 add CLIPPED
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#           g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#           g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped,
#           g_x[43] clipped,g_x[44] clipped
#          ,g_x[45] clipped   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.stg01 #工單類別
#     SKIP TO TOP OF PAGE
 
#  BEFORE GROUP OF sr.stg04 #工單編號
#    #-->取主製程
#    SELECT sta07 INTO l_sta07 FROM sta_file,sfb_file
#     WHERE sr.stg04=sfb01 AND sfb05=sta01
#     IF SQLCA.sqlcode OR l_sta07 IS NULL THEN LET l_sta07=' ' END IF
#   
#    PRINT COLUMN g_c[31],sr.stg04,
#          COLUMN g_c[32],l_ima12,
#          COLUMN g_c[33],l_sta07;
 
#  ON EVERY ROW
#    #-->取料件編號
#    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.stg04
#    IF SQLCA.sqlcode THEN LET l_sfb05 = ' ' END IF
#    #-->取品名,規格
#   #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#    SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
#      FROM ima_file WHERE ima01 = l_sfb05
#    SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file WHERE azi01=sr.stg21
#    IF SQLCA.sqlcode THEN 
#       LET l_ima02 = ' ' 
#       LET l_ima021= ' '   #FUN-5A0059 
#    END IF
 
#    PRINT COLUMN g_c[34],sr.stg06,                          #入庫日期
#          COLUMN g_c[35],sr.stg20,                          #倉庫編號
#          COLUMN g_c[36],sr.stg05,                          #入庫單號
#          COLUMN g_c[37],l_sfb05,                           #料件編號
#          COLUMN g_c[38],l_ima02 CLIPPED,                   #品名  #MOD-4A0238
#         #start FUN-5A0059
#          COLUMN g_c[39],l_ima021 CLIPPED,                  #規格
#          COLUMN g_c[40],cl_numfor(sr.stg07,40,2),          #數量
#          COLUMN g_c[41],sr.stg21,
#          COLUMN g_c[42],cl_numfor(sr.stg22,42,t_azi07),    #幣別/匯率
#          COLUMN g_c[43],cl_numfor(sr.stg23,43,t_azi04),    #原幣單價
#          COLUMN g_c[44],cl_numfor(sr.stg24,44,g_azi04),    #本幣單價 
#          COLUMN g_c[45],cl_numfor(sr.stg25,45,t_azi04)     #委外金額
#         #end FUN-5A0059
 
#  AFTER GROUP OF sr.stg04  #工單編號
#     LET l_stg07 = GROUP SUM(sr.stg07)
#     LET l_stg25 = GROUP SUM(sr.stg25)
#     PRINT COLUMN g_c[34],g_x[15] CLIPPED,
#           COLUMN g_c[40],cl_numfor(l_stg07,40,2),        #FUN-5A0059
#           COLUMN g_c[45],cl_numfor(l_stg25,45,t_azi05)   #FUN-5A0059 
#     PRINT ' '
 
#  ON LAST ROW
#     LET l_stg07 = SUM(sr.stg07)
#     LET l_stg25 = SUM(sr.stg25)
#     PRINT g_dash[1,g_len]
#     #-->列印總計
#     PRINT COLUMN g_c[34],g_x[16] CLIPPED,
#           COLUMN g_c[40],cl_numfor(l_stg07,40,2),        #FUN-5A0059
#           COLUMN g_c[45],cl_numfor(l_stg25,45,t_azi05)   #FUN-5A0059 
#     PRINT g_dash2[1,g_len]
 
#     #-->列印產品分類
#     LET l_cnt = 0
#     DECLARE r270_cur1 CURSOR FOR
#       SELECT * FROM r270_tmp ORDER BY ima131
#     FOREACH r270_cur1 INTO l_ima131,l_stg25
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[17] CLIPPED END IF
#       PRINT COLUMN g_c[37],l_ima131 clipped,
#             COLUMN g_c[45],cl_numfor(l_stg25,45,t_azi05) CLIPPED   #FUN-5A0059
#     END FOREACH
#     PRINT g_dash2[1,g_len]
 
#     #-->列印成本分群+產品分類
#     DECLARE r270_cur CURSOR FOR 
#       SELECT * FROM r270_tmp2 ORDER BY ima12,ima131
#     FOREACH r270_cur INTO l_ima12,l_ima131,l_qty,l_amt
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT COLUMN g_c[34],g_x[17] CLIPPED END IF
#       PRINT COLUMN g_c[37],l_ima12,
#             COLUMN g_c[38],l_ima131 CLIPPED,
#             COLUMN g_c[40],cl_numfor(l_qty,40,2),        #FUN-5A0059
#             COLUMN g_c[45],cl_numfor(l_amt,45,t_azi05)   #FUN-5A0059
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
