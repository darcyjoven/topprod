# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr331.4gl
# Descriptions...: 銀行別現金變動年統計表列印作業
# Date & Author..: 93/04/30  By  Felicity  Tseng
#                : 96/06/14 By Lynn   銀行編號(nma01) 取6碼
# Modify.........: No.FUN-4C0098 05/02/01 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,
              range   LIKE type_file.num10,        #No.FUN-680107 INTEGER
              choice  LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
              END RECORD
   DEFINE g_counter   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
DEFINE   g_i          LIKE type_file.num5          #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.range  = ARG_VAL(8)
   LET tm.choice  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r331_tm(0,0)
      ELSE CALL r331()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r331_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r331_w AT p_row,p_col
        WITH FORM "anm/42f/anmr331"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.range = YEAR(g_today)
   LET tm.choice = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01, nma10
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
      LET INT_FLAG = 0 CLOSE WINDOW r331_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.range,tm.choice,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD range
         IF cl_null(tm.range) THEN
            CALL cl_err(0,'anm-003',0)
            LET tm.range = YEAR(g_today)
            DISPLAY BY NAME tm.range
            NEXT FIELD range
         END IF
         IF tm.range < 1900 THEN
            LET tm.range = YEAR(g_today)
            DISPLAY BY NAME tm.range
            NEXT FIELD range
         END IF
 
      AFTER FIELD choice
         IF CL_NULL(tm.choice) OR tm.choice NOT MATCHES '[YN]' THEN
            LET tm.choice = 'N'
            NEXT FIELD choice
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
      LET INT_FLAG = 0 CLOSE WINDOW r331_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr331'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr331','9031',1)
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
                         " '",tm.range CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr331',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r331_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r331()
   ERROR ""
END WHILE
   CLOSE WINDOW r331_w
END FUNCTION
 
FUNCTION r331()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
          l_bdate   LIKE type_file.dat,          #No.FUN-680107 DATE
          l_edate   LIKE type_file.dat,          #No.FUN-680107 DATE
          l_temp    LIKE type_file.chr8,         #No.FUN-680107 VARCHAR(8)
          l_idx     LIKE type_file.num10,        #No.FUN-680107 INTEGER
          sr               RECORD
                                  nma01 LIKE nma_file.nma01,  #銀行編號
                                  nma03 LIKE nma_file.nma03,  #銀行全名
                                  nma10 LIKE nma_file.nma10,  #幣別
                                  nmc03 LIKE nmc_file.nmc03,  #存提別
                                  nml01 LIKE nml_file.nml01,  #現金變動碼
                                  nml02 LIKE nml_file.nml02,  #變動碼說明
                                  amt   LIKE nme_file.nme04,  #金額
                                  mouth LIKE nmp_file.nmp03,  #變動月份
                                  azi05 LIKE azi_file.azi05
                        END RECORD
 
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
                 " nma01,nma03,nma10,nmc03,nml01,nml02,SUM(nme04),0,azi05 ",
                 " FROM nma_file, nmc_file, nme_file, nml_file,",
                 " OUTER azi_file ",
                 " WHERE ",
                 " nme01 = nma01 ",             #銀行編號
                 " AND nmc01 = nme03 ",         #異動碼
                 " AND nml01 = nme14 ",         #現金變動碼
                " AND nme02 BETWEEN ? AND ? ", #異動日期
                 " AND azi_file.azi01 = nma_file.nma10 ",
                 " AND ",tm.wc CLIPPED,
                 " GROUP BY nma01, nma03, nma10, nmc03, nml01, nml02, azi05 "
 
#    LET l_sql = l_sql CLIPPED," ORDER BY apa01"
     IF tm.range >= 2000 THEN
        LET l_temp[1,2] =(tm.range-2000) USING '&&'
     ELSE
        LET l_temp[1,2] =(tm.range-1900) USING '&&'
     END IF
     LET l_temp[3,8] ='/01/01'
     LET l_bdate = l_temp                       #取得輸入年份的第一天
     CALL cl_outnam('anmr331') RETURNING l_name
     START REPORT r331_rep TO l_name
     PREPARE r331_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r331_curs1 CURSOR FOR r331_prepare1
     FOR l_idx = 1 TO 12
         IF l_idx != 1 THEN
            LET l_bdate = l_edate + 1           #得出當月第一天
            LET l_edate = s_last(l_bdate)       #得出當月最後一天
         ELSE
            LET l_edate = s_last(l_bdate)       #得出當月最後一天
         END IF
