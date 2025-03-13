# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr231.4gl
# Descriptions...: 客戶別應收票據明細帳列印作業
# Date & Author..: 93/04/23  By  Felicity  Tseng
#                : 96/06/13 By Lynn   託貼銀行(nmh21)取6碼
# Modify.........: No.FUN-4C0098 05/01/07 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0244 05/10/21 By Smapmin 未顯示異動金額
# Modify.........: No.MOD-640035 06/04/12 By Nicola 選擇原幣幣別,依原幣顯示應依幣別分別計算顯示,QBE加幣別
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
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
   DEFINE g_dash_1    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(132)
   DEFINE g_counter   LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_amt       LIKE nmh_file.nmh02
   DEFINE g_ary DYNAMIC ARRAY OF RECORD
                data  LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(53)
                sign  LIKE type_file.num10,  #No.FUN-680107 INTEGER
                mony  LIKE nmh_file.nmh02    #餘額
          END RECORD
 
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
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
   LET tm.bdate = ARG_VAL(10)    #TQC-610058
   LET tm.edate = ARG_VAL(11)    #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r231_tm(0,0)           # Input print condition
      ELSE CALL r231()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r231_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r231_w AT p_row,p_col
        WITH FORM "anm/42f/anmr231"
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
   CONSTRUCT BY NAME tm.wc ON occ01,nmh03   #No.MOD-640035
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
      LET INT_FLAG = 0 CLOSE WINDOW r231_w 
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
#     ON ACTION CONTROLP CALL r231_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r231_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr231'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr231','9031',1)
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
         CALL cl_cmdat('anmr231',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r231_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r231()
   ERROR ""
END WHILE
   CLOSE WINDOW r231_w
END FUNCTION
 
{
FUNCTION r231_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
 
   OPEN WINDOW r231_w2 AT 2,2
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
		
   CLOSE WINDOW r231_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r231_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
END FUNCTION
}
 
FUNCTION r231()
   DEFINE l_name    LIKE type_file.chr20         #No.FUN-680107 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0082
   DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
   DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
   DEFINE XX        LIKE type_file.chr2          #No.FUN-680107 VARCHAR(2)
   DEFINE    sr            RECORD
                                  occ01 LIKE occ_file.occ01, #客戶編號
                                  occ02 LIKE occ_file.occ02, #客戶名稱
                                  occ29 LIKE occ_file.occ29, #應收票據餘額
                                  nmh01 LIKE nmh_file.nmh01, #票號
                                  nmh02 LIKE nmh_file.nmh02, #票面金額
                                  nmh03 LIKE nmh_file.nmh03, #幣別
                                  nmh21 LIKE nmh_file.nmh21, #託貼銀行
                                  nmh17 LIKE nmh_file.nmh17, #收款單號
                                  nmi02 LIKE nmi_file.nmi02, #異動日期
                                  nmi03 LIKE nmi_file.nmi03, #異動時間
                                  nmi05 LIKE nmi_file.nmi05,
                                  nmi06 LIKE nmi_file.nmi06,
                                  nmi09 LIKE nmi_file.nmi09,  #本次異動匯率
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
     #End:FUN-980030
 
 
 
     LET l_sql = "SELECT ",
                 " occ01, occ02, occ63, nmh01, nmh02, nmh03, nmh21,  nmh17,",
                 " nmi02, nmi03, nmi05, nmi06, nmi09, 0 ",
                 " FROM occ_file,",
                 " OUTER (nmh_file,nmi_file)",
                 " WHERE ",
                 " nmh_file.nmh11 = occ_file.occ01 ",        #
                 " AND nmi_file.nmi07 = occ_file.occ01 ",    #
                 " AND nmi_file.nmi01 = nmh_file.nmh01 ",    #
                 " AND nmi_file.nmi02 >= '",tm.bdate,"'",
                 " AND ", tm.wc CLIPPED
     PREPARE r231_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r231_curs1 CURSOR FOR r231_prepare1
#    LET l_name = 'anmr231.out'
     CALL cl_outnam('anmr231') RETURNING l_name
     START REPORT r231_rep TO l_name
     LET g_pageno = 0
     LET g_counter = 0
     IF tm.c = '2' THEN
        SELECT azi04, azi05
          INTO t_azi04, t_azi05
          FROM azi_file
          WHERE azi01 = g_aza.aza17
        IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004
        IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004
     END IF
     FOREACH r231_curs1 INTO sr.*
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
          IF sr.sign = 0 THEN
             CONTINUE FOREACH
          END IF
          IF tm.c = '2' THEN
             LET sr.nmh03 = g_aza.aza17           #g_aza17 :本幣幣別(NT$)
             LET sr.nmh02 = sr.nmh02 * sr.nmi09   #轉換成本幣
             IF cl_null(sr.nmh02) THEN LET sr.nmh02 = 0 END IF
          END IF
          OUTPUT TO REPORT r231_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r231_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r231_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_amt         LIKE nmh_file.nmh02
   DEFINE l_idx         LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_max         LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_empty       LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
#No.TQC-6A0110 -- begin --
#   DEFINE l_exp1        LIKE nmi_file.nmi05   #No.FUN-680107 VARCHAR(6)
#   DEFINE l_exp2        LIKE nmi_file.nmi06   #No.FUN-680107 VARCHAR(6)
   DEFINE l_exp1        LIKE ze_file.ze03
   DEFINE l_exp2        LIKE ze_file.ze03
#No.TQC-6A0110 -- end --
   DEFINE l_nma02       LIKE nma_file.nma02   #銀行簡稱
   DEFINE    sr            RECORD
                                  occ01 LIKE occ_file.occ01, #客戶編號
                                  occ02 LIKE occ_file.occ02, #客戶名稱
                                  occ63 LIKE occ_file.occ63, #應收票據餘額
                                  nmh01 LIKE nmh_file.nmh01, #票號
                                  nmh02 LIKE nmh_file.nmh02, #票面金額
                                  nmh03 LIKE nmh_file.nmh03, #幣別
                                  nmh21 LIKE nmh_file.nmh21, #託貼銀行
                                  nmh17 LIKE nmh_file.nmh17, #收款單號
                                  nmi02 LIKE nmi_file.nmi02, #異動日期
                                  nmi03 LIKE nmi_file.nmi03, #異動時間
                                  nmi05 LIKE nmi_file.nmi05,
                                  nmi06 LIKE nmi_file.nmi06,
                                  nmi09 LIKE nmi_file.nmi09,  #本次異動匯率
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
 
   DEFINE l_ary   DYNAMIC ARRAY OF RECORD
                                  nmh01 LIKE nmh_file.nmh01,  #票號
                                  nmh02 LIKE nmh_file.nmh02,  #票面金額
                                  nmh21 LIKE nmh_file.nmh21,  #託貼銀行
                                  nma02 LIKE nma_file.nma02,
                                  nmh17 LIKE nmh_file.nmh17,  #收款單號
                                  nmi02 LIKE nmi_file.nmi02,  #異動日期
#No.TQC-6A0110 -- begin --
#                                  nmi05 LIKE nmi_file.nmi05,  #No.FUN-680107 VARCHAR(6)
#                                  nmi06 LIKE nmi_file.nmi06,  #No.FUN-680107 VARCHAR(6)
                                  nmi05 LIKE ze_file.ze03,
                                  nmi06 LIKE ze_file.ze03,
#No.TQC-6A0110 -- end --
                                  sign  LIKE type_file.num10  #No.FUN-680107 INTEGER
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.occ01,sr.nmh03, sr.nmi02, sr.nmi03   #No.MOD-640035
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
 
   BEFORE GROUP OF sr.occ01
      IF tm.d = 'Y' AND (PAGENO >1 OR LINENO >9)THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.nmh03   #No.MOD-640035
      LET g_counter = g_counter + 1
      IF g_counter != 1 AND (PAGENO >1 OR LINENO >9) THEN
         PRINT g_dash2[1,g_len]
      END IF
      FOR l_idx = 1 TO 100
          INITIALIZE g_ary[l_idx].* TO NULL
      END FOR
      IF tm.c = '1' THEN       #幣別為原幣
         SELECT azi04, azi05
           INTO t_azi04, t_azi05    #NO.CHI-6A0004 
           FROM azi_file
           WHERE azi01 = sr.nmh03
         IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004
         IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004
      END IF
      LET l_amt = sr.occ63     #目前應收帳款餘額
      LET l_idx = 0
 
   ON EVERY ROW
      CALL s_nmdsta(sr.nmi05)  #得出票況的說明
           RETURNING l_exp1
      CALL s_nmdsta(sr.nmi06)  #得出票況的說明
           RETURNING l_exp2
      LET l_exp1=sr.nmi05,'.',l_exp1
      LET l_exp2=sr.nmi06,'.',l_exp2
      SELECT nma02 INTO l_nma02  FROM nma_file WHERE nma01=sr.nmh21
     #96-06-13 Modify By Lynn
      IF sr.nmi02 <= tm.edate THEN       #小於截止日期之data才放入ARRAY
         IF l_idx > 100 THEN CALL cl_err('',9035,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
            EXIT PROGRAM 
         END IF
         LET l_idx = l_idx +1
         LET l_ary[l_idx].nmi02=sr.nmi02
         LET l_ary[l_idx].nmh21=sr.nmh21
         LET l_ary[l_idx].nma02=l_nma02
         LET l_ary[l_idx].nmh17=sr.nmh17 #cl_numfor(sr.nmh17,18,t_azi04)  #NO.CHI-6A0004
         LET l_ary[l_idx].nmh01=sr.nmh01
         LET l_ary[l_idx].nmi05=l_exp1
         LET l_ary[l_idx].nmi06=l_exp2
         LET l_ary[l_idx].sign=sr.sign
         LET l_ary[l_idx].nmh02=sr.nmh02
 
      END IF
      LET l_amt = l_amt + (sr.sign*sr.nmh02)
 
#  AFTER GROUP OF sr.occ01
   AFTER GROUP OF sr.nmh03   #No.MOD-640035
      IF tm.d = 'Y' THEN
         LET g_counter = 0
      END IF
      LET l_max = l_idx                  #ARRAY 被使用的個數
      LET l_empty = 'Y'
      FOR l_idx = 1 TO l_max             #Check Array Y/N empty
          IF NOT cl_null(l_ary[l_idx].nmi02) THEN
             LET l_empty ='N'
             EXIT FOR
          END IF
      END FOR
      CALL r231_calbal(sr.occ01)   #計算期初值
      LET l_amt=g_amt
      IF cl_null(l_amt) THEN LET l_amt=0 END IF
      IF l_empty ='N' OR (l_amt != 0) THEN     #有異動資料者 or 期初 != 0
         PRINT COLUMN g_c[31], g_x[10] CLIPPED,
               COLUMN g_c[32], sr.occ01, #Print "客戶"、"期初"
               COLUMN g_c[33], sr.occ02,
               COLUMN g_c[36], g_x[9] CLIPPED,
               COLUMN g_c[37], sr.nmh03,
               COLUMN g_c[38], g_x[11] CLIPPED,
               COLUMN g_c[39], cl_numfor(l_amt,39,t_azi05)  #NO.CHI-6A0004
         SKIP 1 LINE
         FOR l_idx = 1 TO l_max
             LET l_amt = l_amt - l_ary[l_idx].sign * l_ary[l_idx].nmh02
             PRINT COLUMN g_c[31],l_ary[l_idx].nmi02,
                   COLUMN g_c[32],l_ary[l_idx].nmh21,
                   COLUMN g_c[33],l_ary[l_idx].nma02,
                   #COLUMN g_c[34],l_ary[l_idx].nmh17,
                   COLUMN g_c[34],cl_numfor(l_ary[l_idx].nmh17,34,t_azi04), #NO.CHI-6A0004
                   COLUMN g_c[35],l_ary[l_idx].nmh01,
                   COLUMN g_c[36],l_ary[l_idx].nmi05,
                   COLUMN g_c[37],l_ary[l_idx].nmi06,
                   COLUMN g_c[38], cl_numfor
#                   (-1*g_ary[l_idx].sign*g_ary[l_idx].mony,38,t_azi04) CLIPPED,   #MOD-5A0244 #NO.CHI-6A0004
                   (-1*l_ary[l_idx].sign * l_ary[l_idx].nmh02,38,t_azi04) CLIPPED,   #MOD-5A0244 #NO.CHI-6A0004
                   COLUMN g_c[39], cl_numfor(l_amt,39,t_azi05) CLIPPED    #NO.CHI-6A0004
         END FOR
         LET l_max = 0
      END IF
 
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166 Start
          #    IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
 
          CALL cl_prt_pos_wc(tm.wc)
         #TQC-630166 End
 
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
 
FUNCTION r231_calbal(l_occ01)
   DEFINE    XX     LIKE type_file.chr2     #No.FUN-680107
   DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(600)
   DEFINE l_sign    LIKE type_file.num10    #No.FUN-680107 INTEGER
   DEFINE l_occ01   LIKE occ_file.occ01
   DEFINE sr1           RECORD
                                  occ01 LIKE occ_file.occ01, #客戶編號
                                  nmh02 LIKE nmh_file.nmh02, #票面金額
                                  nmi05 LIKE nmi_file.nmi05,
                                  nmi06 LIKE nmi_file.nmi06,
                                  nmi09 LIKE nmi_file.nmi09  #本次異動匯率
                        END RECORD
 
     LET l_sql = "SELECT occ01, nmh02, nmi05, nmi06, nmi09 ",
                 " FROM occ_file,",
                 " OUTER (nmh_file,nmi_file)",
                 " WHERE  nmh_file.nmh11 = occ_file.occ01 ",        #客戶編號
                 " AND nmi_file.nmi07 = occ_file.occ01 ",    #客戶編號
                 " AND nmi_file.nmi01 = nmh_file.nmh01 ",    #票號
                 " AND nmi_file.nmi02 < '",tm.bdate,"'",
                 " AND occ01='",l_occ01,"'"
     PREPARE r231_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r231_curs2 CURSOR FOR r231_prepare2
     IF tm.c = '2' THEN
        SELECT azi04, azi05 INTO t_azi04, t_azi05  #NO.CHI-6A0004
          FROM azi_file WHERE azi01 = g_aza.aza17
        IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF  #NO.CHI-6A0004
        IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF  #NO.CHI-6A0004
     END IF
     LET g_amt=0
     FOREACH r231_curs2 INTO sr1.*
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
             LET sr1.nmh02 = sr1.nmh02 * sr1.nmi09   #轉換成本幣
             IF cl_null(sr1.nmh02) THEN LET sr1.nmh02 = 0 END IF
          END IF
          LET g_amt=g_amt - sr1.nmh02 * l_sign
     END FOREACH
END FUNCTION
