# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr232.4gl
# Descriptions...: 銀行別應收票據明細帳列印作業
# Date & Author..: 93/04/23  By  Felicity  Tseng
#                : 96/06/13 By Lynn   銀行編號(nma01)取6碼
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0246 05/10/21 By Smapmin 調整SQL抓取條件
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.FUN-720013 07/03/01 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-920120 09/02/09 By chenl  若有重估匯率，則應該將票據金額顯示為原幣金額*重估匯率。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,                #TQC-630166
              c       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              d       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD
   DEFINE g_counter   LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_dash_1    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(132)
   DEFINE g_amt       LIKE nmh_file.nmh02
   DEFINE g_ary DYNAMIC ARRAY OF RECORD
                data  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(53)
                sign  LIKE type_file.num10,  #No.FUN-680107 INTEGER
                mony  LIKE nmh_file.nmh02    #餘額
          END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose   #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #FUN-720013 - START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = " nma01.nma_file.nma01,", #銀行編號
               " nma03.nma_file.nma03,", #銀行名稱
               " nma24.nma_file.nma24,", #應收票據餘額
               " nmh30.nmh_file.nmh30,", #客戶簡稱
               " nmh01.nmh_file.nmh01,", #票號
               " nmh02.nmh_file.nmh02,", #票面金額
               " nmh03.nmh_file.nmh03,", #幣別
               " nmh11.nmh_file.nmh11,", #客戶編號
               " nmh21.nmh_file.nmh21,", #託收銀行
               " nmh17.nmh_file.nmh17,", #收款金額
               " nmi02.nmi_file.nmi02,", #異動日期
               " nmi03.nmi_file.nmi03,", #異動時間
               " nmi05.ze_file.ze03,",
               " nmi06.ze_file.ze03,",
               " nmi09.nmi_file.nmi09,", #本次異動匯率
               " sign.type_file.num10, ", #
               " l_amt.nma_file.nma24, ",
               " t_azi04.azi_file.azi04,",
               " t_azi05.azi_file.azi05 "
 
   LET l_table = cl_prt_temptable('anmr232',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,     #No.TQC-820008 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
                " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ",
               "        ?, ?, ?, ?, ?,  ?, ?, ?, ? ) "
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #FUN-720013 - END
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)
   LET tm.bdate = ARG_VAL(10)    #TQC-610058
   LET tm.edate = ARG_VAL(11)    #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r232_tm(0,0)           # Input print condition
      ELSE CALL r232()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r232_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_cmd       LIKE type_file.chr1000       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r232_w AT p_row,p_col
        WITH FORM "anm/42f/anmr232"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate =g_today
   LET tm.edate =g_today
   LET tm.c    = '1'
   LET tm.d    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01
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
      LET INT_FLAG = 0 CLOSE WINDOW r232_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.c,tm.d,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               CALL cl_err(0,'anm-003',0)
               NEXT FIELD bdate
            END IF
 
      AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               CALL cl_err(0,'anm-003',0)
               NEXT FIELD edate
            END IF
            IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
               CALL cl_err(0,'anm-091',0)
               LET tm.bdate = g_today
               LET tm.edate = g_today
               DISPLAY BY NAME tm.bdate, tm.edate
               NEXT FIELD bdate
            END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES '[12]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r232_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr232'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr232','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr232',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r232_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r232()
   ERROR ""
END WHILE
   CLOSE WINDOW r232_w
