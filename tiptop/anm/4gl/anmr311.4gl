# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmr311.4gl
# Descriptions...: 銀行資金預估狀況彙總表列印作業
# Input parameter: 
# Return code....: 
# Date & Author..: 92/06/04 By yen
# Modify.........: 96/06/14 By Lynn   銀行編號(nma01) 取6碼
#                : 96/06/27 By Lynn   增加未付款發票...等,是否納入資金預估
# Modify.........: No.FUN-4C0098 05/01/31 By pengu 報表轉XML
# Modify.........: No.MOD-520089 05/04/15 By Nicola 移除tm.j欄位
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0089 06/03/23 By Carrier AR月底重評價
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680022 06/08/23 By cl     多帳期處理
# Modify.........: NO.FUN-680107 06/09/19 By douzh 類型轉換
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used 
# Modify.........: No.MOD-690020 06/11/03 By Smapmin nne21 還款日是由還本回寫的, 資金預估應是估未來會發生的, 應改用貸款截止日計算才對
# Modify.........: No.CHI-6A0004 06/10/06 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720013 07/03/02 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-750148 07/05/31 By Sarah 帳面餘額欄位是用g_azi04取位，Temptable增加記錄
# Modify.........: No.TQC-770001 07/07/02 By sherry 增加幫助按鈕
# Modify.........: No.MOD-7B0100 07/11/12 By Smapmin 修正SQL語法
# Modify.........: No.MOD-810226 08/01/28 By Smapmin 修正SQL語法
# Modify.........: No.MOD-840024 08/04/03 By Carol SQL調整排除作廢單據
# Modify.........: No.MOD-840088 08/04/11 By Carol SQL語法調整
# Modify.........: No.MOD-8B0169 08/11/18 By Sarah SQL語法調整
# Modify.........: No.MOD-8C0143 08/12/16 By clover SQL語法調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/07 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-C60061 12/06/11 By Elise 修改 DATEADD
# Modify.........: No.MOD-C60202 12/06/25 By Polly 將金額調整為原幣金額抓取
# Modify.........: No.FUN-C60071 12/06/27 By suncx  rvb35 = 'N'改為rvb35<>'Y'
# Modify.........: No.MOD-CC0177 12/12/21 By Polly 應付帳款未付餘額為負數需乘以-1

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                    # Print condition RECORD
                     wc    STRING,             #Where Condiction  #TQC-630166  
                     edate LIKE type_file.dat,         #No.FUN-680107 DATE
                     detail_sw LIKE type_file.chr1,    # 1.明細 2.日計    #No.FUN-680107 VARCHAR(1)
                     e     LIKE type_file.chr1,        #未付款發票        #No.FUN-680107 VARCHAR(1)
                     f     LIKE type_file.chr1,        #未請款進貨        #No.FUN-680107 VARCHAR(1)
                     g     LIKE type_file.chr1,        #未進貨採購        #No.FUN-680107 VARCHAR(1) 
                     h     LIKE type_file.chr1,        #未收款發票        #No.FUN-680107 VARCHAR(1) 
                     i     LIKE type_file.chr1,        #未開發票出貨      #No.FUN-680107 VARCHAR(1)
      #               j    VARCHAR(1),                    #未出貨銷貨        #No.MOD-520089 Mark
                     more  LIKE type_file.chr1         #是否列印其它條件  #No.FUN-680107 VARCHAR(1)
                  END RECORD,
       l_dash     LIKE type_file.chr1000,     #No.FUN-680107 VARCHAR(180)
       bdate      LIKE type_file.dat,         #No.FUN-680107 DATE
       l_sum      LIKE type_file.num20_6,     #總計銀行目前存款餘額       #No.FUN-680107 DECIMAL(20,6)
       first_sw   LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(01)
       g_amt      LIKE nma_file.nma23
