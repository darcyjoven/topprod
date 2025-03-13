# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar780.4gl
# Descriptions...: 不能辦理投資抵減明細表
# Date & Author..: 96/06/25 By Sophia
# Modify.........: No.FUN-510035 05/02/01 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/17 by day   單據編號加大
# Modify.........: No.TQC-5B0008 05/11/02 By Sarah 將[1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw       #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3,          # Group total sw       #No.FUN-680070 VARCHAR(3)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
           END RECORD,
       g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
       g_faj   RECORD LIKE faj_file.*,
       g_total LIKE type_file.num20_6,  # User defined variable       #No.FUN-680070 DECIMAL(13,2)
       g_k     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.v  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar780_tm(0,0)        # Input print condition
      ELSE CALL afar780()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar780_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar780_w AT p_row,p_col WITH FORM "afa/42f/afar780"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '32'
   LET tm.t    = 'Y  '
   LET tm.v    = 'Y  '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_total = 0
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj26,faj02,faj813,faj04
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
         LET INT_FLAG = 0 CLOSE WINDOW afar780_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
     #DISPLAY BY NAME tm.s,tm.t,tm.v,tm.more
                     # Condition
      INPUT BY NAME
         tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
         tm2.u1,tm2.u2,tm2.u3,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.v = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW afar780_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar780'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar780','9031',1)
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
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.v CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar780',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar780_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar780()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar780_w
END FUNCTION
 
FUNCTION afar780()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE faj_file.faj813,     #No.FUN-680070 VARCHAR(10)
          sr        RECORD order1 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           order2 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           order3 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           faj02  LIKE faj_file.faj02,    #財產編號
                           faj022 LIKE faj_file.faj022,   #財產附號
                           faj26  LIKE faj_file.faj26,    #取得日期
                           faj491 LIKE faj_file.faj491,   #交貨日期
                           faj04  LIKE faj_file.faj04,    #類別
                           faj47  LIKE faj_file.faj47,    #採購單號
                           faj07  LIKE faj_file.faj07,    #英文名稱
                           faj06  LIKE faj_file.faj06,    #中文名稱
                           faj10  LIKE faj_file.faj10,    #廠商
                           faj08  LIKE faj_file.faj08,    #規格型號
                           faj17  LIKE faj_file.faj17,    #數量
                           faj45  LIKE faj_file.faj45,    #帳款編號
                           faj51  LIKE faj_file.faj51,    #發票號碼
                           faj49  LIKE faj_file.faj49,    #進口編號
                           faj16  LIKE faj_file.faj16,    #原幣值
                           faj15  LIKE faj_file.faj15,    #幣別
                           faj14  LIKE faj_file.faj14,    #本幣值
                           faj813 LIKE faj_file.faj813    #原因
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                  #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                  #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                     #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','',",
                 "faj02,faj022,faj26,faj491,faj04,faj47,faj07,faj06,",
                 "faj10,faj08,faj17,faj45,faj51,faj49,faj16,faj15,",
                 "faj14,faj813",
                 "  FROM faj_file ",
                 " WHERE fajconf = 'Y'",
                 "   AND faj42 = '0'",
                 "   AND ",tm.wc CLIPPED
     PREPARE afar780_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar780_curs1 CURSOR FOR afar780_prepare1
 
     CALL cl_outnam('afar780') RETURNING l_name
 
     START REPORT afar780_rep TO l_name
     LET g_pageno = 0
 
     FOREACH afar780_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1'
                      LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
                      LET g_descripe[g_i]=g_x[9]
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj02
                                        LET g_descripe[g_i]=g_x[9]
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj813
                                        LET g_descripe[g_i]=g_x[9]
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj04
                                        LET g_descripe[g_i]=g_x[9]
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
 
       OUTPUT TO REPORT afar780_rep(sr.*)
     END FOREACH
 
     FINISH REPORT afar780_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT afar780_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          sr        RECORD order1 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           order2 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           order3 LIKE faj_file.faj813,   #No.FUN-680070 VARCHAR(10)
                           faj02  LIKE faj_file.faj02,    #財產編號
                           faj022 LIKE faj_file.faj022,   #財產附號
                           faj26  LIKE faj_file.faj26,    #取得日期
                           faj491 LIKE faj_file.faj491,   #交貨日期
                           faj04  LIKE faj_file.faj04,    #類別
                           faj47  LIKE faj_file.faj47,    #採購單號
                           faj07  LIKE faj_file.faj07,    #英文名稱
                           faj06  LIKE faj_file.faj06,    #中文名稱
                           faj10  LIKE faj_file.faj10,    #廠商
                           faj08  LIKE faj_file.faj08,    #規格型號
                           faj17  LIKE faj_file.faj17,    #數量
                           faj45  LIKE faj_file.faj45,    #帳款編號
                           faj51  LIKE faj_file.faj51,    #發票號碼
                           faj49  LIKE faj_file.faj49,    #進口編號
                           faj16  LIKE faj_file.faj16,    #原幣值
                           faj15  LIKE faj_file.faj15,    #幣別
                           faj14  LIKE faj_file.faj14,    #本幣值
                           faj813 LIKE faj_file.faj813    #原因
                        END RECORD,
      l_amt        LIKE type_file.num20_6,                #No.FUN-680070 DECIMAL(17,5)
