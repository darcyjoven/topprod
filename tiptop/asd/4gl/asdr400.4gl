# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr400.4gl
# Descriptions...: 人工差異分析表
# Date & Author..: 99/10/07 By Eric
# Modify.........:
# Modify.........: No.FUN-510037 05/01/21 By pengu 報表轉XML
# Modify.........: No.FUN-570244 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-750031 07/07/10 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
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
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_wo      LIKE cre_file.cre08,         #No.FUN-690010CHAR(10),
          g_bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
          g_edate   LIKE type_file.dat,          #No.FUN-690010DATE,
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table        STRING, #FUN-750031###
         g_str          STRING, #FUN-750031### 
         g_sql          STRING  #FUN-750031### 
 
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
   #str FUN-750031 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ima12.ima_file.ima12,",
               "ima131.ima_file.ima131,",
               "sta03.sta_file.sta03,",
               "sta05.sta_file.sta05,",
               "ste05.ste_file.ste05,",
               "ste04.ste_file.ste04,",
               "qty.oqu_file.oqu12,",
               "ste13.ste_file.ste13,",
               "ste16.ste_file.ste16,",
               "ste23.ste_file.ste23,",
               "qdiff.alb_file.alb06,",
               "pdiff.alb_file.alb06,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"
 
 
   LET l_table = cl_prt_temptable('asdr400',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750031 add
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yea = ARG_VAL(8)
   LET tm.mo = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr400_tm(4,12)        # Input print condition
      ELSE CALL asdr400()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW asdr400_w AT p_row,p_col WITH FORM "asd/42f/asdr400" 
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
     CONSTRUCT BY NAME tm.wc ON ste04,ima131,ima12,sfb05 
 
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
 
     INPUT BY NAME tm.yea,tm.mo,tm.more
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
         WHERE zz01='asdr400'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr400','9031',1)   
           
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
                           " '",tm.mo CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           CALL cl_cmdat('asdr400',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr400_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asdr400()
     ERROR ""
   END WHILE
   CLOSE WINDOW asdr400_w
END FUNCTION
 
FUNCTION asdr400()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_stv     RECORD LIKE stv_file.*,
          l_can     LIKE cre_file.cre08,         #No.FUN-690010CHAR(10),
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima12   LIKE ima_file.ima12,
          sr RECORD 
             ima12  LIKE ima_file.ima12,
             ima131 LIKE ima_file.ima131,
             sta03  LIKE sta_file.sta03,
             sta05  LIKE sta_file.sta05,
             ste05  LIKE ste_file.ste05,
             ste04  LIKE ste_file.ste04,
             qty    LIKE oqu_file.oqu12,         #No.FUN-690010DEC(12,2),
             ste13  LIKE ste_file.ste13,
             ste16  LIKE ste_file.ste16,
             ste23  LIKE ste_file.ste23,
             qdiff  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
             pdiff  LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
             END RECORD
DEFINE    l_ima02   like ima_file.ima02,  #FUN-750031 TSD.liquor add
          l_ima021  like ima_file.ima021  #FUN-750031 TSD.liquor add  
      
     #str FUN-750031 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750031 add
     #------------------------------ CR (2) ------------------------------#
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     LET g_bdate=MDY(tm.mo,1,tm.yea)
     IF tm.mo=12 THEN
        LET g_edate=MDY(12,31,tm.yea)
     ELSE
        LET g_edate=MDY(tm.mo+1,1,tm.yea)-1
     END IF
     DELETE FROM r400tmp
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima12,ima131,sta03,sta05,",
                 " ste05,ste04,sfb08,ste13,ste16,ste23,0,0",
                 " FROM ste_file,sfb_file,ima_file,sta_file",
                 " WHERE ste02=",tm.yea,
                 "   AND ste03=",tm.mo,
                 "   AND ste04=sfb01 AND sfb05=sta01 AND sfb05=ima01",
                 "   AND ",tm.wc CLIPPED
     PREPARE asdr400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr400_curs1 CURSOR FOR asdr400_prepare1
     CALL cl_outnam('asdr400') RETURNING l_name
     LET g_pageno = 0
     FOREACH asdr400_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       #-->本月人工投入工時
       SELECT stv05 INTO l_stv.stv05 FROM stv_file
        WHERE stv01=tm.yea AND stv02=tm.mo AND stv03=sr.ste04
           IF SQLCA.sqlcode OR l_stv.stv05 IS NULL 
           THEN LET l_stv.stv05=0 
           END IF
 
       LET sr.pdiff=(sr.sta05*l_stv.stv05)-sr.ste13
       LET sr.qdiff=((sr.sta03*sr.ste16)-l_stv.stv05)*sr.sta05
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
         FROM ima_file WHERE ima01=sr.ste05
       EXECUTE insert_prep USING
           sr.*,l_ima02,l_ima021
       #------------------------------ CR (3) ------------------------------#
       #end FUN-750031 add
     END FOREACH
 
     #str FUN-750031 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ste04,ima131,ima12,sfb05') RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.yea,";",tm.mo 
     CALL cl_prt_cs3('asdr400','asdr400',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
    # CALL cl_used('asdr400' ,g_time ,2) RETURNING g_time               #No.FUN-6A0089   #FUN-B80062
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END FUNCTION
 
 
REPORT asdr400_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-690010  VARCHAR(1) ,
          l_s1      LIKE alb_file.alb06,         #No.FUN-690010decimal(20 ,6)  ,
          l_s2      LIKE alb_file.alb06,         #No.FUN-690010decimal(20 ,6)  ,
          l_s3      LIKE alb_file.alb06,         #No.FUN-690010decimal(20 ,6)  ,
          l_ima02   like ima_file.ima02,
          l_ima021  like ima_file.ima021,   #FUN-5A0059
          l_ima131  like ima_file.ima131,
          l_ima12   LIKE ima_file.ima12,         # Prog. Version..: '5.30.06-13.03.12(04), #TQC-840066
          l_sfb05   like sfb_file.sfb05  ,
          sr RECORD 
             ima12  LIKE ima_file.ima12,
             ima131 LIKE ima_file.ima131,
             sta03  LIKE sta_file.sta03,
             sta05  LIKE sta_file.sta05,
             ste05  LIKE ste_file.ste05,
             ste04  LIKE ste_file.ste04,
             qty    LIKE oqu_file.oqu12,         #No.FUN-690010DEC(12,2),
             ste13  LIKE ste_file.ste13,
             ste16  LIKE ste_file.ste16,
             ste23  LIKE ste_file.ste23,
             qdiff  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
             pdiff  LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)
             END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima12,sr.ima131,sr.ste04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      LET g_head1=g_x[10] CLIPPED ,tm.yea USING '&&&&' ,'/' ,tm.mo USING '&&' 
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
            g_x[39] clipped
           ,g_x[40] clipped   #FUN-5A0059
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
     #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
      SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
        FROM ima_file WHERE ima01=sr.ste05
      PRINT COLUMN g_c[31],sr.ima12,                #成本分群
            COLUMN g_c[32],sr.ima131,               #產品分類
            COLUMN g_c[33],sr.ste05,                #料件編號
            COLUMN g_c[34],l_ima02,                 #品名
           #start FUN-5A0059
            COLUMN g_c[35],l_ima021,                #規格
            COLUMN g_c[36],sr.ste04,                #工單編號
            COLUMN g_c[37],cl_numfor(sr.qty,37,0),  #套數
            COLUMN g_c[38],cl_numfor(sr.ste23,38,2),#人工差異
            COLUMN g_c[39],cl_numfor(sr.qdiff,39,2),
            COLUMN g_c[40],cl_numfor(sr.pdiff,40,2) #人工價差
           #end FUN-5A0059
 
   ON LAST ROW
      LET l_s1=SUM(sr.ste23)
      LET l_s2=SUM(sr.qdiff)
      LET l_s3=SUM(sr.pdiff)
      PRINT g_dash[1,g_len]
      PRINT COLUMN g_c[33],g_x[14] CLIPPED,
           #start FUN-5A0059
            COLUMN g_c[38],cl_numfor(l_s1,38,2),
            COLUMN g_c[39],cl_numfor(l_s2,39,2),
            COLUMN g_c[40],cl_numfor(l_s3,40,2)
           #end FUN-5A0059
 
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
