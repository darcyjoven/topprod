# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdr390.4gl
# Descriptions...: 材料用量差異明細表
# Date & Author..: 99/09/28 By Eric
# Modify.........: NO.MOD-4A0041 04/10/05 By Mandy l_rowid無用到,所以刪除
# Modify.........: No.FUN-510037 05/02/17 By pengu 報表轉XML
# Modify.........: NO.FUN-550066 05/05/24 By vivien 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-570244 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號部份改char(16)
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: NO.FUN-850090 08/05/23 By zhaijie老報表修改為CR
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-940008 09/05/07 By hongmei GP5.2發料改善
# Modify.........: No.TQC-960113 09/06/11 By xiaofeizhu 修改g_edate的定義為日期型
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo 於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No:MOD-C50140 12/05/21 By ck2yuan 抓取bom資料應串主件於aimi100的主特性代碼
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              sw      LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1         #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
 
          sort RECORD                # Print condition RECORD
               #wo     LIKE cre_file.cre08,         #No.FUN-690010 VARCHAR(10),     #          #FUN-660152 remark 
               wo      LIKE ste_file.ste04,#     #FUN-660152
               partno  LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
               stdqty  LIKE alb_file.alb06,         #No.FUN-690010DEC(14,2),
               actqty  LIKE alb_file.alb06,         #No.FUN-690010DEC(14,2),
               uprice  LIKE alb_file.alb06,         #No.FUN-690010DEC(14,2),
               amt     LIKE alb_file.alb06          #No.FUN-690010DEC(14,2)
               END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          #g_wo     LIKE cre_file.cre08,         #No.FUN-690010 VARCHAR(10),            #FUN-660152
          g_wo      LIKE ste_file.ste04,  #FUN-660152
          g_bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