#        LET l_name = 'anmr331.out'
         LET g_pageno = 0
         LET g_counter = 0
         FOREACH r331_curs1 USING l_bdate,l_edate INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach error!',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET sr.mouth = l_idx
              IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
              OUTPUT TO REPORT r331_rep(sr.*)
         END FOREACH
     END FOR
 
     FINISH REPORT r331_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r331_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_bank       LIKE zaa_file.zaa08,         #No.FUN-680107 VARCHAR(40)
          l_curr       LIKE zaa_file.zaa08,         #No.FUN-680107 VARCHAR(18)
          sr               RECORD
                                  nma01 LIKE nma_file.nma01,  #銀行編號
                                  nma03 LIKE nma_file.nma03,  #銀行全名
                                  nma10 LIKE nma_file.nma10,  #幣別
                                  nmc03 LIKE nmc_file.nmc03,  #存提別
                                  nml01 LIKE nml_file.nml01,  #現金變動碼
                                  nml02 LIKE nml_file.nml02,  #變動碼說明
                                  amt   LIKE nme_file.nme04,  #金額
                                  mouth LIKE nmp_file.nmp03,  #變動月份
                                  azi05 LIKE azi_file.azi05
                        END RECORD,
      l_position   LIKE type_file.num10,                      #No.FUN-680107 INTEGER
      l_idx        LIKE type_file.num10,                      #No.FUN-680107 INTEGER
      l_mony       LIKE  nme_file.nme04,
      l_gsum       LIKE  nme_file.nme04,
      l_ary        ARRAY [20] OF LIKE type_file.num20_6,      #No.FUN-680107 ARRAY[20] OF DECIMAL
      l_chr        LIKE type_file.chr1                        #No.FUN-680107 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nma01,sr.nma10,sr.nml01,sr.mouth,sr.nmc03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[10] CLIPPED, tm.range
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT  g_x[31] CLIPPED,
             g_x[32] CLIPPED,
             g_x[33] CLIPPED,
             g_x[34] CLIPPED,
             g_x[35] CLIPPED,
             g_x[36] CLIPPED,
             g_x[37] CLIPPED,
             g_x[38] CLIPPED,
             g_x[39] CLIPPED,
             g_x[40] CLIPPED,
             g_x[41] CLIPPED,
             g_x[42] CLIPPED,
             g_x[43] CLIPPED,
             g_x[44] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nma01   #銀行編號
      IF tm.choice = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
      LET g_counter = g_counter + 1
      IF g_counter != 1 THEN
         PRINT g_dash2[1,g_len]
      END IF
      FOR l_idx = 1 TO 12
          LET l_ary[l_idx] = 0
      END FOR
      #96-06-14 Modify By Lynn
      LET l_bank=g_x[25] CLIPPED,sr.nma01,' - ',sr.nma03
      LET l_curr=g_x[26] CLIPPED,sr.nma10
      PRINT COLUMN g_c[31],l_bank,
            COLUMN g_c[34],l_curr
      SKIP 1 LINE
 
   BEFORE GROUP OF sr.nml01  #現金變動碼
      LET l_gsum = 0         #合計
      PRINT COLUMN g_c[31], sr.nml02;
 
   BEFORE GROUP OF sr.mouth
      LET l_mony = 0
 
   ON EVERY ROW
      IF sr.nmc03 = '1' THEN
         LET l_mony = l_mony + sr.amt  #借方
      ELSE
         LET l_mony = l_mony - sr.amt  #貸方
      END IF
 
   AFTER GROUP OF sr.mouth
      CASE
           WHEN sr.mouth = 1
                PRINT COLUMN g_c[32], cl_numfor(l_mony,32,sr.azi05) CLIPPED;
                LET l_ary[1] =l_ary[1] + l_mony
           WHEN sr.mouth = 2
                PRINT COLUMN g_c[33], cl_numfor(l_mony,33,sr.azi05) CLIPPED;
                LET l_ary[2] =l_ary[2] + l_mony
           WHEN sr.mouth = 3
                PRINT COLUMN g_c[34], cl_numfor(l_mony,34,sr.azi05) CLIPPED;
                LET l_ary[3] =l_ary[3] + l_mony
           WHEN sr.mouth = 4
                PRINT COLUMN g_c[35], cl_numfor(l_mony,35,sr.azi05) CLIPPED;
                LET l_ary[4] =l_ary[4] + l_mony
           WHEN sr.mouth = 5
                PRINT COLUMN g_c[36], cl_numfor(l_mony,36,sr.azi05) CLIPPED;
                LET l_ary[5] =l_ary[5] + l_mony
           WHEN sr.mouth = 6
                PRINT COLUMN g_c[37], cl_numfor(l_mony,37,sr.azi05) CLIPPED;
                LET l_ary[6] =l_ary[6] + l_mony
           WHEN sr.mouth = 7
                PRINT COLUMN g_c[38], cl_numfor(l_mony,38,sr.azi05) CLIPPED;
                LET l_ary[7] =l_ary[7] + l_mony
           WHEN sr.mouth = 8
                PRINT COLUMN g_c[39], cl_numfor(l_mony,39,sr.azi05) CLIPPED;
                LET l_ary[8] =l_ary[8] + l_mony
           WHEN sr.mouth = 9
                PRINT COLUMN g_c[40], cl_numfor(l_mony,40,sr.azi05) CLIPPED;
                LET l_ary[9] =l_ary[9] + l_mony
           WHEN sr.mouth = 10
                PRINT COLUMN g_c[41], cl_numfor(l_mony,41,sr.azi05) CLIPPED;
                LET l_ary[10] =l_ary[10] + l_mony
           WHEN sr.mouth = 11
                PRINT COLUMN  g_c[42],cl_numfor(l_mony,42,sr.azi05) CLIPPED;
                LET l_ary[11] =l_ary[11] + l_mony
           WHEN sr.mouth = 12
                PRINT COLUMN g_c[43], cl_numfor(l_mony,43,sr.azi05) CLIPPED;
                LET l_ary[12] =l_ary[12] + l_mony
      END CASE
      LET l_gsum = l_gsum + l_mony
 
   AFTER GROUP OF sr.nml01
      PRINT COLUMN g_c[44], cl_numfor(l_gsum,44,sr.azi05) CLIPPED  #Print 合計
 
   AFTER GROUP OF sr.nma01
      IF tm.choice = 'Y' THEN
         LET g_counter = 0
      END IF
      LET l_position = 0
      PRINT COLUMN g_c[31], g_x[27] CLIPPED;
      FOR l_idx = 1 TO 12
          IF l_ary[l_idx] = 0 THEN
             LET l_ary[l_idx] = NULL
          END IF
      END FOR
      FOR l_idx = 1 TO 12
          LET l_position = 31+ l_idx
              PRINT COLUMN g_c[l_position],
                    cl_numfor(l_ary[l_idx],l_position,sr.azi05) CLIPPED;
      END FOR
      SKIP 1 LINE
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash2[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash2[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
