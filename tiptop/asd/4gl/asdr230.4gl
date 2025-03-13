# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asdr230.4gl
# Descriptions...: 期末在製品明細表-2
# Date & Author..: 99/04/09 By Eric
# Modify.........: No.FUN-510037 05/02/17 By pengu 報表轉XML
# Modify.........: No.MOD-590002 05/09/05 By Tracy 報表格式修改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-810010 08/01/20 By baofei 報表輸出改為Crystal Report
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              jump    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          tr  RECORD
              ste05     LIKE cre_file.cre08,         #No.FUN-690010char(10),          
              ste16     LIKE oqu_file.oqu12,         #No.FUN-690010decimal(12,2),     
              ste17     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste18     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste19     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste20     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste22     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste23     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste24     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),   
              ste25     LIKE alb_file.alb06          #No.FUN-690010decimal(20,6)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
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
               " l_sfb08.sfb_file.sfb08,", 
               " l_stb07.stb_file.stb07,",
               " l_stb08.stb_file.stb08,",
               " l_stb09.stb_file.stb09,",
               " l_stb09a.stb_file.stb09a,",
               " ste04.ste_file.ste04,",
               " ste05.ste_file.ste05,",
               " ste16.ste_file.ste16,",
               " ste17.ste_file.ste17,",
               " ste18.ste_file.ste18,",
               " ste19.ste_file.ste19,",
               " ste20.ste_file.ste20,",
               " ste22.ste_file.ste22,",
               " ste23.ste_file.ste23,",
               " ste24.ste_file.ste24,",
               " ste25.ste_file.ste25,",
               " ste31.ste_file.ste31"
   LET l_table = cl_prt_temptable('asdr230',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF   
#No.FUN-810010--End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.yea = ARG_VAL(8)
   LET tm.mo  = ARG_VAL(9)
   LET tm.jump =ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL asdr230_tm()        # Input print condition
   ELSE 
      CALL asdr230()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD 
END MAIN
 
FUNCTION asdr230_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW asdr230_w AT p_row,p_col WITH FORM "asd/42f/asdr230" 
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
           IF tm.yea IS NULL OR tm.yea=0 THEN
              NEXT FIELD yea
           END IF
        AFTER FIELD mo
           IF tm.mo IS NULL OR tm.mo=0 THEN
              NEXT FIELD mo
           END IF
        AFTER FIELD jump
           IF tm.jump NOT MATCHES '[YN]' THEN
              LET tm.jump='Y'
              NEXT FIELD jump
           END IF
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
    
##################################################################################
#   START genero shell script ADD
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
#   END genero shell script ADD
##################################################################################
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
        LET INT_FLAG = 0 CLOSE WINDOW asdr230_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='asdr230'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asdr230','9031',1)   
          
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
                           " '",tm.yea CLIPPED,"'",
                           " '",tm.mo  CLIPPED,"'",
                           " '",tm.jump  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
    
           CALL cl_cmdat('asdr230',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr230_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     #-->依產品分類小計
#No.FUN-690010-----Begin------
#     CREATE TEMP TABLE r230_tmp
#      (
#       ima131    VARCHAR(10),          
#       ste16     decimal(12,2),     
#       ste17     decimal(20,6),    
#       ste18     decimal(20,6),    
#       ste19     decimal(20,6),    
#       ste20     decimal(20,6),    
#       ste22     decimal(20,6),   
#       ste23     decimal(20,6),     
#       ste24     decimal(20,6),     
#       ste25     decimal(20,6)   
#      );
#No.FUN-810010---Begin
#     CREATE TEMP TABLE r230_tmp(
#       ima131    LIKE ima_file.ima131,
#       ste16     LIKE ste_file.ste16,
#       ste17     LIKE type_file.num20_6,
#       ste18     LIKE type_file.num20_6,
#       ste19     LIKE type_file.num20_6,
#       ste20     LIKE type_file.num20_6,
#       ste22     LIKE type_file.num20_6,
#       ste23     LIKE type_file.num20_6,
#       ste24     LIKE type_file.num20_6,
#       ste25     LIKE type_file.num20_6);   
     
#No.FUN-690010------End------
#       create unique index r230_tmp  on r230_tmp(ima131) 
#No.FUN-810010---End    
    
     #-->依成本分群小計
#No.FUN-690010------Begin------
#     CREATE TEMP TABLE r230_tmp2
#      (
#       ima12     VARCHAR(10),          
#       ste16     decimal(12,2),     
#       ste17     decimal(20,6),    
#       ste18     decimal(20,6),    
#       ste19     decimal(20,6),    
#       ste20     decimal(20,6),    
#       ste22     decimal(20,6),   
#       ste23     decimal(20,6),     
#       ste24     decimal(20,6),     
#       ste25     decimal(20,6)   
#      );
#No.FUN-810010---Begin
#     CREATE TEMP TABLE r230_tmp2(
#       ima12     LIKE ima_file.ima12,
#       ste16     LIKE ste_file.ste16,
#       ste17     LIKE type_file.num20_6,
#       ste18     LIKE type_file.num20_6,
#       ste19     LIKE type_file.num20_6,
#       ste20     LIKE type_file.num20_6,
#       ste22     LIKE type_file.num20_6,
#       ste23     LIKE type_file.num20_6,
#       ste24     LIKE type_file.num20_6,
#       ste25     LIKE type_file.num20_6);
#      
##No.FUN-690010------End------
#       create unique index r230_tmp2  on r230_tmp2(ima12) 
 
#No.FUN-810010---End
     CALL asdr230()
     ERROR ""
END WHILE
   CLOSE WINDOW asdr230_w
END FUNCTION
 
FUNCTION asdr230()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima12   LIKE ima_file.ima12,
          l_ima131  LIKE ima_file.ima131,
          l_ima02   LIKE ima_file.ima02,      #No.FUN-810010                                                                                         
          l_ima021  LIKE ima_file.ima021,     #No.FUN-810010
          l_sfb08   LIKE sfb_file.sfb08,      #No.FUN-810010
          l_cost    LIKE stb_file.stb06,      #No.FUN-810010
          l_k       LIKE type_file.chr1000,   #No.FUN-810010  
          l_stb RECORD LIKE stb_file.* ,      #No.FUN-810010
          sr RECORD LIKE ste_file.*
  
       CALL cl_del_data(l_table)               #No.FUN-810010
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-810010
     LET l_sql = "SELECT ste_file.* FROM ste_file,ima_file ",
                 " WHERE ste02=",tm.yea," AND ste03=",tm.mo,
                 "   AND ste05=ima01 ",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr230_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr230_curs1 CURSOR FOR asdr230_prepare1
#FUN-810010---------START-----MARK--
#      CALL cl_outnam('asdr230') RETURNING l_name
#     DELETE FROM r230_tmp
#     DELETE FROM r230_tmp2
#     START REPORT asdr230_rep TO l_name
#     LET g_pageno = 0
#NO.FUN-810010---END-------
     FOREACH asdr230_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
          
          EXIT FOREACH
       END IF
       LET l_ima131=' '
       LET l_ima12=' '
       SELECT ima12,ima131 INTO l_ima12,l_ima131 
         FROM ima_file WHERE ima01=sr.ste05
       IF STATUS <> 0 THEN LET l_ima131=' ' LET l_ima12=' ' END IF
       IF l_ima131 IS NULL THEN LET l_ima131=' ' END IF
       IF l_ima12 IS NULL THEN LET l_ima12=' ' END IF
 
#No.FUN-810010---Begin
       #-->依產品分類小計
#       INSERT INTO r230_tmp VALUES(l_ima131,sr.ste16,sr.ste17,sr.ste18,
#                                  sr.ste19,sr.ste20,sr.ste22,sr.ste23,
#                                  sr.ste24,sr.ste25)
#       IF SQLCA.sqlcode THEN 
#          UPDATE r230_tmp SET ste16=ste16+sr.ste16, ste17=ste17+sr.ste17,
#                             ste18=ste18+sr.ste18, ste19=ste19+sr.ste19,
#                             ste20=ste20+sr.ste20, ste22=ste22+sr.ste22,
#                             ste23=ste23+sr.ste23, ste24=ste24+sr.ste24,
#                             ste25=ste25+sr.ste25
#                       WHERE ima12=l_ima12 
#       END IF
 
       #-->依分群小計
#       INSERT INTO r230_tmp2 VALUES(l_ima12,sr.ste16,sr.ste17,sr.ste18,
#                                  sr.ste19,sr.ste20,sr.ste22,sr.ste23,
#                                  sr.ste24,sr.ste25)
#       IF SQLCA.sqlcode THEN 
#          UPDATE r230_tmp2 SET ste16=ste16+sr.ste16, ste17=ste17+sr.ste17,
#                             ste18=ste18+sr.ste18, ste19=ste19+sr.ste19,
#                             ste20=ste20+sr.ste20, ste22=ste22+sr.ste22,
#                             ste23=ste23+sr.ste23, ste24=ste24+sr.ste24,
#                             ste25=ste25+sr.ste25
#                       WHERE ima12=l_ima12 
#       END IF
 
#       OUTPUT TO REPORT asdr230_rep(l_ima12,l_ima131,sr.*)
     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
       FROM ima_file WHERE ima01=sr.ste05
     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
     IF SQLCA.sqlcode THEN LET l_sfb08 = 0 END IF
 
     SELECT * INTO l_stb.* FROM stb_file
      WHERE stb01=sr.ste05 AND stb02=tm.yea AND stb03=tm.mo
     
     LET l_cost=l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a
     LET l_stb.stb08=l_stb.stb05
     LET l_stb.stb09=l_stb.stb06
     LET l_stb.stb09a=l_stb.stb06a
     LET l_stb.stb07=l_cost-l_stb.stb08-l_stb.stb09-l_stb.stb09a
        EXECUTE insert_prep USING l_ima02,l_ima021,l_ima12,l_ima131,l_sfb08,
                                  l_stb.stb07,l_stb.stb08,l_stb.stb09,l_stb.stb09a,
                                  sr.ste04,sr.ste05,sr.ste16,sr.ste17,sr.ste18,
                                  sr.ste19,sr.ste20,sr.ste22,sr.ste23,sr.ste24,
                                  sr.ste25,sr.ste31  
#No.FUN-810010---End
     END FOREACH
#     FINISH REPORT asdr230_rep                            #NO.FUN-810010
#No.FUN-810010---Begin
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ste04,ima12,ste31,ima131')                         
              RETURNING tm.wc                                                   
      END IF          
      LET l_k = tm.yea USING '&&&&','/',tm.mo USING '&&'                                                          
      LET g_str=tm.wc ,";",l_k,";",tm.jump,";",g_azi04,";",g_azi05
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('asdr230','asdr230',l_sql,g_str)
#No.FUN-810010---End
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #No.FUN-BB0047--mark--End-----
#      CALL cl_prt(l_name,g_prtway,g_copies,g_len)         #NO.FUN-810010
END FUNCTION
 
#No.FUN-810010---Begin
#REPORT asdr230_rep(l_ima12,l_ima131,sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#          l_cnt        LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#          l_oamt,l_damt LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#          l_line1    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_line2    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_line3    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
#          l_cls      LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#          l_ima02   LIKE ima_file.ima02,
#          l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#          l_ima12   like ima_file.ima12 ,
#          l_ima131  like ima_file.ima131,
#          l_cost    LIKE stb_file.stb06,
#          l_sfb08   LIKE sfb_file.sfb08,
#          l_stb RECORD LIKE stb_file.* ,
#          sr RECORD LIKE ste_file.*
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
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
#      PRINT COLUMN (g_c[37]+(g_w[37]-FGL_WIDTH(g_x[21]))/2),g_x[21] CLIPPED,
#            COLUMN (g_c[42]+(g_w[42]+g_w[43]-FGL_WIDTH(g_x[2]))/2),g_x[22] CLIPPED,
#            COLUMN (g_c[49]+(g_w[49]-FGL_WIDTH(g_x[2]))/2),g_x[23] CLIPPED
##     LET l_line1=g_w[34]+g_w[35]+g_w[36]+g_w[37]+g_w[38]
##     LET l_line2=g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+g_w[44]
##     LET l_line3=g_w[45]+g_w[46]+g_w[47]+g_w[48]+g_w[49]
##No.MOD-590002 --start--                                                                                                            
#      LET l_line1=g_w[35]+g_w[36]+g_w[37]+g_w[38]+g_w[39]+4                                                                         
#      LET l_line2=g_w[40]+g_w[41]+g_w[42]+g_w[43]+g_w[44]+g_w[45]+5                                                                 
#      LET l_line3=g_w[46]+g_w[47]+g_w[48]+g_w[49]+g_w[50]+4                                                                         
##No.FUN-580002 --end--             
#      PRINT COLUMN g_c[35],g_dash2[1,l_line1],
#            COLUMN g_c[40],g_dash2[1,l_line2],
#            COLUMN g_c[46],g_dash2[1,l_line3]
#
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
#            g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED,g_x[50] CLIPPED
#           ,g_x[51] CLIPPED   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF l_ima12
#     IF tm.jump='Y' THEN SKIP TO TOP OF PAGE END IF
#
#
#   ON EVERY ROW
#    #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
#       FROM ima_file WHERE ima01=sr.ste05
#     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
#     IF SQLCA.sqlcode THEN LET l_sfb08 = 0 END IF
#
#     SELECT * INTO l_stb.* FROM stb_file
#      WHERE stb01=sr.ste05 AND stb02=tm.yea AND stb03=tm.mo
#     
#     LET l_cost=l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a
#     LET l_stb.stb08=l_stb.stb05
#     LET l_stb.stb09=l_stb.stb06
#     LET l_stb.stb09a=l_stb.stb06a
#     LET l_stb.stb07=l_cost-l_stb.stb08-l_stb.stb09-l_stb.stb09a
#
#     LET l_oamt = sr.ste17+sr.ste18+sr.ste19+sr.ste20
#     LET l_damt = sr.ste22+sr.ste23+sr.ste24+sr.ste25 
#     PRINT COLUMN g_c[31],sr.ste05,                            #料號
#           COLUMN g_c[32],l_ima02,                             #品名
#          #start FUN-5A0059
#           COLUMN g_c[33],l_ima021,                            #規格
#           COLUMN g_c[34],sr.ste04,                            #工單編號
#           COLUMN g_c[35],cl_numfor(l_sfb08,35,0),             #生產套數
#           COLUMN g_c[36],cl_numfor(l_stb.stb07  ,36,g_azi04), #材料
#           COLUMN g_c[37],cl_numfor(l_stb.stb08  ,37,g_azi04), #人工
#           COLUMN g_c[38],cl_numfor(l_stb.stb09  ,38,g_azi04), #製費一
#           COLUMN g_c[39],cl_numfor(l_stb.stb09a ,39,g_azi04), #製費二
#           COLUMN g_c[40],cl_numfor(sr.ste16 ,40,g_azi04),     #本期轉出
#           COLUMN g_c[41],cl_numfor(sr.ste17 ,41,g_azi04),     #本期轉出材料
#           COLUMN g_c[42],cl_numfor(sr.ste18 ,42,g_azi04),     #本期轉出人工
#           COLUMN g_c[43],cl_numfor(sr.ste19 ,43,g_azi04),     #本期轉出製費一
#           COLUMN g_c[44],cl_numfor(sr.ste20 ,44,g_azi04),     #本期轉出製費二
#           COLUMN g_c[45],cl_numfor(l_oamt   ,45,g_azi04),
#           COLUMN g_c[46],cl_numfor(sr.ste22 ,46,g_azi04),     #差異成本材料
#           COLUMN g_c[47],cl_numfor(sr.ste23 ,47,g_azi04),     #差異成本人工
#           COLUMN g_c[48],cl_numfor(sr.ste24 ,48,g_azi04),     #差異成本製費一
#           COLUMN g_c[49],cl_numfor(sr.ste25 ,49,g_azi04),     #差異成本製費二
#           COLUMN g_c[50],cl_numfor(l_damt   ,50,g_azi04),
#           COLUMN g_c[51],sr.ste31                             #結案否
#          #end FUN-5A0059
#
#   AFTER GROUP OF l_ima12   
#      LET tr.ste16=GROUP SUM(sr.ste16)
#      LET tr.ste17=GROUP SUM(sr.ste17)
#      LET tr.ste18=GROUP SUM(sr.ste18)
#      LET tr.ste19=GROUP SUM(sr.ste19)
#      LET tr.ste20=GROUP SUM(sr.ste20)
#      LET tr.ste22=GROUP SUM(sr.ste22)
#      LET tr.ste23=GROUP SUM(sr.ste23)
#      LET tr.ste24=GROUP SUM(sr.ste24)
#      LET tr.ste25=GROUP SUM(sr.ste25)
#      LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#      LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25
#      #-->列印成本分群小計
#      PRINT ' ' 
#      LET l_cls=g_x[17] CLIPPED,'(',l_ima12,')'
#      PRINT COLUMN g_c[32],l_cls,
#           #start FUN-5A0059
#            COLUMN g_c[40],cl_numfor(tr.ste16 ,40,g_azi05),
#            COLUMN g_c[41],cl_numfor(tr.ste17 ,41,g_azi05),
#            COLUMN g_c[42],cl_numfor(tr.ste18 ,42,g_azi05),
#            COLUMN g_c[43],cl_numfor(tr.ste19 ,43,g_azi05),
#            COLUMN g_c[44],cl_numfor(tr.ste20 ,44,g_azi05),
#            COLUMN g_c[45],cl_numfor(l_oamt   ,45,g_azi05),
#            COLUMN g_c[46],cl_numfor(tr.ste22 ,46,g_azi05),
#            COLUMN g_c[47],cl_numfor(tr.ste23 ,47,g_azi05),
#            COLUMN g_c[48],cl_numfor(tr.ste24 ,48,g_azi05),
#            COLUMN g_c[49],cl_numfor(tr.ste25 ,49,g_azi05),
#            COLUMN g_c[50],cl_numfor(l_damt   ,50,g_azi05)
#           #end FUN-5A0059
#
#   ON LAST ROW
#      LET tr.ste16=SUM(sr.ste16)
#      LET tr.ste17=SUM(sr.ste17)
#      LET tr.ste18=SUM(sr.ste18)
#      LET tr.ste19=SUM(sr.ste19)
#      LET tr.ste20=SUM(sr.ste20)
#      LET tr.ste22=SUM(sr.ste22)
#      LET tr.ste23=SUM(sr.ste23)
#      LET tr.ste24=SUM(sr.ste24)
#      LET tr.ste25=SUM(sr.ste25)
#      LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20
#      LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25 
#      #-->列印總計
#      PRINT g_dash2[1,g_len]
#      PRINT COLUMN g_c[32],g_x[19] CLIPPED,
#           #start FUN-5A0059
#            COLUMN g_c[40],cl_numfor(tr.ste16 ,40,g_azi05),
#            COLUMN g_c[41],cl_numfor(tr.ste17 ,41,g_azi05),
#            COLUMN g_c[42],cl_numfor(tr.ste18 ,42,g_azi05),
#            COLUMN g_c[43],cl_numfor(tr.ste19 ,43,g_azi05),
#            COLUMN g_c[44],cl_numfor(tr.ste20 ,44,g_azi05),
#            COLUMN g_c[45],cl_numfor(l_oamt   ,45,g_azi05),
#            COLUMN g_c[46],cl_numfor(tr.ste22 ,46,g_azi05),
#            COLUMN g_c[47],cl_numfor(tr.ste23 ,47,g_azi05),
#            COLUMN g_c[48],cl_numfor(tr.ste24 ,48,g_azi05),
#            COLUMN g_c[49],cl_numfor(tr.ste25 ,49,g_azi05),
#            COLUMN g_c[50],cl_numfor(l_damt   ,50,g_azi05)
#           #end FUN-5A0059
#      PRINT g_dash[1,g_len]
#
#      #-->列印產品分類小計
#      LET l_cnt = 0 
#      DECLARE r230_cur1 CURSOR FOR
#        SELECT * FROM r230_tmp ORDER BY ima131
#      FOREACH r230_cur1 INTO tr.*
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT column 12,g_x[24] clipped END IF
#        LET l_cnt = l_cnt + 1
#        LET l_oamt= tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#        LET l_damt= tr.ste22+tr.ste23+tr.ste24+tr.ste25
#        PRINT COLUMN g_c[32],tr.ste05,
#             #start FUN-5A0059
#              COLUMN g_c[40],cl_numfor(tr.ste16 ,40,g_azi05),
#              COLUMN g_c[41],cl_numfor(tr.ste17 ,41,g_azi05),
#              COLUMN g_c[42],cl_numfor(tr.ste18 ,42,g_azi05),
#              COLUMN g_c[43],cl_numfor(tr.ste19 ,43,g_azi05),
#              COLUMN g_c[44],cl_numfor(tr.ste20 ,44,g_azi05),
#              COLUMN g_c[45],cl_numfor(l_oamt   ,45,g_azi05),
#              COLUMN g_c[46],cl_numfor(tr.ste22 ,46,g_azi05),
#              COLUMN g_c[47],cl_numfor(tr.ste23 ,47,g_azi05),
#              COLUMN g_c[48],cl_numfor(tr.ste24 ,48,g_azi05),
#              COLUMN g_c[49],cl_numfor(tr.ste25 ,49,g_azi05),
#              COLUMN g_c[50],cl_numfor(l_damt   ,50,g_azi05)
#             #end FUN-5A0059
#      END FOREACH
#
#      #-->列印成本分群小計
#      LET l_cnt =0
#      PRINT g_dash2[1,g_len]
#      DECLARE r231_cur1 CURSOR FOR
#        SELECT * FROM r230_tmp2 ORDER BY ima12
#      FOREACH r231_cur1 INTO tr.*
#        IF STATUS <> 0 THEN EXIT FOREACH END IF
#        IF l_cnt = 0 THEN PRINT column 12,g_x[25] clipped END IF
#        LET l_cnt = l_cnt + 1
#        LET l_oamt= tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#        LET l_damt= tr.ste22+tr.ste23+tr.ste24+tr.ste25
#        PRINT COLUMN g_c[32],tr.ste05, 
#             #start FUN-5A0059
#              COLUMN g_c[40],cl_numfor(tr.ste16 ,40,g_azi05),
#              COLUMN g_c[41],cl_numfor(tr.ste17 ,41,g_azi05),
#              COLUMN g_c[42],cl_numfor(tr.ste18 ,42,g_azi05),
#              COLUMN g_c[43],cl_numfor(tr.ste19 ,43,g_azi05),
#              COLUMN g_c[44],cl_numfor(tr.ste20 ,44,g_azi05),
#              COLUMN g_c[45],cl_numfor(l_oamt   ,45,g_azi05),
#              COLUMN g_c[46],cl_numfor(tr.ste22 ,46,g_azi05),
#              COLUMN g_c[47],cl_numfor(tr.ste23 ,47,g_azi05),
#              COLUMN g_c[48],cl_numfor(tr.ste24 ,48,g_azi05),
#              COLUMN g_c[49],cl_numfor(tr.ste25 ,49,g_azi05),
#              COLUMN g_c[50],cl_numfor(l_damt   ,50,g_azi05)
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
#END REPORT
#NO.FUN-810010----END---
