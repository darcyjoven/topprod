# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abxr160.4gl
# Descriptions...: 保稅BOM列印
# Date & Author..: 96/09/10 By STAR
#                  01/29/97 By Sally:以輸入之有效日tm.effective展列BOM
# Modify.........: 05/02/23 By cate 報表標題標準化
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: NO.MOD-570347 ON EVERY ROW中之LINENO > 13的寫法應為LINOENO >=13 或是LINENO >12
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5A0106 05/10/13 By elva 料號欄位放大
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5B0024 05/12/09 By Nicola 新增列印實用數、損耗數、應用數
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/24 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.CHI-910056 09/02/01 By Cockroach FUN-850089轉CR時，漏掉此支未追5.1
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10043 10/01/08 By Smapmin 補上更新下階BOM編號的功能
# Modify.........: No:CHI-A40034 10/04/19 By houlia 追單MOD-9C0118
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD
                      wc        LIKE type_file.chr1000,              #No.FUN-680062   VARCHAR(300)   
                      doc_no    LIKE type_file.chr1000,              #No.FUN-680062   VARCHAR(12)
                      effective LIKE type_file.dat,                  #No.FUN-680062   date
                      a         LIKE type_file.num10,                #No.FUN-680062   integer 
                      b         LIKE type_file.chr1,                 #No.FUN-680062   VARCHAR(1)
                      rname     LIKE type_file.chr1,   #FUN-6A0007
                      more      LIKE type_file.chr1                  #No.FUN-680062   VARCHAR(1)
                   END RECORD,
       l_cmd       LIKE type_file.chr1000,       #No.FUN-680062 VARCHAR(400)
       g_bnd01_a   LIKE bnd_file.bnd01, #主件料號
       g_bnd02_a   LIKE bnd_file.bnd02,
       g_tot       LIKE type_file.num10,                            #No.FUN-680062   integer
       g_str       LIKE type_file.chr1000,                          #No.FUN-680062   VARCHAR(33)     
       l_cnt       LIKE type_file.num5,                   #品名規格額外說明筆數        #No.FUN-680062 smallint
       l_bnd03     LIKE bnd_file.bnd03,    #來源
       l_bnd04     LIKE bnd_file.bnd04,    #來源
       l_ima02     LIKE imc_file.imc04,    #品名規格
       l_ima03     LIKE imc_file.imc04,    #品名規格
       l_ima25     LIKE ima_file.ima25     #單位
DEFINE g_time1     DATETIME HOUR TO SECOND  #FUN-6A0007
DEFINE g_chr       LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table      STRING,    #CHI-910056 add
         l_table1     STRING,    #CHI-910056 add
         g_sql        STRING     #CHI-910056 add
         
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   
   #---CHI-910056 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bnd01.bnd_file.bnd01,",    #主件料件
              "ima02a.ima_file.ima02,",
              "ima021a.ima_file.ima021,",
              "ima25a.ima_file.ima25,",
              "ima1916a.ima_file.ima1916,",  
              "bxe02a.bxe_file.bxe02,",
              "bxe03a.bxe_file.bxe03,",
              "bxe04a.bxe_file.bxe04,",
              "bnd04.bnd_file.bnd04,",    #
#             "ima15.ima_file.ima15,",    #保稅否  #CHI-A40034
              "ima15a.ima_file.ima15,",    #保稅否 #CHI-A40034  ima15-->ima15a
              "bne03.bne_file.bne03,",    #項次
              "bne05.bne_file.bne05,",    #元件料號
              "ima02.ima_file.ima02,",    #品名規格
              "ima021.ima_file.ima021,",  
              "ima25.ima_file.ima25,",    #單位
              "bne10.bne_file.bne10,",    
              "bne11.bne_file.bne11,",    
              "bne08.bne_file.bne08,",    #QPA/BASE