#      l_azi03      LIKE azi_file.azi03,                  #No.CHI-6A0004 mark 
#      l_azi04      LIKE azi_file.azi04,                  #No.CHI-6A0004 mark
#      l_azi05      LIKE azi_file.azi05,                  #No.CHI-6A0004 mark
      l_chr        LIKE type_file.chr1                    #No.FUN-680070 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.faj813
  FORMAT
   PAGE HEADER
#No.TQC-6C0009 --end--
#     IF pageno = 1 THEN
#        PRINT '~x0;'
#     ELSE
#        PRINT
#     END IF
#No.TQC-6C0009 --end--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO>1 OR LINENO>13)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO>1 OR LINENO>13)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO>1 OR LINENO>13)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file       #No.CHI-6A0004 l_azi-->t_azi
       WHERE azi01=sr.faj15
         PRINT
            COLUMN g_c[31],sr.faj02,
            COLUMN g_c[32],sr.faj022,
            COLUMN g_c[33],sr.faj26,
            COLUMN g_c[34],sr.faj491,
            COLUMN g_c[35],sr.faj04[1,4],
            COLUMN g_c[36],sr.faj47,            #No.FUN-550034
           #COLUMN g_c[37],sr.faj07[1,30],    #TQC-5B0008 mark
            COLUMN g_c[37],sr.faj07 CLIPPED,  #TQC-5B0008
            COLUMN g_c[38],sr.faj06[1,25],
            COLUMN g_c[39],sr.faj10[1,10],
            COLUMN g_c[40],sr.faj08[1,20],
            COLUMN g_c[41],cl_numfor(sr.faj17,41,0),
            COLUMN g_c[42],sr.faj45,
            COLUMN g_c[43],sr.faj51,
            COLUMN g_c[44],sr.faj49,
            COLUMN g_c[45],cl_numfor(sr.faj16,45,t_azi04),              #No.CHI-6A0004 l_azi-->t_azi  
            COLUMN g_c[46],sr.faj15[1,4],
            COLUMN g_c[47],cl_numfor(sr.faj14,47,g_azi04),
            COLUMN g_c[48],sr.faj813
 
   AFTER GROUP OF sr.order1
      IF tm.v[1,1] = 'Y'
         THEN
         PRINT
         PRINT COLUMN g_c[44],g_descripe[1],
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.faj14),47,g_azi05)
         PRINT
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.v[2,2] = 'Y'
         THEN
         PRINT
         PRINT COLUMN g_c[44],g_descripe[2],
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.faj14),47,g_azi05)
         PRINT
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.v[3,3] = 'Y'
         THEN
         PRINT
         PRINT COLUMN g_c[44],g_descripe[3],
               COLUMN g_c[47],cl_numfor(GROUP SUM(sr.faj14),47,g_azi05)
         PRINT
      END IF
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      LET g_total = SUM(sr.faj14)
      PRINT COLUMN g_c[44],g_x[10] CLIPPED,
            COLUMN g_c[47],cl_numfor(g_total,47,g_azi05)
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     PRINT '~i;'   #No.TQC-6C0009 mark
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
