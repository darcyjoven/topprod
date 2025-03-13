# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr131.4gl
# Descriptions...: 廠商別應付票據明細帳列印作業
# Date & Author..: 93/04/21  By  Felicity  Tseng
#                : 96/06/13 By Lynn   銀行編號(nmd03)取6碼
# Modify.........: No.FUN-4C0098 05/01/07 By pengu 報表轉XML
# Modify.........: No.MOD-5A0074 05/10/07 By Dido 增加新舊票況判斷
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, #TQC-630166
              c       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              d       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD
   DEFINE g_dash_1    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(80)
   DEFINE g_counter   LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_amt       LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6)
   DEFINE l_count     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE g_ary DYNAMIC ARRAY OF RECORD
                data  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(51)
                sign  LIKE type_file.num10,  #No.FUN-680107 INTEGER
                mony  LIKE nmd_file.nmd04    #餘額
          END RECORD
 
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
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
 
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)
   LET tm.bdate = ARG_VAL(10)   #TQC-610058
   LET tm.edate = ARG_VAL(11)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r131_tm(0,0)           # Input print condition
      ELSE CALL r131()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r131_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r131_w AT p_row,p_col
        WITH FORM "anm/42f/anmr131"
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
   CONSTRUCT BY NAME tm.wc ON pmc01
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
      LET INT_FLAG = 0 CLOSE WINDOW r131_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.c,tm.d,tm.more
                 WITHOUT DEFAULTS
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
#     ON ACTION CONTROLP CALL r131_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr131'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr131','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
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
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr131',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r131()
   ERROR ""
END WHILE
   CLOSE WINDOW r131_w
END FUNCTION
 
{
FUNCTION r131_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680107
 
   OPEN WINDOW r131_w2 AT 2,2
        WITH FORM "anm/42f/anmt110"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("anmt110")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                      # 螢幕上取條件
              apa01, apa02, apa05,
              apa06, apa08, apa09, apa11, apa12,
              apa13, apa14, apa15, apa16,
              apa19, apa20, apa17, apa21, apa22,
              apa24, apa25, apa43, apa44, apamksg, apa36,
              apa31, apa51, apa32, apa52, apa33, apa53, apa34, apa54,
              apa35,
              apainpd, apauser, apagrup, apamodu, apadate, apaacti
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
		
   CLOSE WINDOW r131_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION r131()
   DEFINE l_name    LIKE type_file.chr20         #No.FUN-680107 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0082
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(1200)
   DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
   DEFINE XX        LIKE type_file.chr2          #No.FUN-680107 VARCHAR(2)
   DEFINE    sr            RECORD
                                  pmc01 LIKE pmc_file.pmc01, #廠商編號
                                  pmc03 LIKE pmc_file.pmc03, #廠商名稱
                                  nmd02 LIKE nmd_file.nmd02, #票號
                                  nmd03 LIKE nmd_file.nmd03, #異動日期
                                  nmd04 LIKE nmd_file.nmd04, #金額
                                  nmd10 LIKE nmd_file.nmd10, #付款單號
                                  nmd21 LIKE nmd_file.nmd21, #幣別
                                  nmf02 LIKE nmf_file.nmf02,
                                  nmf03 LIKE nmf_file.nmf03,
                                  nmf05 LIKE nmf_file.nmf05,
                                  nmf06 LIKE nmf_file.nmf06,
                                  nmf09 LIKE nmf_file.nmf09,  #本次異動匯率
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
     #End:FUN-980030
 
 
 
     LET l_sql = "SELECT ",
                 " pmc01, pmc03, nmd02, nmd03, nmd04, nmd10,",
" nmd21, nmf02, nmf03, nmf05, nmf06, nmf09, 0 FROM pmc_file LEFT OUTER JOIN  nmd_file ON nmd08 = pmc01 LEFT OUTER JOIN nmf_file ON (nmf07 = pmc01 AND nmf02<= '",tm.edate,"') WHERE nmf_file.nmf01 = nmd_file.nmd01 AND ",tm.wc CLIPPED
     PREPARE r131_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r131_curs1 CURSOR FOR r131_prepare1
#    LET l_name = 'anmr131.out'
     CALL cl_outnam('anmr131') RETURNING l_name
     START REPORT r131_rep TO l_name
     LET g_pageno = 0
     LET g_counter = 0
     FOREACH r131_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr.nmd04) THEN LET sr.nmd04 = 0 END IF
          LET XX = sr.nmf05,sr.nmf06
          CASE XX
               WHEN '01' LET sr.sign = -1
               WHEN '16' LET sr.sign = 1
               WHEN '18' LET sr.sign = 1
               WHEN '19' LET sr.sign = 1
               WHEN '17' LET sr.sign = 1
               WHEN '0X' LET sr.sign = -1
               WHEN 'X8' LET sr.sign = 1
#MOD-5A0074
               WHEN 'X6' LET sr.sign = 1
               WHEN 'X7' LET sr.sign = 1
               WHEN 'X9' LET sr.sign = 1
