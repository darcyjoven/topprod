# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr330.4gl
# Descriptions...: 現金變動表列印作業
# Date & Author..: 93/04/27  By  Felicity  Tseng
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-580010 05/08/08 By will 報表轉XML格式
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720013 07/03/01 By TSD.Ken #CR11
# Modify.........: No.MOD-940220 09/04/15 By lilingyu 寫入nml03欄位時,改成只抓nml03的第一碼寫入
# Modify.........: No.MOD-940228 09/04/16 By lilingyu tm.c和tm.d畫面檔屬性及預設值更改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              c       LIKE azi_file.azi01,   #No.FUN-680107 #幣別
              d       LIKE azi_file.azi01,   #No.FUN-680107 #幣別
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_year      LIKE type_file.num10,  #No.FUN-680107 INTEGER #年度
          g_month     LIKE type_file.num10,  #No.FUN-680107 INTEGER #月份
          g_dash_1    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(132)
          g_rest1     LIKE nme_file.nme04,
          g_rest2     LIKE nme_file.nme04,
          t_azi05_1   LIKE azi_file.azi05, #NO.CHI-6A0004
          t_azi05_2   LIKE azi_file.azi05  #NO.CHI-6A0004
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose        #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
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
 
  LET g_sql = " nma10.nma_file.nma10, ",
              " nmc03.nmc_file.nmc03, ",
              " nml01.nml_file.nml01, ",
              " nml02.nml_file.nml02, ",
              " nml03.nml_file.nml03, ",
              " amt.nme_file.nme04    "
 
   LET l_table = cl_prt_temptable('anmr330',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?) "
 
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
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r330_tm(0,0)           # Input print condition
      ELSE CALL r330()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r330_tm(p_row,p_col)
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cnt       LIKE type_file.num10,   #No.FUN-680107 INTEGER
       l_cmd       LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r330_w AT p_row,p_col
        WITH FORM "anm/42f/anmr330"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
#  LET tm.c = g_aza.aza17      #MOD-940228
   LET tm.d = g_aza.aza17      #MOD-940228
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
      LET INT_FLAG = 0 CLOSE WINDOW r330_w 
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
            LET g_year =YEAR(tm.bdate)
            LET g_month =MONTH(tm.bdate)
            IF g_month = 1 THEN         #起始日期之"月份"為一月
               LET g_year = g_year - 1
               LET g_month = 12
            ELSE
               LET g_month = g_month - 1
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
         #MOD-940228 mark--
         #   IF cl_null(tm.c) THEN
         #      CALL cl_err(0,'anm-003',0)
         #      NEXT FIELD c
         #   END IF
         #MOD-940228 mark--
         IF NOT cl_null(tm.c) THEN  #MOD-940228
            SELECT COUNT(*)
              INTO l_cnt
              FROM azi_file
              WHERE azi01 = tm.c
            IF l_cnt = 0 THEN
              CALL cl_err(tm.c,'anm-007',0)
             # LET tm.c = g_aza.aza17  #MOD-940228
             # DISPLAY BY NAME tm.c    #MOD-940228
              NEXT FIELD c
            END IF
         END IF    #MOD-940228
 
      AFTER FIELD d
            IF NOT cl_null(tm.d) THEN
               SELECT COUNT(*)
                 INTO l_cnt
                 FROM azi_file
                 WHERE azi01 = tm.d
               IF l_cnt = 0 THEN
                 CALL cl_err(tm.d,'anm-007',0)
                #LET tm.d = 'US$ '
                #DISPLAY BY NAME tm.d
                 LET tm.d = g_aza.aza17          #MOD-940228
                 DISPLAY BY NAME tm.d            #MOD-940228                
                 NEXT FIELD d
               END IF
            ELSE                                 #MOD-940228
                CALL cl_err('','anm-003',0)      #MOD-940228   
                NEXT FIELD d                     #MOD-940228                  
            END IF
            IF tm.c = tm.d THEN
               CALL cl_err(tm.d,'anm-094',0)
              # LET tm.d =' '             #MOD-940228  
                LET tm.d = g_aza.aza17    #MOD-940228
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
      LET INT_FLAG = 0 CLOSE WINDOW r330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr330'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr330','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr330',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r330()
   ERROR ""
