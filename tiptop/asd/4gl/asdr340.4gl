# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr340.4gl
# Descriptions...: 生產量值彙總表
# Date & Author..: 99/07/07 By Eric
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-750031 07/07/10 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改		
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              type    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
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
   LET g_sql = "stm03.stm_file.stm03,",
               "q01.stm_file.stm04,",
               "a01.stm_file.stm05,",
               "q02.stm_file.stm04,",
               "a02.stm_file.stm05,",
               "q03.stm_file.stm04,",
               "a03.stm_file.stm05,",
               "q04.stm_file.stm04,",
               "a04.stm_file.stm05,",
               "q05.stm_file.stm04,",
               "a05.stm_file.stm05,",
               "q06.stm_file.stm04,",
               "a06.stm_file.stm05,",
               "q07.stm_file.stm04,",
               "a07.stm_file.stm05,",
               "q08.stm_file.stm04,",
               "a08.stm_file.stm05,",
               "q09.stm_file.stm04,",
               "a09.stm_file.stm05,",
               "q10.stm_file.stm04,",
               "a10.stm_file.stm05,",
               "q11.stm_file.stm04,",
               "a11.stm_file.stm05,",
               "q12.stm_file.stm04,",
               "a12.stm_file.stm05,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('asdr340',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
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
   #TQC-610079-begin
   LET tm.yea = ARG_VAL(8)
   LET tm.type= ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610079-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr340_tm(4,14)        # Input print condition
      ELSE CALL asdr340()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr340_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW asdr340_w AT p_row,p_col WITH FORM "asd/42f/asdr340" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   
   LET tm.yea  = YEAR(g_today) 
   LET tm.type = '1'
   LET tm.more = 'N' 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON stm03 
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
 
     INPUT BY NAME tm.yea,tm.type,tm.more
      WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yea
           IF tm.yea IS NULL OR tm.yea=0 THEN
              NEXT FIELD yea
           END IF
        AFTER FIELD type
           IF tm.type IS NULL OR tm.type NOT MATCHES '[123]' THEN
              NEXT FIELD type
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
         WHERE zz01='asdr340'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asdr340','9031',1)   
           
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
                           " '",tm.yea CLIPPED,"'",             #TQC-610079 
                           " '",tm.type CLIPPED,"'",            #TQC-610079
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           CALL cl_cmdat('asdr340',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE  
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr340()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr340_w
END FUNCTION
 
FUNCTION asdr340()
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
          l_stm03   LIKE stm_file.stm03,
          l_ima131  LIKE ima_file.ima131,
          l_sta07   LIKE sta_file.sta07,
          l_stm     RECORD LIKE stm_file.*,
          sr DYNAMIC ARRAY OF RECORD 
             stm04     LIKE ccq_file.ccq03,       #No.FUN-690010decimal(13,2),       #生產數量
             stm05     LIKE alb_file.alb06        #No.FUN-690010decimal(20,6)        #生產成本
             END RECORD,
          ss RECORD
             stm03     LIKE stm_file.stm03,
             q01       LIKE stm_file.stm04,
             a01       LIKE stm_file.stm05,
             q02       LIKE stm_file.stm04,
             a02       LIKE stm_file.stm05,
             q03       LIKE stm_file.stm04,
             a03       LIKE stm_file.stm05,
             q04       LIKE stm_file.stm04,
             a04       LIKE stm_file.stm05,
             q05       LIKE stm_file.stm04,
             a05       LIKE stm_file.stm05,
             q06       LIKE stm_file.stm04,
             a06       LIKE stm_file.stm05,
             q07       LIKE stm_file.stm04,
             a07       LIKE stm_file.stm05,
             q08       LIKE stm_file.stm04,
             a08       LIKE stm_file.stm05,
             q09       LIKE stm_file.stm04,
             a09       LIKE stm_file.stm05,
             q10       LIKE stm_file.stm04,
             a10       LIKE stm_file.stm05,
             q11       LIKE stm_file.stm04,
             a11       LIKE stm_file.stm05,
             q12       LIKE stm_file.stm04,
             a12       LIKE stm_file.stm05
             END RECORD
 
     #str FUN-750031 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750031 add
     IF tm.type='1' THEN LET g_x[1]= g_x[1]  END IF
     IF tm.type='2' THEN LET g_x[1]= g_x[21] END IF
     IF tm.type='3' THEN LET g_x[1]= g_x[22] END IF
 
 
     LET l_sql = "SELECT UNIQUE stm03 FROM stm_file" ,
                 " WHERE stm01=",tm.yea ,
                 "   AND ",tm.wc CLIPPED," ORDER BY stm03"
 
     PREPARE asdr340_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE asdr340_curs1 CURSOR FOR asdr340_prepare1
 
     CALL cl_outnam('asdr340') RETURNING l_name
 
     LET g_pageno = 0
     FOREACH asdr340_curs1 INTO l_stm03
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR l_i=1 to 12
           LET sr[l_i].stm04=0
           LET sr[l_i].stm05=0
       END FOR
       DECLARE r340_c2 CURSOR FOR
        SELECT * FROM stm_file WHERE stm01=tm.yea AND stm03=l_stm03
       FOREACH r340_c2 INTO l_stm.*
           LET l_i=l_stm.stm02
           #-->含重工  
           IF tm.type='1' THEN
              LET sr[l_i].stm04=l_stm.stm04
              LET sr[l_i].stm05=l_stm.stm05
           END IF
           #-->不含重工
           IF tm.type='2' THEN
              LET sr[l_i].stm04=l_stm.stm06
              LET sr[l_i].stm05=l_stm.stm07
           END IF
       END FOREACH
       LET ss.stm03=l_stm03
       LET ss.q01= sr[01].stm04 
       LET ss.a01= sr[01].stm05 
       LET ss.q02= sr[02].stm04 
       LET ss.a02= sr[02].stm05 
       LET ss.q03= sr[03].stm04 
       LET ss.a03= sr[03].stm05 
       LET ss.q04= sr[04].stm04 
       LET ss.a04= sr[04].stm05 
       LET ss.q05= sr[05].stm04 
       LET ss.a05= sr[05].stm05 
       LET ss.q06= sr[06].stm04 
       LET ss.a06= sr[06].stm05 
       LET ss.q07= sr[07].stm04 
       LET ss.a07= sr[07].stm05 
       LET ss.q08= sr[08].stm04 
       LET ss.a08= sr[08].stm05 
       LET ss.q09= sr[09].stm04 
       LET ss.a09= sr[09].stm05 
       LET ss.q10= sr[10].stm04 
       LET ss.a10= sr[10].stm05 
       LET ss.q11= sr[11].stm04 
       LET ss.a11= sr[11].stm05 
       LET ss.q12= sr[12].stm04 
       LET ss.a12= sr[12].stm05 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING
           ss.*,g_azi04,g_azi05
       #------------------------------ CR (3) ------------------------------#
       #end FUN-750031 add
     END FOREACH
 
       #str FUN-750031 add
       ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
       LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       #是否列印選擇條件
       IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'stm03') RETURNING tm.wc
          LET g_str = tm.wc
       END IF
       LET g_str = g_str,";",tm.yea,";",tm.type 
       CALL cl_prt_cs3('asdr340','asdr340',l_sql,g_str)
       #------------------------------ CR (4) ------------------------------#
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END FUNCTION