END FUNCTION
 
 
FUNCTION r232()
   DEFINE l_name    LIKE type_file.chr20         #No.FUN-680107 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0082
   DEFINE l_sql     LIKE type_file.chr1000	 #No.FUN-680107 VARCHAR(1200)
   DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
   DEFINE XX        LIKE type_file.chr2          #No.FUN-680107 VARCHAR(2)
   DEFINE l_amt         LIKE nma_file.nma24
   DEFINE l_exp1        LIKE ze_file.ze03
   DEFINE l_exp2        LIKE ze_file.ze03
   DEFINE    sr            RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nma03 LIKE nma_file.nma03, #銀行名稱
                                  nma24 LIKE nma_file.nma24, #應收票據餘額
                                  nmh30 LIKE nmh_file.nmh30, #客戶簡稱
                                  nmh01 LIKE nmh_file.nmh01, #票號
                                  nmh02 LIKE nmh_file.nmh02, #票面金額
                                  nmh03 LIKE nmh_file.nmh03, #幣別
                                  nmh11 LIKE nmh_file.nmh11, #客戶編號
                                  nmh21 LIKE nmh_file.nmh21, #託收銀行
                                  nmh17 LIKE nmh_file.nmh17, #收款金額
                                  nmi02 LIKE nmi_file.nmi02, #異動日期
                                  nmi03 LIKE nmi_file.nmi03, #異動時間
                                  nmi05 LIKE nmi_file.nmi05,
                                  nmi06 LIKE nmi_file.nmi06,
                                  nmi09 LIKE nmi_file.nmi09,  #本次異動匯率
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
   DEFINE l_nmh39      LIKE nmh_file.nmh39 #No.MOD-920120
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
     #FUN-720013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 " nma01,nma03,nma24,nmh30,nmh01,nmh02,nmh03,nmh11,nmh21,nmh17,",
                 " nmi02, nmi03, nmi05, nmi06, nmi09, 0 ,nmh39 ",
 " FROM nma_file LEFT OUTER JOIN  ",   
 " (select nmh30,nmh01,nmh02,nmh03,nmh11,nmh21,nmh17,",   
 "          nmi02,nmi03,nmi05,nmi06,nmi09,nmh39 ",   
 "    from nmi_file,nmh_file ",    
 "   where nmi01 = nmh01 ",  
 "     and nmh38 <> 'X' ",    
 "     and nmi02 >= '",tm.bdate,"') tmp",    
 "     ON tmp.nmh21 = nma01 ",        #  
 "     WHERE ", tm.wc CLIPPED 
     PREPARE r232_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r232_curs1 CURSOR FOR r232_prepare1
     LET g_pageno = 0
     LET g_counter = 0
     IF tm.c = '2' THEN
        SELECT azi04, azi05
          INTO t_azi04, t_azi05  #NO.CHI-6A0004
          FROM azi_file
          WHERE azi01 = g_aza.aza17
        IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004
        IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004
     END IF
     FOREACH r232_curs1 INTO sr.*,l_nmh39   #No.MOD-920120 add nmh39
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr.nmh02) THEN LET sr.nmh02 = 0 END IF
          LET XX = sr.nmi05,sr.nmi06
          CASE XX
               WHEN '01' LET sr.sign = -1
               WHEN '02' LET sr.sign = -1
               WHEN '03' LET sr.sign = -1
               WHEN '04' LET sr.sign = -1
               WHEN '28' LET sr.sign = 1
               WHEN '38' LET sr.sign = 1
               WHEN '48' LET sr.sign = 1
               WHEN '26' LET sr.sign = 1
               WHEN '27' LET sr.sign = 1
               WHEN '37' LET sr.sign = 1
               WHEN '47' LET sr.sign = 1
               WHEN '15' LET sr.sign = 1
          END CASE
          IF sr.sign = 0 THEN CONTINUE FOREACH END IF
          IF tm.c = '2' THEN
             LET sr.nmh03 = g_aza.aza17           #g_aza17 :本幣幣別(NT$)
             IF cl_null(l_nmh39) OR l_nmh39 = 0 THEN #No.MOD-920120
                LET sr.nmh02 = sr.nmh02 * sr.nmi09   #轉換成本幣
             ELSE                                    #No.MOD-920120
                LET sr.nmh02 = sr.nmh02 * l_nmh39    #No.MOD-920120
             END IF                                  #No.MOD-920120
             IF cl_null(sr.nmh02) THEN LET sr.nmh02 = 0 END IF
          END IF
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          IF tm.c = '1' THEN       #幣別為原幣
             SELECT azi04, azi05
               INTO t_azi04, t_azi05  #NO.CHI-6A0004
               FROM azi_file
               WHERE azi01 = sr.nmh03
             IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004 
             IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004 
          END IF
          IF sr.nmi02 <= tm.edate THEN       #小於截止日期之data才放入temptalbe
             CALL s_nmdsta(sr.nmi05)  #得出票況的說明
                  RETURNING l_exp1
             CALL s_nmdsta(sr.nmi06)  #得出票況的說明
                  RETURNING l_exp2
             LET l_exp1=sr.nmi05,'.',l_exp1
             LET l_exp2=sr.nmi06,'.',l_exp2
             CALL r232_calbal(sr.nma01) #前初值計算
             LET l_amt=g_amt
             IF cl_null(l_amt) THEN LET l_amt=0 END IF
 
             EXECUTE insert_prep USING 
                    sr.nma01, sr.nma03, sr.nma24, sr.nmh30, sr.nmh01,
                    sr.nmh02, sr.nmh03, sr.nmh11, sr.nmh21, sr.nmh17,
                    sr.nmi02, sr.nmi03,  l_exp1 ,  l_exp2 , sr.nmi09,
                    sr.sign , l_amt   , t_azi04 , t_azi05 
          END IF 
          #------------------------------ CR (3) ------------------------------#
          #FUN-720013 - END
     END FOREACH
     #FUN-720013 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nma01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.d
     CALL cl_prt_cs3('anmr232','anmr232',l_sql,g_str)   #FUN-71080 modify
     #------------------------------ CR (4) ------------------------------#
     #FUN-720013 - END
 