#         g_edate   LIKE type_file.num5,         #No.FUN-690010DATE,                 #TQC-960113 Mark
          g_edate   LIKE type_file.dat,          #No.TQC-960113  
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#NO.FUN-850090--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
DEFINE l_table1     STRING
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD
#NO.FUN-850090--start---
    LET  g_sql = "l_ima12.ima_file.ima12,",
                 "l_ima131.ima_file.ima131,",
                 "ste04.ste_file.ste04,",
                 "ste05.ste_file.ste05,",
                 "ste06.ste_file.ste06,",
                 "ste11.ste_file.ste11,",
                 "ste16.ste_file.ste16,",
                 "ste22.ste_file.ste22,",
                 "ste26.ste_file.ste26,",
                 "p_woq.oqu_file.oqu12"
   LET l_table = cl_prt_temptable('asdr390',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM 
   END IF   
 
    LET  g_sql = "l_ima02.ima_file.ima02,",
                 "l_ima021.ima_file.ima021,",
                 "wo.ste_file.ste04,",
                 "partno.type_file.chr20,",
                 "stdqty.alb_file.alb06,",
                 "actqty.alb_file.alb06,",
                 "uprice.alb_file.alb06,",
                 "amt.alb_file.alb06"
   LET l_table1 = cl_prt_temptable('asdr3901',g_sql) CLIPPED
   IF l_table1 = -1 THEN
     EXIT PROGRAM 
   END IF
 #NO.FUN-850090---end---
 
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
   LET tm.sw  = ARG_VAL(10)
   let g_rep_user = arg_val(11)
   let g_rep_clas = arg_val(12)
   let g_template = arg_val(13)
   ##No.FUN-570264 --start--
   #let g_rep_user = arg_val(8)
   #let g_rep_clas = arg_val(9)
   #let g_template = arg_val(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
 
   DROP TABLE r390tmp
#No.FUN-690010------Begin------
#   CREATE TEMP TABLE r390tmp
#    (
#          #wo      VARCHAR(10),    #FUN-660152 remark
#          wo      VARCHAR(16),     #FUN-660152
#          partno  VARCHAR(40),     #FUN-560011
#          stdqty  DEC(14,2),
#          actqty  DEC(14,2),
#          uprice  DEC(14,2),
#          amt     DEC(14,2)
#    );
   CREATE TEMP TABLE r390tmp(
          wo      LIKE ste_file.ste04, 
          partno  LIKE stf_file.stf07,
          stdqty  LIKE imk_file.imk09,
          actqty  LIKE imk_file.imk09,
          uprice  LIKE imk_file.imk09,
          amt     LIKE imk_file.imk09);
 
#No.FUN-690010-------End------    
     create unique index r390tmp  on r390tmp(wo,partno)   
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr390_tm(4,12)        # Input print condition
      ELSE CALL asdr390()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr390_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW asdr390_w AT p_row,p_col WITH FORM "asd/42f/asdr390" 
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
   LET tm.sw = 'N'
   LET tm.more = 'N'
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ste04,ima12,ima08,sfb05,ima131,ima06 
 
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
 
     INPUT BY NAME tm.yea,tm.mo,tm.sw,tm.more
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
         WHERE zz01='asdr390'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr390','9031',1)  
           
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
                           " '",tm.sw CLIPPED,"'",              #TQC-610079  
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr390',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE 
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr390()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr390_w
 
END FUNCTION
 
FUNCTION asdr390()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_stf     RECORD LIKE stf_file.*,
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima131  LIKE ima_file.ima131,
          l_ima12   LIKE ima_file.ima12, 
          p_woq     LIKE feb_file.feb10,       #No.FUN-690010DEC(12,2),
          sr RECORD LIKE ste_file.*
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
      
#NO.FUN-850090---START--
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_ima021  LIKE ima_file.ima021
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
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
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asdr390'
#NO.FUN-850090---END-- 
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     LET g_bdate=MDY(tm.mo,1,tm.yea)
     IF tm.mo=12 THEN
        LET g_edate=MDY(12,31,tm.yea)
     ELSE
        LET g_edate=MDY(tm.mo+1,1,tm.yea)-1
     END IF
     DELETE FROM r390tmp
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #-->取暫存檔下階用料資料
     LET l_sql = " SELECT * FROM r390tmp WHERE wo= ? ",
                 "  ORDER BY partno "
     PREPARE r390_pretmp   FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('pretmp:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
      EXIT PROGRAM  
        
     END IF
     DECLARE r390tmp_cur  CURSOR FOR r390_pretmp 
 
     #-->取工單實際領退料數量
     LET l_sql = " SELECT * FROM stf_file ",
                 " WHERE stf04= ? ", 
                 " AND ((stf02< ",tm.yea,") OR ",
                      " (stf02=",tm.yea,"AND stf03<=",tm.mo,"))"
     PREPARE r390_prestf   FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prestf:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE stf_cur CURSOR FOR r390_prestf 
 
     LET l_sql = "SELECT ste_file.* FROM ste_file,sfb_file,ima_file,sta_file",
                 " WHERE ste02=",tm.yea,
                 "   AND ste03=",tm.mo,
                 "   AND ste04=sfb01 AND sfb05=sta01 AND sfb05=ima01",
                 "   AND ",tm.wc CLIPPED," ORDER BY ste04"
     PREPARE asdr390_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE asdr390_curs1 CURSOR FOR asdr390_prepare1
#     CALL cl_outnam('asdr390') RETURNING l_name           #NO.FUN-850090
#     START REPORT asdr390_rep TO l_name                   #NO.FUN-850090
#     LET g_pageno = 0                                     #NO.FUN-850090
     FOREACH asdr390_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima131,ima12 INTO l_ima131,l_ima12 FROM ima_file ,sfb_file
        WHERE ima01 = sfb05 AND sfb01 = sr.ste04
       IF STATUS <> 0 OR l_ima131 IS NULL THEN
          LET l_ima131=' '
       END IF
       IF STATUS <> 0 OR l_ima12 IS NULL THEN
          LET l_ima12=' '
       END IF
       LET g_wo=sr.ste04
       SELECT sfb08 INTO p_woq FROM sfb_file WHERE sfb01=sr.ste04
       #FUN-550110
       LET l_ima910=''
       SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=sr.ste05
       IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
       #--
       #-->展BOM
       CALL cralc_bom(0,sr.ste05,l_ima910,p_woq,1)  #FUN-550110
 
       #-->取工單實際領退料數量
       FOREACH stf_cur USING sr.ste04 INTO l_stf.*
         IF STATUS <> 0 THEN EXIT FOREACH END IF
         INSERT INTO r390tmp VALUES(sr.ste04,l_stf.stf07,0,l_stf.stf08,0,0)
            IF SQLCA.sqlcode THEN 
               UPDATE r390tmp SET actqty=actqty+l_stf.stf08
                            WHERE wo=sr.ste04 AND partno=l_stf.stf07
            END IF
       END FOREACH
 
       #-->
       DECLARE stb_cur CURSOR FOR
        SELECT * FROM r390tmp WHERE wo=sr.ste04
       FOREACH stb_cur INTO sort.*
         SELECT stb07+stb08+stb09+stb09a INTO sort.uprice FROM stb_file
          WHERE stb01 = sort.partno AND stb02 = tm.yea AND stb03 = tm.mo
         IF STATUS <> 0 THEN LET sort.uprice=0 END IF
         LET sort.amt=(sort.stdqty-sort.actqty)*sort.uprice
         UPDATE r390tmp SET uprice=sort.uprice,amt=sort.amt
          WHERE wo=sort.wo AND partno=sort.partno
       END FOREACH
 
#       OUTPUT TO REPORT asdr390_rep(sr.*,p_woq,l_ima12,l_ima131)  #NO.FUN-850090
#NO.FUN-850090--start---
      FOREACH r390tmp_cur USING sr.ste04 INTO sort.*
        IF tm.sw='N' THEN
           IF sort.stdqty=sort.actqty THEN CONTINUE FOREACH END IF
        END IF
        SELECT ima02,ima021 INTO l_ima02,l_ima021
          FROM ima_file WHERE ima01=sort.partno
        IF SQLCA.sqlcode THEN 
           LET l_ima02 = ' ' 
           LET l_ima021= ' '
        END IF
        EXECUTE insert_prep1 USING
          l_ima02,l_ima021,sort.wo,sort.partno,sort.stdqty,sort.actqty,
          sort.uprice,sort.amt
      END FOREACH
        EXECUTE insert_prep USING
          l_ima12,l_ima131,sr.ste04,sr.ste05,sr.ste06,sr.ste11,sr.ste16,
          sr.ste22,sr.ste26,p_woq
#NO.FUN-850090--end---
     END FOREACH
#NO.FUN-850090--start---
#     FINISH REPORT asdr390_rep                                     #NO.FUN-850090
#     CALL cl_used('asdr390' ,g_time ,2) RETURNING g_time           #No.FUN-6A0089
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ste04,ima12,ima08,sfb05,ima131,ima06')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.yea,";",tm.mo,";",g_azi03,";",
                 g_azi04,";",g_azi05
     CALL cl_prt_cs3('asdr390','asdr390',g_sql,g_str)
#NO.FUN-850090--end---
#     CALL cl_prt(l_name ,g_prtway ,g_copies ,g_len)               #NO.FUN-850090
END FUNCTION
   
FUNCTION cralc_bom(p_level,p_key,p_key2,p_total,p_QPA)  #FUN-550110
DEFINE
    p_level LIKE type_file.num5,         #No.FUN-690010SMALLINT, #level code
    p_total LIKE csb_file.csb05,       #No.FUN-690010DECIMAL(13,5),
    p_QPA LIKE bmb_file.bmb06,  #FUN-560230
    l_QPA LIKE bmb_file.bmb06,  #FUN-560230
    l_total LIKE csb_file.csb05,       #No.FUN-690010       #No.FUN-690010DECIMAL(13,5),    #原發數量
    l_total2 LIKE csb_file.csb05,       #No.FUN-690010       #No.FUN-690010DECIMAL(13,5),    #應發數量
    p_key LIKE bma_file.bma01,  #assembly part number
    p_key2   LIKE ima_file.ima910,   #FUN-550110
    l_ac,l_i,l_x,l_s LIKE type_file.num5,         #No.FUN-690010SMALLINT,
    arrno LIKE type_file.num5,         #No.FUN-690010 #BUFFER SIZE
    b_seq,l_double LIKE type_file.num10,        #No.FUN-690010INTEGER, #restart sequence (line number)
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #SEQ
        bmb03 LIKE bmb_file.bmb03, #component part number
        bmb10 LIKE bmb_file.bmb10, #Issuing UOM
        bmb10_fac LIKE bmb_file.bmb10_fac,#Issuing UOM to stock transfer rate
        bmb10_fac2 LIKE bmb_file.bmb10_fac2,#Issuing UOM to cost transfer rate
        bmb15 LIKE bmb_file.bmb15, #consumable part flag
        bmb16 LIKE bmb_file.bmb16, #substitable flag
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #yield
        bmb09 LIKE bmb_file.bmb09, #operation sequence number
        bmb18 LIKE bmb_file.bmb18, #days offset
        ima08 LIKE ima_file.ima08, #source code
        ima37 LIKE ima_file.ima37, #OPC
        ima25 LIKE ima_file.ima25, #UOM
        ima86 LIKE ima_file.ima86, #COST UNIT
        ima86_fac LIKE ima_file.ima86_fac, #
        bma01 LIKE type_file.chr20        #No.FUN-690010CHAR(20) 
    END RECORD,
    g_sfa RECORD  LIKE sfa_file.*,    #備料檔
    l_ima08 LIKE  ima_file.ima08, #source code
#   l_ima26 LIKE  ima_file.ima26, #QOH    ###GP5.2  #NO.FUN-A20044 dxfwo mark
#   l_ima262 LIKE ima_file.ima262, #QOH   ###GP5.2  #NO.FUN-A20044 dxfwo mark
    l_ima84 LIKE  ima_file.ima84, #QOH
    l_ima94 LIKE  ima_file.ima94, #QOH
    l_SafetyStock LIKE ima_file.ima27,
    l_SSqty LIKE  ima_file.ima27,
    l_ima37 LIKE  ima_file.ima37, #OPC
    l_ima64 LIKE  ima_file.ima64,    #Issue Pansize
    l_ima641 LIKE ima_file.ima641,    #Minimum Issue QTY
    l_uom LIKE ima_file.ima25,        #Stock UOM
    l_chr LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
#   l_sfa07 LIKE sfa_file.sfa07, #quantity owed  #FUN-940008 mark
    l_sfa03 LIKE sfa_file.sfa03, #part No
    l_sfa11 LIKE sfa_file.sfa11, #consumable flag
#   l_qty LIKE ima_file.ima26, #issuing to stock qty
    l_qty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
#   l_bal LIKE ima_file.ima26, #balance (QOH-issue)
    l_bal LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
    l_ActualQPA LIKE bmb_file.bmb06,  #FUN-560230
    l_sfa12 LIKE sfa_file.sfa12,    #發料單位
    l_sfa13 LIKE sfa_file.sfa13,    #發料/庫存單位換算率
    l_unaloc,l_uuc LIKE sfa_file.sfa25, #unallocated quantity
    l_cnt,l_c LIKE type_file.num5,         #No.FUN-690010smallint,
    l_cmd LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=
            "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
            "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,ima08,ima37,ima25, ",
            " ima86,ima86_fac,bma01",
           #" FROM bmb_file,OUTER ima_file,OUTER bma_file",  #MOD-C50140 mark
            " FROM bmb_file,ima_file,bma_file",              #MOD-C50140 add
            " WHERE bmb01='", p_key,"' AND bmb02>?",
           #MOD-C50140 str add-----
           #"   AND bmb_file.bmb03 = bma_file.bma01",
           #"   AND bmb_file.bmb03 = ima_file.ima01",
            "   AND bmb_file.bmb01 = bma_file.bma01",
            "   AND bmb_file.bmb01 = ima_file.ima01",
            "   AND bma06=bmb29 AND bmb29=ima910 ",
           #MOD-C50140 end add-----
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550110
            "   AND (bmb04 <='",g_edate,
            "'   OR bmb04 IS NULL) AND (bmb05 >'",g_edate,
            "'   OR bmb05 IS NULL)",
            " ORDER BY 1"
        PREPARE cralc_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
 
    #put BOM data into buffer
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur USING b_seq INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
            CALL ui.Interface.refresh()
            #若換算率有問題, 則設為1
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
                LET sr[l_ac].bmb10_fac=1
            END IF
            IF sr[l_ac].bmb16 IS NULL THEN    #若未定義, 則給予'正常'
                LET sr[l_ac].bmb16='0'
            END IF
# 97/11/13 修改,備料時不考慮替代料處理, 一律展出BOM中資料, 若有替代料問題
# eric     由使用者自行修改備料資料.
            LET sr[l_ac].bmb16='0'
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
            LET sr[l_i].bmb08=0 
            #Actual QPA
            LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
            LET l_QPA=sr[l_i].bmb06 * p_QPA   
            LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
            LET l_total2=l_total
         #  LET l_sfa07=0   #FUN-940008 mark
            LET l_sfa11='N'
            IF sr[l_i].ima08='R' THEN #routable part
         #      LET l_sfa07=l_total  #FUN-940008 mark
                LET l_sfa11='R'
            ELSE
                IF sr[l_i].bmb15='Y' THEN #comsumable
                    LET l_sfa11='E'
                ELSE 
                    IF sr[l_i].ima08 MATCHES '[UV]' THEN
                        LET l_sfa11=sr[l_i].ima08
                    END IF
                END IF #consumable
            END IF
            IF sr[l_i].ima08!='X' THEN
                INSERT INTO r390tmp VALUES(g_wo,sr[l_i].bmb03,l_total,0,0,0)
                IF SQLCA.sqlcode THEN 
                    UPDATE r390tmp SET stdqty=stdqty+l_total
                                 WHERE partno=sr[l_i].bmb03 AND wo=g_wo
                END IF
            END IF
            IF sr[l_i].ima08='X' THEN
                IF sr[l_i].bma01 IS NOT NULL THEN 
                   #CALL cralc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550110 #FUN-8B0035
                    CALL cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0035
                        p_total*sr[l_i].bmb06,l_ActualQPA)
                END IF
            END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
END FUNCTION
#NO.FUN-850090--start--mark--
#REPORT asdr390_rep(sr,p_woq,l_ima12,l_ima131)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1) ,
#          l_s1      LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6)  ,
#          l_ima02   like ima_file.ima02,
#          l_ima021  like ima_file.ima021,   #FUN-5A0059
#          l_ima12   LIKE ima_file.ima12,
#          l_ima131  like ima_file.ima131,
#          p_woq     LIKE oqu_file.oqu12,         #No.FUN-690010DEC(12,2),
#          l_sfb05   like sfb_file.sfb05  ,
#          sr RECORD LIKE ste_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.ste04
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[10] CLIPPED ,tm.yea USING '&&&&' ,'/' ,tm.mo USING '&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] clipped,COLUMN 10,l_ima12,
#            column 20,g_x[12] clipped,column 29,l_ima131,
#            column 42,g_x[13] clipped,column 51,sr.ste04,
#      #No.FUN-550066 --start--
#            column 72,g_x[14] clipped,column 75,sr.ste05
#      #No.FUN-550066 --end--  
#      PRINT g_x[15] clipped,column 10,p_woq  USING '----,--&',
#            column 20,g_x[16] clipped,column 29,sr.ste06 USING '----,--&',
#            column 42,g_x[17] clipped,column 51,sr.ste11 USING '----,--&',
#      #No.FUN-550066 --start--
#            column 72,g_x[18] clipped,column 75,sr.ste16 USING '----,--&',
#            column 93,g_x[19] clipped,column 98,sr.ste26 USING '----,--&',
#            column 115,g_x[20] clipped,column 122,sr.ste22 USING '---,---,--&.&&'
#      #No.FUN-550066 --end--  
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#           ,g_x[38] CLIPPED   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      SKIP TO TOP OF PAGE
#      LET l_s1=0
#      FOREACH r390tmp_cur USING sr.ste04 INTO sort.*
#        IF tm.sw='N' THEN
#           IF sort.stdqty=sort.actqty THEN CONTINUE FOREACH END IF
#        END IF
#       #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#        SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#          FROM ima_file WHERE ima01=sort.partno
#        IF SQLCA.sqlcode THEN 
#           LET l_ima02 = ' ' 
#           LET l_ima021= ' '   #FUN-5A0059
#        END IF
#        PRINT COLUMN g_c[31],sort.partno,
#              COLUMN g_c[32],l_ima02,
#             #start FUN-5A0059
#              COLUMN g_c[33],l_ima021,
#              COLUMN g_c[34],cl_numfor(sort.stdqty,34,2), 
#              COLUMN g_c[35],cl_numfor(sort.actqty,35,2), 
#              COLUMN g_c[36],cl_numfor(sort.stdqty-sort.actqty,36,2), 
#              COLUMN g_c[37],cl_numfor(sort.uprice,37,g_azi03), 
#              COLUMN g_c[38],cl_numfor(sort.amt,38,g_azi04) 
#             #end FUN-5A0059
#        LET l_s1=l_s1+sort.amt
#      END FOREACH
#      PRINT g_dash2[1,g_len]
#      PRINT column g_c[31],g_x[24] clipped,COLUMN g_c[37],cl_numfor(l_s1,37,g_azi05) 
#
#   ON LAST ROW  
#      PRINT g_dash[1,g_len] CLIPPED
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
##NO.FUN-850090--end---mark---
