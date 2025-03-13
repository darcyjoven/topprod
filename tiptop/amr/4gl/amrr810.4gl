# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amrr810.4gl
# Descriptions...: MRP Inventory projection report
# Input parameter:
# Return code....:
# Date & Author..: 98/06/29 By Eric
# Modify.........: No.FUN-510046 05/03/01 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580014 05/08/17 By jackie 轉xml
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 將印報表名稱那一行移到印製表日期的前面一行
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE 
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(接下頁)、(結束)
# Modify.........: No.MOD-720041 07/03/12 By TSD.Jin 改為Crystal Report
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-B60093 11/06/30 By JoHung 畫面加上成本計算類別
#                                                   依成本計算類別取得該料的成本平均
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,# Where condition   #NO.FUN-680082 VARCHAR(600) 
              ver_no  LIKE mss_file.mss_v,   #NO.FUN-680082 VARCHAR(2)
              yy      LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
              mm      LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
              order   LIKE type_file.chr1,   #NO.FUN-680082 VARCHAR(1)
              type    LIKE type_file.chr1,   #CHI-B60093 add
              more    LIKE type_file.chr1    # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD,
          g_date0     LIKE type_file.dat,    #NO.FUN-680082 DATE
          g_date1     LIKE type_file.dat,    #NO.FUN-680082 DATE
          g_date2     LIKE type_file.dat,    #NO.FUN-680082 DATE
          g_date3     LIKE type_file.dat,    #NO.FUN-680082 DATE
          g_date4     LIKE type_file.dat,    #NO.FUN-680082 DATE
          g_date5     LIKE type_file.dat     #NO.FUN-680082 DATE
   DEFINE st  RECORD
              qty0   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt0   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty1   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt1   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty2   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt2   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty3   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt3   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6) 
              qty4   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt4   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty5   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt5   LIKE  ima_file.ima91     #NO.FUN-680082 DEC(20,6)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #NO.FUN-680082 SMALLINT