END FUNCTION
 
FUNCTION r232_calbal(l_nma01)
   DEFINE    XX        LIKE type_file.chr2      #No.FUN-680107 VARCHAR(2)
   DEFINE    l_sql     LIKE type_file.chr1000	#No.FUN-680107 VARCHAR(600)
   DEFINE    l_sign    LIKE type_file.num10     #No.FUN-680107 INTEGER
   DEFINE    l_nma01   LIKE nma_file.nma01
   DEFINE    sr1           RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nmh02 LIKE nmh_file.nmh02, #票面金額
                                  nmi05 LIKE nmi_file.nmi05,
                                  nmi06 LIKE nmi_file.nmi06,
                                  nmi09 LIKE nmi_file.nmi09  #本次異動匯率
                        END RECORD
   DEFINE    l_nmh39    LIKE nmh_file.nmh39  #No.MOD-920120
 
     LET l_sql = "SELECT nma01, nmh02, nmi05, nmi06, nmi09 ,nmh39 ",   #No.MOD-920120 add nmh39
                 " FROM nma_file LEFT OUTER JOIN nmh_file LEFT OUTER JOIN nmi_file ",
                 "ON nmi01 = nmh01 AND nmi02 < '",tm.bdate,"' ON nmh21 = nma01",
                 " WHERE ",
                 " nma01='",l_nma01,"'"
     PREPARE r232_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r232_curs2 CURSOR FOR r232_prepare2
     IF tm.c = '2' THEN
        SELECT azi04, azi05 INTO t_azi04, t_azi05  #NO.CHI-6A0004
          FROM azi_file WHERE azi01 = g_aza.aza17
        IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004 
        IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004 
     END IF
     LET g_amt=0
     FOREACH r232_curs2 INTO sr1.*,l_nmh39
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach2:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr1.nmh02) THEN LET sr1.nmh02 = 0 END IF
          LET l_sign=0
          LET XX = sr1.nmi05,sr1.nmi06
          CASE XX
               WHEN '01' LET l_sign = -1
               WHEN '02' LET l_sign = -1
               WHEN '03' LET l_sign = -1
               WHEN '04' LET l_sign = -1
               WHEN '28' LET l_sign = 1
               WHEN '38' LET l_sign = 1
               WHEN '48' LET l_sign = 1
               WHEN '26' LET l_sign = 1
               WHEN '27' LET l_sign = 1
               WHEN '37' LET l_sign = 1
               WHEN '47' LET l_sign = 1
               WHEN '15' LET l_sign = 1
          END CASE
          IF l_sign  = 0 THEN
             CONTINUE FOREACH
          END IF
          IF tm.c = '2' THEN
             IF cl_null(l_nmh39) OR l_nmh39 = 0 THEN    #No.MOD-920120
                LET sr1.nmh02 = sr1.nmh02 * sr1.nmi09   #轉換成本幣   
             ELSE                                       #No.MOD-920120
                LET sr1.nmh02 = sr1.nmh02 * l_nmh39     #No.MOD-920120
             END IF                                     #No.MOD-920120
             IF cl_null(sr1.nmh02) THEN LET sr1.nmh02 = 0 END IF
          END IF
          LET g_amt=g_amt - sr1.nmh02 * l_sign
     END FOREACH
END FUNCTION