END WHILE
   CLOSE WINDOW r330_w
END FUNCTION
 
FUNCTION r330()
   DEFINE l_name     LIKE type_file.chr20,        # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0082
          l_sql      LIKE type_file.chr1000,      # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr      LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_c        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_d        LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
          l_temp     LIKE type_file.chr8,         #No.FUN-680107 VARCHAR(8)
          l_year     LIKE nmp_file.nmp02,
          l_bdate    LIKE type_file.dat,          #No.FUN-680107 DATE
          l_edate    LIKE type_file.dat,          #No.FUN-680107 DATE
          l_rest_1   LIKE nme_file.nme04,
          l_rest_2   LIKE nme_file.nme04,
          l_debit_1  LIKE nme_file.nme04,
          l_debit_2  LIKE nme_file.nme04,
          l_credit_1 LIKE nme_file.nme04,
          l_credit_2 LIKE nme_file.nme04,
          l_tmpdate  LIKE type_file.dat,
          sr               RECORD
                                  nma10 LIKE nma_file.nma10, #存款幣別
                                  nmc03 LIKE nmc_file.nmc03, #銀行存提別
                                  nml01 LIKE nml_file.nml01, #現金變動碼
                                  nml02 LIKE nml_file.nml02, #變動碼說明
                                  nml03 LIKE nml_file.nml03, #變動分類
                                  amt   LIKE nme_file.nme04  #銀行存提金額
                        END RECORD
 
 
#FUN-720013 - START
## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### CR11 add ###
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
                 " nma10,nmc03,nml01,nml02,nml03,SUM(nme04),0,0",
                 " FROM nma_file, nme_file, nmc_file, nml_file ",
                 " WHERE nme01 = nma01 ",  #銀行編號
                 " AND   nme03 = nmc01 ",  #存提異動碼
                 " AND  nme14 = nml01 ",   #現金變動碼
                 " AND ( nma10 = '",tm.c,"' OR nma10 = '",tm.d,"' )",
                 " AND  nme02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND ", tm.wc CLIPPED,
                 " GROUP BY  nma10,nmc03,nml01,nml02,nml03 "
 
     SELECT azi05 INTO t_azi05_1 FROM azi_file WHERE azi01 = tm.c  #NO.CHI-6A0004
     IF cl_null(t_azi05_1) THEN LET t_azi05_1 = 0 END IF           #NO.CHI-6A0004
     SELECT azi05 INTO t_azi05_2 FROM azi_file WHERE azi01 = tm.d  #NO.CHI-6A0004
     IF cl_null(t_azi05_2) THEN LET t_azi05_2 = 0 END IF           #NO.CHI-6A0004
     PREPARE r330_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r330_curs1 CURSOR FOR r330_prepare1
#No.FUN-580010  --begin
     FOR g_i = 1 TO g_len
         LET g_dash_1[g_i,g_i] = '-'
     END FOR
     LET g_zaa[32].zaa08 = tm.c CLIPPED,' ',g_x[12] CLIPPED
     LET g_zaa[33].zaa08 = tm.c CLIPPED,' ',g_x[13] CLIPPED
     LET g_zaa[34].zaa08 = tm.d CLIPPED,' ',g_x[14] CLIPPED
     LET g_zaa[35].zaa08 = tm.d CLIPPED,' ',g_x[15] CLIPPED
