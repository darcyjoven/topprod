# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gxcr005.4gl
# Descriptions...: 部門出庫成本統計表
# Input parameter:
# Return code....:
# Date & Author..: 95/10/10 By Nick
# Modify.........: No:A102       04/03/09 By Elva for先進先出調整列印明細
# Modify.........: No.FUN-4C0099 05/01/27 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/17 by day   單據編號加大
# Modify.........: No.TQC-630003 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-720042 07/03/12 By TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-B80044 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2) 
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(600)   # Where condition
              yy,mm   LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
              o       LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)     # (1)工單領用 (2)雜項領用
                                                                         # (3)其他調整 (4)銷售出庫
              a       LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
              b       LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
              c       LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
              more    LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)     # Input more condition(Y/N)
              END RECORD,
       g_tot_bal  LIKE eca_file.eca60      #NO.FUN-680145 DECIMAL(13,2) # User defined variable
   DEFINE bdate   LIKE type_file.dat          #NO.FUN-680145 DATE
   DEFINE edate   LIKE type_file.dat          #NO.FUN-680145 DATE
   DEFINE g_argv1 LIKE ima_file.ima01         #NO.FUN-680145 VARCHAR(20)
   DEFINE g_argv2 LIKE type_file.num5         #NO.FUN-680145 SMALLINT
   DEFINE g_argv3 LIKE type_file.num5         #NO.FUN-680145 SMALLINT
DEFINE   g_i      LIKE type_file.num5         #NO.FUN-680145 SMALLINT   #count/index for any purpose
DEFINE   g_chr    LIKE type_file.chr1         #NO.FUN-680145 VARCHAR(1)    #Print tm.wc ?(Y/N)
#MOD-720042 BY TSD.Sora---start---
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#MOD-720042 BY TSD.Sora---end---
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXC")) THEN
      EXIT PROGRAM
   END IF
   #TQC-630003-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.o    = '1'
   #LET tm.a    = 'Y'
   #LET tm.b    = 'Y'
   #LET tm.c    = 'Y'
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_trace = 'N'                # default trace off
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #        LET tm.o =ARG_VAL(4)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(5)
   #LET g_rep_clas = ARG_VAL(6)
   #LET g_template = ARG_VAL(7)
   ##No.FUN-570264 ---end---
   #        CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
   #        CALL gxcr005()            # Read data and create out-file
   #END IF
  
   #MOD-720042 BY TSD.Sora---start---
   LET g_sql = "tlf19.tlf_file.tlf19,",
               "tlf14.tlf_file.tlf14,",
               "tlf01.tlf_file.tlf01,",
               "ima25.ima_file.ima25,",
#               "qty.ima_file.ima26,", #FUN-A20044
               "qty.type_file.num15_3,", #FUN-A20044
               "up.oeb_file.oeb13,",
               "amt.type_file.num20_6,",
               "gem02.gem_file.gem02,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
    LET l_table = cl_prt_temptable('gxcr005',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
    #MOD-720042 BY TSD.Sora---end---
 
 
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)    
   LET tm.yy    = ARG_VAL(8)    
   LET tm.mm    = ARG_VAL(9)       
   LET tm.o     = ARG_VAL(10)       
   LET tm.a     = ARG_VAL(11)       
   LET tm.b     = ARG_VAL(12)       
   LET tm.c     = ARG_VAL(13)       
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    # No.FUN-B80044---add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL gxcr005_tm(0,0)          # Input print condition
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      CALL gxcr005()                # Read data and create out-file
   END IF
   #TQC-630003-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
END MAIN
 
FUNCTION gxcr005_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(400)
 
IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   LET p_row = 3 LET p_col = 15
   OPEN WINDOW gxcr005_w AT p_row,p_col
        WITH FORM "axc/42f/axcr005"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   CALL cl_opmsg('p')
   #TQC-630003-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   LET tm.o    = '1'
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_trace = 'N'                # default trace off
   #TQC-630003-end
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON tlf19,tlf14,ima01,ima39
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      #str FUN-710080 add
      ON ACTION CONTROLP
         IF INFIELD(ima01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         END IF
      #endFUN-710080 add
 
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
      LET INT_FLAG = 0 CLOSE WINDOW gxcr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
      EXIT PROGRAM
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC%'"
 
INPUT BY NAME tm.yy,tm.mm,tm.o,tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[1-4]' THEN
            NEXT FIELD o
         END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
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
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
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
      LET INT_FLAG = 0 CLOSE WINDOW gxcr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxcr005'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gxcr005','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-630003-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.o  CLIPPED,"'",
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.b  CLIPPED,"'",
                         " '",tm.c  CLIPPED,"'",
                         #TQC-630003-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gxcr005',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxcr005_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxcr005()
   ERROR ""
END WHILE
   CLOSE WINDOW gxcr005_w
END FUNCTION
 
FUNCTION gxcr005()
   DEFINE l_name    LIKE type_file.chr20,   #NO.FUN-680145 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          l_sql     LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(1200)    # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
          xxx       LIKE smy_file.smyslip,  #NO.FUN-680145 VARCHAR(5)
          u_sign    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
          l_za05    LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(40)
          l_order   ARRAY[5] OF   LIKE cre_file.cre08,   #NO.FUN-680145  VARCHAR(10)
          l_ima53,l_ima91,l_ima531    LIKE ima_file.ima53,   #NO.FUN-680145 DECIMAL(15,3)
          l_dmy1    LIKE smy_file.smydmy1,
          l_cxc     RECORD LIKE cxc_file.*,        #No.A102
          #No.A102
          #MOD-720042 BY TSD.Sora---start---
          l_gem02   LIKE gem_file.gem02,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          #MOD-720042 BY TSD.Sora---end---
       sr               RECORD ima01  LIKE ima_file.ima01,
                                  tlf19  LIKE tlf_file.tlf19,
                                  tlf14  LIKE tlf_file.tlf14,
                                  tlf01  LIKE tlf_file.tlf01,
                                  ima25  LIKE ima_file.ima25,
                                  tlf06  LIKE tlf_file.tlf06,
                                  tlf02  LIKE tlf_file.tlf02,
                                  tlf03  LIKE tlf_file.tlf03,
                                  tlf026 LIKE tlf_file.tlf026,
                                  tlf027 LIKE tlf_file.tlf027,
                                  tlf036 LIKE tlf_file.tlf036,
                                  tlf037 LIKE tlf_file.tlf037,
                                  tlf11  LIKE tlf_file.tlf11,
                                  tlf21  LIKE tlf_file.tlf21,
                                  qty    LIKE tlf_file.tlf10,
                                  up     LIKE ccc_file.ccc23,	
                                  amt    LIKE ccc_file.ccc12,
                                  seq    LIKE type_file.num5     #NO.FUN-680145 SMALLINT
                        END RECORD       #end No.A102

     # No.FUN-B80044--start mark--------------------------------------------------------------------
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     # No.FUN-B80044--end mark----------------------------------------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #MOD-720042 BY TSD.Sora---start---
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gxcr005' 
     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
       FROM azi_file WHERE azi01 = g_aza.aza17
     #070227 BY TSD.Sora---end---
 
     #No.A102
     LET l_sql = "SELECT * FROM cxc_file ",
                 " WHERE cxc01 = ? AND cxc02 = ",tm.yy," AND cxc03 =",tm.mm,
                 "   AND cxc04 = ? AND cxc05 = ? "
     PREPARE cxc_pre FROM l_sql
     IF STATUS THEN 
        CALL cl_err('cxc_pre:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
        EXIT PROGRAM 
     END IF
     DECLARE cxc_curs CURSOR FOR cxc_pre
     #end No.A102
 
  LET l_sql = "SELECT ima01,tlf19,tlf14,tlf01,ima25,tlf06,tlf02,tlf03,",
                 "       tlf026,tlf027,tlf036,tlf037,tlf11,tlf21,",
                 "       (tlf10*tlf60),0,0",     #No.A102
                 "  FROM tlf_file, ima_file",
                 " WHERE ",tm.wc,
                 "   AND ((tlf02=50 OR tlf02=57) OR (tlf03=50 OR tlf03=57)) ",
                 "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
                 "   AND tlf01=ima01",
                 " ORDER BY tlf19,tlf14,tlf01 "
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE gxcr005_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    # No.FUN-B80044---add--
        EXIT PROGRAM 
     END IF
     DECLARE gxcr005_curs1 CURSOR FOR gxcr005_prepare1
 
     #070314 BY TSD.Sora---start---
     #CALL cl_outnam('gxcr005') RETURNING l_name
     #START REPORT gxcr005_rep TO l_name
     #070314 BY TSD.Sora---end---
     LET g_pageno = 0
     FOREACH gxcr005_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    IF g_trace='Y' THEN DISPLAY sr.tlf01 END IF
      #IF tm.a='N' THEN LET sr.tlf19=' ' END IF
      #IF tm.b='N' THEN LET sr.tlf14=' ' END IF
       LET u_sign=0
       IF sr.tlf02 = 50 OR sr.tlf02 = 57
          THEN LET u_sign=1 LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
       END IF
       IF sr.tlf03 = 50 OR sr.tlf03 = 57
          THEN LET u_sign=-1
       END IF
       IF u_sign=0 THEN CONTINUE FOREACH END IF
       LET sr.qty = sr.qty * u_sign
#No.FUN-550025-begin
#      LET xxx=sr.tlf036[1,3] LET g_chr = ''
       CALL s_get_doc_no(sr.tlf036) RETURNING xxx
       LET g_chr = ''
#No.FUN-550025-end
     #MOD-720042 BY TSD.Sora---start---
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=sr.tlf19
       IF SQLCA.sqlcode THEN
          LET l_gem02 = NULL
       END IF
 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01=sr.tlf01
       IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
       END IF
     #MOD-720042 BY TSD.Sora---end---
 
       SELECT smydmy2,smydmy1 INTO g_chr,l_dmy1
         FROM smy_file WHERE smyslip=xxx
       IF g_chr = '1' OR g_chr IS NULL THEN CONTINUE FOREACH END IF
###951108 Add by Jackson 成本
       IF l_dmy1 != 'Y' THEN CONTINUE FOREACH END IF
       IF tm.o='1' THEN 		#(1)工單領用
          IF g_chr != '3' THEN CONTINUE FOREACH END IF
          IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
             (sr.tlf03 >= 60 AND sr.tlf03 <= 69)
             THEN LET g_chr=''
             ELSE CONTINUE FOREACH
          END IF
       END IF
       IF tm.o='2' THEN 		#(2)雜項領用
          IF g_chr != '3' THEN CONTINUE FOREACH END IF
          IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
             (sr.tlf03 >= 60 AND sr.tlf03 <= 69)
             THEN CONTINUE FOREACH
             ELSE LET g_chr=''
          END IF
       END IF
       IF tm.o='3' THEN 		#(3)其他調整
          IF g_chr != '5' THEN CONTINUE FOREACH END IF
       END IF
       IF tm.o='4' THEN 		#(4)銷售出庫
          IF g_chr != '2' THEN CONTINUE FOREACH END IF
       END IF
       SELECT ccc23 INTO sr.up FROM ccc_file
              WHERE ccc01=sr.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm
                AND ccc07='1'                     #No.FUN-840041
       IF sr.up IS NULL THEN LET sr.up=0 END IF
       #No.A102
       IF u_sign = 1 THEN
        #MOD-720042 BY TSD.Sora---start---
         # OPEN cxc_curs USING sr.ima01,sr.tlf036,sr.tlf037
         # FOREACH cxc_curs INTO l_cxc.*
           FOREACH cxc_curs USING sr.ima01,sr.tlf036,sr.tlf037 INTO l_cxc.*
        #MOD-720042 BY TSD.Sora---end---
              IF STATUS THEN
                 CALL cl_err('cxc_curs',STATUS,0) EXIT FOREACH
              END IF
              LET sr.up  = l_cxc.cxc10
              LET sr.qty = l_cxc.cxc08
              LET sr.amt = l_cxc.cxc09
              LET sr.seq = l_cxc.cxc11
             #MOD-720042 BY TSD.Sora---start---
             #OUTPUT TO REPORT gxcr005_rep(sr.*)
              IF cl_null(sr.qty) THEN LET sr.qty=0 END IF
              IF cl_null(sr.up) THEN LET sr.up=0 END IF
              IF cl_null(sr.amt) THEN LET sr.amt=0 END IF
              EXECUTE insert_prep USING
                  sr.tlf19,sr.tlf14,sr.tlf01,sr.ima25,
                  sr.qty,sr.up,sr.amt,
                  l_gem02,l_ima02,l_ima021,g_azi03,g_azi04,g_azi05
           END FOREACH
       ELSE 
           LET sr.amt = sr.tlf21 * -1
          #MOD-720042 BY TSD.Sora---start---
           IF cl_null(sr.qty) THEN LET sr.qty=0 END IF
           IF cl_null(sr.up) THEN LET sr.up=0 END IF
           IF cl_null(sr.amt) THEN LET sr.amt=0 END IF
           IF sr.qty != 0 THEN 
          #MOD-720042 BY TSD.Sora---end---
              LET sr.up= sr.amt / sr.qty
          #MOD-720042 BY TSD.Sora---start---
           END IF
           #OUTPUT TO REPORT gxcr005_rep(sr.*)
           EXECUTE insert_prep USING
               sr.tlf19,sr.tlf14,sr.tlf01,sr.ima25,
               sr.qty,sr.up,sr.amt,
               l_gem02,l_ima02,l_ima021,g_azi03,g_azi04,g_azi05
          #MOD-720042 BY TSD.Sora---end---
 
       END IF
       #end No.A102
  
     END FOREACH
 
     #MOD-720042 BY TSD.Sora---start---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'tlf19,tlf14,ima01,ima39')
          RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.o,";",tm.a,";",tm.b,";",tm.c
     CALL cl_prt_cs3('gxcr005','gxcr005',l_sql,g_str)   #FUN-710080 modify
 
     #FINISH REPORT gxcr005_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #MOD-720042 BY TSD.Sora---end---
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
{REPORT gxcr005_rep(sr)
   DEFINE qty,u_p,amt  LIKE cxc_file.cxc08    #NO.FUN-680145 DEC(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,   #NO.FUN-680145 VARCHAR(1)
          l_gem02   LIKE gem_file.gem02,
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          #No.A102
          sr               RECORD ima01  LIKE ima_file.ima01,
                                  tlf19  LIKE tlf_file.tlf19,
                                  tlf14  LIKE tlf_file.tlf14,
                                  tlf01  LIKE tlf_file.tlf01,
                                  ima25  LIKE ima_file.ima25,
                                  tlf06  LIKE tlf_file.tlf06,
                                  tlf02  LIKE tlf_file.tlf02,
                                  tlf03  LIKE tlf_file.tlf03,
                                  tlf026 LIKE tlf_file.tlf026,
                                  tlf027 LIKE tlf_file.tlf027,
                                  tlf036 LIKE tlf_file.tlf036,
                                  tlf037 LIKE tlf_file.tlf037,
                                  tlf11  LIKE tlf_file.tlf11,
                                  tlf21  LIKE tlf_file.tlf21,
                                  qty    LIKE tlf_file.tlf10,
                                  up     LIKE ccc_file.ccc23,	
                                  amt    LIKE ccc_file.ccc12,
                                  seq    LIKE type_file.num5     #NO.FUN-680145 SMALLINT
                           END RECORD,     #end No.A102
      l_chr        LIKE type_file.chr1          #NO.FUN-680145  VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.tlf19,sr.tlf14,sr.tlf01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      CASE WHEN tm.o='1' LET g_x[1]=g_x[14]
           WHEN tm.o='2' LET g_x[1]=g_x[15]
           WHEN tm.o='3' LET g_x[1]=g_x[16]
           WHEN tm.o='4' LET g_x[1]=g_x[17]
      END CASE
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&','   ',
            g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
   #No.A102
   BEFORE GROUP OF sr.tlf19
      SELECT gem02 INTO l_gem02 FROM gem_file
          WHERE gem01=sr.tlf19
      IF SQLCA.sqlcode THEN
          LET l_gem02 = NULL
      END IF
 
      PRINT COLUMN g_c[31],sr.tlf19,
            COLUMN g_c[32],l_gem02,
            COLUMN g_c[33],sr.tlf14;
   BEFORE GROUP OF sr.tlf01
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01=sr.tlf01
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[34],sr.tlf01,
            COLUMN g_c[35],l_ima02,
            COLUMN g_c[36],l_ima021,
            COLUMN g_c[37],sr.ima25;
 
   ON EVERY ROW
      IF tm.c='Y' THEN
         LET qty=GROUP SUM(sr.qty)
         IF qty = 0 THEN LET qty = NULL END IF
         PRINT COLUMN g_c[38],cl_numfor(sr.qty,38,0),
               COLUMN g_c[39],cl_numfor(sr.up,39,g_azi03),
               COLUMN g_c[40],cl_numfor(sr.amt,40,g_azi04)
      END IF
   AFTER GROUP OF sr.tlf01
      IF tm.b = 'Y' THEN
      PRINT
      PRINT COLUMN g_c[33],sr.tlf14,
            COLUMN g_c[36],g_x[11] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty),38,0),
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt),40,g_azi05)
      PRINT
      END IF
     #end No.A102
   AFTER GROUP OF sr.tlf19
      IF tm.a = 'Y' THEN
         SELECT gem02 INTO l_gem02 FROM gem_file
             WHERE gem01=sr.tlf19
         IF SQLCA.sqlcode THEN
             LET l_gem02 = NULL
         END IF
         PRINT COLUMN g_c[31],sr.tlf19,
               COLUMN g_c[32],l_gem02,
               COLUMN g_c[36],g_x[12] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty),38,0),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt),40,g_azi05)
         PRINT
      END IF
 
   ON LAST ROW
      PRINT COLUMN g_c[36],g_x[13] CLIPPED,
            COLUMN g_c[38],cl_numfor(SUM(sr.qty),38,0),
            COLUMN g_c[40],cl_numfor(SUM(sr.amt),40,g_azi05)
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610037 <001> #
}