DEFINE g_i        LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_head1    STRING
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
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
   LET g_sql = "flag.type_file.chr2,",
               "nmdat.type_file.dat,",
               "bank.nma_file.nma01,",
               "bank_name.nma_file.nma02,",
               "amt1.type_file.num20_6,",  
               "amt2.type_file.num20_6,",  
               "amt3.type_file.num20_6,",  
               "amt4.type_file.num20_6,",
               "amt5.type_file.num20_6,",
               "trno.alb_file.alb04,",
               "whom.alb_file.alb03,",
               "ddesc.type_file.chr1000,",
               "azi04.azi_file.azi04,",      #FUN-750148 add
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('anmr311',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #FUN-750148 add ?
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
   LET tm.edate = ARG_VAL(8)
   LET tm.detail_sw = ARG_VAL(9)
   LET tm.e = ARG_VAL(10)
   LET tm.f = ARG_VAL(11)
   LET tm.g = ARG_VAL(12)
   LET tm.h = ARG_VAL(13)
   LET tm.i = ARG_VAL(14)
 #  LET tm.j = ARG_VAL(15)   #No.MOD-520089 Mark
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.TQC-5C0089 --Begin
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
   #No.TQC-5C0089 --End
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL anmr311_tm()                    # Input print condition
   ELSE
      CALL anmr311()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
 
END MAIN
 
FUNCTION anmr311_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd            LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
          l_flag           LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-680107 VARCHAR(1)
          l_jmp_flag       LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 5
   LET p_col = 12
 
   OPEN WINDOW anmr311_w AT p_row,p_col
     WITH FORM "anm/42f/anmr311"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET bdate = g_today 
   LET tm.edate = g_today  
   LET tm.detail_sw = '1'
   LET tm.e = 'Y'
   LET tm.f = 'Y'
   LET tm.g = 'Y'
   LET tm.h = 'Y'
   LET tm.i = 'Y'
 #  LET tm.j = 'Y'   #No.MOD-520089 Mark
   LET tm.more = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      LET tm.wc = '1=1'
      DISPLAY BY NAME tm.edate,tm.more       # Condition
 
       INPUT BY NAME tm.edate,tm.detail_sw,tm.e,tm.f,tm.g,tm.h,tm.i,   #tm.j,   #No.MOD-520089 Mark
                    tm.more  WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
      
         AFTER FIELD edate
            IF tm.edate IS NULL OR tm.edate = ' ' THEN
               LET tm.edate = g_lastdat
               DISPLAY BY NAME tm.edate
               NEXT FIELD edate
            END IF
 
         AFTER FIELD detail_sw
            IF tm.detail_sw NOT MATCHES "[123]" THEN
               NEXT FIELD detail_sw
            END IF
      
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES "[YN]" THEN
               NEXT FIELD e 
            END IF
      
         AFTER FIELD f
            IF cl_null(tm.f) OR tm.f NOT MATCHES "[YN]" THEN
               NEXT FIELD f
            END IF
      
         AFTER FIELD g
            IF cl_null(tm.g) OR tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
      
         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES "[YN]" THEN 
               NEXT FIELD h
            END IF
      
         AFTER FIELD i
            IF cl_null(tm.i) OR tm.i NOT MATCHES "[YN]" THEN
               NEXT FIELD i
            END IF
      
         #AFTER FIELD j   #No.MOD-520089 Mark
        #   IF cl_null(tm.j) OR tm.j NOT MATCHES "[YN]" THEN
        #      NEXT FIELD j
        #   END IF
     
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' ' THEN
               NEXT FIELD more
            END IF
 
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag = 'N'
         
            IF INT_FLAG THEN 
               EXIT INPUT 
            END IF
         
            IF tm.edate IS NULL THEN  
               LET l_flag='Y'
               DISPLAY BY NAME tm.edate 
               NEXT FIELD edate
            END IF
         
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD bdate
            END IF
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         
         ON ACTION help          #No.TQC-770001                           
            CALL cl_show_help()  #No.TQC-770001
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr311_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='anmr311'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('anmr311','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.detail_sw CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.g CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.i CLIPPED,"'",
                       # " '",tm.j CLIPPED,"'",   #No.MOD-520089 Mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('anmr311',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW anmr311_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmr311()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmr311_w
 
END FUNCTION
 
FUNCTION anmr311()
   DEFINE l_name      LIKE type_file.chr20,    # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0082
          l_sql       LIKE type_file.chr1000,  # RDSQL STATEMENT                #No.FUN-680107 VARCHAR(1200)
          l_za05      LIKE type_file.chr1000,  #標題內容                        #No.FUN-680107 VARCHAR(40)
          l_order     ARRAY[2] OF LIKE alb_file.alb03,  #排列順序               #No.FUN-680107 VARCHAR(10)
          l_rva05     LIKE rva_file.rva05,
          l_pmm20     LIKE pmm_file.pmm20,
          sr          RECORD 
                       flag  LIKE type_file.chr2,        #10:N/P               #No.FUN-680107 VARCHAR(2)
                                               #20:人工輸入預計提出
                                               #21:已請款未付清
                                               #22:待抵帳未抵完
                                               #23:已進貨未請款
                                               #24:已採購未進貨
                                               #25:已贖單未還款
                                               #30:N/R
                                               #40:人工輸入預計存入
                                               #41:已開發票未收清
                                               #42:待抵帳未抵完
                                               #43:出貨未開發票
                                               #44:已受訂未出貨
                       nmdat LIKE type_file.dat,      #No.FUN-680107 DATE
                       bank  LIKE nma_file.nma01,
                       amt1  LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                       amt2  LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                       amt3  LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                       amt4  LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                       amt5  LIKE type_file.num20_6,  #融資/中長貸  #No.FUN-680107 DECIMAL(20,6)
                       trno  LIKE alb_file.alb04,     #No.FUN-680107 VARCHAR(10)
                       whom  LIKE alb_file.alb03,     #No.FUN-680107 VARCHAR(10)
                       desc  LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(40)
                      END RECORD
   DEFINE l_pma03     LIKE pma_file.pma03           #No.FUN-680107 VARCHAR(1)
   DEFINE l_pma08,l_pma09,l_pma10    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_gga03,l_gga04            LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_gga05,l_gga051,l_gga07,l_gga071  LIKE type_file.num5      #No.FUN-680107 SMALLINT
   DEFINE l_paydate  LIKE type_file.dat,              #No.FUN-680107 DATE
          l_apa24    LIKE apa_file.apa24
   DEFINE l_rate,l_days              LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_nma02    LIKE nma_file.nma02  #CR11
   DEFINE l_pmn02    LIKE pmn_file.pmn02  #MOD-8C0143 
   DEFINE l_azw01    LIKE azw_file.azw01  #FUN-A60056
     LET first_sw = 'y'
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   #FUN-720013 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #FUN-720013 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
#NO.CHI-6A0004--BEGIN
#   SELECT azi04 INTO g_azi04
#            FROM azi_file WHERE azi01 = g_aza.aza17  #nma10 ??
#   IF SQLCA.sqlcode THEN 
#     CALL cl_err(g_azi04,SQLCA.sqlcode,0) #FUN-660148
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#   END IF
#NO.CHI-6A0004--END
#  CALL cl_outnam('anmr311') RETURNING l_name   #CR11
#========================================================================
#   CALL cl_outnam('anmr311') RETURNING l_name  #CR11
#   START REPORT anmr311_rep TO l_name          #CR11
   LET g_pageno = 0
#----------------------------------- 10.(到期日) -------------------------
  #LET l_sql = "SELECT '10',nmd05,nmd03,nmd04*nmd19*-1,'0','0','0','0',",    #MOD-C60202 mark
   LET l_sql = "SELECT '10',nmd05,nmd03,nmd04*-1,'0','0','0','0',",          #MOD-C60202 add
               "       nmd02,nmd09,''",
               " FROM nmd_file",
             # " WHERE nmd05 <= '",tm.edate,"' AND nmd12 MATCHES '[1]'"
             #No.+115 010514 by linda mod
               " WHERE nmd05 <= '",tm.edate,"' AND nmd12 IN ('1','X')",
               "   AND nmd30 <> 'X' "
     PREPARE anmr311_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('anmr311_prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE anmr311_curs1 CURSOR FOR anmr311_prepare1
     FOREACH anmr311_curs1 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH 
       END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
       IF sr.amt1 IS NULL THEN LET sr.amt1 = 0  END IF
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
 
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
#----------------------------------- 30. (預兌日)-------------------------
  #LET l_sql = "SELECT '30',nmh09,nmh21,'0','0',nmh02*nmh28,'0','0',",    #MOD-C60202 mark
   LET l_sql = "SELECT '30',nmh09,nmh21,'0','0',nmh02,'0','0',",          #MOD-C60202 add
               "       nmh01,nmh30,''",
               " FROM nmh_file",
               " WHERE nmh38 <> 'X'  ",
               "   AND nmh09 <= '",tm.edate,"' AND nmh24 IN ('1','2','3','4') "  #MOD-8B0169
     PREPARE anmr311_prepare2 FROM l_sql
     IF STATUS THEN
        CALL cl_err('anmr311_prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr311_curs2 CURSOR FOR anmr311_prepare2
     FOREACH anmr311_curs2 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach3:',STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT FOREACH 
       END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
       IF sr.amt3 IS NULL THEN LET sr.amt3 = 0  END IF
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
#----------------------------------- 20/40. ---------------------------------
   LET l_sql = "SELECT nmc03,nmj02,nmj01,'0','0','0',nmj04,'0',",
               "       '','',nmj05",
               " FROM nmj_file, nmc_file",
               " WHERE nmj02 <= '",tm.edate,"' AND nmj06 = 'N'",
               "   AND nmj03 = nmc01"
     PREPARE anmr311_prepare3 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('anmr311_prepare3:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr311_curs3 CURSOR FOR anmr311_prepare3
     FOREACH anmr311_curs3 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach3:',STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT FOREACH
       END IF
       IF sr.flag = '2'
          THEN LET sr.flag = '20' LET sr.amt2 = sr.amt4*-1 LET sr.amt4 = 0
          ELSE LET sr.flag = '40'
       END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
#----------------------------------- 51. ---------------------------------
  #LET l_sql = "SELECT '51',nne21,nne04,'0','0','0','0',(nne19-nne20)*-1,",   #MOD-C60202 mark
   LET l_sql = "SELECT '51',nne21,nne04,'0','0','0','0',(nne12-nne27)*-1,",   #MOD-C60202 add
               "       nne01,'',''",
               " FROM nne_file",
               #" WHERE nne21 <= '",tm.edate,"' AND nneconf='Y' ",   #MOD-690020
               " WHERE nne112 <= '",tm.edate,"' AND nneconf='Y' ",   #MOD-690020
               #" AND (nne26 IS NULL OR nne26=' ')"    #MOD-7B0100
               " AND nne26 IS NULL "    #MOD-7B0100
     PREPARE anmr311_prepare50 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('anmr311_prepare50:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr311_curs50 CURSOR FOR anmr311_prepare50
     FOREACH anmr311_curs50 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach50:',STATUS,1) 
          EXIT FOREACH 
       END IF
       MESSAGE sr.flag,' ',sr.amt5
       CALL ui.Interface.refresh()
       IF sr.amt5 IS NULL THEN LET sr.amt5 = 0  END IF
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
#----------------------------------- 52. ---------------------------------
  #LET l_sql = "SELECT '52',nnh03,nng04,'0','0','0','0',nnh04*-1,",         #MOD-C60202 mark
   LET l_sql = "SELECT '52',nnh03,nng04,'0','0','0','0',nnh04f*-1,",        #MOD-C60202 add
               "       nng01,'',''",
               " FROM nng_file,nnh_file",
               " WHERE nng01=nnh01 AND nngconf='Y' ",
               " AND nnh03 BETWEEN '",g_today,"' AND '",tm.edate,"'",
               " AND nng15='2'" 
     PREPARE anmr311_prepare51 FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('anmr311_prepare51:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE anmr311_curs51 CURSOR FOR anmr311_prepare51
     FOREACH anmr311_curs51 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach51:',STATUS,1) EXIT FOREACH 
       END IF
       MESSAGE sr.flag,' ',sr.amt5
       CALL ui.Interface.refresh()
       IF sr.amt5 IS NULL THEN LET sr.amt5 = 0  END IF
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#      OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
#----------------------------------- 21/22. ---------------------------------
  #96-06-27 Modify By Lynn
  IF tm.e = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz14
#--modi by kitty bug no:A059
#  LET l_sql ="SELECT apa00,apa12+apa24,'','0',(apa34-apa35)*-1,'0','0',",
  #LET l_sql ="SELECT apa00,apa12+apa24,'','0',apa73*-1,'0','0',",   #No.FUN-680027 mark
# #LET l_sql ="SELECT apa00,DATEADD(day,apa24,apc04),'','0',apc13*-1,'0','0',",   #No.FUN-680027 add   #No.FUN-B80067---MARK---
  #LET l_sql ="SELECT apa00,(apa24+apc04),'','0',apc13*-1,'0','0',",                                    #No.FUN-B80067---轉換DATEADD函數---  #MOD-C60061 mark
  #LET l_sql ="SELECT apa00,apc04,'','0',apc13*-1,'0','0',",             #MOD-C60061 #MOD-C60202 mark
  #LET l_sql ="SELECT apa00,apc04,'','0',apc08-apc10-apc14,'0','0',",             #MOD-C60202 add #MOD-CC0177 mark
   LET l_sql ="SELECT apa00,apc04,'','0',(apc08-apc10-apc14)*-1,'0','0',",        #MOD-CC0177 add
               "      '0',apa01,pmc03,'',apa24 ",               #MOD-C60061 add apa24
              #"  FROM apa_file, OUTER pmc_file",          #No.FUN-680027 mark
               "  FROM apc_file,apa_file, OUTER pmc_file", #No.FUN-680027 add
              #" WHERE apa12 BETWEEN '",bdate,"' AND '",tm.edate,"'",   #No.FUN-680027  mark
               " WHERE apc04 BETWEEN '",bdate,"' AND '",tm.edate,"'",   #No.FUN-680027  add
   #           "   AND apa34 > apa35",
              #"   AND apa73 > 0    ",         #A059     #No.FUN-680027 mark
               "   AND apc13 > 0    ",         #A059     #No.FUN-680027
               "   AND apa_file.apa06 = pmc_file.pmc01",
               "   AND apa42 = 'N' ",
               "   AND apa01 = apc01 "   #MOD-810226
     PREPARE r311_p21 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p21:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c21 CURSOR FOR r311_p21
     FOREACH r311_c21 INTO sr.*,l_apa24        #MOD-C60061 add l_apa24
       IF STATUS THEN 
          CALL cl_err('foreach21:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT FOREACH END IF
       LET sr.nmdat = sr.nmdat + l_apa24    #MOD-C60061 add
       IF sr.nmdat > tm.edate THEN CONTINUE FOREACH END IF
       IF sr.amt2 IS NULL THEN LET sr.amt2 = 0  END IF
       IF sr.flag[1,1]='1'
          THEN LET sr.flag = '21'
          ELSE LET sr.flag = '22'
               LET sr.amt2 = sr.amt2 * -1
       END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
  END IF
#----------------------------------- 23 -------------------------------------
 #96-06-27 Modify By Lynn
 IF tm.f = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz15
  #FUN-A60056--add--str--
   LET l_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azw02 = '",g_legal,"'",
               "   AND azwacti = 'Y'"
   PREPARE sel_azw01 FROM l_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01
   FOREACH sel_azw01_cur INTO l_azw01
  #FUN-A60056--add--end
  #LET l_sql = "SELECT '23',rva06,'','0',(rvb09-rvb06)*pmn44*-1,'0','0','0',",   #MOD-690020
  #LET l_sql = "SELECT '23',rva06,'','0',(rvb87*pmn44)*-1,'0','0','0',",   #MOD-690020 #MOD-C60202 mark
   LET l_sql = "SELECT '23',rva06,'','0',(rvb87*pmn31)*-1,'0','0','0',",   #MOD-C60202 add
               "       rva01,pmc03,'',pma03,pma08,pma09,pma10,pmm20,rva05",
#FUN-A70139--mod--str---改為標準sql語法
#             #FUN-A60056--mod--str--
#             #"  FROM rva_file, rvb_file, pmn_file, pmm_file,",
#             #"       OUTER pma_file, OUTER pmc_file",
#              "  FROM ",cl_get_target_table(l_azw01,'rva_file'),",",
#              "       ",cl_get_target_table(l_azw01,'rvb_file'),",",
#              "       ",cl_get_target_table(l_azw01,'pmn_file'),",",
#              "       ",cl_get_target_table(l_azw01,'pmm_file'),",",
#              "  OUTER ",cl_get_target_table(l_azw01,'pma_file'),",",
#              "  OUTER ",cl_get_target_table(l_azw01,'pmc_file'),
#             #FUN-A60056--mod--end
#              " WHERE rva06 BETWEEN '",bdate,"' AND '",tm.edate,"'",
#              "   AND rva01 = rvb01 AND rvb04 = pmn01 AND rvb03 = pmn02",
#              "   AND rvb04 = pmm01 AND pmm_file.pmm20 = pma_file.pma01 AND pmm18 !='X' ",
#              "   AND rva_file.rva05 = pmc_file.pmc01 AND rvaconf <> 'X'",
#              "   AND pmm18 <> 'X' ",                     #MOD-840024-add
#              "   AND rvb35 = 'N'",
#              "   AND rvb09 > rvb06"
               "  FROM ",cl_get_target_table(l_azw01,'rva_file'),
               "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'pmc_file'),
               "    ON rva_file.rva05 = pmc_file.pmc01 ,",
               "       ",cl_get_target_table(l_azw01,'rvb_file'),",",
               "       ",cl_get_target_table(l_azw01,'pmn_file'),",",
               "       ",cl_get_target_table(l_azw01,'pmm_file'),
               "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'pma_file'),
               "    ON pmm_file.pmm20 = pma_file.pma01  ",
               " WHERE rva06 BETWEEN '",bdate,"' AND '",tm.edate,"'",
               "   AND rva01 = rvb01 AND rvb04 = pmn01 AND rvb03 = pmn02",
               "   AND rvb04 = pmm01 AND pmm18 !='X' ",
               "   AND rvaconf <> 'X'",
               "   AND pmm18 <> 'X' ",
              #"   AND rvb35 = 'N'",     #FUN-C60071 mark
               "   AND rvb35 <> 'Y' ",   #FUN-C60071 add
               "   AND rvb09 > rvb06"
#FUN-A70139--mod--end
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A60056
     CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql    #FUN-A60056
     PREPARE r311_p23 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p23:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c23 CURSOR FOR r311_p23
     FOREACH r311_c23 INTO sr.*,l_pma03,l_pma08,l_pma09,l_pma10,l_pmm20,l_rva05
       IF STATUS THEN 
          CALL cl_err('foreach23:',STATUS,1) EXIT FOREACH 
       END IF
     #No.+106 010507 mod by linda
     # CALL pay_date(sr.nmdat,l_pma03,l_pma08,l_pma09,l_pma10)
     #               RETURNING sr.nmdat
       CALL s_paydate('a','',sr.nmdat,sr.nmdat,l_pmm20,l_rva05)
                     RETURNING l_paydate,sr.nmdat,l_apa24  
     #No+106 end---
       IF sr.amt2 IS NULL THEN LET sr.amt2 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
    END FOREACH   #FUN-A60056
  END IF
#----------------------------------- 24 -------------------------------------
 #96-06-27 Modify By Lynn
 IF tm.g = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz16
   LET l_sql = "SELECT azw01 FROM azw_file",
               " WHERE azw02 = '",g_legal,"' AND azwacti = 'Y'"
   PREPARE sel_azw01_pre1 FROM l_sql
   DECLARE sel_azw01_cur1 CURSOR FOR sel_azw01_pre1
   FOREACH sel_azw01_cur1 INTO l_azw01
  #LET l_sql = "SELECT '24',pmn34,'','0',(pmn20-pmn50-pmn58)*pmn44*-1,'0','0',",   #MOD-690020
  #LET l_sql = "SELECT '24',pmn34,'','0',(pmn87-pmn50-pmn58)*pmn44*-1,'0','0',",   #MOD-690020 #MOD-C60202 mark
   LET l_sql = "SELECT '24',pmn34,'','0',(pmn87-pmn50-pmn58)*pmn31*-1,'0','0',",   #MOD-C60202 add
               "    '0', pmn01,pmc03,'',pma03,pma08,pma09,pma10,pmm20,pmm09,pmn02",  #MOD-8C0143
              #FUN-A60056--mod--str--
              #"  FROM pmn_file, pmm_file, OUTER pma_file, OUTER pmc_file",
               "  FROM ",cl_get_target_table(l_azw01,'pmn_file'),",",
               "       ",cl_get_target_table(l_azw01,'pmm_file'),",",
               " OUTER ",cl_get_target_table(l_azw01,'pma_file'),",",
               " OUTER ",cl_get_target_table(l_azw01,'pmc_file'),
              #FUN-A60056--mod--end
               " WHERE pmn34 BETWEEN '",bdate,"' AND '",tm.edate,"'",
               "   AND pmn01 = pmm01 AND pmm_file.pmm20 = pma_file.pma01",
               "   AND pmm18 <> 'X' ",                     #MOD-840024-add
               "   AND pmm_file.pmm09 = pmc_file.pmc01",
               "   AND pmn16 = '2' AND pmn20 > (pmn50+pmn58)"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A60056
     CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql     #FUN-A60056
     PREPARE r311_p24 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p24:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c24 CURSOR FOR r311_p24
     FOREACH r311_c24 INTO sr.*,l_pma03,l_pma08,l_pma09,l_pma10,l_pmm20,l_rva05,l_pmn02  #MOD-8C0143
       IF STATUS THEN 
          CALL cl_err('foreach24:',STATUS,1) EXIT FOREACH 
       END IF
       SELECT AVG(ala21),AVG(ala22) INTO l_rate,l_days
           FROM alb_file,ala_file
          #WHERE alb04 = sr.trno AND alb05 = l_pmn01 AND alb01 = ala01
          WHERE alb04 = sr.trno AND alb05 = l_pmn02 AND alb01 = ala01   #MOD-8C0143
            AND alafirm <> 'X' #modi 01/08/14
       IF l_rate > 0
          THEN LET sr.nmdat = sr.nmdat + l_days
               LET sr.amt2  = sr.amt2  * (100 - l_rate) / 100
          ELSE 
             #No.+106 010507 add by linda
             #  CALL pay_date(sr.nmdat,l_pma03,l_pma08,l_pma09,l_pma10)
             #       RETURNING sr.nmdat
                CALL s_paydate('a','',sr.nmdat,sr.nmdat,l_pmm20,l_rva05)
                     RETURNING l_paydate,sr.nmdat,l_apa24  
             #No+106 end---
       END IF
       IF sr.amt2 IS NULL THEN LET sr.amt2 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
   END FOREACH    #FUN-A60056
  END IF
#----------------------------------- 25 -------------------------------------
#bugno:6496 mark...........................................................
{
 #96-06-27 Modify By Lynn
 IF tm.e = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz14
   LET l_sql = "SELECT '25',ald31,'','0',ald33*-1,'0','0','0',",
               "       ald01,'',''",
               "  FROM ald_file",
               " WHERE ald31 BETWEEN '",bdate,"' AND '",tm.edate,"'",
               "   AND ald34 IS NULL"
     PREPARE r311_p25 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p25:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c25 CURSOR FOR r311_p25
     FOREACH r311_c25 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach25:',STATUS,1) EXIT FOREACH 
       END IF
       IF sr.amt2 IS NULL THEN LET sr.amt2 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
  END IF
}
#bugno:6496 end...........................................................
#----------------------------------- 41 -------------------------------------
 #96-06-27 Modify By Lynn
 IF tm.h = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz17
  #LET l_sql = "SELECT '41',oma11,'','0','0','0',(oma54t-oma55),'0',",
#No.FUN-680022--begin-- mark
# #no.2643應抓本幣金額
#  #No.TQC-5C0089  --Begin
#  IF g_ooz.ooz07 = 'N' THEN
#     LET l_sql = "SELECT '41',oma11,'','0','0','0',oma56t-oma57,'0',",
#                 "       oma01,oma032,''",
#                 "  FROM oma_file",
#                 " WHERE oma11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
#                 "   AND oma00 MATCHES '1*' AND oma56t-oma57 > 0    "
#  ELSE
#     LET l_sql = "SELECT '41',oma11,'','0','0','0',oma61,'0',",
#                 "       oma01,oma032,''",
#                 "  FROM oma_file",
#                 " WHERE oma11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
#                 "   AND oma00 MATCHES '1*' AND oma61 > 0    "
#  END IF
#  #No.TQC-5C0089  --End
#No.FUN-680022--end-- mark
#No.FUN-680022--begin-- add
#資料抓取omc_file
  #IF g_ooz.ooz07 = 'N' THEN                                            #MOD-C60202 mark
  #LET l_sql = "SELECT '41',omc04,'','0','0','0',omc09 -omc11,'0',",    #MOD-C60202 mark
   LET l_sql = "SELECT '41',omc04,'','0','0','0',omc08 -omc10,'0',",    #MOD-C60202 add
               "       omc01,oma032,''",
               "  FROM oma_file,omc_file",
               " WHERE omc04 BETWEEN '",bdate,"' AND '",tm.edate,"'",
               "   AND oma00 MATCHES '1*' AND omc09 -omc11 > 0    ",
               "   AND omavoid = 'N' ",         #MOD-840024-add
               "   AND oma01=omc01 "
  #----------------------MOD-C60202-----------------------------mark
  #ELSE
  #   LET l_sql = "SELECT '41',omc04,'','0','0','0',omc13,'0',",
  #               "       omc01,oma032,''",
  #               "  FROM oma_file,omc_file",
  #               " WHERE oma11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
  #               "   AND oma00 MATCHES '1*' AND omc13 > 0 ",   #MOD-840024-modify
  #               "   AND omavoid = 'N' ",         #MOD-840024-add
  #               "   AND oma01=omc01 "            #MOD-840024-modify
  #END IF
  #----------------------MOD-C60202-----------------------------mark
#No.FUN-680022--end-- add
     PREPARE r311_p41 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p41:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c41 CURSOR FOR r311_p41
     FOREACH r311_c41 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach41:',STATUS,1) EXIT FOREACH 
       END IF
       IF sr.amt4 IS NULL THEN LET sr.amt4 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
  END IF
#----------------------------------- 42 -------------------------------------
 #96-06-27 Modify By Lynn
 IF tm.h = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz17
  #LET l_sql = "SELECT '42',oma11,'','0','0','0',(oma54t-oma55)*-1,'0',",
#No.FUN-680022--begin-- mark
# #no.2643應抓本幣金額
#  #No.TQC-5C0089  --Begin
#  IF g_ooz.ooz07 = 'N' THEN
#     LET l_sql = "SELECT '42',oma11,'','0','0','0',(oma56t-oma57)*-1,'0',",
#                 "       oma01,oma032,''",
#                 "  FROM oma_file",
#                 " WHERE oma11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
#                 "   AND oma00 MATCHES '2*' AND oma56t-oma57 > 0    "
#  ELSE
#     LET l_sql = "SELECT '42',oma11,'','0','0','0',oma61*-1,'0',",
#                 "       oma01,oma032,''",
#                 "  FROM oma_file",
#                 " WHERE oma11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
#                 "   AND oma00 MATCHES '2*' AND oma61 > 0    "
#  END IF
#  #No.TQC-5C0089  --End 
#No.FUN-680022--end-- mark
#No.FUN-680022--begin-- add
#資料抓取omc_file
  #IF g_ooz.ooz07 = 'N' THEN                                                      #MOD-C60202 mark
  #LET l_sql = "SELECT '42',omc04,'','0','0','0',(omc09 -omc11)*-1,'0',",         #MOD-C60202 mark
   LET l_sql = "SELECT '42',omc04,'','0','0','0',(omc08 -omc10)*-1,'0',",         #MOD-C60202 add
               "       omc01,oma032,''",
               "  FROM oma_file,omc_file",
               " WHERE omc04 BETWEEN '",bdate,"' AND '",tm.edate,"'",
               "   AND oma00 MATCHES '2*' AND omc09 -omc11 > 0    ",
               "   AND omavoid = 'N' ",        #MOD-840024-add
               "   AND oma01=omc01 "
  #----------------------MOD-C60202-----------------------------mark
  #ELSE
  #   LET l_sql = "SELECT '42',omc04,'','0','0','0',omc13*-1,'0',",
  #               "       omc01,oma032,''",
  #               "  FROM oma_file,omc_file",
  #               " WHERE omc04 BETWEEN '",bdate,"' AND '",tm.edate,"'",
  #               "   AND oma00 MATCHES '2*' AND omc13 > 0 ",     #MOD-840024-modify
  #               "   AND omavoid = 'N' ",        #MOD-840024-add
  #               "   AND oma01=omc01 "           #MOD-840024-modify
  #END IF
  #----------------------MOD-C60202-----------------------------mark
#No.FUN-680022--end-- add
     PREPARE r311_p42 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p42:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c42 CURSOR FOR r311_p42
     FOREACH r311_c42 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach42:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT FOREACH END IF
       IF sr.amt4 IS NULL THEN LET sr.amt4 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
  END IF
#----------------------------------- 43 -------------------------------------
 #96-06-27 Modify By Lynn
 IF tm.i = 'Y' THEN
   LET bdate = g_today - g_nmz.nmz18
   LET l_sql = "SELECT azw01 FROM azw_file",
               " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'"
   PREPARE sel_azw01_pre2 FROM l_sql
   DECLARE sel_azw01_cur2 CURSOR FOR sel_azw01_pre2
   FOREACH sel_azw01_cur2 INTO l_azw01
  #LET l_sql = "SELECT '43',oga11,'','0','0','0',oga53,'0',",
  #no.2643應抓本幣金額
  #LET l_sql = "SELECT '43',oga11,'','0','0','0',(oga53*oga24),'0',",    #MOD-C60202 mark
   LET l_sql = "SELECT '43',oga11,'','0','0','0',oga53,'0',",            #MOD-C60202 add
               "       oga01,oga032,''",
              #"  FROM oga_file",   #FUN-A60056
               "  FROM ",cl_get_target_table(l_azw01,'oga_file'),      #FUN-A60056
               " WHERE oga11 BETWEEN '",bdate,"' AND '",tm.edate,"'",
              #No.FUN-610020  --Begin
              #"   AND oga09='2' AND oga10 IS NULL",
               "   AND oga09 IN ('2','8') AND oga10 IS NULL",
               "   AND oga65 ='N' ",  #No.FUN-610020
              #No.FUN-610020  --End  
               "   AND ogaconf != 'X' " #01/08/20 mandy
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A60056
     CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql   #FUN-A60056
     PREPARE r311_p43 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('r311_p43:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE r311_c43 CURSOR FOR r311_p43
     FOREACH r311_c43 INTO sr.*
       IF STATUS THEN 
          CALL cl_err('foreach43:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT FOREACH END IF
       IF sr.amt4 IS NULL THEN LET sr.amt4 = 0  END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
 
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank;
       IF STATUS THEN LET l_nma02 = ' ' END IF
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.flag, sr.nmdat, sr.bank, l_nma02, sr.amt1,
                                 sr.amt2, sr.amt3,  sr.amt4, sr.amt5,
                                 sr.trno, sr.whom,  sr.desc, g_azi04, g_azi05   #FUN-750148 add g_azi04
       #------------------------------ CR (3) ------------------------------#
       #FUN-720013 - END
#       OUTPUT TO REPORT anmr311_rep(sr.*)
     END FOREACH
   END FOREACH   #FUN-A60056
  END IF
#------------------------------------------------------------------------
#     FINISH REPORT anmr311_rep    #CR11
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #CR11
 
   #FUN-720013 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   CALL r311_calbal()   #計算餘額
   LET l_sum=g_amt   
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
   LET g_str = g_str,";",l_sum,";",tm.detail_sw,";",tm.edate
   CALL cl_prt_cs3('anmr311','anmr311',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #FUN-720013 - END
 
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END FUNCTION
 
FUNCTION pay_date(ddate,l_pma03,l_pma08,l_pma09,l_pma10)
   DEFINE ddate           LIKE type_file.dat       #No.FUN-680107 DATE
   DEFINE start_date      LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(8)
          l_monday        LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(8)
          l_date          LIKE type_file.dat,      #No.FUN-680107 DATE
          l_bdate,l_edate LIKE type_file.dat       #No.FUN-680107 DATE
   DEFINE l_pma03         LIKE pma_file.pma03      #No.FUN-680107 VARCHAR(1)
   DEFINE l_pma08,l_pma09,l_pma10   LIKE type_file.num5    #No.FUN-680107 SMALLINT
    
   IF l_pma03 IS NULL THEN RETURN ddate END IF
   LET start_date = ddate USING 'yyyymmdd'
   IF l_pma03 MATCHES "[456]"
      THEN LET start_date[5,6] = (start_date[5,6] + 1) USING '&&'
           IF start_date[5,6] = '13' THEN
              LET start_date[1,4] = (start_date[1,4] + 1) USING '&&&&'
              LET start_date[5,6] = '01'
           END IF
   END IF
   IF l_pma09 > 0 THEN               #起算日起加幾月
      LET start_date[5,6] = (start_date[5,6] + l_pma09) USING '&&'
      IF start_date[5,6] > '12' THEN
         LET start_date[1,4] = (start_date[1,4] + 1)  USING '&&&&'
         LET start_date[5,6] = (start_date[5,6] - 12) USING '&&'
      END IF
      LET ddate= MDY(start_date[5,6],start_date[7,8],start_date[1,4])
   END IF
   #判斷該日期是否合理日期
   LET l_date = MDY(start_date[5,6],1,start_date[1,4])
   CALL s_mothck(l_date) RETURNING l_bdate,l_edate
   LET l_monday = l_edate USING 'yyyymmdd'
   IF start_date[7,8] > l_monday[7,8] THEN
      LET start_date[7,8]=l_monday[7,8]
   END IF
   LET ddate = MDY(start_date[5,6],start_date[7,8],start_date[1,4])
   LET ddate = ddate + l_pma08 + l_pma10
   RETURN ddate
END FUNCTION
 
FUNCTION rec_date(ddate,l_gga03,l_gga04,l_gga05,l_gga051,l_gga07,l_gga071)
   DEFINE ddate                LIKE type_file.dat       #No.FUN-680107 DATE
   DEFINE start_date           LIKE type_file.chr20     #No.FUN-680107 VARCHAR(8)
   DEFINE l_gga03,l_gga04      LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
   DEFINE l_gga05,l_gga051,l_gga07,l_gga071     LIKE type_file.num5     #No.FUN-680107 SMALLINT
    
   IF l_gga03 IS NULL THEN RETURN ddate END IF
   LET start_date = ddate USING 'yyyymmdd'
   IF l_gga03 MATCHES "[5]"
      THEN LET start_date[5,6] = (start_date[5,6] + 1) USING '&&'
           LET start_date[7,8] = '01'
           IF start_date[5,6] = '13' THEN
              LET start_date[1,4] = (start_date[1,4] + 1) USING '&&&&'
              LET start_date[5,6] = '01'
           END IF
   END IF
      LET start_date[5,6] = (start_date[5,6] + l_gga051+l_gga07) USING '&&'
      IF start_date[5,6] > '12' THEN
         LET start_date[1,4] = (start_date[1,4] + 1) USING '&&&&'
         LET start_date[5,6] = (start_date[5,6] - 12) USING '&&'
      END IF
   LET ddate = MDY(start_date[5,6],start_date[7,8],start_date[1,4])
   LET ddate = ddate + l_gga05
   RETURN ddate
END FUNCTION
 
{
REPORT anmr311_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_nma02       LIKE nma_file.nma02,   
          a,l_amt1,l_amt2,l_amt   LIKE type_file.num10,    #No.FUN-680107 INTEGER
          l_sta         LIKE type_file.chr4,    #No.FUN-680107 VARCHAR(04)
 
          sr   RECORD 
               flag     LIKE type_file.chr2,    #No.FUN-680107 VARCHAR(2)
               nmdat    LIKE type_file.dat,     #No.FUN-680107 DATE
               bank     LIKE nma_file.nma01,
               amt1     LIKE type_file.num20_6, #No.FUN-680107 DECIMAL(20,6)
               amt2     LIKE type_file.num20_6, #No.FUN-680107 DECIMAL(20,6)
               amt3     LIKE type_file.num20_6, #No.FUN-680107 DECIMAL(20,6)
               amt4     LIKE type_file.num20_6, #No.FUN-680107 DECIMAL(20,6)
               amt5     LIKE type_file.num20_6, #融資/中長貸  #No.FUN-680107 DECIMAL(20,6)
               trno     LIKE alb_file.alb04,    #No.FUN-680107 VARCHAR(10)
               whom     LIKE alb_file.alb03,    #No.FUN-680107 VARCHAR(10)
               desc     LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(40)
               END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nmdat,sr.trno
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[11] CLIPPED,' ',tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nmdat
      IF first_sw = 'y' THEN
        CALL r311_calbal()   #計算餘額
        LET l_sum=g_amt   
        IF cl_null(l_sum) THEN LET l_sum=0 END IF
        PRINT COLUMN g_c[38],g_x[15] CLIPPED,
              COLUMN g_c[39],cl_numfor(l_sum,39,g_azi04) 
      END IF
      LET first_sw = 'n'
 
   ON EVERY ROW
      LET l_sum = l_sum + sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4
 
   AFTER GROUP OF sr.trno
      IF tm.detail_sw = '1' THEN
      #96-06-14 Modify By Lynn
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.bank
      PRINT COLUMN g_c[31],sr.nmdat,
            COLUMN g_c[32],sr.bank[1,6],
            COLUMN g_c[33],l_nma02,
            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.amt1),34,g_azi05),
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt2),35,g_azi05),
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt5),36,g_azi05),
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt3),37,g_azi05),
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt4),38,g_azi05),
            COLUMN g_c[39],cl_numfor(l_sum,39,g_azi05),
            COLUMN g_c[40],sr.trno,
            COLUMN g_c[41],sr.whom;
            CASE sr.flag
              WHEN '21' PRINT COLUMN g_c[42],g_x[21] CLIPPED
              WHEN '22' PRINT COLUMN g_c[42],g_x[22] CLIPPED
              WHEN '23' PRINT COLUMN g_c[42],g_x[23] CLIPPED
              WHEN '24' PRINT COLUMN g_c[42],g_x[24] CLIPPED
              WHEN '25' PRINT COLUMN g_c[42],g_x[25] CLIPPED
              WHEN '41' PRINT COLUMN g_c[42],g_x[26] CLIPPED
              WHEN '42' PRINT COLUMN g_c[42],g_x[27] CLIPPED
              WHEN '43' PRINT COLUMN g_c[42],g_x[28] CLIPPED
              WHEN '44' PRINT COLUMN g_c[42],g_x[29] CLIPPED
              OTHERWISE PRINT COLUMN g_c[42],sr.desc CLIPPED
            END CASE
      END IF
   AFTER GROUP OF sr.nmdat
      IF tm.detail_sw = '2' THEN
         PRINT COLUMN g_c[31],sr.nmdat,
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.amt1),34,g_azi05),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt2),35,g_azi05), 
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt5),36,g_azi05), 
               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt3),37,g_azi05), 
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt4),38,g_azi05),
               COLUMN g_c[39],cl_numfor(l_sum,39,g_azi05)
      END IF
      IF tm.detail_sw = '3' THEN
         PRINT COLUMN g_c[31],sr.nmdat,
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.amt1),34,g_azi05),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt2),35,g_azi05),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt5),36,g_azi05),
               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt3),37,g_azi05),
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt4),38,g_azi05),
               COLUMN g_c[39],cl_numfor(l_sum,39,g_azi05) ; 
         LET a = 0
         LET l_amt = GROUP SUM(sr.amt2) WHERE sr.flag='21'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[21] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt2) WHERE sr.flag='22'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[22] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt2) WHERE sr.flag='23'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[23] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt2) WHERE sr.flag='24'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[24] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt2) WHERE sr.flag='25'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[25] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt4) WHERE sr.flag='41'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[26] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt4) WHERE sr.flag='42'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[27] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt4) WHERE sr.flag='43'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[28] CLIPPED,l_amt LET a=1 END IF
         LET l_amt = GROUP SUM(sr.amt4) WHERE sr.flag='44'
         IF l_amt > 0 THEN PRINT COLUMN g_c[42],g_x[29] CLIPPED,l_amt LET a=1 END IF
         IF a = 0 THEN PRINT END IF
      END IF
      PRINT
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #TQC-630166 Start
              #IF tm.wc[001,120] > ' ' THEN                  # for 132
              #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[121,240] > ' ' THEN
              #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
              #IF tm.wc[241,300] > ' ' THEN
              #PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
 
              CALL cl_prt_pos_wc(tm.wc)
              #TQC-630166 End
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_sum = 0
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
 
