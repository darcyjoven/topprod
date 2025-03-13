# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: anmr321.4gl
# Descriptions...: 銀行收支日計表列印作業
# Date & Author..: 93/04/13 By Felicity  Tseng
#                : 96/06/14 By Lynn   銀行編號(nma01) 取6碼
# Modify.........: No.FUN-4C0098 05/01/03 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-720013 07/03/08 BY TSD.c123k 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.CHI-8B0001 08/11/25 By Sarah 若區間在質押日以前仍可顯示,若在質押日範圍內則不可計算定存金額
# Modify.........: No.MOD-930294 09/03/30 By Sarah 修正CHI-8B0001,當tm.curr_sw='1'時抓SUM(nme04),當tm.curr_sw='2'時抓SUM(nme08)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A30106 10/03/29 By wujie  增加银行编号开窗挑选功能,"选择"中默认为会计日期
# Modify.........: No.MOD-CB0210 12/11/26 By Polly 增加質押銀行條件抓取金額
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,    #TQC-630166
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE 
              date_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              curr_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(80)
 
DEFINE    g_i         LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE    g_head1     STRING
DEFINE    l_table     STRING                 # TSD.c123k
DEFINE    g_sql       STRING                 # TSD.c123k
DEFINE    g_str       STRING                 # TSD.c123k
 
 
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
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "nma01.nma_file.nma01,",
               "nma02.nma_file.nma02,",
               "nma10.nma_file.nma10,",
               "rest.nme_file.nme04,",
               "debit.nme_file.nme04,",
               "credit.nme_file.nme04,",
               "balance.nme_file.nme04,",
               "date_sw.type_file.chr1,",
               "bdate.type_file.dat,",
               "edate.type_file.dat,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('anmr321',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
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
   LET tm.date_sw  = ARG_VAL(10)
   LET tm.curr_sw  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r321_tm(0,0)
      ELSE CALL r321()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r321_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          l_cmd        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW r321_w AT p_row,p_col
        WITH FORM "anm/42f/anmr321"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
#  LET tm.date_sw = '1'
   LET tm.date_sw = '2'               #No.FUN-A30106
   LET tm.curr_sw = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma10, nma01, nma04
#No.FUN-A30106  --begin                                                         
      ON ACTION CONTROLP                                                        
         CASE                                                                   
           WHEN INFIELD(nma01)                                                  
              CALL cl_init_qry_var()                                            
              LET g_qryparam.form = "q_nma"                                     
              LET g_qryparam.state = "c"                                        
              CALL cl_create_qry() RETURNING g_qryparam.multiret                
              DISPLAY g_qryparam.multiret TO nma01                              
         END CASE                                                               
#No.FUN-A30106  --end  
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r321_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.date_sw,tm.curr_sw,tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD bdate
         END IF
         IF NOT cl_null(tm.edate) THEN
         IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
            CALL cl_err(0,'anm-091',0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.bdate) THEN
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
      AFTER FIELD date_sw
         IF CL_NULL(tm.date_sw) OR tm.date_sw NOT MATCHES '[12]' THEN
            LET tm.date_sw = '1' NEXT FIELD date_sw
         END IF
      AFTER FIELD curr_sw
         IF CL_NULL(tm.curr_sw) OR tm.curr_sw NOT MATCHES '[12]' THEN
            LET tm.curr_sw = '1' NEXT FIELD curr_sw
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
#     ON ACTION CONTROLP CALL r321_wc()      # Input detail Where Condition
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr321'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr321','9031',1)
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
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.date_sw CLIPPED,"'",
                         " '",tm.curr_sw CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr321',g_time,l_cmd)
      END IF
      CLOSE WINDOW r321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r321()
   ERROR ""
END WHILE
   CLOSE WINDOW r321_w
END FUNCTION
 
