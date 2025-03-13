# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfr700.4gl
# Descriptions...: 個人生產狀況明細表
# Date & Author..: 99/05/21 by patricia
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.FUN-720005 07/04/11 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                       # Print condition RECORD
                    wc     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
                  more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
         g_tot2          LIKE shb_file.shb032
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE    l_table     STRING,                 ### FUN-720005 ###
          g_str       STRING,                 ### FUN-720005 ###
          g_sql       STRING                  ### FUN-720005 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/02/06 TSD.Martin  *** ##
   LET g_sql  = "shb08.shb_file.shb08,",
                "gem02.gem_file.gem02,",
                "shb02.shb_file.shb02,",
                "shb04.shb_file.shb04,",
                "gen01.gen_file.gen01,",
                "gen03.gen_file.gen03,",
                "gen02.gen_file.gen02,",
                "shb05.type_file.chr1000,",
                "shb10.shb_file.shb10,",
                "shb06.shg_file.shg07,",
                "ecm45.ecm_file.ecm45,",
                "shb032.shg_file.shg05,",
                "shb111.shb_file.shb111,",
                "shb113.shb_file.shb113,",
                "shb112.shb_file.shb112,",
                "shb114.shb_file.shb114,",
                "shb012.shb_file.shb012,",     #FUN-A60027
                "l_ima02.ima_file.ima02,",
                "l_ima021.ima_file.ima021, ",
                "l_flag.shb_file.shb08"
 
   LET l_table = cl_prt_temptable('asfr700',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?,? ,", 
               "        ?, ?, ?, ?, ?,  ?, ?, ?, ?,?)"       #FUN-A60027 add ?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720005 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r700_tm(0,0)        # Input print condition
      ELSE CALL asfr700()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r700_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 14
   END IF
   OPEN WINDOW r700_w AT p_row,p_col
        WITH FORM "asf/42f/asfr700"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON shb04,shb03,shb08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    ON ACTION help                              #No.TQC-770004                                                                                                               
         #CALL cl_dynamic_locale()                #No.TQC-770004                                                                                   
          CALL cl_show_help()                   #No.FUN-550037 hmf   #No.TQC-770004                                                             
         LET g_action_choice = "help"                         #No.TQC-770004                                                                     
         CONTINUE CONSTRUCT                   #No.TQC-770004 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        ON ACTION help                              #No.TQC-770004                                                                      
         #CALL cl_dynamic_locale()                #No.TQC-770004                                                                    
          CALL cl_show_help()                   #No.FUN-550037 hmf   #No.TQC-770004                                                 
         LET g_action_choice = "help"                         #No.TQC-770004                                                        
          CONTINUE INPUT                   #No.TQC-770004     
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr700','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr700',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr700()
   ERROR ""
END WHILE
   CLOSE WINDOW r700_w
END FUNCTION
 
FUNCTION asfr700()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_str         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_shb04   LIKE shb_file.shb04,
          l_shb08   LIKE shb_file.shb08,
         sr2    RECORD
                 shg06  LIKE shg_file.shg06,
                 shg08  LIKE shg_file.shg08,
                 shg07  LIKE shg_file.shg07,
                 ecm45  LIKE ecm_file.ecm45,
                 shg05  LIKE shg_file.shg05,
                 sgb05  LIKE sgb_file.sgb05
               END RECORD,
          sr        RECORD
                  shb08  LIKE shb_file.shb08,
                  gem02  LIKE gem_file.gem02,
                  shb02  LIKE shb_file.shb02,
                  shb04  LIKE shb_file.shb04,
                  gen01  LIKE gen_file.gen01,  #作業員工
                  gen03  LIKE gen_file.gen03,  #
                  gen02  LIKE gen_file.gen02,
                  shb05  LIKE shb_file.shb05,
                  shb10  LIKE shb_file.shb10,
                  shb06  LIKE shb_file.shb06,
                  ecm45  LIKE ecm_file.ecm45,
                  shb032 LIKE shb_file.shb032,
                  shb111 LIKE shb_file.shb111,
                  shb113 LIKE shb_file.shb113,
                  shb112 LIKE shb_file.shb112,
                  shb114 LIKE shb_file.shb114,
                  shb012 LIKE shb_file.shb012     #FUN-A60027
                    END RECORD
 
     #str FUN-720005 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
     #------------------------------ CR (2) ------------------------------#
     #end FUN-720005 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND shbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
    #End:FUN-980030
 
 
     LET l_sql =" SELECT shb08,'',shb02,shb04,gen01,gen03,'',shb05,",
                " shb10,shb06,ecm45,shb032,shb111,shb113,shb112,shb114,shb012 ",    #FUN-A60027 add shb012
                " FROM shb_file,OUTER gen_file,OUTER ecm_file",
                " WHERE  shb_file.shb05 = ecm_file.ecm01  ",
                "   AND  shb_file.shb06 = ecm_file.ecm03  ",
                "   AND  shb_file.shb012 = ecm_file.ecm012 ",    #FUN-A60027    
                "   AND  shb_file.shb04 = gen_file.gen01  ",
                "   AND  shb_file.shbconf = 'Y' ",        #FUN-A70095    
                "   AND ",tm.wc CLIPPED
 
     PREPARE r700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r700_cs1 CURSOR FOR r700_prepare1
     LET g_tot2 = 0
     FOREACH r700_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.gen01 IS NOT NULL THEN
        SELECT gen02 INTO sr.gen02 FROM gen_file
        WHERE gen01 = sr.gen01
       END IF
       IF sr.gen03 IS NOT NULL THEN
        SELECT gem02 INTO sr.gem02 FROM gem_file
        WHERE gem01 = sr.gen03
       END IF
       #str FUN-720005 add
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
       LET l_ima02 = ''
       LET l_ima021= ''
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = sr.shb10
       EXECUTE insert_prep USING 
                sr.shb08, sr.gem02, sr.shb02, sr.shb04, sr.gen01,
                sr.gen03, sr.gen02, sr.shb05, sr.shb10, sr.shb06,
                sr.ecm45, sr.shb032, sr.shb111, sr.shb113, sr.shb112,
                sr.shb114,sr.shb012,l_ima02  , l_ima021, "1"                          #FUN-A60027 add shb012
       #------------------------------ CR (3) ------------------------------#
       #end FUN-720005 add
     END FOREACH
     LET l_sql = "SELECT DISTINCT shb04,shb08 FROM ",
                 g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     PREPARE get_temp_prep FROM l_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM
     END IF
     DECLARE get_temp CURSOR FOR get_temp_prep 
     LET l_shb04 = ''  LET l_shb08 = ''  
     FOREACH get_temp INTO l_shb04,l_shb08   
        DECLARE shg_cur CURSOR FOR
           SELECT shg06,shg08,shg07,ecm45,shg05,sgb05
             FROM shg_file,OUTER ecm_file,OUTER sgb_file
            WHERE  shg_file.shg06 = ecm_file.ecm01  AND  shg_file.shg07 = ecm_file.ecm03 
              AND  shg_file.shg04 = sgb_file.sgb01 
              AND shg02 = l_shb04 AND shg021 = l_shb08
 
        FOREACH shg_cur INTO sr2.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           LET l_ima02 = ''
           LET l_ima021= ''
           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
            WHERE ima01 = sr2.shg08
 
           LET l_str = '*',sr2.shg06 CLIPPED
           IF cl_null(sr2.shg07) THEN LET sr2.shg07 = ' ' END IF 
           IF cl_null(sr2.shg05) THEN LET sr2.shg05 = ' ' END IF 
           IF cl_null(sr2.sgb05) THEN LET sr2.sgb05 = ' ' END IF 
           IF cl_null(l_ima021) THEN LET l_ima021 = ' ' END IF 
           IF cl_null(sr2.ecm45) THEN LET sr2.ecm45 = ' ' END IF 
    
          EXECUTE insert_prep USING 
                   l_shb08 ,      '' ,    '', l_shb04, '',
                   ''      ,      '' , l_str, sr2.shg08, sr2.shg07,
                   sr2.ecm45, sr2.shg05, sr2.sgb05,  '0' ,     '0',
                        '0','',l_ima02  , l_ima021   , "2"         #FUN-A60027 add ''
 
        END FOREACH 
     END FOREACH 
   #str FUN-720005 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'shb04,shb03,shb08') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
  #CALL cl_prt_cs3('asfr700','asfr700',l_sql,g_str)   #FUN-710080 modify  #FUN-A60027
  #FUN-A60027 -----------------start------------------------
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_prt_cs3('asfr700','asfr700_1',l_sql,g_str)
   ELSE
      CALL cl_prt_cs3('asfr700','asfr700',l_sql,g_str)
   END IF  
  #FUN-A60027------------------end-------------------------  
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720005 add
END FUNCTION
 