FUNCTION r311_calbal()   # 期初值計算
DEFINE l_d1   LIKE nma_file.nma23
DEFINE l_c1   LIKE nma_file.nma23
DEFINE l_bdate,l_edate     LIKE type_file.dat       #No.FUN-680107 DATE
DEFINE l_yy,l_mm           LIKE type_file.num5      #No.FUN-680107 SMALLINT  
 
   #利月月結檔及銀行異動檔算出目前銀行餘額
   SELECT nmp02,nmp03 INTO l_yy,l_mm
     FROM nmp_file 
    WHERE MDY(nmp03,1,nmp02) IN (SELECT MAX(MDY(nmp03,1,nmp02)) FROM nmp_file)
    GROUP BY nmp02,nmp03     #MOD-840088-modify
 
   SELECT MIN(azn01) INTO l_bdate FROM azn_file
           WHERE azn02 = l_yy AND azn04 = l_mm 
 
   SELECT MAX(azn01) INTO l_edate FROM azn_file
           WHERE azn02 = l_yy AND azn04 = l_mm 
 
  #SELECT SUM(nmp09) INTO g_amt FROM nmp_file           #MOD-C60202 mark
   SELECT SUM(nmp06) INTO g_amt FROM nmp_file           #MOD-C60202 add
    WHERE nmp02 = l_yy AND nmp03 = l_mm
   #           nmp02 = (SELECT MAX(nmp02) FROM nmp_file )
   #       AND nmp03 = (SELECT MAX(nmp03) FROM nmp_file )
   IF g_amt IS NULL OR g_amt = ' ' THEN LET g_amt = 0 END IF
 
  #no.2643應抓本幣金額
   SELECT SUM(nme04) INTO l_d1 FROM nme_file,nmc_file  #MOD-C60202 remark
  #SELECT SUM(nme08) INTO l_d1 FROM nme_file,nmc_file  #MOD-C60202 mark
          WHERE  nme03 = nmc01 AND nmc03 = '1'
                   AND nme02 > l_edate   # 計算月結以後金額
  #no.2643應抓本幣金額
   SELECT SUM(nme04) INTO l_c1 FROM nme_file,nmc_file    #MOD-C60202 remark
  #SELECT SUM(nme08) INTO l_c1 FROM nme_file,nmc_file    #MOD-C60202 mark 
          WHERE nme03 = nmc01 AND nmc03 = '2' 
          AND nme02 > l_edate   # 計算月結以後金額 
   IF cl_null(l_d1)  THEN LET l_d1 = 0 END IF 
   IF cl_null(l_c1)  THEN LET l_c1 = 0 END IF 
   LET g_amt=g_amt+ l_d1 - l_c1
END FUNCTION