#MOD-5A0074 End
 
          END CASE
          IF sr.sign = 0 THEN   #沒有做異動,故不須列出
             CONTINUE FOREACH
          END IF
          IF tm.c = '2' THEN
             LET sr.nmd21 = g_aza.aza17           #g_aza17 :本幣幣別(NT$)
             LET sr.nmd04 = sr.nmd04 * sr.nmf09   #轉換成本幣
             IF cl_null(sr.nmd04) THEN LET sr.nmd04 = 0 END IF
          END IF
          OUTPUT TO REPORT r131_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r131_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r131_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_idx         LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_max         LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_print       LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_amt         LIKE nmd_file.nmd04
   DEFINE l_empty       LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_exp1        LIKE ze_file.ze03     #No.FUN-680107 VARCHAR(6)
   DEFINE l_exp2        LIKE ze_file.ze03     #No.FUN-680107 VARCHAR(6)
   DEFINE l_p_dash      LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_sign        LIKE nmd_file.nmd04   #異動金額
   DEFINE l_nma02       LIKE nma_file.nma02
   DEFINE    sr            RECORD
                                  pmc01 LIKE pmc_file.pmc01, #廠商編號
                                  pmc03 LIKE pmc_file.pmc03, #廠商名稱
                                  nmd02 LIKE nmd_file.nmd02, #票號
                                  nmd03 LIKE nmd_file.nmd03, #異動日期
                                  nmd04 LIKE nmd_file.nmd04, #原票況
                                  nmd10 LIKE nmd_file.nmd10, #付款單號
                                  nmd21 LIKE nmd_file.nmd21, #幣別
                                  nmf02 LIKE nmf_file.nmf02,
                                  nmf03 LIKE nmf_file.nmf03,
                                  nmf05 LIKE nmf_file.nmf05,
                                  nmf06 LIKE nmf_file.nmf06,
                                  nmf09 LIKE nmf_file.nmf09,  #本次異動匯率
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
   DEFINE l_ary    DYNAMIC ARRAY OF RECORD
                                  nmd02 LIKE nmd_file.nmd02,
                                  nmd03 LIKE nmd_file.nmd03, #異動日期
                                  nma02 LIKE nma_file.nma02,
                                  nmd04 LIKE nmd_file.nmd04, #原票況
                                  nmd10 LIKE nmd_file.nmd10, #付款單號
                                  nmf02 LIKE nmf_file.nmf02,
                                  nmf05 LIKE nmf_file.nmf05,
                                  nmf06 LIKE nmf_file.nmf06,
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmc01, sr.nmf02, sr.nmf03    #廠商編號、異動日期、異動時間
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[12] CLIPPED,tm.bdate,'-',tm.edate
      #PRINT g_head1                        #FUN-660060 remark
      PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pmc01
      IF tm.d = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
      LET g_counter = g_counter + 1
      IF g_counter != 1 AND (PAGENO > 1 OR LINENO > 9) THEN
         IF l_p_dash='Y'  THEN
            PRINT g_dash2[1,g_len]   #g_dash_1[1,g_len]
         END IF
      END IF
      LET l_p_dash='N'
      FOR l_idx = 1 TO 50
          INITIALIZE g_ary[l_idx].* TO NULL
          INITIALIZE l_ary[l_idx].* TO NULL
      END FOR
     {
      IF tm.c = '1' THEN        #幣別為原幣
         SELECT azi04, azi05
           INTO g_azi04, g_azi05
           FROM azi_file
           WHERE azi01 = sr.nmd21
      IF cl_null(g_azi04) THEN LET g_azi04 = 0 END IF
      IF cl_null(g_azi05) THEN LET g_azi05 = 0 END IF
      END IF
     }
      LET l_idx = 0
 
   ON EVERY ROW
      CALL s_nmdsta(sr.nmf05)  #得出票況的說明
           RETURNING l_exp1
      CALL s_nmdsta(sr.nmf06)  #得出票況的說明
           RETURNING l_exp2
      LET l_exp1=sr.nmf05,'.',l_exp1
      LET l_exp2=sr.nmf06,'.',l_exp2
 
      IF sr.nmf02 >= tm.bdate THEN       #大於截止日期之data才放入ARRAY
         SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nmd03
         LET l_idx = l_idx +1
         LET l_ary[l_idx].nmf02=sr.nmf02
         LET l_ary[l_idx].nmd03=sr.nmd03
         LET l_ary[l_idx].nma02=l_nma02
         LET l_ary[l_idx].nmd10=sr.nmd10
         LET l_ary[l_idx].nmd02=sr.nmd02
         LET l_ary[l_idx].nmf05=l_exp1
         LET l_ary[l_idx].nmf06=l_exp2
         LET l_ary[l_idx].sign=sr.sign
         LET l_ary[l_idx].nmd04=sr.nmd04
 
      END IF
 
   AFTER GROUP OF sr.pmc01
      IF tm.d = 'Y' THEN
         LET g_counter = 0
      END IF
      LET l_max = l_idx                  #ARRAY 被使用的個數
      LET l_empty = 'Y'
      FOR l_idx = 1 TO l_max             #Check Array Y/N empty
          #IF NOT cl_null(g_ary[l_idx].data) THEN
          IF NOT cl_null(l_ary[l_idx].nmf02) THEN
             LET l_empty ='N'
             EXIT FOR
          END IF
      END FOR
      CALL r131_calbal(sr.pmc01)   #計算前初值
      LET l_amt=g_amt
      IF cl_null(l_amt) THEN LET l_amt=0 END IF
      IF tm.c = '1' THEN        #幣別為原幣
         SELECT azi04, azi05
           INTO t_azi04, t_azi05   #NO.CHI-6A0004
           FROM azi_file
           WHERE azi01 = sr.nmd21
      END IF
      IF l_empty ='N' OR (l_amt != 0) THEN     #有異動資料者 or 期初 != 0
         PRINT COLUMN g_c[31], g_x[10] CLIPPED,
               COLUMN g_c[32],sr.pmc01,
               COLUMN g_c[33], sr.pmc03,
               COLUMN g_c[36], g_x[9] CLIPPED,
               COLUMN g_c[37], sr.nmd21,
               COLUMN g_c[38], g_x[11] CLIPPED,
               COLUMN g_c[39], cl_numfor(l_amt,39,t_azi05)  #NO.CHI-6A0004  
         SKIP 1 LINE
         FOR l_idx = 1 TO l_max
             LET l_amt = l_amt - l_ary[l_idx].sign * l_ary[l_idx].nmd04
             PRINT COLUMN g_c[31],l_ary[l_idx].nmf02,
                   COLUMN g_c[32],l_ary[l_idx].nmd03,
                   COLUMN g_c[33],l_ary[l_idx].nma02,
                   COLUMN g_c[34],l_ary[l_idx].nmd10,
                   COLUMN g_c[35],l_ary[l_idx].nmd02,
                   COLUMN g_c[36],l_ary[l_idx].nmf05,
                   COLUMN g_c[37],l_ary[l_idx].nmf06,
                   COLUMN g_c[38], cl_numfor
                   (-1*g_ary[l_idx].sign*g_ary[l_idx].mony,38,t_azi04) CLIPPED,  #NO.CHI-6A0004  
                   COLUMN g_c[39], cl_numfor(l_amt,39,t_azi05) CLIPPED  #NO.CHI-6A0004  
         END FOR
         LET l_max = 0
         LET l_p_dash='Y'
      END IF
 
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
 
         #TQC-63016 Start     
            #  IF tm.wc[001,070] > ' ' THEN            # for 80
        # PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         
          CALL cl_prt_pos_wc(tm.wc)
         #TQC-63016 End
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION r131_calbal(l_pmc01)
   DEFINE l_sql     LIKE type_file.chr1000#No.FUN-680107 VARCHAR(600)
   DEFINE l_sign    LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_pmc01   LIKE pmc_file.pmc01   #No.FUN-680107 VARCHAR(10)
   DEFINE XX        LIKE type_file.chr2   #No.FUN-680107 VARCHAR(2)
   DEFINE    sr1           RECORD
                                  pmc01 LIKE pmc_file.pmc01, #廠商編號
                                  nmd04 LIKE nmd_file.nmd04, #原票況
                                  nmf05 LIKE nmf_file.nmf05,
                                  nmf06 LIKE nmf_file.nmf06,
                                  nmf09 LIKE nmf_file.nmf09  #本次異動匯率
                        END RECORD
 
     LET l_sql = "SELECT ",
