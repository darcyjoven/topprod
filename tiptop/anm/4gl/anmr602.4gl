# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr602.4gl
# Descriptions...: 月份別投資利潤統計表
# Input parameter:
# Return code....:
# Date & Author..: 00/07/10 by Brendan
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-4C0098 05/01/04 By pengu 報表轉XML
# Modify         : No.MOD-530872 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-590111 05/10/04 By Nicola 投資毛利欄位修改
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720013 07/03/08 By TSD.c123k 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B20107 11/02/22 By Dido 條件少了 and gse03 = gsb01
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		             # Print condition RECORD
              wc    STRING,                  #Where Condiction
              yy    LIKE type_file.num5,     #No.FUN-680107 SMALLINT #年度
              more  LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)  #是否列印其它條件
              END RECORD
 
   DEFINE g_i       LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
   DEFINE g_head1   STRING
   DEFINE l_table   STRING                 # TSD.c123k
   DEFINE g_sql     STRING                 # TSD.c123k
   DEFINE g_str     STRING                 # TSD.c123k
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #FUN-720013 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "gse03.gse_file.gse03,",
               "gsb03.gsb_file.gsb03,",
               "gsb06.gsb_file.gsb06,",
               "gse24.gse_file.gse24,",
               "year1.type_file.num5,",
               "month1.type_file.num5,",
               "g_azi04.azi_file.azi04,",
               "g_azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('anmr602',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,? ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-720013 - END
 
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.yy  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr602_tm()	        	# Input print condition
      ELSE CALL anmr602()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr602_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW anmr602_w AT p_row,p_col
        WITH FORM "anm/42f/anmr602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.yy=YEAR(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gse03,gsb05,gse06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' '
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF cl_null(tm.yy) THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.yy
           NEXT FIELD yy
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD yy
       END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr602'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr602','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr602',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr602()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr602_w
END FUNCTION
 
FUNCTION anmr602()
   DEFINE l_name  LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8     #No.FUN-6A0082
          l_sql   LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05  LIKE type_file.chr1000,        #標題內容  #No.FUN-680107 VARCHAR(40)
          l_i     LIKE type_file.num5,           #No.FUN-680107 SMALLINT
          l_mm    SMALLINT,
          sr            RECORD
                           gse03    LIKE gse_file.gse03,
                           gsb03    LIKE gsb_file.gsb03,
                           gsb06    LIKE gsb_file.gsb06,
                           gse24    LIKE gse_file.gse24   #No.FUN-590111
                        END RECORD
 
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ----------------------------------#
     #FUN-720013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
#NO.CHI-6A0004--BEGIN
#     SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 #NO.CHI-6A0004
#     IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#        CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#     END IF
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND gseuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gsegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gsegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gseuser', 'gsegrup')
     #End:FUN-980030
 
   LET l_sql = "SELECT gse03, gsb03, gsb06, gse24 ",   #No.FUN-590111
               " FROM gsb_file, gse_file ",
               " WHERE ",tm.wc CLIPPED,
               " AND YEAR(gsb03) = '",tm.yy,"' ",
               " AND gsb01 = gse03 ",              #MOD-B20107 remark
               " AND gsbconf !='X' ", #010816增
               " AND gseconf !='X' ", #010816增
               " ORDER BY gse03"
 
     PREPARE anmr602_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr602_curs1 CURSOR FOR anmr602_prepare1
 
     LET g_pageno = 0
 
     FOREACH anmr602_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       LET l_mm = MONTH(sr.gsb03) 
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** #
       EXECUTE insert_prep USING
           sr.gse03,    sr.gsb03,    sr.gsb06,    sr.gse24,
           tm.yy,       l_mm    ,     g_azi04,     g_azi05
       #------------------------------ CR (3) -------------------------------
       #FUN-720013 - END
 
     END FOREACH
 
     #FUN-720013 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'gse03,gsb05,gse06')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     CALL cl_prt_cs3('anmr602','anmr602',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
     #FUN-720013 - END
 
END FUNCTION
 