#No.FUN-580010  --end
#     START REPORT r330_rep TO l_name
     LET g_pageno = 0
        IF g_year >=2000  THEN
           LET l_year = g_year - 2000
        ELSE
           LET l_year = g_year - 1900
        END IF
        LET l_temp[1,2] = l_year USING '&&'
        LET l_temp[3,3] ='/'
        LET l_temp[4,5] = g_month USING '&&'
        LET l_temp[6,6] ='/'
        LET l_temp[7,8] ='01'
        LET l_tmpdate = l_temp
        LET l_bdate = l_tmpdate       #得到本月份1st天
        LET l_edate = (tm.bdate - 1)  #起始日期前一天
 
     LET l_sql = " SELECT SUM(nmp06), SUM(nmp09)",   #得出上月結存
                 "   FROM nma_file, nmp_file ",
                 "   WHERE nmp01 = nma01 ",
                 "   AND   nmp02 = ",g_year,
                 "   AND   nmp03 = ",g_month,
                 "   AND   nmaacti IN ('y','Y') ",
                 "   AND   ",tm.wc CLIPPED
 
     PREPARE r330_p1 FROM l_sql
     DECLARE r330_c1 CURSOR FOR r330_p1
     OPEN r330_c1
     FETCH r330_c1 INTO l_rest_1, l_rest_2
     IF cl_null(l_rest_1) THEN LET l_rest_1 = 0 END IF
     IF cl_null(l_rest_2) THEN LET l_rest_2 = 0 END IF
 
     IF DAY(tm.bdate) != 1 THEN
        LET l_sql = " SELECT  SUM(nme04), SUM(nme08) ",
                    "   FROM  nma_file ,nme_file, nmc_file",
                    "   WHERE nme01 = nma01 ",
                    "   AND   nme02  BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                    "   AND   nmc01 = nme03 ",    #異動碼
                    "   AND   nmc03 = ? ",
                    "   AND   nmaacti IN ('y','Y') ",
                    "   AND   nmcacti IN ('y','Y') ",
                    "   AND  ",tm.wc CLIPPED
 
        LET l_d = '1'    #借方
        PREPARE r330_p2 FROM l_sql
        DECLARE r330_c2 CURSOR FOR r330_p2
        OPEN r330_c2 USING l_d
        FETCH r330_c2 INTO  l_debit_1, l_debit_2
        IF cl_null(l_debit_1) THEN LET l_debit_1 = 0 END IF
        IF cl_null(l_debit_2) THEN LET l_debit_2 = 0 END IF
 
        LET l_c = '2'    #貸方
        PREPARE r330_p3 FROM l_sql
        DECLARE r330_c3 CURSOR FOR r330_p3
        OPEN r330_c3 USING l_c
        FETCH r330_c2 INTO  l_credit_1, l_credit_2
        IF cl_null(l_credit_1) THEN LET l_credit_1 = 0 END IF
        IF cl_null(l_credit_2) THEN LET l_credit_2 = 0 END IF
 
        LET g_rest1 = l_rest_1 + l_debit_1 - l_credit_1   #期初金額(原幣)
        LET g_rest2 = l_rest_2 + l_debit_2 - l_credit_2   #期初金額(本幣)
     ELSE
        LET g_rest1 = l_rest_1
        LET g_rest2 = l_rest_2
     END IF
 
     FOREACH r330_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',sqlca.SQLCode,1)
             EXIT FOREACH
          END IF
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       LET sr.nml03 = sr.nml03[1,1] CLIPPED    #MOD-940220       
       EXECUTE insert_prep USING sr.nma10, sr.nmc03, sr.nml01, sr.nml02, sr.nml03, sr.amt
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
     END FOREACH
 
    #FUN-720013 - START
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'nma01')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = g_str,";",tm.bdate,";",tm.edate,";",t_azi05_1,";",t_azi05_2,";",
                g_rest1,";",g_rest2,";",tm.c,";",tm.d                              
    CALL cl_prt_cs3('anmr330','anmr330',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    #FUN-720013 - END
END FUNCTION
 
