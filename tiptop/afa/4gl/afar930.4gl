# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar930.4gl
# Descriptions...: 未抵押資產明細表
# Date & Author..: 96/06/11 By STAR
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-860018 08/06/10 By Smapmin INPUT語法錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                   # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition            #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1,          # Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr3,          # Order by sequence          #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3           # Eject sw                   #No.FUN-680070 VARCHAR(3)
           END RECORD,
       m_codest  LIKE type_file.chr1000             #No.FUN-680070 VARCHAR(34)
 
DEFINE g_i            LIKE type_file.num5           #count/index for any purpose #No.FUN-680070 SMALLINT
DEFINE t4             LIKE type_file.num5           #No.FUN-680070 SMALLINT
 
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar930_tm(0,0)        # Input print condition
      ELSE CALL afar930()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar930_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar930_w AT p_row,p_col WITH FORM "afa/42f/afar930"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s  = '12 '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj14,faj33,faj30,faj47,faj53, faj20,faj22
 
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
 
     #-----MOD-610033---------
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(faj22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_azp"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj22
                   NEXT FIELD faj22
        END CASE
     #-----END MOD-610033-----
 
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar930_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm.more
            WITHOUT DEFAULTS
 
         #INPUT BY NAME tm.s,tm.t,tm.more WITHOUT DEFAULTS     #TQC-860018
 
            AFTER FIELD more
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
         LET INT_FLAG = 0 CLOSE WINDOW afar930_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW afar930_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar930'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar930','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s  CLIPPED,"'",
                            " '",tm.t  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
            CALL cl_cmdat('afar930',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar930()
   END WHILE
 
   CLOSE WINDOW afar930_w
END FUNCTION
 
FUNCTION afar930()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE type_file.chr21,          #No.FUN-680070 VARCHAR(10)
          sr        RECORD order1 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order2 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order3 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           faj04  LIKE faj_file.faj04,
                           faj06  LIKE faj_file.faj06,
                           faj07  LIKE faj_file.faj07,
                           faj17  LIKE faj_file.faj17,
                           faj58  LIKE faj_file.faj58,
                           faj14  LIKE faj_file.faj14,
                           faj32  LIKE faj_file.faj32,
                           faj33  LIKE faj_file.faj33,
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           faj29  LIKE faj_file.faj29,
                           faj30  LIKE faj_file.faj30,
                           faj05  LIKE faj_file.faj05,
                           faj53  LIKE faj_file.faj53,
                           faj47  LIKE faj_file.faj47,
                           faj21  LIKE faj_file.faj21
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','',faj04,faj06,faj07,faj17,faj58,faj14,faj32, ",
                 "       faj33,faj02,faj022,faj29,faj30,faj05,faj53,faj47,faj21 ",
                 "  FROM faj_file ",
            #    " WHERE faj89<>' ' ",
                 " WHERE ( faj89=' ' or faj89 is null ) ",
            #---- jeffery update ------#
          #      " WHERE faj41='1' and faj43 not matches '[056]' ",
                 "   AND ",tm.wc CLIPPED
# call cl_wcshow(l_sql)
 
     PREPARE afar930_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar930_curs1 CURSOR FOR afar930_prepare1
 
      CALL cl_outnam('afar930') RETURNING l_name
 
     START REPORT afar930_rep TO l_name
     LET g_pageno = 0
 
     FOREACH afar930_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj14
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj33
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj30
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF cl_null(sr.faj17) THEN LET sr.faj17 = 0 END IF
       IF cl_null(sr.faj58) THEN LET sr.faj58 = 0 END IF
       IF cl_null(sr.faj14) THEN LET sr.faj14 = 0 END IF
       IF cl_null(sr.faj32) THEN LET sr.faj32 = 0 END IF
       IF cl_null(sr.faj33) THEN LET sr.faj33 = 0 END IF
       IF cl_null(sr.faj29) THEN LET sr.faj29 = 0 END IF
       IF cl_null(sr.faj30) THEN LET sr.faj30 = 0 END IF
       OUTPUT TO REPORT afar930_rep(sr.*)
     END FOREACH
 
     FINISH REPORT afar930_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT afar930_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,                       #No.FUN-680070 VARCHAR(1)
          sr        RECORD order1 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order2 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           order3 LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(10)
                           faj04  LIKE faj_file.faj04,
                           faj06  LIKE faj_file.faj06,
                           faj07  LIKE faj_file.faj07,
                           faj17  LIKE faj_file.faj17,
                           faj58  LIKE faj_file.faj58,
                           faj14  LIKE faj_file.faj14,
                           faj32  LIKE faj_file.faj32,
                           faj33  LIKE faj_file.faj33,
                           faj02  LIKE faj_file.faj02,
                           faj022 LIKE faj_file.faj022,
                           faj29  LIKE faj_file.faj29,
                           faj30  LIKE faj_file.faj30,
                           faj05  LIKE faj_file.faj05,
                           faj53  LIKE faj_file.faj53,
                           faj47  LIKE faj_file.faj47,
                           faj21  LIKE faj_file.faj21
                        END RECORD
  define i LIKE type_file.num5         #No.FUN-680070 smallint
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
         SKIP TO TOP OF PAGE
     END IF
 
   BEFORE GROUP OF sr.order2
     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
 
   BEFORE GROUP OF sr.order3
     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10) THEN
        SKIP TO TOP OF PAGE
     END IF
 
   ON EVERY ROW
         PRINT COLUMN g_c[31], sr.faj04,
               COLUMN g_c[32],sr.faj06[1,23],
               COLUMN g_c[33],sr.faj07,
               COLUMN g_c[34],cl_numfor(sr.faj17-sr.faj58,34,0),
               COLUMN g_c[35],cl_numfor(sr.faj14,35,g_azi03),
               COLUMN g_c[36],cl_numfor(sr.faj32,36,g_azi04),
               COLUMN g_c[37],cl_numfor(sr.faj33,37,g_azi04),
               COLUMN g_c[38],sr.faj02,
               COLUMN g_c[39],sr.faj022,
               COLUMN g_c[40],sr.faj29 USING '###',
               COLUMN g_c[41],sr.faj30 USING '###',
               COLUMN g_c[42],sr.faj30/sr.faj29 USING '#.##',
               COLUMN g_c[43],sr.faj53[1,6],
               COLUMN g_c[44],sr.faj47,
               COLUMN g_c[45],sr.faj21
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      print column g_c[31],g_x[10],
            column g_c[35],cl_numfor(sum(sr.faj14),35,g_azi05),
            column g_c[36],cl_numfor(sum(sr.faj32),36,g_azi05),
            column g_c[37],cl_numfor(sum(sr.faj33),37,g_azi05)
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
       ELSE
           SKIP 2 LINE
       END IF
 
END REPORT
