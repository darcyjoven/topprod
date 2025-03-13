# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr310.4gl
# Descriptions...: 銀行別資金預估狀況表
# Input parameter:
# Return code....:
# Date & Author..: 94/03/04 By Roger
# Modify.........: 96/06/13 By Lynn   銀行編號(nma01) 取6碼
#                : 01/02/16 By Mandy 加上一起始日期:起迄範圍
#                : 01/05/08 No.B210 銀行餘額改call s_cntrest 並增加起始日期
# Modify.........: No.FUN-4C0098 05/01/31 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-690001 06/11/30 By Smapmin DEFINE trno LIKE nmh_file.nmh01
# Modify.........: NO.FUN-720013 07/03/01 BY TSD.c123k 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-750143 07/05/30 By Sarah 報表漏印"期間: tm.bdate - tm.edate ",請印在"製表日期"的後面
# Modify.........: No.MOD-7B0100 07/11/12 By Smapmin 修正SQL語法
# Modify.........: No.MOD-7C0072 07/12/19 By Smapmin 調整CR報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                       # Print condition RECORD
              wc    STRING,                #Where Condiction #TQC-630166
              wc2   STRING,                #Where Condiction #TQC-630166
              sdate LIKE type_file.dat,    #No.FUN-680107 DATE
              edate LIKE type_file.dat,    #No.FUN-680107 DATE
          detail_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)                 # 1.明細 2.日計
               more LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
          bdate     LIKE type_file.dat,    #No.FUN-680107 DATE
          l_sum     LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #總計銀行目前存款餘額
          l_tot     LIKE type_file.num20_6,#MOD-7C0072
          first_sw  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          g_amt     LIKE nma_file.nma23
 
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   l_table    STRING                 # TSD.c123k
DEFINE   g_sql      STRING                 # TSD.c123k
DEFINE   g_str      STRING                 # TSD.c123k
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
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
   LET g_sql = "flag.type_file.chr2,",
               "nmdat.type_file.dat,",
               "bank1.nma_file.nma01,",
               "amt1.type_file.num20_6,",
               "amt2.type_file.num20_6,",
               "amt3.type_file.num20_6,",
               "amt4.type_file.num20_6,",
               "amt5.type_file.num20_6,",
               "trno.nmh_file.nmh01,",
               "whom.nmd_file.nmd09,",
               "desc1.nmj_file.nmj05,",
               "l_nma02.nma_file.nma02,",
               "l_sum.type_file.num20_6,",
               "l_tot.type_file.num20_6"    #MOD-7C0072
               #"detail_sw.type_file.chr1,",  #MOD-7C0072
               #"l_amt.type_file.num10,",   #MOD-7C0072  
               #"g_azi04.azi_file.azi04,",  #MOD-7C0072
               #"g_azi05.azi_file.azi05"    #MOD-7C0072
            
   LET l_table = cl_prt_temptable('anmr310',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               #"        ?,?,?,?,?, ?,?)"   #MOD-7C0072
               "        ?,?,?,?)"   #MOD-7C0072
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #FUN-720013 - END
 
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.sdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.detail_sw  = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL anmr310_tm()                    # Input print condition
      ELSE CALL anmr310()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr310_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(400)
          l_flag        LIKE type_file.chr1,         #是否必要欄位有輸入  #No.FUN-680107 VARCHAR(1)
          l_jmp_flag    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW anmr310_w AT p_row,p_col
        WITH FORM "anm/42f/anmr310" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET bdate=g_today
  #LET tm.edate=g_lastdat
   LET tm.sdate=g_today
   LET tm.edate=g_today
   LET tm.detail_sw='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01
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
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.sdate,tm.edate,tm.detail_sw,tm.more  WITHOUT DEFAULTS 
          AFTER FIELD sdate
                IF cl_null(tm.sdate) THEN NEXT FIELD sdate END IF
                IF NOT cl_null(tm.edate) THEN
                   IF tm.sdate > tm.edate THEN
                      NEXT FIELD sdate
                   END IF
                END IF
          AFTER FIELD edate
                IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
                IF tm.sdate > tm.edate THEN
                   NEXT FIELD sdate
                END IF
{
                   IF tm.edate IS NULL OR tm.edate = ' ' THEN
                          LET tm.edate = g_lastdat
                          DISPLAY BY NAME tm.edate
                          NEXT FIELD edate
           END IF
}
          AFTER FIELD detail_sw
                   IF tm.detail_sw NOT MATCHES "[123]" THEN NEXT FIELD detail_sw END IF
 
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
       IF tm.sdate IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.sdate 
           NEXT FIELD sdate
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#     ON ACTION CONTROLP CALL anmr310_wc()   # Input detail where condiction
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr310','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",             #TQC-610058
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.detail_sw CLIPPED,"'",         #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr310',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr310()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr310_w
END FUNCTION
{
FUNCTION anmr310_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
 
    OPEN WINDOW r310_w2 AT 3,2     #顯示畫面
        WITH FORM "anm/42f/anmixxx" 
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("anmixxx")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
    CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        nma01,  nma04,
       .ser,.rup.odu.ate.cti
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
    END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   CLOSE WINDOW r310_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r310_w2 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
END FUNCTION
}
FUNCTION anmr310()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,              # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,              #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE type_file.chr20,    #No.FUN-680107 ARRAY[2] OF VARCHAR(10) #排列順序
          sr            RECORD
                           flag     LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2)
                           nmdat    LIKE type_file.dat,      #No.FUN-680107 DATE
                           bank     LIKE nma_file.nma01,
                           amt1     LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                           amt2     LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                           amt3     LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                           amt4     LIKE type_file.num20_6,  #No.FUN-680107 DECIMAL(20,6)
                           amt5     LIKE type_file.num20_6,  #融資/中長貸  #No.FUN-680107 DECIMAL(20,6)
                           trno     LIKE nmh_file.nmh01,     #No.FUN-680107 VARCHAR(10)
                           whom     LIKE nmd_file.nmd09,     #No.FUN-680107 VARCHAR(10)
                           desc     LIKE nmj_file.nmj05      #No.FUN-680107 VARCHAR(16)
                        END RECORD
   DEFINE l_pma03                    LIKE pma_file.pma03     #No.FUN-680107 VARCHAR(1)
   DEFINE l_pma08,l_pma09,l_pma10    LIKE pma_file.pma08     #No.FUN-680107 SMALLINT
   DEFINE l_gga03,l_gga04            LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_gga05,l_gga051,l_gga07,l_gga071  LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_rate,l_days              LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_nma02                    LIKE nma_file.nma02      # TSD.c123k add
          #l_azi04                    LIKE azi_file.azi04,    # TSD.c123k add    #MOD-7C0072
          #l_azi05                    LIKE azi_file.azi05,    # TSD.c123k add    #MOD-7C0072 
          #l_amt                      LIKE type_file.num10    # TSD.c123k add    #MOD-7C0072
 
     LET first_sw = 'y'
 
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ----------------------------------#
     #FUN-720013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