" pmc01, nmd04,nmf05, nmf06, nmf09 FROM pmc_file LEFT OUTER JOIN nmd_file ON nmd08=pmc01 LEFT OUTER JOIN nmf_file ON nmf07=pmc01 AND nmf02<'",tm.bdate,"' WHERE nmf_file.nmf01 = nmd_file.nmd01 AND nmd30<>'X'  AND pmc01='",l_pmc01,"'"
     PREPARE r131_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r131_curs2 CURSOR FOR r131_prepare2
     LET g_amt = 0
     FOREACH r131_curs2 INTO sr1.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach2:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr1.nmd04) THEN LET sr1.nmd04 = 0 END IF
          LET l_sign=0
          LET XX = sr1.nmf05,sr1.nmf06
          CASE XX
               WHEN '01' LET l_sign = -1
               WHEN '16' LET l_sign = 1
               WHEN '18' LET l_sign = 1
               WHEN '19' LET l_sign = 1
               WHEN '17' LET l_sign = 1
               WHEN '0X' LET l_sign = -1
               WHEN 'X8' LET l_sign = 1
          END CASE
          IF l_sign = 0 THEN   #沒有做異動,故不須列出
             CONTINUE FOREACH
          END IF
          IF tm.c = '2' THEN
             LET sr1.nmd04 = sr1.nmd04 * sr1.nmf09   #轉換成本幣
             IF cl_null(sr1.nmd04) THEN LET sr1.nmd04 = 0 END IF
          END IF
          LET g_amt = g_amt - sr1.nmd04 * l_sign
     END FOREACH
END FUNCTION
