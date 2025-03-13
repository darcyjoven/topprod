# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr341.4gl
# Descriptions...: 銀行存款調節表列印作業
# Date & Author..: 93/04/19  By  Felicity  Tseng
# Modify.........: No.8436 03/10/21 By Kitty nmykindo值若找不到要清空
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-590084 05/09/20 By Dido 公司帳面額額與銀行帳面餘額位置對調
# Modify.........: No.MOD-590413 05/10/07 By Smapmin nmykind不為1.2者,皆視為相同處理
# Modify.........: No.MOD-5A0242 05/10/21 By Smapmin 銀行帳面餘額不符
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-760070 07/06/14 By Smapmin 增加會計日小於等於截止日且銀行日大於截止日的條件
# Modify.........: NO.FUN-830004 08/03/06 By zhaijie 報表修改為CR格式
# Modify.........: NO.MOD-830221 08/04/17 By Carol 調節碼金額未計算
# Modify.........: No.MOD-850294 08/06/09 By Sarah 銀行帳面餘額(l_rest1)需+-調節金額(tot_jamt)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-C50156 12/05/24 By Polly 增加考量anmt150與anmt250產生的銀存異動檔

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_yyyy     LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_mm	     LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_edate,g_bdate LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE tm RECORD
             wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
             more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
         END RECORD
   DEFINE g_i        LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
#NO.FUN-830004-------------------SATRT----------
   DEFINE g_sql      STRING
   DEFINE g_str      STRING
   DEFINE l_table    STRING
   DEFINE l_table1   STRING
   DEFINE l_table2   STRING
#NO.FUN-830004--------------END-------------
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
 