#========================================================================
   #CALL cl_outnam('anmr310') RETURNING l_name  #TSD.c123k mark
   #START REPORT anmr310_rep TO l_name          #TSD.c123k mark
   LET g_pageno = 0
#----------------------------------- 00. ---------------------------------
   LET l_sql = "SELECT '00','010101',nma01,'0','0','0','0','0','','',''",
               " FROM nma_file",
             # " WHERE nma23 > 0 AND ",tm.wc  no.4975
               " WHERE ",tm.wc
    PREPARE anmr310_prepare0 FROM l_sql
     DECLARE anmr310_curs0 CURSOR FOR anmr310_prepare0
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
 
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
       
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       #LET l_azi04 = g_azi04   
       #LET l_azi05 = g_azi05   
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
       
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot    #MOD-7C0072
       #------------------------------ CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#----------------------------------- 10. ---------------------------------
   CALL r310_wcc(tm.wc,'nma01','nmd03') RETURNING tm.wc2
     # 010302 By Star 不須重算本幣金額 
  #LET l_sql = "SELECT '10',nmd05,nmd03,nmd04*nmd19*-1,'0','0','0','0',",
   LET l_sql = "SELECT '10',nmd05,nmd03,(nmd26*-1),'0','0','0','0',",
               "       nmd02,nmd09,''",
               " FROM nmd_file",
               " WHERE nmd05 BETWEEN '",tm.sdate,"' AND '",tm.edate,
               "' AND nmd12 IN ('1','X')",
               "   AND nmd30 <> 'X' AND ",tm.wc2
     PREPARE anmr310_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('p10:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE anmr310_curs1 CURSOR FOR anmr310_prepare1
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       MESSAGE sr.flag,' ',sr.nmdat
       CALL ui.Interface.refresh()
       IF sr.amt1 IS NULL THEN LET sr.amt1 = 0  END IF
  
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
      
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot   #MOD-7C0072
       #------------------------------ CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#----------------------------------- 30. ---------------------------------
   CALL r310_wcc(tm.wc,'nma01','nmh21') RETURNING tm.wc2
   LET l_sql = "SELECT '30',nmh09,nmh21,'0','0',nmh02*nmh28,'0','0',",
               "       nmh01,nmh30,''",
               " FROM nmh_file",
               " WHERE nmh09 BETWEEN '",tm.sdate,"' AND '",tm.edate,
               "' AND nmh24 IN ('1','2','3','4') ",
               "  AND nmh38 = 'Y' ",   #No.B213
               "   AND ",tm.wc2
     PREPARE anmr310_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('p30:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr310_curs2 CURSOR FOR anmr310_prepare2
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs2 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach3:',STATUS,1) EXIT FOREACH END IF
       IF sr.amt3 IS NULL THEN LET sr.amt3 = 0  END IF
 
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
      
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
 
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot   #MOD-7C0072
       #------------------------------ CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#----------------------------------- 20/40. ---------------------------------
   CALL r310_wcc(tm.wc,'nma01','nmj01') RETURNING tm.wc2
   LET l_sql = "SELECT nmc03,nmj02,nmj01,'0','0','0',nmj04,'0',",
               "       '','',nmj05",
               " FROM nmj_file, nmc_file",
               " WHERE nmj02 BETWEEN '",tm.sdate,"' AND '",tm.edate,
               "' AND nmj06 = 'N'",
               "   AND nmj03 = nmc01",
               "   AND ",tm.wc2
     PREPARE anmr310_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('p20:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr310_curs3 CURSOR FOR anmr310_prepare3
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs3 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach3:',STATUS,1) EXIT FOREACH END IF
       IF sr.flag = '2'
          THEN LET sr.flag = '20' LET sr.amt2 = sr.amt4*-1 LET sr.amt4 = 0
          ELSE LET sr.flag = '40'
       END IF
 
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
 
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
       
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot    #MOD-7C0072
       #------------------------------ CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#----------------------------------- 50. ---------------------------------
   CALL r310_wcc(tm.wc,'nma01','nne04') RETURNING tm.wc2
   LET l_sql = "SELECT '50',nne21,nne04,'0','0','0','0',(nne19-nne20)*-1,",
               "       nne01,'',''",
               " FROM nne_file",
               " WHERE nne21 BETWEEN '",tm.sdate,"' AND '",tm.edate,
               "' AND nneconf='Y' ",
               #" AND (nne26 IS NULL OR nne26=' ')",   #MOD-7B0100
               " AND nne26 IS NULL ",   #MOD-7B0100
               "   AND ",tm.wc2
     PREPARE anmr310_prepare50 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('p10:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE anmr310_curs50 CURSOR FOR anmr310_prepare50
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs50 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach50:',STATUS,1) EXIT FOREACH END IF
       IF sr.amt5 IS NULL THEN LET sr.amt5 = 0  END IF
 
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
      
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
 
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot  #MOD-7C0072
       #------------------------------ CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#----------------------------------- 51. ---------------------------------
   CALL r310_wcc(tm.wc,'nma01','nng04') RETURNING tm.wc2
   LET l_sql = "SELECT '51',nnh03,nng04,'0','0','0','0',nnh04*-1,",
               "       nng01,'',''",
               " FROM nng_file,nnh_file",
               " WHERE nng01=nnh01 AND nngconf='Y' ",
               " AND nnh03 BETWEEN '",tm.sdate,"' AND '",tm.edate,"'",
               " AND nng15='2'",
               "   AND ",tm.wc2
     PREPARE anmr310_prepare51 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('p10:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM END IF
     DECLARE anmr310_curs51 CURSOR FOR anmr310_prepare51
 
     # TSD.c123k add ----
     LET l_nma02 = NULL
     LET l_sum = 0
     # TSD.c123k end ----
 
     FOREACH anmr310_curs51 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach51:',STATUS,1) EXIT FOREACH END IF
       MESSAGE sr.flag,' ',sr.amt5
       CALL ui.Interface.refresh()
       IF sr.amt5 IS NULL THEN LET sr.amt5 = 0  END IF
 
       # TSD.c123k add ------------------------------------------------------##
       SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.bank
 
       LET g_amt = 0
       CALL s_cntrest(sr.bank,tm.sdate,'2','1') RETURNING g_amt    #計算期初餘額
       
       LET l_sum = g_amt
       IF cl_null(l_sum) THEN LET l_sum = 0 END IF
       #-----MOD-7C0072---------
       LET l_tot = 0 
       IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
       IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
       IF cl_null(sr.amt3) THEN LET sr.amt3 = 0 END IF
       IF cl_null(sr.amt4) THEN LET sr.amt4 = 0 END IF
       IF cl_null(sr.amt5) THEN LET sr.amt5 = 0 END IF
       LET l_tot = sr.amt1 + sr.amt2 + sr.amt3 + sr.amt4 + sr.amt5
       #-----END MOD-7C0072-----
       # ---------------------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** ##
       EXECUTE insert_prep USING
          sr.flag,   sr.nmdat,   sr.bank,   sr.amt1,   sr.amt2,    sr.amt3,
          sr.amt4,   sr.amt5,    sr.trno,   sr.whom,   sr.desc,    l_nma02,
          #l_sum,     tm.detail_sw,  l_amt,  l_azi04,   l_azi05   #MOD-7C0072
          l_sum,     l_tot   #MOD-7C0072
       #----------------------------- CR (3) --------------------------------#
       #FUN-720013 - END
     END FOREACH
#------------------------------------------------------------------------
 
    #FUN-720013 - START
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'nma01')
            RETURNING tm.wc
    ELSE
       LET tm.wc = ' '
    END IF
    #LET g_str = tm.wc,";",tm.sdate,";",tm.edate        #FUN-750143 add tm.sdate,tm.edate   #MOD-7C0072
    LET g_str = tm.wc,";",tm.sdate,";",tm.edate,";",tm.detail_sw,";",g_azi04,";",g_azi05        #FUN-750143 add tm.sdate,tm.edate   #MOD-7C0072
    CALL cl_prt_cs3('anmr310','anmr310',l_sql,g_str)   #FUN-710080 modify
    #------------------------------ CR (4) ------------------------------#
    #FUN-720013 - END
 
END FUNCTION
 
FUNCTION r310_wcc(p_wc,p_from,p_to)
  DEFINE p_wc           LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(300)
  DEFINE p_from,p_to    LIKE nmd_file.nmd03      #No.FUN-680107 VARCHAR(5)
  DEFINE i              LIKE type_file.num5      #No.FUN-680107 SMALLINT
  FOR i = 1 TO 296
     IF p_wc[i,i+4] = p_from THEN LET p_wc[i,i+4] = p_to END IF
  END FOR
  RETURN p_wc
END FUNCTION
 