#             "ima15a.ima_file.ima15,",   #CHI-A40034
              "ima15.ima_file.ima15,",    #CHI-A40034  ima15a-->ima15 
              "ima1916b.ima_file.ima1916,",  
              "bxe02.bxe_file.bxe02,",    #
              "bxe03.bxe_file.bxe03,",    #FUN-6A0007
              "bxe04.bxe_file.bxe04,",    #FUN-6A0007
              "bne09.bne_file.bne09 "     #有效否
 
                                          #24 items
  LET l_table = cl_prt_temptable('abxr160',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生子報表Temp Table >>>> CR11 *** ##
  LET g_sql =  "l_ima02.imc_file.imc04,",    #品名規格
               "l_ima03.imc_file.imc04,",    #品名規格
               "bnd01.bnd_file.bnd01,",      #主件料件
               "l_bnd04.bnd_file.bnd04,",    #來源
               "l_company.zo_file.zo02,",    #公司名稱
               "l_yy.type_file.chr4,",
               "l_mm.type_file.chr2,",
               "l_dd.type_file.chr2,",
               "l_doc_no.type_file.chr1000 "           
 
                                          #9 items
  LET l_table1 = cl_prt_temptable('abxr1601',g_sql) CLIPPED   # 產生Temp Table
  IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
 #------------------------------ CR (1) ------------------------------#
#---CHI-910056 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   LET g_pdate = ARG_VAL(1)                # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.doc_no  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.a       = ARG_VAL(10)
   LET tm.b       = ARG_VAL(11)
   #FUN-6A0007...............begin
   LET tm.rname   = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(12)
   #LET g_rep_clas = ARG_VAL(13)
   #LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   #FUN-6A0007...............end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r160_tm(0,0)
   ELSE
      CALL r160()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION r160_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,                 #No.FUN-680062 SMALLINT
          l_flag        LIKE type_file.num5,                 #No.FUN-680062 SMALLINT 
          l_count       LIKE type_file.num5,                 #No.FUN-680062 SMALLINT 
          l_one         LIKE type_file.chr1,                 #No.FUN-680062  VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bnd01       LIKE bnd_file.bnd01,
          l_ima06       LIKE ima_file.ima06
   DEFINE l_str1,l_str2  STRING       #No.MOD-580323  
 
   LET p_row = 6 LET p_col = 22
 
   OPEN WINDOW r160_w AT p_row,p_col
     WITH FORM "abx/42f/abxr160"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                        # Default condition
   LET tm.effective = g_today        #有效日期
   LET tm.a  = 1
   LET tm.b  = 'N'
   LET tm.rname = '1'  #FUN-6A0007
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      #CONSTRUCT tm.wc ON bnd01 FROM bnd01 #FUN-6A0007
      CONSTRUCT tm.wc ON bnd01,ima1916 FROM bnd01,ima1916 #FUN-6A0007
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
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
 
        #No.FUN-570243  --start-
         ON ACTION CONTROLP
               IF INFIELD(bnd01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bnd01
                  NEXT FIELD bnd01
               END IF
               #FUN-6A0007...............begin
               IF INFIELD(ima1916) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bxe01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1916
                  NEXT FIELD ima1916
               END IF
               #FUN-6A0007...............end
        #No.FUN-570243 --end--
 
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
         CLOSE WINDOW r160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
 
#     LET l_one='N'
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
#     IF tm.wc != ' 1=1' THEN
#         LET l_cmd="SELECT COUNT(*) ",
#                   " FROM bnd_file,ima_file",
#                   " WHERE bnd01=ima01 AND ",   #  " AND ima08 != 'A' AND ",
#                    tm.wc CLIPPED
#         PREPARE r160_cnt FROM l_cmd
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
#            EXIT PROGRAM
#         END IF
#         MESSAGE " SEARCHING ! "
#         FOREACH r160_cnt INTO l_count           #是個主件 ...下面還有元件
#           IF SQLCA.sqlcode  THEN
#              CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
#              CONTINUE WHILE
#           ELSE
#              LET l_one = 'Y'
#              EXIT FOREACH
#           END IF
#         END FOREACH
#         MESSAGE " "
#         IF cl_null(l_count) OR l_count < 1 THEN
#            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
#            CONTINUE WHILE
#         END IF
#     END IF
 
      #INPUT BY NAME tm.doc_no,tm.effective,tm.a,tm.b,tm.more #FUN-6A0007
      INPUT BY NAME tm.doc_no,tm.effective,tm.a,tm.b,tm.rname,tm.more #FUN-6A0007
               WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF tm.a IS NULL OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[YN]' THEN
              #No.MOD-580323 --start--
               CALL cl_getmsg('mfg1601',g_lang) RETURNING l_str2
               MESSAGE l_str2
               NEXT FIELD b
            END IF
            CALL ui.Interface.refresh()
            IF tm.b='Y' AND tm.effective IS NULL THEN
               CALL cl_getmsg('abx-160',g_lang) RETURNING l_str1
               ERROR l_str1
              #No.MOD-580323 --end--
               NEXT FIELD effective
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         #FUN-6A0007...............begin
         AFTER FIELD rname
            IF tm.rname NOT MATCHES '[12]' THEN
               NEXT FIELD rname
            END IF
         #FUN-6A0007...............end
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
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
         CLOSE WINDOW r160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file        #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr160'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr160','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,                #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.doc_no CLIPPED,"'",
                        " '",tm.effective CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",              #No.TQC-610081 add
                        " '",tm.rname CLIPPED,"'",        #FUN-6A0007
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('abxr160',g_time,l_cmd)        # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r160_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r160()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r160_w
 
END FUNCTION
 
FUNCTION r160()
   DEFINE l_name        LIKE type_file.chr20,         #No.FUN-680062  VARCHAR(20) 
#       l_time          LIKE type_file.chr8            #No.FUN-6A0062
          l_sql         LIKE type_file.chr1000,       #No.FUN-680062  VARCHAR(1000)
          l_za05        LIKE za_file.za05,             #No.FUN-680062  VARCHAR(40)  
          l_bnd01 LIKE bnd_file.bnd01,          #主件料件
          l_bnd02 LIKE bnd_file.bnd02           #主件料件
   #FUN-6A0007...............begin
   DEFINE l_bnd DYNAMIC ARRAY OF RECORD
                bnd01  LIKE bnd_file.bnd01,
                bnd02  LIKE bnd_file.bnd02
          END RECORD
   DEFINE l_i   LIKE type_file.num5
   DEFINE l_x   LIKE type_file.num5
   #FUN-6A0007...............end
 
#CHI-910056 add---START
   DEFINE l_yy      LIKE type_file.chr4,
          l_mm      LIKE type_file.chr2,
          l_dd      LIKE type_file.chr2,
          l_page    LIKE type_file.num5,
          l_doc_no  LIKE type_file.chr1000
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
  
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    LET l_page = 0
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#CHI-910056 add---END   
   
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#  LET g_x[1]='保稅BOM'
#  LET g_x[2]='製表日期:'
#  LET g_x[3]='頁次:'
#  LET g_x[4]='(abxr160)'
#  LET g_x[6]='(接下頁)'
#  LET g_x[7]='(結  束)'
 
  #FUN-6A0007.......................mark begin
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abxr160'
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 121 END IF #MOD-5A0106 #FUN-5B0013 161->121
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
  #FUN-6A0007.......................mark end
  
   LET l_sql = "SELECT bnd01,bnd02",
               " FROM bnd_file,ima_file", #FUN-6A0007 ima_file不OUTER
               " WHERE bnd01 = ima_file.ima01  AND ", tm.wc
 
   IF tm.effective IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED,
                " AND (bnd02 <='",tm.effective,"' OR bnd02 IS NULL)",
                " AND (bnd03 > '",tm.effective,"' OR bnd03 IS NULL)"
   END IF
 
   PREPARE r160_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   DECLARE r160_c1 CURSOR FOR r160_prepare1
#CHI-910056 MARK START --
#   CALL cl_outnam('abxr160') RETURNING l_name
#   START REPORT r160_rep TO l_name
#   START REPORT r160_rep2 TO 'abxr160.ou2'
#CHI-910056 MARK END --
 
   LET g_pageno = 0
   LET g_tot=0
   LET g_time1 = CURRENT HOUR TO SECOND #FUN-6A0007 
   LET l_x = 1  #FUN-6A0007 
 
   FOREACH r160_c1 INTO l_bnd01,l_bnd02
      IF SQLCA.sqlcode THEN
         CALL cl_err('F1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_bnd01_a=l_bnd01
      LET g_bnd02_a=l_bnd02
 
      #---取出表頭所需資料
 
      #CHI-910056 add---START
       LET l_bnd03 = NULL
       LET l_bnd04 = NULL
       LET l_ima02 = NULL
       LET l_ima03 = NULL
       LET l_ima25 = NULL
      #CHI-910056 add---END
 
      SELECT bnd03,bnd04,ima02,ima03,ima25
        INTO l_bnd03,l_bnd04,l_ima02,l_ima03,l_ima25
        FROM bnd_file ,OUTER ima_file
       WHERE bnd01=g_bnd01_a AND bnd_file.bnd01 = ima_file.ima01     AND bnd02 = g_bnd02_a
 
## No:2456  modify 1998/09/29 ------
      SELECT COUNT(*) INTO l_cnt FROM imc_file WHERE imc01=g_bnd01_a
##
 
      #品名規格額外說明
      IF l_cnt>0 THEN
         SELECT imc04 INTO l_ima02 FROM imc_file
          WHERE imc01=g_bnd01_a AND imc02='01' AND imc03=1
         SELECT imc04 INTO l_ima03 FROM imc_file
          WHERE imc01=g_bnd01_a AND imc02='01' AND imc03=2
      END IF
 
      ##FUN-6A0007...............begin
      LET l_bnd[l_x].bnd01 = l_bnd01
      LET l_bnd[l_x].bnd02 = l_bnd02
      LET l_x = l_x + 1
      #FUN-6A0007...............end
 
#---CHI-910056 add---START
 
      LET l_yy = YEAR(g_pdate)-1911 USING '<<<'
      LET l_mm = MONTH(g_pdate) USING '&&'
      LET l_dd = DAY(g_pdate) USING '&&'
      IF NOT cl_null(tm.doc_no) THEN
         LET l_doc_no = tm.doc_no
      ELSE 
         LET l_doc_no = ' '
      END IF
   
      IF NOT cl_null(tm.doc_no) THEN
         LET l_page = l_page + 1
         EXECUTE insert_prep1 USING   l_ima02, l_ima03, l_bnd01, l_bnd04,
                                    g_company,    l_yy,    l_mm,    l_dd,
                                     l_doc_no
 
         IF SQLCA.sqlcode  THEN
            CALL cl_err('insert_prep1:',STATUS,1) EXIT FOREACH
         END IF
      END IF
#---CHI-910056 add---END
#      OUTPUT TO REPORT r160_rep2(l_bnd01)    #CHI-910056 mark
 
  #   CALL r160_bom(0,l_bnd01,l_bnd02,tm.a)   01/29/97 by sally
      CALL r160_bom(0,l_bnd01,tm.effective,tm.a)
   END FOREACH
 
#   FINISH REPORT r160_rep       #CHI-910056 mark 
#   FINISH REPORT r160_rep2      #CHI-910056 mark 
 
   LET INT_FLAG = 0  ######add for prompt bug
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
#CHI-910056  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bnd01,ima1916')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
                #P1       #P2           #P3      #P4 
    LET g_str = g_str,";",tm.doc_no,";",tm.a,";",tm.effective,";",
                #P5      #P6
                tm.b,";",tm.rname,";",
                #P7
#FUN-860063-modify
#               YEAR(g_pdate)-1911 USING '&&;',
                YEAR(g_pdate)-1911 USING '&&&;',
#FUN-860063-modify-end
                #P8
                MONTH(g_pdate) USING '&&;',
                #P9
                DAY(g_pdate) USING '&&;',
                #P10             #P11             #P12
                g_bxz.bxz100,";",g_bxz.bxz102,";",g_bxz.bxz101,";",
                #P13
                l_page
 
    CALL cl_prt_cs3('abxr160','abxr160',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
#CHI-910056  ----end---
#CHI-910056  --mark start--
#  IF tm.doc_no IS NOT NULL AND tm.doc_no<>' ' THEN
#     LET l_cmd='cat ','abxr160.ou2 ','>> ',l_name
#     RUN l_cmd WITHOUT WAITING
#  END IF
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#CHI-910056  --mark end--
 
   ##FUN-6A0007...............begin
   LET l_x = l_x - 1
   IF cl_confirm('abx-049') THEN
      BEGIN WORK
      FOR l_i = 1 TO l_x
          UPDATE bnd_file SET bnd102 = 'Y'
           WHERE bnd01 = l_bnd[l_i].bnd01
            AND bnd02 = l_bnd[l_i].bnd02
      END FOR
      COMMIT WORK
   END IF
   #FUN-6A0007...............end
 
#  IF tm.doc_no IS NOT NULL AND tm.doc_no<>' ' THEN
#     CALL cl_prt('abxr160.ou2',g_prtway,g_copies,g_len)
#  END IF
 
 
END FUNCTION
 
FUNCTION r160_bom(p_level,p_key,p_key1,p_total)
   DEFINE p_level   LIKE type_file.num5,           #No.FUN-680062  SMALLINT
          p_total   LIKE bne_file.bne08, #FUN-560231
          l_total   LIKE bne_file.bne08, #FUN-560231
          l_tot     LIKE type_file.num10,            #No.FUN-680062  INTEGER
          l_times   LIKE type_file.num5,             #No.FUN-680062  SMALLINT
          p_key                LIKE bnd_file.bnd01,  #主件料件編號
          p_key1        LIKE bnd_file.bnd02,  #主件料件有效日期
          l_ac,i        LIKE type_file.num5,      #No.FUN-680062  SMALLINT
          arrno         LIKE type_file.num5,      #BUFFER SIZE (可存筆數)  #No.FUN-680062  SMALLINT 
          b_seq         LIKE type_file.num10,     #當BUFFER滿時,重新讀單身之起始ROWID  #No.FUN-680062  INTEGER
          l_chr                LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_order2 LIKE type_file.chr20,                     #No.FUN-680062 VARCHAR(20) 
          l_ima1916_t LIKE ima_file.ima1916,
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bnd01 LIKE bnd_file.bnd01,    #主件料件
              bnd02 LIKE bnd_file.bnd02,    #主件料件生效日期
              #FUN-6A0007...............begin
              bnd04 LIKE bnd_file.bnd04,    #
              ima1916a LIKE ima_file.ima1916,  
              bxe02a LIKE bxe_file.bxe02,
              bxe03a LIKE bxe_file.bxe03,
              bxe04a LIKE bxe_file.bxe04,
              ima02a  LIKE ima_file.ima02,
              ima021a LIKE ima_file.ima021,
              ima15a  LIKE ima_file.ima15,
              ima25a  LIKE ima_file.ima25,
              #FUN-6A0007...............end
              bne01 LIKE bne_file.bne01,    #本階主件
              bne02 LIKE bne_file.bne02,    #生效日期(主件)
              bne03 LIKE bne_file.bne03,    #項次
              bne05 LIKE bne_file.bne05,    #元件料號
              bne06 LIKE bne_file.bne06,    #有效日期
              bne07 LIKE bne_file.bne07,    #失效日期
              bne08 LIKE bne_file.bne08,    #QPA/BASE
              bne10 LIKE bne_file.bne10,    #No.FUN-5B0024
              bne11 LIKE bne_file.bne11,    #No.FUN-5B0024
              ima1916b LIKE ima_file.ima1916,  
              bxe02 LIKE bxe_file.bxe02,    #FUN-6A0007
              bxe03 LIKE bxe_file.bxe03,    #FUN-6A0007
              bxe04 LIKE bxe_file.bxe04,    #FUN-6A0007
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-6A0007
              ima25 LIKE ima_file.ima25,    #單位
              ima15 LIKE ima_file.ima15,    #保稅否
              bne09 LIKE bne_file.bne09     #有效否
          END RECORD,
          l_cmd1        LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF p_level > 20 THEN
      CALL cl_err('','mfg2733',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
 
   LET p_level = p_level + 1
 
   #FUN-6A0007...............begin
   #IF p_level = 1 THEN                                        #第0階主件資料
   #   INITIALIZE sr[1].* TO NULL
   #   LET g_pageno = 0
   #   LET sr[1].bne05 = p_key
   #   OUTPUT TO REPORT r160_rep(1,0,tm.a,sr[1].*)        #第0階主件資料
   #END IF
   #FUN-6A0007...............end
 
   LET l_times=1
   LET arrno = 601
 
   WHILE TRUE
      LET l_cmd1=
          ##FUN-6A0007...............begin
          "SELECT bnd01,bnd02,bnd04,a.ima1916,'','','','','','','', ",
          "       bne01,bne02,bne03,bne05,bne06,bne07,",
          "       bne08,bne10,bne11,b.ima1916,bxe02,bxe03,bxe04, ",
          "       b.ima02,b.ima021,b.ima25,b.ima15,bne09 ",   
          "  FROM bnd_file,bne_file,ima_file a,ima_file b,OUTER bxe_file ",
          " WHERE bnd01='", p_key,"'",
          "   AND bnd02<='", p_key1,"'",
          "   AND (bnd03 IS NULL OR bnd03>'",p_key1,"'",
          " ) AND bne01=bnd01 AND bne02=bnd02",
          "   AND bne03 >",b_seq,
          "   AND b.ima1916 = bxe_file.bxe01 ", 
          "   AND bne09 = 'Y' ",
          "   AND bnd01 = a.ima01 ",
          "   AND bne05 = b.ima01 "
 
      #---->生效日及失效日的判斷
      ##FUN-6A0007...............begin
      #LET l_cmd1 = l_cmd1 CLIPPED, " ORDER BY bne03 ,bne09 DESC  "
      IF tm.rname = '1' THEN
         LET l_cmd1 = l_cmd1 CLIPPED, " ORDER BY bne03 ,bne09 DESC  "
      ELSE
         LET l_cmd1 = l_cmd1 CLIPPED, " ORDER BY b.ima1916,bne03 "
      END IF
      #FUN-6A0007...............end
      
## No:2456  modify 1998/09/29 ------
      PREPARE r160_pre FROM l_cmd1
      DECLARE r160_cur CURSOR FOR r160_pre
##
      IF SQLCA.sqlcode THEN
         CALL cl_err('P1:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
         EXIT PROGRAM
      END IF
 
      LET l_ac = 1
 
      FOREACH r160_cur INTO sr[l_ac].*        # 先將BOM單身存入BUFFER
         #FUN-6A0007...............begin
         IF tm.rname = '2' THEN
            # 相同保稅群組代號，只show一次
            IF cl_null(sr[l_ac].ima1916b) THEN 
               LET sr[l_ac].ima1916b = ' '
            END IF
 
            IF l_ac = 1 OR 
               sr[l_ac].ima1916b != l_ima1916_t THEN
               IF sr[l_ac].ima1916b = ' ' THEN 
                  SELECT SUM(bne08),SUM(bne10),SUM(bne11)
                    INTO sr[l_ac].bne08,sr[l_ac].bne10,sr[l_ac].bne11
                    FROM bne_file,ima_file
                   WHERE bne01 = sr[l_ac].bne01
                     AND bne02 = sr[l_ac].bne02
                     AND bne05 = ima01
                     AND ima1916 IS NULL
                     AND bne09 = 'Y'
               ELSE
                  SELECT SUM(bne08),SUM(bne10),SUM(bne11) 
                    INTO sr[l_ac].bne08,sr[l_ac].bne10,sr[l_ac].bne11
                    FROM bne_file,ima_file
                   WHERE bne01 = sr[l_ac].bne01
                     AND bne02 = sr[l_ac].bne02
                     AND bne05 = ima01
                     AND ima1916 = sr[l_ac].ima1916b
                     AND bne09 = 'Y'
               END IF
               LET l_ima1916_t = sr[l_ac].ima1916b
            ELSE 
               IF sr[l_ac].ima15 = 'Y' THEN
                  LET sr[l_ac-1].ima15 = 'Y'
               END IF
               CONTINUE FOREACH
            END IF
         END IF
 
         LET sr[l_ac].bne08 = sr[l_ac].bne08 * tm.a
         LET sr[l_ac].bne10 = sr[l_ac].bne10 * tm.a
         LET sr[l_ac].bne11 = sr[l_ac].bne11 * tm.a
 
         # 主件料號 品名、規格、單位、保稅否
         SELECT ima02,ima021,ima15,ima25 
           INTO sr[l_ac].ima02a,sr[l_ac].ima021a,
                sr[l_ac].ima15a,sr[l_ac].ima25a
           FROM ima_file
          WHERE ima01 = sr[l_ac].bnd01
         # 主件料號 保稅品名、規格、單位
         SELECT bxe02,bxe03,bxe04
           INTO sr[l_ac].bxe02a,sr[l_ac].bxe03a,
                sr[l_ac].bxe04a
           FROM bxe_file 
          WHERE bxe01 = sr[l_ac].ima1916a
         #FUN-6A0007...............end
         LET l_ac = l_ac + 1                            # 但BUFFER不宜太大
         IF l_ac > arrno THEN
            EXIT FOREACH
         END IF
      END FOREACH
 
      LET l_tot = l_ac - 1
 
      FOR i = 1 TO l_tot                            # 讀BUFFER傳給REPORT
         LET l_total=p_total*sr[i].bne08
 
         #OUTPUT TO REPORT r160_rep(p_level,i,l_total,sr[i].*) #FUN-6A0007
#         OUTPUT TO REPORT r160_rep(sr[i].*) #FUN-6A0007   #CHI-910056 MARK
      #---CHI-910056 add---START
       EXECUTE insert_prep USING sr[i].bnd01,    sr[i].ima02a,   
                                 sr[i].ima021a,  sr[i].ima25a, 
                                 sr[i].ima1916a, sr[i].bxe02a,
                                 sr[i].bxe03a,   sr[i].bxe04a,   
                             #   sr[i].bnd04,    sr[i].ima15,   #CHI-A40034
                                 sr[i].bnd04,    sr[i].ima15a,   #CHI-A40034  ima15--->ima15a
                                 sr[i].bne03,    sr[i].bne05,
                                 sr[i].ima02,    sr[i].ima021,   
                                 sr[i].ima25,    sr[i].bne10,    
                                 sr[i].bne11,    sr[i].bne08,
                            #    sr[i].ima15a,   sr[i].ima1916b,#CHI-A40034
                                 sr[i].ima15,   sr[i].ima1916b,#CHI-A40034   ima15a--->ima15
                                 sr[i].bxe02,    sr[i].bxe03,    
                                 sr[i].bxe04,    sr[i].bne09
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOR 
       END IF
      #---CHI-910056 add---END

      #-----MOD-A10043---------
      IF tm.b='Y' AND tm.effective IS NOT NULL THEN
         UPDATE bnd_file SET bnd04=sr[i].bnd04
            WHERE bnd01=sr[i].bne05 AND
            (bnd02<=tm.effective OR bnd02 IS NULL) AND
            (bnd03>tm.effective OR bnd03 IS NULL) 
      END IF
      #-----END MOD-A10043-----
      
         #FUN-6A0007...............begin
         # 限只展單階 
         #IF sr[i].bnd01 IS NOT NULL AND sr[i].bne09='Y' THEN #若為主件
         #   CALL r160_bom(p_level,sr[i].bne05,tm.effective,
         #                 p_total*sr[i].bne08)
         #END IF
         #FUN-6A0007...............end
      END FOR
 
      IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_tot].bne03
         LET l_times=l_times+1
      END IF
   END WHILE
 
END FUNCTION
 
#FUN-6A0007...........................................mark begin
#REPORT r160_rep(p_level,p_i,p_total,sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,                    #No.FUN-680062   VARCHAR(1)  
#          p_level,p_i  LIKE type_file.num5,                    #No.FUN-680062   SMALLINT
#          p_total      LIKE bne_file.bne08, #FUN-560231
#          sr           RECORD
#                          bnd01 LIKE bnd_file.bnd01,    #主件料件
#                          bnd02 LIKE bnd_file.bnd02,    #主件料件(生效日期)
#                          bne01 LIKE bne_file.bne01,    #本階主件
#                          bne02 LIKE bne_file.bne02,    #生效日期(主件)
#                          bne03 LIKE bne_file.bne03,    #項次
#                          bne05 LIKE bne_file.bne05,    #元件料號
#                          bne06 LIKE bne_file.bne06,    #有效日期
#                          bne07 LIKE bne_file.bne07,    #失效日期
#                          bne08 LIKE bne_file.bne08,    #QPA/BASE
#                          bne10 LIKE bne_file.bne10,    #No.FUN-5B0024
#                          bne11 LIKE bne_file.bne11,    #No.FUN-5B0024
#                          ima02 LIKE ima_file.ima02,    #品名規格
#                          ima25 LIKE ima_file.ima25,    #單位
#                          ima15 LIKE ima_file.ima15,    #保稅否
#                          bne09 LIKE bne_file.bne09     #有效否
#                       END RECORD,
#          l_str2       LIKE type_file.chr20,              #No.FUN-680062  VARCHAR(10)
#          l_bne05      LIKE bne_file.bne05,               #No.FUN-680062  VARCHAR(40)
#          l_k,l_p      LIKE type_file.num5,               #No.FUN-680062  smallint
#          l_now,l_now2 LIKE type_file.num5,               #No.FUN-680062  smallint
#          l_point      LIKE type_file.chr20,              #No.FUN-680062  VARCHAR(10)
#          l_ver        LIKE ima_file.ima05,
#          l_byte,l_len LIKE type_file.num5,               #No.FUN-680062  smallint
#          l_ute_flag   LIKE type_file.chr2                #No.FUN-680062  VARCHAR(2) 
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   FORMAT
#      PAGE HEADER
#         PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#         IF g_towhom IS NULL OR g_towhom = ' ' THEN
#            PRINT '';
#         ELSE
#            PRINT 'TO:',g_towhom;
#         END IF
#         PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#         LET g_pageno = g_pageno + 1
# 
#         PRINT g_x[2] CLIPPED,g_pdate,' ',TIME
#         PRINT g_x[11] clipped,g_bnd02_a ,' - ',l_bnd03     #生效範圍
#         PRINT g_x[12] clipped,l_bnd04       #BOM 編號:
#         PRINT g_x[13] clipped,g_bnd01_a,g_x[14] clipped,l_ima25,  #料號   單位
#               COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#         IF l_cnt=0 THEN
#            PRINT g_x[15] clipped,l_ima02 CLIPPED,l_ima03 CLIPPED
#            PRINT ''
#         ELSE
#            PRINT g_x[15] clipped,l_ima02 CLIPPED #FUN-5B0013 add CLIPPED
#            PRINT '         ',l_ima03
#         END IF
#         PRINT g_dash[1,g_len]
#     #  #PRINT g_x[16],COLUMN 60,g_x[15],  #MOD-5A0106 #FUN-5B0013 mark
#     #   PRINT g_x[16],COLUMN 49,g_x[15],  #MOD-5A0106 #FUN-5B0013 add
#     #         #COLUMN 122,g_x[17],g_x[18] clipped  #MOD-5A0106#FUN-5B0013 mark
#     #         COLUMN 80,g_x[17],g_x[18] clipped  #MOD-5A0106 #FUN-5B0013 add
#     #   PRINT g_x[19],g_x[20] clipped,g_x[21] CLIPPED #FUN-5B0013
#     #         #g_x[21],g_x[22] clipped #FUN-5B0013 mark
#         PRINT g_x[16],COLUMN 49,g_x[17],g_x[49],g_x[18] CLIPPED   #No.FUN-5B0024
#         PRINT g_x[19],g_x[20] CLIPPED,g_x[21],g_x[22] CLIPPED
#         LET l_last_sw = 'n'
# 
#       ON EVERY ROW
#          IF p_level = 1 AND p_i = 0 THEN
#              #IF (PAGENO > 1 OR LINENO > 13) THEN #MOD-570347 mark
#             IF (PAGENO > 1 OR LINENO >= 13) THEN
#                 LET g_pageno = 0
#                 SKIP TO TOP OF PAGE
#                 LET g_pageno = 1
#             END IF
#          ELSE
#             IF p_level>10 THEN LET p_level=10 END IF
#             PRINT column p_level,p_level  using'<<<',
#                   COLUMN 12,sr.bne03 USING '###&',#FUN-590118
#                   #MOD-5A0106 --begin
#                   COLUMN 17,sr.bne05[1,40],
#                  #COLUMN 58,sr.ima02,#FUN-5B0013 mark
#                   COLUMN 49,sr.ima02 CLIPPED, #FUN-5B0013 add
#                   COLUMN 79,sr.bne10 USING '###,##&.&&' ,   #No.FUN-5B0024
#                   COLUMN 91,sr.bne11 USING '###,##&.&&' ,   #No.FUN-5B0024
#                   COLUMN 101,p_total USING '###,##&.&&',#FUN-5B0013 119->80
#                   COLUMN 112,sr.ima25,  #FUN-5B0013 130->88
#                   COLUMN 118,sr.ima15,  #FUN-5B0013 135->94
#                   COLUMN 123,sr.bne09,  #FUN-5B0013 140->99
#                   COLUMN 127,sr.bne06,  #FUN-5B0013 145->103
#                   COLUMN 136,sr.bne07   #FUN-5B0013 154->112
#                   #MOD-5A0106 --end
#          END IF
#          IF tm.b='Y' AND tm.effective IS NOT NULL THEN
#             UPDATE bnd_file SET bnd04=l_bnd04
#                WHERE bnd01=sr.bne05 AND
#                (bnd02<=tm.effective OR bnd02 IS NULL) AND
#                (bnd03>tm.effective OR bnd03 IS NULL) END IF
# 
#      ON LAST ROW
#         LET l_last_sw = 'y'
# 
#      PAGE TRAILER
# #       PRINT '* SEQ相同者為OPTION *'
#         PRINT g_x[23] CLIPPED
#         PRINT g_dash[1,g_len]
#         IF l_last_sw = 'y'
#            THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         END IF
#
#END REPORT
#FUN-6A0007...........................................mark end
 
#CHI-910056 MARK BEGIN--
##FUN-6A0007...............begin
#REPORT r160_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,
#         sr  RECORD                        #每階存放資料
#             bnd01 LIKE bnd_file.bnd01,    #主件料件
#             bnd02 LIKE bnd_file.bnd02,    #主件料件生效日期
#             bnd04 LIKE bnd_file.bnd04,    #
#             ima1916a LIKE ima_file.ima1916,   
#             bxe02a LIKE bxe_file.bxe02,
#             bxe03a LIKE bxe_file.bxe03,
#             bxe04a LIKE bxe_file.bxe04,
#             ima02a  LIKE ima_file.ima02,
#             ima021a LIKE ima_file.ima021,
#             ima15a  LIKE ima_file.ima15,
#             ima25a  LIKE ima_file.ima25,
#             bne01 LIKE bne_file.bne01,    #本階主件
#             bne02 LIKE bne_file.bne02,    #生效日期(主件)
#             bne03 LIKE bne_file.bne03,    #項次
#             bne05 LIKE bne_file.bne05,    #元件料號
#             bne06 LIKE bne_file.bne06,    #有效日期
#             bne07 LIKE bne_file.bne07,    #失效日期
#             bne08 LIKE bne_file.bne08,    #QPA/BASE
#             bne10 LIKE bne_file.bne10,    
#             bne11 LIKE bne_file.bne11,   
#             ima1916b LIKE ima_file.ima1916,   
#             bxe02 LIKE bxe_file.bxe02,
#             bxe03 LIKE bxe_file.bxe03,
#             bxe04 LIKE bxe_file.bxe04,
#             ima02 LIKE ima_file.ima02,    #品名規格
#             ima021 LIKE ima_file.ima021,  
#             ima25 LIKE ima_file.ima25,    #單位
#             ima15 LIKE ima_file.ima15,    #保稅否
#             bne09 LIKE bne_file.bne09     #有效否
#         END RECORD
#  
#  OUTPUT TOP MARGIN g_top_margin
#  LEFT MARGIN 0
#  BOTTOM MARGIN g_bottom_margin
#  PAGE LENGTH g_page_line
#  ORDER EXTERNAL BY sr.bnd01
#  FORMAT
#    PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company)
#                        -FGL_WIDTH(g_bxz.bxz100)
#                        -FGL_WIDTH(g_bxz.bxz102))/2)+3,
#                    g_bxz.bxz100 CLIPPED,' ',
#                    g_company CLIPPED,' ',
#                    g_bxz.bxz102 CLIPPED
#       PRINT COLUMN g_len-20,g_x[51] CLIPPED,g_bxz.bxz101 CLIPPED
#       PRINT COLUMN g_len-20,g_x[52] CLIPPED,g_user CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
#       PRINT ' '
#       LET g_pageno = g_pageno + 1
#       IF tm.rname = '1' THEN
#          PRINT COLUMN 01,g_x[53],sr.bnd01,
#                COLUMN 41,g_x[54],sr.ima02a,
#                COLUMN 81,g_x[55],sr.ima021a,
#                COLUMN 121,g_x[56],sr.ima25a
#          PRINT COLUMN 01,g_x[57],sr.ima1916a,
#                COLUMN 41,g_x[58],sr.bxe02a,
#                COLUMN 81,g_x[59],sr.bxe03a,
#                COLUMN 121,g_x[60],sr.bxe04a
#          PRINT COLUMN 01,g_x[61],tm.effective,
#                COLUMN 41,g_x[62],tm.a USING '<<<<&',
#                COLUMN 81,g_x[63],sr.bnd04 CLIPPED,
#                COLUMN 121,g_x[64],sr.ima15
#          PRINT COLUMN 01,g_x[2] CLIPPED,g_today,' ',g_time1,
#                COLUMN g_len-10,g_x[3],g_pageno USING '<<<'
#          PRINT g_dash
#          PRINTX name = H1 g_x[71] CLIPPED,g_x[72] CLIPPED,g_x[73] CLIPPED,
#                g_x[74] CLIPPED,g_x[75] CLIPPED,g_x[76] CLIPPED,
#                g_x[77] CLIPPED,g_x[78] CLIPPED,g_x[79] CLIPPED
#          PRINT g_dash1
#       ELSE
#          PRINT COLUMN 01,g_x[57],sr.ima1916a,
#                COLUMN 41,g_x[58],sr.bxe02a,
#                COLUMN 81,g_x[59],sr.bxe03a,
#                COLUMN 121,g_x[60],sr.bxe04a
#          PRINT COLUMN 01,g_x[53],sr.bnd01,
#                COLUMN 41,g_x[54],sr.ima02a,
#                COLUMN 81,g_x[55],sr.ima021a
#          PRINT COLUMN 01,g_x[61],tm.effective,
#                COLUMN 41,g_x[62],tm.a USING '<<<<&',
#                COLUMN 81,g_x[63],sr.bnd04 CLIPPED,
#                COLUMN 121,g_x[64],sr.ima15
#          PRINT COLUMN 01,g_x[2] CLIPPED,g_today,' ',g_time1,
#                COLUMN g_len-10,g_x[3],g_pageno USING '<<<'
#          PRINT g_dash
#          PRINTX name = H2 g_x[80] CLIPPED,g_x[81] CLIPPED,g_x[82] CLIPPED,
#                g_x[83] CLIPPED,g_x[84] CLIPPED,g_x[85] CLIPPED,
#                g_x[86] CLIPPED,g_x[87] CLIPPED,g_x[88] CLIPPED
#          PRINT g_dash1
 
#       END IF
#       LET l_last_sw = 'n'
#  
#    BEFORE GROUP OF sr.bnd01
#       SKIP TO TOP OF PAGE
 
#    ON EVERY ROW
#       IF tm.rname = '1' THEN
#          PRINTX name = D1 COLUMN g_c[71],cl_numfor(sr.bne03,71,0) CLIPPED,
#                COLUMN g_c[72],sr.bne05[1,30] CLIPPED,
#                COLUMN g_c[73],sr.ima02[1,30] CLIPPED,
#                COLUMN g_c[74],sr.ima021[1,30] CLIPPED,
#                COLUMN g_c[75],sr.ima25 CLIPPED,
#                COLUMN g_c[76],cl_numfor(sr.bne10,76,4) CLIPPED,
#                COLUMN g_c[77],cl_numfor(sr.bne11,77,4) CLIPPED,
#                COLUMN g_c[78],cl_numfor(sr.bne08,78,4) CLIPPED,
#                COLUMN g_c[79],sr.ima15 CLIPPED
#       
#          PRINTX name = D1 COLUMN g_c[72],sr.ima1916b[1,30],
#                COLUMN g_c[73],sr.bxe02[1,30],
#                COLUMN g_c[74],sr.bxe03[1,30],
#                COLUMN g_c[75],sr.bxe04
#       ELSE
#          PRINTX name = D2 COLUMN g_c[80],cl_numfor(sr.bne03,80,0) CLIPPED,
#                COLUMN g_c[81],sr.ima1916b[1,30] CLIPPED,
#                COLUMN g_c[82],sr.bxe02[1,30] CLIPPED,
#                COLUMN g_c[83],sr.bxe03[1,30] CLIPPED,
#                COLUMN g_c[84],sr.bxe04 CLIPPED,
#                COLUMN g_c[85],cl_numfor(sr.bne10,85,4) CLIPPED,
#                COLUMN g_c[86],cl_numfor(sr.bne11,86,4) CLIPPED,
#                COLUMN g_c[87],cl_numfor(sr.bne08,87,4) CLIPPED,
#                COLUMN g_c[88],sr.ima15 CLIPPED
#       END IF
 
#
#    ON LAST ROW
#       PRINT g_dash
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED,
#           COLUMN (g_len-9), g_x[7] CLIPPED
 
#    PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#        PRINT g_dash
#        PRINT g_x[4],g_x[5] CLIPPED,
#              COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE
#        SKIP 2 LINE
#     END IF
 
#END REPORT
##FUN-6A0007...............end
 
#REPORT r160_rep2(sr)
#  DEFINE sr  RECORD
#             bnd01 LIKE bnd_file.bnd01     #主件料件
#         END RECORD,
#         l_ima02long LIKE type_file.chr1000  #No.FUN-680062   VARCHAR(120)
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#    ON EVERY ROW
#      LET l_ima02long=l_ima02 CLIPPED,l_ima03
#      PRINT
#      PRINT
#      PRINT
#      PRINT "~w3z3l6g2;     ",g_company
#      PRINT "~w2z2;"
#      PRINT g_x[24],g_x[25] clipped
#      PRINT g_x[26],g_x[27] clipped
#      PRINT g_x[24],g_x[25] clipped
#      PRINT
#      #PRINT g_x[28] clipped,l_ima02long[1,30]#FUN-5B0013 mark
#      PRINT g_x[28] clipped,l_ima02long CLIPPED #FUN-5B0013 add
#      #PRINT "           ",l_ima02long[31,60]#FUN-5B0013 mark
#      #PRINT "           ",l_ima02long[61,90]#FUN-5B0013 mark
#      #PRINT "           ",l_ima02long[91,120]#FUN-5B0013 mark
#      PRINT
#      PRINT g_x[13] clipped,sr.bnd01 CLIPPED #FUN-5B0013 add CLIPPED
#      PRINT
#      PRINT g_x[29] clipped,tm.doc_no
#      PRINT
#      PRINT g_x[12] clipped,l_bnd04
#      PRINT
##FUN-860063-modify
##      PRINT g_x[30] clipped,year(g_pdate)-1911 USING "&&"," 年 ",
#      PRINT g_x[30] clipped,year(g_pdate)-1911 USING "&&&"," 年 ",
##FUN-860063-modify
#            month(g_pdate) USING "&&"," 月 ",
#            day(g_pdate) USING "&&",' 日'
#      PRINT
#      PRINT g_x[31] clipped
#      PRINT "~w1z1;"
#      PRINT g_x[32],g_x[33] clipped
#      PRINT g_x[34],g_x[35] clipped
#      PRINT g_x[36],g_x[37] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[40] CLIPPED,20 SPACE,g_x[44] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[41],g_x[42] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[43] CLIPPED,20 SPACE,g_x[44] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[41],g_x[42] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[45] CLIPPED,20 SPACE,g_x[46] clipped
#      PRINT g_x[38] CLIPPED,20 SPACE,g_x[39] clipped
#      PRINT g_x[47],g_x[48] clipped
#
#      SKIP TO TOP OF PAGE
 
#END REPORT
##Patch....NO.TQC-610035 <001> #
#CHI-910056 MARK END--