DEFINE l_table    STRING                 #No.MOD-720041 By TSD.Jin
DEFINE g_str      STRING                 #No.MOD-720041 By TSD.Jin
DEFINE g_sql      STRING                 #No.MOD-720041 By TSD.Jin
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #No.MOD-720041 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " order1.ima_file.ima23,",
               " ima01.ima_file.ima01,",
               " ima02.ima_file.ima02,",
               " ima06.ima_file.ima06,",
               " ima08.ima_file.ima08,",
               " ima23.ima_file.ima23,",
               " ima25.ima_file.ima25,",
               " ima43.ima_file.ima43,",
               " ima67.ima_file.ima67,",
               " qty0.mss_file.mss08, ", 
               " amt0.ima_file.ima91, ", 
               " qty1.mss_file.mss08, ", 
               " amt1.ima_file.ima91, ", 
               " qty2.mss_file.mss08, ", 
               " amt2.ima_file.ima91, ", 
               " qty3.mss_file.mss08, ", 
               " amt3.ima_file.ima91, ", 
               " qty4.mss_file.mss08, ", 
               " amt4.ima_file.ima91, ", 
               " qty5.mss_file.mss08, ", 
               " amt5.ima_file.ima91, ", 
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05 " 
 
   LET l_table = cl_prt_temptable('amrr810',g_sql) CLIPPED  # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生有錯
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?) "
 
   PREPARE insert_prep FROM g_sql
   IF sqlca.sqlcode THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
   #No.MOD-720041 By TSD.Jin--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.ver_no  = ARG_VAL(8)
   LET tm.yy      = ARG_VAL(9)
   LET tm.mm      = ARG_VAL(10)
   LET tm.order   = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   LET tm.type    = ARG_VAL(15)  #CHI-B60093 add
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr810_tm(0,0)        # Input print condition
      ELSE CALL amrr810()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr810_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680082 SMALLINT 
          l_msr RECORD   LIKE msr_file.*,
          l_cmd          LIKE type_file.chr1000#NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr810_w AT p_row,p_col
        WITH FORM "amr/42f/amrr810"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'   #CHI-B60093 add
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.order = '1'
   LET tm.type = g_ccz.ccz28   #CHI-B60093 add
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   IF tm.mm = 1 THEN
      LET tm.yy=tm.yy - 1
      LET tm.mm=12
   ELSE
       LET tm.mm=tm.mm - 1
   END IF
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima08,ima43,ima06,ima67,ima23
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(mss01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO mss01
            NEXT FIELD mss01
         END IF
#No.FUN-570240 --end
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
#  INPUT BY NAME tm.ver_no, tm.yy,tm.mm,tm.order,tm.more WITHOUT DEFAULTS           #CHI-B60093 mark
   INPUT BY NAME tm.ver_no, tm.yy,tm.mm,tm.order,tm.type,tm.more WITHOUT DEFAULTS   #CHI-B60093
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT * INTO l_msr.* FROM msr_file WHERE msr_v=tm.ver_no
         IF STATUS <> 0 THEN
            ERROR 'MRP Version not found!'
            LET tm.ver_no=' '
            NEXT FIELD ver_no
         END IF
 
        AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD yy
            END IF
 
        AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD mm
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               LET tm.mm=MONTH(g_today)
               NEXT FIELD mm
            END IF
 
      AFTER FIELD order
         IF cl_null(tm.order) THEN NEXT FIELD order END IF
         IF tm.order NOT MATCHES '[12345]' THEN
            LET tm.order='1'
            NEXT FIELD order
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr810','9031',1)
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
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                         ," '",tm.type CLIPPED,"'"              #CHI-B60093 add
         CALL cl_cmdat('amrr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr810()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr810_w
END FUNCTION
 
FUNCTION amrr810()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name      #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_n       LIKE type_file.num5,    #NO.FUN-680082 SMALLINT 
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40) 
          l_supply,l_demand LIKE  mss_file.mss08,                            #NO.FUN-680082 DEC(12,3)
          l_mss01 LIKE mss_file.mss01,
          sr  RECORD
              order  LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,
              ima02  LIKE ima_file.ima02,
              ima06  LIKE ima_file.ima06,
              ima08  LIKE ima_file.ima08,
              ima23  LIKE ima_file.ima23,
              ima25  LIKE ima_file.ima25,
              ima43  LIKE ima_file.ima43,
              ima67  LIKE ima_file.ima67,
              qty0   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt0   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty1   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt1   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty2   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt2   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty3   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt3   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty4   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt4   LIKE  ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
              qty5   LIKE  mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
              amt5   LIKE  ima_file.ima91     #NO.FUN-680082 DEC(20,6)
              END RECORD
 
#No.MOD-720041 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.MOD-720041 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET st.qty0=0
     LET st.amt0=0
     LET st.qty1=0
     LET st.amt1=0
     LET st.qty2=0
     LET st.amt2=0
     LET st.qty3=0
     LET st.amt3=0
     LET st.qty4=0
     LET st.amt4=0
     LET st.qty5=0
     LET st.amt5=0
     LET l_sql = "SELECT UNIQUE mss01",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mss01=ima01 ",
                 "   AND mss_v='",tm.ver_no,"'"
 
#No.MOD-720041 By TSD.Jin--start mark
#    CALL cl_outnam('amrr810') RETURNING l_name
#    START REPORT amrr810_rep TO l_name
#No.MOD-720041 By TSD.Jin--end
 
     LET g_pageno = 0
     IF MONTH(g_today) = 12 THEN
        LET g_date0=MDY(12,31,YEAR(g_today))
     ELSE
        LET g_date0=MDY(MONTH(g_today)+1,1,YEAR(g_today))-1
     END IF
     LET g_date1=r810_nextmonth(g_date0)
     LET g_date2=r810_nextmonth(g_date1)
     LET g_date3=r810_nextmonth(g_date2)
     LET g_date4=r810_nextmonth(g_date3)
     LET g_date5=r810_nextmonth(g_date4)
     PREPARE amrr810_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr810_curs1 CURSOR FOR amrr810_prepare1
     FOREACH amrr810_curs1 INTO sr.ima01
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       CALL r810_bal(sr.ima01,g_date0) RETURNING sr.qty0,sr.amt0
       CALL r810_bal(sr.ima01,g_date1) RETURNING sr.qty1,sr.amt1
       CALL r810_bal(sr.ima01,g_date2) RETURNING sr.qty2,sr.amt2
       CALL r810_bal(sr.ima01,g_date3) RETURNING sr.qty3,sr.amt3
       CALL r810_bal(sr.ima01,g_date4) RETURNING sr.qty4,sr.amt4
       CALL r810_bal(sr.ima01,g_date5) RETURNING sr.qty5,sr.amt5
       IF sr.qty0=0 AND sr.qty1=0 AND sr.qty2=0 AND sr.qty3=0 AND
          sr.qty4=0 AND sr.qty5=0 THEN
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima06,ima08,ima23,ima25,ima43,ima67
         INTO sr.ima01,sr.ima02,sr.ima06,sr.ima08,sr.ima23,sr.ima25,sr.ima43,sr.ima67
         FROM ima_file WHERE ima01=sr.ima01
       IF STATUS <> 0 THEN CONTINUE FOREACH END IF
       CASE WHEN tm.order = '1'
                 LET sr.order=sr.ima23
            WHEN tm.order = '2'
                 LET sr.order=sr.ima67
            WHEN tm.order = '3'
                 LET sr.order=sr.ima43
            WHEN tm.order = '4'
                 LET sr.order=sr.ima06
            OTHERWISE
                 LET sr.order=' '
       END CASE
     #No.MOD-720041 By TSD.Jin--start
     # OUTPUT TO REPORT amrr810_rep(sr.*)
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING 
          sr.order, sr.ima01, sr.ima02, sr.ima06, sr.ima08,
          sr.ima23, sr.ima25, sr.ima43, sr.ima67, sr.qty0, 
          sr.amt0,  sr.qty1,  sr.amt1,  sr.qty2,  sr.amt2, 
          sr.qty3,  sr.amt3,  sr.qty4,  sr.amt4,  sr.qty5, 
          sr.amt5,  g_azi03,  g_azi04,  g_azi05
     #No.MOD-720041 By TSD.Jin--end 
     END FOREACH
 
  #No.MOD-720041 By TSD.Jin--start
  #  FINISH REPORT amrr810_rep
  #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'mss01,ima06,ima08,ima67,ima43,ima23')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.order,";",
                 YEAR(g_date0) USING '##&&','/',MONTH(g_date0) USING '&&',";",
                 YEAR(g_date1) USING '##&&','/',MONTH(g_date1) USING '&&',";",
                 YEAR(g_date2) USING '##&&','/',MONTH(g_date2) USING '&&',";",
                 YEAR(g_date3) USING '##&&','/',MONTH(g_date3) USING '&&',";",
                 YEAR(g_date4) USING '##&&','/',MONTH(g_date4) USING '&&',";",
                 YEAR(g_date5) USING '##&&','/',MONTH(g_date5) USING '&&',";" 
 
     IF tm.order = '5' THEN
        CALL cl_prt_cs3('amrr810','amrr810_2',l_sql,g_str)   #FUN-710080 modify
     ELSE
        CALL cl_prt_cs3('amrr810','amrr810_1',l_sql,g_str)   #FUN-710080 modify
     END IF
  #No.MOD-720041 By TSD.Jin--end
END FUNCTION
 
FUNCTION r810_bal(l_partno,l_date)
    DEFINE l_partno LIKE ima_file.ima01,
           l_date   LIKE type_file.dat,     #NO.FUN-680082 DATE
           l_qty    LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
           l_amt    LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
           l_ccc23  LIKE ccc_file.ccc23
 
    DECLARE mss_cur CURSOR FOR
     SELECT mss08,mss03 FROM mss_file
      WHERE mss_v=tm.ver_no AND mss01=l_partno AND mss03 <= l_date
      ORDER BY mss03 DESC
    OPEN mss_cur
    FETCH mss_cur INTO l_qty
    IF STATUS <> 0 THEN LET l_qty=0 END IF
    CLOSE mss_cur
    IF l_qty < 0 THEN LET l_qty=0 END IF
#   SELECT ccc23 INTO l_ccc23 FROM ccc_file                   #CHI-B60093 mark
    SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_File              #CHI-B60093
     WHERE ccc01=l_partno AND ccc02=tm.yy AND ccc03=tm.mm
#      AND ccc07='1'                         #No.FUN-840041   #CHI-B60093 mark
       AND ccc07 = tm.type
     GROUP BY ccc01                                           #CHI-B60093 add
    IF STATUS <> 0 THEN LET l_ccc23=0 END IF
    IF l_ccc23 IS NULL THEN LET l_ccc23=0 END IF
    LET l_amt=l_qty*l_ccc23
    RETURN l_qty,l_amt
END FUNCTION
 
FUNCTION r810_nextmonth(l_date)
    DEFINE l_date    LIKE type_file.dat,     #NO.FUN-680082 DATE
           r_date    LIKE type_file.dat,     #NO.FUN-680082 DATE
           l_yy,l_mm LIKE type_file.num5     #NO.FUN-680082 SMALLINT
 
    LET l_yy=YEAR(l_date) USING '&&&&'
    LET l_mm=MONTH(l_date)
    IF l_mm = 12 THEN
       LET l_yy=l_yy+1
       LET l_mm=1
    ELSE
       LET l_mm=l_mm+1
    END IF
    IF l_mm = 12 THEN
       LET l_yy=l_yy+1
       LET l_mm=1
    ELSE
       LET l_mm=l_mm+1
    END IF
    LET r_date=MDY(l_mm,1,l_yy)-1
    RETURN r_date
END FUNCTION
 
#No.MOD-720041 By TSD.Jin--start mark
#REPORT amrr810_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1) 
#          l_c          LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
#          l_h          LIKE type_file.chr8,    #NO.FUN-680082 VARCHAR(08)
#          l_h2         LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(23) 
#   DEFINE sr  RECORD
#              order  LIKE ima_file.ima23,
#              ima01  LIKE ima_file.ima01,
#              ima02  LIKE ima_file.ima02,
#              ima06  LIKE ima_file.ima06,
#              ima08  LIKE ima_file.ima08,
#              ima23  LIKE ima_file.ima23,
#              ima25  LIKE ima_file.ima25,
#              ima43  LIKE ima_file.ima43,
#              ima67  LIKE ima_file.ima67,
#              qty0   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt0   LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
#              qty1   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt1   LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
#              qty2   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt2   LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
#              qty3   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt3   LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
#              qty4   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt4   LIKE ima_file.ima91,    #NO.FUN-680082 DEC(20,6)
#              qty5   LIKE mss_file.mss08,    #NO.FUN-680082 DEC(12,3)
#              amt5   LIKE ima_file.ima91     #NO.FUN-680082 DEC(20,6)
#                     END RECORD
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.order,sr.ima01
#  FORMAT
#   PAGE HEADER
##No.FUN-580014 --start--
#      IF tm.order='5' THEN
#        LET g_zaa[31].zaa06='Y'
#      ELSE
#        LET g_zaa[31].zaa06='N'
#      END IF
#      CALL cl_prt_pos_len()
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]   #TQC-5B0019
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      IF tm.order='1' THEN
#         LET g_zaa[31].zaa08=g_x[8]
#      ELSE
#         IF tm.order='2' THEN
#            LET g_zaa[31].zaa08=g_x[9]
#         ELSE
#            IF tm.order='3' THEN
#               LET g_zaa[31].zaa08=g_x[10]
#            ELSE
#               LET g_zaa[31].zaa08=''
#            END IF
#         END IF
#      END IF
#      IF tm.order = '4' THEN LET g_zaa[31].zaa08=g_x[13] CLIPPED  END IF
#      LET g_zaa[35].zaa08=YEAR(g_date0) USING '##&&','/',MONTH(g_date0) USING '&&'
#      LET g_zaa[36].zaa08=YEAR(g_date1) USING '##&&','/',MONTH(g_date1) USING '&&'
#      LET g_zaa[37].zaa08=YEAR(g_date2) USING '##&&','/',MONTH(g_date2) USING '&&'
#      LET g_zaa[38].zaa08=YEAR(g_date3) USING '##&&','/',MONTH(g_date3) USING '&&'
#      LET g_zaa[39].zaa08=YEAR(g_date4) USING '##&&','/',MONTH(g_date4) USING '&&'
#      LET g_zaa[40].zaa08=YEAR(g_date5) USING '##&&','/',MONTH(g_date5) USING '&&'
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      NEED 2 LINES
##      PRINT sr.order CLIPPED;
##      IF tm.order='5' THEN
##         PRINT COLUMN 10,sr.ima01[1,12],
##               COLUMN 23,sr.ima08,
##               COLUMN 29,sr.ima25,
##               COLUMN 35,
##               cl_numfor(sr.qty0 ,15,2),' ',
##               cl_numfor(sr.qty1 ,15,2),' ',
##               cl_numfor(sr.qty2 ,15,2),' ',
##               cl_numfor(sr.qty3 ,15,2),' ',
##               cl_numfor(sr.qty4 ,15,2),' ',
##               cl_numfor(sr.qty5 ,15,2)
#         PRINTX name=D1
#               COLUMN g_c[31],sr.order CLIPPED,
#               COLUMN g_c[32],sr.ima01 CLIPPED,   #FUN-5B0014 [1,20],
#               COLUMN g_c[33],sr.ima08 CLIPPED,
#               COLUMN g_c[34],sr.ima25,
#               COLUMN g_c[35],cl_numfor(sr.amt0 ,35,2),
#               COLUMN g_c[36],cl_numfor(sr.amt1 ,36,2),
#               COLUMN g_c[37],cl_numfor(sr.amt2 ,37,2),
#               COLUMN g_c[38],cl_numfor(sr.amt3 ,38,2),
#               COLUMN g_c[39],cl_numfor(sr.amt4 ,39,2),
#               COLUMN g_c[40],cl_numfor(sr.amt5 ,40,2)
#      LET st.qty0=st.qty0+sr.qty0
#      LET st.amt0=st.amt0+sr.amt0
#      LET st.qty1=st.qty1+sr.qty1
#      LET st.amt1=st.amt1+sr.amt1
#      LET st.qty2=st.qty2+sr.qty2
#      LET st.amt2=st.amt2+sr.amt2
#      LET st.qty3=st.qty3+sr.qty3
#      LET st.amt3=st.amt3+sr.amt3
#      LET st.qty4=st.qty4+sr.qty4
#      LET st.amt4=st.amt4+sr.amt4
#      LET st.qty5=st.qty5+sr.qty5
#      LET st.amt5=st.amt5+sr.amt5
# 
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash2[1,g_len] CLIPPED
#      PRINTX name=S1
#               COLUMN g_c[32],g_x[12] CLIPPED,
#               COLUMN g_c[35],cl_numfor(sr.qty0 ,35,2),
#               COLUMN g_c[36],cl_numfor(sr.qty1 ,36,2),
#               COLUMN g_c[37],cl_numfor(sr.qty2 ,37,2),
#               COLUMN g_c[38],cl_numfor(sr.qty3 ,38,2),
#               COLUMN g_c[39],cl_numfor(sr.qty4 ,39,2),
#               COLUMN g_c[40],cl_numfor(sr.qty5 ,40,2)
#      PRINTX name=S1
#               COLUMN g_c[35],cl_numfor(sr.amt0 ,35,2),
#               COLUMN g_c[36],cl_numfor(sr.amt1 ,36,2),
#               COLUMN g_c[37],cl_numfor(sr.amt2 ,37,2),
#               COLUMN g_c[38],cl_numfor(sr.amt3 ,38,2),
#               COLUMN g_c[39],cl_numfor(sr.amt4 ,39,2),
#               COLUMN g_c[40],cl_numfor(sr.amt5 ,40,2)
#      PRINT g_dash[1,g_len] CLIPPED
#     #PRINT '(amrr810)'                                             #TQC-6B0011 mark
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0011
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#             #PRINT '(amrr810)'                                             #TQC-6B0011 mark
#              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #TQC-6B0011
#         ELSE SKIP 2 LINE
##No.FUN-580014 --end--
#      END IF
#END REPORT
##Patch....NO.TQC-610035 <> #
#No.MOD-720041 By TSD.Jin--end mark