#NO.FUN-830004-----------------START-----------
  LET g_sql = "nma01.nma_file.nma01,  nma02.nma_file.nma02,",
              "nma04.nma_file.nma04,  azi04.azi_file.azi04,",
              "jcode.nmy_file.nmykind,jname.type_file.chr20,",
              "jsign.type_file.chr1,  jdate.type_file.dat,",
              "jcus.nme_file.nme13,   jnote.nme_file.nme17,",
              "jamt.type_file.num20_6,jdesp.nme_file.nme12,",
              "nme02.nme_file.nme02,  nme09.nme_file.nme09,",
              "nmc03.nmc_file.nmc03,  l_rest.type_file.num20_6,",
              "l_rest1.type_file.num20_6"
  LET l_table = cl_prt_temptable('anmr341',g_sql) CLIPPED
  IF  l_table = -1 THEN EXIT PROGRAM END IF
 
  LET g_sql = "nma01.nma_file.nma01,",
              "tot_jname.type_file.chr20,",
              "tot_jsign.type_file.chr1,",
              "tot_jamt.type_file.num20_6,",
              "l_nmk02.nmk_file.nmk02"
   LET l_table1 = cl_prt_temptable('anmr3411',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
#NO.FUN-830004-------------END-----------
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_yyyy = ARG_VAL(8)   #TQC-610058
   LET g_mm = ARG_VAL(9)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r341_tm(0,0)           # Input print condition
      ELSE CALL r341()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
FUNCTION r341_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW r341_w AT p_row,p_col
        WITH FORM "anm/42f/anmr341"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_yyyy = YEAR(g_today)
   LET g_mm   = MONTH(g_today) - 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01,nma10
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
      LET INT_FLAG = 0 CLOSE WINDOW r341_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME g_yyyy,g_mm,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD g_yyyy
         IF g_yyyy IS NULL THEN NEXT FIELD g_yyyy END IF
      AFTER FIELD g_mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yyyy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF g_mm IS NULL THEN NEXT FIELD g_mm END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r341_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
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
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='anmr341'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr341','9031',1)
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
                         " '",g_yyyy CLIPPED,"'" ,   #TQC-610058
                         " '",g_mm CLIPPED,"'" ,   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr341',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r341_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r341()
   ERROR ""
END WHILE
   CLOSE WINDOW r341_w
END FUNCTION
 
FUNCTION r341()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_gt      LIKE nmy_file.nmyslip,  #No.FUN-680107 VARCHAR(03)
          l_kide    LIKE nmy_file.nmykind,  #No.FUN-680107 VARCHAR(02)
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680107 VARCHAR(600)
          l_chr     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE type_file.num20,  #No.FUN-680107 VARCHAR(10)
          l_i       LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_nmk03   LIKE nmk_file.nmk03,
          sr        RECORD
                    nma01 LIKE nma_file.nma01,   #銀行
                    nma02 LIKE nma_file.nma02,   #銀行簡稱
                    nma04 LIKE nma_file.nma04,   #帳號
                    azi04 LIKE azi_file.azi04
                    END RECORD,
          sr2       RECORD
                    jcode LIKE nmy_file.nmykind, #1 2 3 #No.FUN-680107 VARCHAR(02)
                    jname LIKE type_file.chr20,  #應付未兌 應收未兌 其它 #No.FUN-680107 VARCHAR(12)
                    jsign LIKE type_file.chr1,   #-        + #No.FUN-680107 VARCHAR(1)
                    jdate LIKE type_file.dat,    #異動日期 #No.FUN-680107 DATE
                    jcus  LIKE nme_file.nme13,   #廠商/客戶 #NO.FUN-680107 VARCHAR(10)
                    jnote LIKE nme_file.nme17,   #票號 #No.FUN-680107 VARCHAR(10)
                    jamt  LIKE type_file.num20_6,#金額  #No.FUN-680107 DECIMAL(20,6)
                    jdesp LIKE nme_file.nme12,   #CHAR(20),      #參考單號
                    nme02 LIKE nme_file.nme02,
                    nme09 LIKE nme_file.nme09,
                    nmc03 LIKE nmc_file.nmc03
                    END RECORD
#NO.FUN-830004-----------------START-----------
   DEFINE    i     LIKE type_file.num5
   DEFINE    tot   DYNAMIC ARRAY OF RECORD
                    jcode LIKE nmy_file.nmykind, # VARCHAR(02)
                    nme09 LIKE nme_file.nme09,
                    jname LIKE type_file.chr20,  # VARCHAR(12)
                    jsign LIKE type_file.chr1,   # VARCHAR(1)
                    jamt  LIKE type_file.num20_6 # DECIMAL(20,6)
                    END RECORD
   DEFINE    l_nmk02      LIKE nmk_file.nmk02
   DEFINE    l_rest       LIKE type_file.num20_6      #DECIMAL(20,6)
   DEFINE    l_rest1      LIKE type_file.num20_6       #DECIMAL(20,6)
   DEFINE    l_gx36       LIKE zaa_file.zaa08  
   DEFINE    l_gx37       LIKE zaa_file.zaa08  
   DEFINE    l_gx38       LIKE zaa_file.zaa08  
   DEFINE    l_gx39       LIKE zaa_file.zaa08  
   DEFINE    l_gx40       LIKE zaa_file.zaa08  
   DEFINE    l_gx41       LIKE zaa_file.zaa08  
   DEFINE    l_gx42       LIKE zaa_file.zaa08  
   DEFINE    l_gx43       LIKE zaa_file.zaa08  
   DEFINE    l_gx44       LIKE zaa_file.zaa08  
   DEFINE    l_sumjamt    ARRAY[8] OF LIKE type_file.num20_6  #MOD-830221-add
   DEFINE    l_code       LIKE type_file.num5                 #MOD-830221-add
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
   END IF
 
  #str MOD-850294 add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET l_rest1=? WHERE nma01=?"
   PREPARE update_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('update_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
  #end MOD-850294 add
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
#NO.FUN-830004-----------------END-----------
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr341'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT nma01, nma02, nma04, azi04",
               " FROM nma_file, OUTER azi_file",
               " WHERE ", tm.wc CLIPPED,
               "   AND nma_file.nma10 = azi_file.azi01 "
   PREPARE r341_prepare1 FROM l_sql
   IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE r341_curs1 CURSOR FOR r341_prepare1
   SELECT MIN(azn01),MAX(azn01) INTO g_bdate,g_edate
     FROM azn_file WHERE azn02 = g_yyyy AND azn04 = g_mm
#  CALL cl_outnam('anmr341') RETURNING l_name           #NO.FUN-830004
#  START REPORT r341_rep TO l_name                      #NO.FUN-830004 
   LET g_pageno = 0
#NO.FUN-830004-------------START---------
   CALL cl_getmsg('anmr_36',g_lang) RETURNING l_gx36
   CALL cl_getmsg('anmr_37',g_lang) RETURNING l_gx37
   CALL cl_getmsg('anmr_38',g_lang) RETURNING l_gx38
   CALL cl_getmsg('anmr_39',g_lang) RETURNING l_gx39
   CALL cl_getmsg('anmr_40',g_lang) RETURNING l_gx40
   CALL cl_getmsg('anmr_41',g_lang) RETURNING l_gx41
   CALL cl_getmsg('anmr_42',g_lang) RETURNING l_gx42
   CALL cl_getmsg('anmr_43',g_lang) RETURNING l_gx43
   CALL cl_getmsg('anmr_44',g_lang) RETURNING l_gx44
#NO.FUN-830004-------------END-------
   FOREACH r341_curs1 INTO sr.*
      IF STATUS != 0 THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
 
      #No:8436
      DECLARE r341_c1 CURSOR FOR
          SELECT ' ',' ',' ',nme16,nme13,nme17,nme04,
                 nme12,nme02,nme09,nmc03
            FROM nme_file,OUTER nmc_file
           WHERE nme01 = sr.nma01
             AND nme_file.nme03 = nmc_file.nmc01
   #--No:8436 end
 
      LET l_i = 0
 
#MOD-830221-add
      CALL tot.clear()  
      LET l_rest = 0  
      LET l_rest1 = 0
      SELECT nmp16,nmp06 INTO l_rest,l_rest1 FROM nmp_file
       WHERE nmp01 = sr.nma01 
         AND nmp02 = g_yyyy
         AND nmp03 = g_mm
      IF cl_null(l_rest) THEN LET l_rest=0 END IF
      IF cl_null(l_rest1) THEN LET l_rest1=0 END IF
      LET l_rest1 = l_rest   #MOD-850294 add
#MOD-830221-add-end
 
      FOREACH r341_c1 INTO sr2.*             #No:8436
         IF STATUS THEN CALL cl_err('for nmd:',STATUS,1) EXIT FOREACH END IF
        #LET l_gt=sr2.jdesp[1,3]
         LET l_gt = s_get_doc_no(sr2.jdesp)       #No.FUN-550057
         SELECT nmykind INTO l_kide FROM nmy_file
          WHERE nmyslip=l_gt
         IF status THEN LET l_kide=' ' END IF    #No:8436
        #CASE l_kide                                                   #MOD-C50156 mark
        #   WHEN '1'                                                   #MOD-C50156 mark
         CASE                                                          #MOD-C50156 add
            WHEN (l_kide = '1' OR l_kide = 'A')                        #MOD-C50156 add
                 IF ( (sr2.jdate <=g_edate AND
                      (sr2.nme02 IS NULL OR sr2.nme02 > g_edate)) OR
                      (sr2.jdate >g_edate AND
                       sr2.nme02 >=g_bdate AND sr2.nme02 <= g_edate )
                     )
                 THEN
                      SELECT nmk03 INTO l_nmk03 FROM nmk_file
                                  WHERE nmk01 = sr2.nme09
                      IF SQLCA.sqlcode THEN
                         LET l_nmk03 = ' ' CONTINUE FOREACH
                      END IF
                      IF l_nmk03 = '-' THEN
                         LET sr2.jcode='1'
                         LET sr2.jname=l_gx36
                         LET sr2.jsign='-'
                         LET l_sumjamt[1] = ( l_sumjamt[1] + sr2.jamt ) * -1  #MOD-830221-add 
                      ELSE
                         LET sr2.jcode='2'
                         LET sr2.jname=l_gx37
                         LET sr2.jsign='+'
                         LET l_sumjamt[2] = ( l_sumjamt[2] + sr2.jamt )       #MOD-830221-add 
                      END IF
                 ELSE
                    CONTINUE FOREACH
                 END IF
           #WHEN '2'                                                   #MOD-C50156 mark
            WHEN (l_kide = '2' OR l_kide = 'B')                        #MOD-C50156 add
                 IF (sr2.jdate <= g_edate AND
                     (cl_null(sr2.nme02) OR sr2.nme02 > g_edate))
                 OR (sr2.jdate > g_edate AND
                      (sr2.nme02 >=g_bdate AND sr2.nme02 <=g_edate))
                  THEN
                      SELECT nmk03 INTO l_nmk03 FROM nmk_file
                                  WHERE nmk01 = sr2.nme09
                      IF SQLCA.sqlcode THEN
                         LET l_nmk03 = ' ' CONTINUE FOREACH
                      END IF
                      IF l_nmk03 = '-' THEN
                         LET sr2.jcode='3'
                         LET sr2.jname=l_gx38
                         LET sr2.jsign='-'
                         LET l_sumjamt[3] = ( l_sumjamt[3] + sr2.jamt ) * -1  #MOD-830221-add 
                      ELSE
                         LET sr2.jcode='4'
                         LET sr2.jname=l_gx39
                         LET sr2.jsign='+'
                      END IF
                 ELSE
                    CONTINUE FOREACH
                 END IF
           #WHEN '3'      #MOD-590413
            OTHERWISE     #MOD-590413
                 IF (sr2.jdate > g_edate OR sr2.jdate IS NULL) AND
                      (sr2.nme02 IS NULL OR sr2.nme02 <= g_edate)
                 THEN
                      SELECT nmk03 INTO l_nmk03 FROM nmk_file
                                  WHERE nmk01 = sr2.nme09
                      IF SQLCA.sqlcode THEN
                         LET l_nmk03 = ' ' CONTINUE FOREACH
                      END IF
                      IF l_nmk03  = '+' THEN
                         LET sr2.jcode='5'
                         LET sr2.jname=l_gx40
                         LET sr2.jsign='+'
                      ELSE
                         LET sr2.jcode='6'
                         LET sr2.jname=l_gx41
                         LET sr2.jsign='-'
                         LET l_sumjamt[6] = ( l_sumjamt[6] + sr2.jamt ) * -1  #MOD-830221-add 
                      END IF
                 ELSE
                     #-----MOD-760070---------
                     #IF ( ((sr2.jdate >= g_bdate AND sr2.jdate <= g_edate) OR
                     #       sr2.jdate IS NULL)
                     #    AND (sr2.nme02 > g_edate) )
                     #   OR sr2.nme02 IS NULL OR sr2.nme02 = ' '
                     #THEN
                     IF (sr2.jdate <= g_edate OR sr2.jdate IS NULL) AND
                          (sr2.nme02 IS NULL OR sr2.nme02 > g_edate)
                     THEN
                     #-----END MOD-760070-----
                        SELECT nmk03 INTO l_nmk03 FROM nmk_file
                                    WHERE nmk01 = sr2.nme09
                        IF SQLCA.sqlcode THEN
                           LET l_nmk03 = ' ' CONTINUE FOREACH
                        END IF
                        IF l_nmk03  = '-' THEN
                           LET sr2.jcode='7'
                           LET sr2.jname=l_gx42
                           LET sr2.jsign='-'
                           LET l_sumjamt[7] = ( l_sumjamt[7] + sr2.jamt ) * -1  #MOD-830221-add 
                        ELSE
                           LET sr2.jcode='8'
                           LET sr2.jname=l_gx43
                           LET sr2.jsign='+'
                        END IF
                     ELSE
                        CONTINUE FOREACH
                     END IF
                 END IF
            #OTHERWISE CONTINUE FOREACH   #MOD-590413
         END CASE
         LET l_i=l_i+1
        #OUTPUT TO REPORT r341_rep(sr.*, sr2.*)
#NO.FUN-830004-------------START---------------
 
#MOD-830221-modify
#調節碼金額合計
         IF cl_null(sr2.jamt) THEN 
            LET sr2.jamt = 0
         END IF
 
        #FOR i = 1 TO 20   #MOD-850294 mark
         LET i = 1         #MOD-850294 add
        #IF cl_null(tot[i].jcode) THEN    #MOD-850294 mark
            LET tot[i].jcode = sr2.jcode
            LET tot[i].nme09 = sr2.nme09
            LET tot[i].jname = sr2.jname
            LET tot[i].jsign = sr2.jsign
            LET tot[i].jamt  = sr2.jamt      #MOD-830221-add
           #str MOD-850294 add
            IF sr2.jsign='+' THEN
               LET l_rest1 = l_rest1 + sr2.jamt
            ELSE
               LET l_rest1 = l_rest1 - sr2.jamt
            END IF
           #end MOD-850294 add
           #EXIT FOR                         #MOD-830221-add   #MOD-850294 mark
        #str MOD-850294 mark
        #ELSE
        #   IF tot[i].jcode = sr2.jcode THEN
        #      IF sr2.jsign='-' THEN
        #         LET tot[i].jamt  = tot[i].jamt + ( sr2.jamt * -1  )
        #         LET l_rest1 = l_rest1 - sr2.jamt   #MOD-850294 add
        #      ELSE
        #         LET tot[i].jamt  = tot[i].jamt + sr2.jamt
        #         LET l_rest1 = l_rest1 + sr2.jamt   #MOD-850294 add
        #      END IF
        #   END IF
        #  #EXIT FOR                                 #MOD-850294 mark
        #END IF
        #end MOD-850294 mark
        #str MOD-850294 add
         LET l_nmk02 = NULL
         SELECT nmk02 INTO l_nmk02 FROM nmk_file WHERE nmk01 = tot[i].nme09
         EXECUTE insert_prep1 USING
            sr.nma01,tot[i].jname,tot[i].jsign,tot[i].jamt,l_nmk02
        #end MOD-850294 add
        #END FOR   #MOD-850294 mark
#MOD-830221-modify-end
 
         EXECUTE insert_prep USING
            sr.nma01,sr.nma02,sr.nma04,sr.azi04,sr2.jcode,sr2.jname,sr2.jsign,
            sr2.jdate,sr2.jcus,sr2.jnote,sr2.jamt,sr2.jdesp,sr2.nme02,sr2.nme09,
            sr2.nmc03,l_rest,l_rest1
#NO.FUN-830004-----------END----------
       END FOREACH
       IF l_i = 0 THEN
          LET sr2.jdate= ' '
          LET sr2.jcus = ' '
          LET sr2.jnote= ' '
          LET sr2.jamt =  0
          LET sr2.jdesp= ' '
          LET sr2.jcode='9'
          LET sr2.jname=l_gx44
          LET sr2.jsign=' '
#MOD-830221-add
         EXECUTE insert_prep USING
            sr.nma01,sr.nma02,sr.nma04,sr.azi04,sr2.jcode,sr2.jname,sr2.jsign,
            sr2.jdate,sr2.jcus,sr2.jnote,sr2.jamt,sr2.jdesp,sr2.nme02,sr2.nme09,
            sr2.nmc03,l_rest,l_rest1
      END IF
 
      EXECUTE update_prep USING l_rest1,sr.nma01   #MOD-850294 add
 
     #str MOD-850294 mark
     #FOR i = 1 TO 20
     #    IF cl_null(tot[i].jcode) THEN EXIT FOR END IF
     #    EXECUTE insert_prep1 USING 
     #            sr.nma01,tot[i].jcode,tot[i].nme09,tot[i].jname,
     #            tot[i].jsign,tot[i].jamt
     #
     #    LET l_nmk02 = NULL
     #    SELECT nmk02 INTO l_nmk02 FROM nmk_file WHERE nmk01 = tot[i].nme09
     #    EXECUTE insert_prep2 USING
     #           sr.nma01,tot[i].jname,tot[i].jsign,tot[i].jamt,l_nmk02
     #END FOR
     #end MOD-850294 mark
#MOD-830221-add-end
 
   END FOREACH
 
#  FINISH REPORT r341_rep                               #NO.FUN-830004
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-830004
 
#NO.FUN-830004-----------START-----------
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'nma01,nma10')                          
           RETURNING tm.wc
   ELSE
      LET tm.wc=""
   END IF
   LET g_str = tm.wc,";",g_edate
   CALL cl_prt_cs3('anmr341','anmr341',g_sql,g_str)
#NO.FUN-830004--------------END-----------
END FUNCTION
 
 
#NO.FUN-830004------------MARK---START-----
#REPORT r341_rep(sr, sr2)
#   DEFINE l_last_sw LIKE type_file.chr1,                     #No.FUN-680107 VARCHAR(1)
#          sr        RECORD
#                                  nma01 LIKE nma_file.nma01,
#                                  nma02 LIKE nma_file.nma02, #銀行簡稱
#                                  nma04 LIKE nma_file.nma04, #帳號
#                                  azi04 LIKE azi_file.azi04
#                    END RECORD,
#          sr2       RECORD
#                    jcode LIKE nmy_file.nmykind, #No.FUN-680107 VARCHAR(02)
#                    jname LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(12)
#                    jsign LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#                    jdate LIKE type_file.dat,    #No.FUN-680107 DATE
#                    jcus  LIKE nme_file.nme13,   #NO.FUN-680107 VARCHAR(10)
#                    jnote LIKE nme_file.nme17,   #No.FUN-680107 VARCHAR(10)
#                    jamt  LIKE type_file.num20_6,#No.FUN-680107 DECIMAL(20,6)
#                    jdesp LIKE nme_file.nme12,   #No.FUN-680107 VARCHAR(20)
#                    nme02 LIKE nme_file.nme02,
#                    nme09 LIKE nme_file.nme09,
#                    nmc03 LIKE nmc_file.nmc03
#                    END RECORD,
#      tot DYNAMIC ARRAY OF RECORD
#                    jcode LIKE nmy_file.nmykind, #No.FUN-680107 VARCHAR(02)
#                    nme09 LIKE nme_file.nme09,
#                    jname LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(12)
#                    jsign LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#                    jamt  LIKE type_file.num20_6 #No.FUN-680107 DECIMAL(20,6)
#                    END RECORD,
#      i		    LIKE type_file.num5,         #No.FUN-680107 SMALLINT
#      l_nmk02       LIKE nmk_file.nmk02,
#      l_sum         LIKE type_file.num20_6,      #No.FUN-680107 DECIMAL(20,6)
#      l_rest        LIKE type_file.num20_6,      #No.FUN-680107 DECIMAL(20,6)
#      l_rest1       LIKE type_file.num20_6       #No.FUN-680107 DECIMAL(20,6)
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.nma01,sr2.jcode
#
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##No.TQC-6A0110 -- begin --
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#         PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      SKIP 1 LINE
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[45] CLIPPED,g_edate,
#            g_x[46] CLIPPED,sr.nma01 CLIPPED,' ',sr.nma02,' ',
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
##      LET g_pageno = g_pageno + 1
##      LET pageno_total=PAGENO USING '<<<',"/pageno"
##      PRINT g_head CLIPPED,pageno_total
##No.TQC-6A0110 -- end --
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.nma01
#      SKIP TO TOP OF PAGE
#      FOR i = 1 TO 20 INITIALIZE tot[i].* TO NULL END FOR
#
#   BEFORE GROUP OF sr2.jcode
#      PRINT g_x[12] CLIPPED,sr2.jname
#      SKIP 1 LINE
#      IF sr2.jcode MATCHES '[123456789]' THEN
#         PRINT COLUMN 01, g_x[13] CLIPPED,
#               COLUMN 10, g_x[14] CLIPPED,
#               COLUMN 31, g_x[15] CLIPPED,
#               COLUMN 48, g_x[16] CLIPPED,
#               COLUMN 68, g_x[28] CLIPPED
#         PRINT '-------- -------------------- ----------------',COLUMN 48,'-------------------',
#               COLUMN 68,'--------------------'
#      END IF
#
#   ON EVERY ROW
#      IF sr2.jcode MATCHES '[123456789]' THEN
#         PRINT COLUMN 01, sr2.jdate,
#               COLUMN 10, sr2.jcus,
##No.TQC-6A0110 -- begin --
##               COLUMN 21, sr2.jnote,
##               COLUMN 38, cl_numfor(sr2.jamt,18,sr.azi04),
##               COLUMN 60, sr2.jdesp CLIPPED
#               COLUMN 31, sr2.jnote,
#               COLUMN 48, cl_numfor(sr2.jamt,18,sr.azi04),
#               COLUMN 68, sr2.jdesp CLIPPED
#No.TQC-6A0110 -- end --
#      END IF
#
#   AFTER GROUP OF sr2.jcode   #調節碼
#    IF sr2.jcode MATCHES '[123456789]' THEN
#      LET l_sum = GROUP SUM(sr2.jamt)
#      FOR i = 1 TO 20
#         IF cl_null(tot[i].jcode)
#            THEN LET tot[i].jcode = sr2.jcode
#                 LET tot[i].nme09 = sr2.nme09
#                 LET tot[i].jname = sr2.jname
#                 LET tot[i].jsign = sr2.jsign
#         END IF
#         IF tot[i].jcode = sr2.jcode
#            THEN IF tot[i].jsign = '-'
#                    THEN LET tot[i].jamt = l_sum * -1
#                    ELSE LET tot[i].jamt = l_sum
#                 END IF
#                 EXIT FOR
#         END IF
#      END FOR
#      PRINT COLUMN 31, g_x[19] CLIPPED,COLUMN 48,cl_numfor(tot[i].jamt,18,sr.azi04)
#    END IF
#
#   AFTER GROUP OF sr.nma01    #銀行
#      PRINT COLUMN 01, g_x[25] CLIPPED,
#            COLUMN 21, g_x[27] CLIPPED,
#            COLUMN 43, g_x[18] CLIPPED
#      PRINT '-------------------',COLUMN 21,'---------------------',
#            COLUMN 43,'---------------------------------------------'
#      LET l_rest = 0   LET l_rest1 = 0
#      SELECT nmp16,nmp06 INTO l_rest,l_rest1  #公司帳面餘額及出納(銀行)實際餘額
#        FROM nmp_file
#             WHERE nmp01 = sr.nma01 AND nmp02 = g_yyyy AND nmp03 = g_mm
#      IF cl_null(l_rest) THEN LET l_rest=0 END IF
#      IF cl_null(l_rest1) THEN LET l_rest1=0 END IF
#
#      #公司帳面餘額 FUN-590084
##      PRINT g_x[29] CLIPPED,COLUMN 27, cl_numfor(l_rest,18,sr.azi04)   #MOD-590413
#     PRINT g_x[29] CLIPPED,COLUMN 21, cl_numfor(l_rest,18,sr.azi04)   #MOD-590413
# 
#      IF sr2.jcode MATCHES '[123456789]' THEN
#        FOR i = 1 TO 20
#            IF tot[i].jcode IS NULL THEN EXIT FOR END IF
#            LET l_nmk02 = NULL
#            SELECT nmk02 INTO l_nmk02 FROM nmk_file WHERE nmk01 = tot[i].nme09
#            IF tot[i].jsign = '+' THEN PRINT g_x[47] CLIPPED; END IF
#            IF tot[i].jsign = '-' THEN PRINT g_x[48] CLIPPED; END IF
#            PRINT COLUMN 01, tot[i].jname,
#                  COLUMN 21, cl_numfor(tot[i].jamt,18,sr.azi04),
#                  COLUMN 43, l_nmk02
##            LET l_rest1 = l_rest1 + tot[i].jamt    #MOD-5A0242
#        END FOR
#      END IF
#      #銀行帳面餘額 FUN-590084
#      PRINT g_x[35] CLIPPED,COLUMN 21, cl_numfor(l_rest1,18,sr.azi04)
# 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#      LET g_pageno = 0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
##        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-830004---------MARK---END----
#Patch....NO.TQC-610036 <001> #