{
FUNCTION r321_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
 
   OPEN WINDOW r321_w2 AT 2,2
        WITH FORM "anm/42f/anmt110"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("anmt110")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                      # 螢幕上取條件
              nme01, nme03, nme05,
              nme06, nme08, nme09, nme11, nme12,
              nme13, nme14, nme15, nme16,
              nme19, nme20, nme17, nme21, nme22,
              nme24, nme25, nme43, nme44, nmemksg, nme36,
              nme31, nme51, nme32, nme52, nme33, nme53, nme34, nme54,
              nme35,
              nmeinpd, nmeuser, nmegrup, nmemodu, nmedate, nmeacti
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
		
   CLOSE WINDOW r321_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION r321()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#         l_time    LIKE type_file.chr8            #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,           #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680107 VARCHAR(40)
          sr        RECORD
                     nma01   LIKE nma_file.nma01,  #銀行編號
                     nma02   LIKE nma_file.nma02,  #銀行全名
                     nma10   LIKE nma_file.nma10,  #幣別
                     rest    LIKE nme_file.nme04,  #餘額
                     debit   LIKE nme_file.nme04,  #存入金額
                     credit  LIKE nme_file.nme04,  #支出金額
                     debit_1  LIKE nme_file.nme04, #CHI-8B0001 add
                     credit_1 LIKE nme_file.nme04, #CHI-8B0001 add
                     debit_2  LIKE nme_file.nme04, #CHI-8B0001 add
                     credit_2 LIKE nme_file.nme04, #CHI-8B0001 add
                     balance LIKE nme_file.nme04
                    END RECORD,
          t_azi04   LIKE azi_file.azi04,           #TSD.c123k add
          t_azi05   LIKE azi_file.azi05,           #TSD.c123k add
          l_gxf21   LIKE gxf_file.gxf21            #CHI-8B0001 add
 
     #FUN-720013 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ----------------------------------#
     #FUN-720013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-720013 add
 
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
 
     LET l_sql = "SELECT nma01,nma02,nma10,0,0,0,0 FROM nma_file",
                 " WHERE ", tm.wc CLIPPED
     PREPARE r321_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
     END IF
     DECLARE r321_curs1 CURSOR FOR r321_prepare1
#    LET l_name = 'anmr321.out'
 
     LET g_pageno = 0
     FOREACH r321_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF tm.curr_sw = '2' THEN LET sr.nma10 = g_aza.aza17 END IF
       CALL s_cntrest(sr.nma01,tm.bdate,tm.date_sw,tm.curr_sw)
                     RETURNING sr.rest  #計算期初餘額
       CASE
         WHEN tm.date_sw = '1' AND tm.curr_sw = '1'
          SELECT SUM(nme04) INTO sr.debit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme04) INTO sr.credit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
         WHEN tm.date_sw = '1' AND tm.curr_sw = '2'
          SELECT SUM(nme08) INTO sr.debit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme08) INTO sr.credit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme02 BETWEEN tm.bdate AND tm.edate
         WHEN tm.date_sw = '2' AND tm.curr_sw = '1'
          SELECT SUM(nme04) INTO sr.debit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme04) INTO sr.credit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
         WHEN tm.date_sw = '2' AND tm.curr_sw = '2'
          SELECT SUM(nme08) INTO sr.debit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
          SELECT SUM(nme08) INTO sr.credit FROM nme_file,nmc_file
                 WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
                   AND nme16 BETWEEN tm.bdate AND tm.edate
       END CASE
      #str CHI-8B0001 add
      #抓取本期存入、本期提出金額時,應考慮到質押及質押解除,
      #  質押日界於日期範圍的金額  ->將此金額扣除
      #  解除日>結束日期的金額     ->將此金額加入
       LET sr.debit_1=0   LET sr.credit_1=0
       LET sr.debit_2=0   LET sr.credit_2=0
       CASE                      #MOD-930294 add
         WHEN tm.curr_sw = '1'   #MOD-930294 add
           SELECT SUM(nme04) INTO sr.debit_1 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
              AND gxf011= nme12
              AND gxf21 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
           SELECT SUM(nme04) INTO sr.credit_1 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
              AND gxf011= nme12
              AND gxf21 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add  
           SELECT SUM(nme04) INTO sr.debit_2 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
              AND gxf011= nme12
              AND gxf22 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
           SELECT SUM(nme04) INTO sr.credit_2 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
              AND gxf011= nme12
              AND gxf22 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
      #str MOD-930294 add
         WHEN tm.curr_sw = '2'
           SELECT SUM(nme08) INTO sr.debit_1 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
              AND gxf011= nme12
              AND gxf21 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
           SELECT SUM(nme08) INTO sr.credit_1 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
              AND gxf011= nme12
              AND gxf21 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add       
           SELECT SUM(nme08) INTO sr.debit_2 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
              AND gxf011= nme12
              AND gxf22 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
           SELECT SUM(nme08) INTO sr.credit_2 FROM nme_file,nmc_file,gxf_file
            WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
              AND gxf011= nme12
              AND gxf22 BETWEEN tm.bdate AND tm.edate
              AND gxf02 = nme01                                                   #MOD-CB0210 add
       END CASE
      #end MOD-930294 add
  
       IF sr.debit_1 IS NULL  THEN LET sr.debit_1 = 0 END IF
       IF sr.credit_1 IS NULL THEN LET sr.credit_1= 0 END IF
       IF sr.debit_2 IS NULL  THEN LET sr.debit_2 = 0 END IF
       IF sr.credit_2 IS NULL THEN LET sr.credit_2= 0 END IF
      #end CHI-8B0001 add
       IF sr.debit IS NULL THEN LET sr.debit = 0 END IF
       IF sr.credit IS NULL THEN LET sr.credit = 0 END IF
       LET sr.debit = sr.debit  - sr.debit_1  + sr.debit_2    #CHI-8B0001 add
       LET sr.credit= sr.credit - sr.credit_1 + sr.credit_2   #CHI-8B0001 add
       LET sr.balance = sr.rest + sr.debit - sr.credit
       IF sr.rest = 0 AND sr.debit = 0 AND sr.credit = 0 THEN
          CONTINUE FOREACH
       END IF
 
       # TSD.c123k add ------------------------------------------------------#
       SELECT azi04, azi05 INTO t_azi04, t_azi05 
         FROM azi_file
        WHERE azi01 = sr.nma10
       # TSD.c123k end ------------------------------------------------------#
 
       #FUN-720013 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k *** #
       EXECUTE insert_prep USING
           sr.nma01,    sr.nma02,    sr.nma10,    sr.rest,   sr.debit,
           sr.credit,   sr.balance,  tm.date_sw,  tm.bdate,  tm.edate,
           t_azi04,     t_azi05
       #------------------------------ CR (3) --------------------------------
       #FUN-720013 - END
     END FOREACH
 
     #FUN-720013 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nma10,nma01,nma04')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     CALL cl_prt_cs3('anmr321','anmr321',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
     #FUN-720013 - END
 
END FUNCTION
