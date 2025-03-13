# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar960.4gl
# Descriptions...: 抵押資產報廢/出售明細表
# Date & Author..: 96/06/11 By STAR
# Modify.........: No.FUN-510035 05/01/24 By Smapmin 報表轉XML格式
#
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-860018 08/06/10 By Smapmin INPUT語法錯誤
# Modify.........: No.FUN-890054 08/09/11 By sabrina 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                   # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition            #No.FUN-680070 VARCHAR(1000)
              bdate   LIKE type_file.dat,           #No.FUN-680070 DATE
              edate   LIKE type_file.dat,           #No.FUN-680070 DATE
              more    LIKE type_file.chr1,          # Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
              s       LIKE type_file.chr3,          # Order by sequence          #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw                   #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3           #No.FUN-680070 VARCHAR(3)
           END RECORD,
       m_codest       LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(34)
 
DEFINE g_i            LIKE type_file.num5           #count/index for any purpose #No.FUN-680070 SMALLINT
#FUN-890054---add-start
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
#FUN-890054---add-end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   #FUN-890054---add-start
   LET g_sql="faj89.faj_file.faj89,",
             "faj90.faj_file.faj90,",
             "faj02.faj_file.faj02,",
             "faj022.faj_file.faj022,",
             "faj06.faj_file.faj06,",
             "faj07.faj_file.faj07,",
             "faj17.faj_file.faj17,",
             "faj87.faj_file.faj87,",
             "faj33.faj_file.faj33,",
             "faj47.faj_file.faj47,",
             "faj58.faj_file.faj58,",
             "faj14.faj_file.faj14,",
             "faj141.faj_file.faj141,",
             "faj59.faj_file.faj59,",
             "faj32.faj_file.faj32,",
             "faj60.faj_file.faj60"
            
   LET l_table=cl_prt_temptable('afar960',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
 
   LET g_sql="INSERT INTO ", g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
 
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  
   INITIALIZE tm.* TO NULL
   #FUN-890054---add---end
 
   LET g_pdate = ARG_VAL(1)                         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.v  = ARG_VAL(10)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'             # If background job sw is off
      THEN CALL afar960_tm(0,0)                     # Input print condition
      ELSE CALL afar960()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar960_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,      #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar960_w AT p_row,p_col WITH FORM "afa/42f/afar960"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
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
      CONSTRUCT BY NAME tm.wc ON faj89,faj90,faj47,faj20,faj22
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar960_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm.bdate,tm.edate,
            tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,
            tm.more
            WITHOUT DEFAULTS
 
 
         #INPUT BY NAME tm.bdate,tm.edate,tm.s,tm.t,tm.v,tm.more WITHOUT DEFAULTS   #TQC-860018
 
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
         END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW afar960_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar960'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar960','9031',1)
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
                            " '",tm.v  CLIPPED,"'",
                            " '",tm.bdate  CLIPPED,"'",
                            " '",tm.edate  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
            CALL cl_cmdat('afar960',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar960_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar960()
   END WHILE
 
   CLOSE WINDOW afar960_w
END FUNCTION
 
FUNCTION afar960()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE faj_file.faj89,         #No.FUN-680070 VARCHAR(10)
         #l_n       LIKE type_file.num5,          #No.FUN-680070 SMALLINT  #FUN-890054  mark
          l_fap03   LIKE fap_file.fap03,
          l_fap04   LIKE fap_file.fap04,
          sr        RECORD order1 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
                           order2 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
                           order3 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
                           faj    RECORD  LIKE faj_file.*,
                           qty    LIKE faj_file.faj17,       #數量
                           cost   LIKE faj_file.faj14        #帳值
                    END RECORD
  #DEFINE l_str     LIKE type_file.chr6                      #No.FUN-680070 VARCHAR(6)  #FUN-890054  mark
 
     CALL cl_del_data(l_table)       #FUN-890054 add 清除暫存檔的資料  
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='afar960'   #FUN-890054 add 抓取是否列印選擇條件
 
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
 
 
     LET l_sql = "SELECT '','','',faj_file.*,0,0 ",
                 "  FROM faj_file ",
                 " WHERE (faj89!= '' OR faj89 IS NOT NULL)",  #抵押資產
                 "   AND ",tm.wc CLIPPED
 
     PREPARE afar960_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar960_curs1 CURSOR FOR afar960_prepare1
 
    #FUN-890054---mark---start
     #CALL cl_outnam('afar960') RETURNING l_name  
     #START REPORT afar960_rep TO l_name    
     #LET g_pageno = 0                     
    #FUN-890054---mark---end
 
     FOREACH afar960_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
          #取得這筆扺押資產, 是什麼狀況
          LET l_fap03 = '' LET l_fap04 = ''
          DECLARE fap_curs SCROLL CURSOR FOR
          SELECT fap03,fap04 FROM fap_file
           WHERE fap02 = sr.faj.faj02 AND fap021 = sr.faj.faj022
             AND fap03 in ('4','5','6')
             AND fap04 >=  tm.bdate
             AND fap04 <=  tm.edate ORDER BY fap04 DESC
          OPEN fap_curs
          FETCH FIRST fap_curs INTO l_fap03,l_fap04
          CLOSE fap_curs
          IF l_fap03 = '0' THEN CONTINUE FOREACH END IF  #若為新購, 則不列印
         #CALL r960_getstatus(l_n) RETURNING l_str     #FUN-890054  mark
          #取得抵押的數量及帳值
          SELECT fce20,fce04 INTO sr.qty,sr.cost
            FROM fce_file WHERE fce03=sr.faj.faj02 AND fce031=sr.faj.faj022
          IF STATUS THEN
             LET sr.qty=(sr.faj.faj17-sr.faj.faj58)
             LET sr.cost=sr.faj.faj14+sr.faj.faj141-sr.faj.faj59
                         -sr.faj.faj32-sr.faj.faj60
          END IF
 
      #FUN-890054---mark---start
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      #FOR g_i = 1 TO 3
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj.faj89
      #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj.faj90
      #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj.faj47
      #        OTHERWISE LET l_order[g_i] = '-'
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #LET sr.order3 = l_order[3]
      #FUN-890054---mark---end
       IF cl_null(sr.faj.faj17)  THEN LET sr.faj.faj17 = 0 END IF
       IF cl_null(sr.faj.faj58)  THEN LET sr.faj.faj58 = 0 END IF
       IF cl_null(sr.faj.faj14)  THEN LET sr.faj.faj14 = 0 END IF
       IF cl_null(sr.faj.faj141) THEN LET sr.faj.faj141 = 0 END IF
       IF cl_null(sr.faj.faj59)  THEN LET sr.faj.faj59 = 0 END IF
       IF cl_null(sr.faj.faj32)  THEN LET sr.faj.faj32 = 0 END IF
       IF cl_null(sr.faj.faj60)  THEN LET sr.faj.faj60 = 0 END IF
      #OUTPUT TO REPORT afar960_rep(sr.*,l_str)   #FUN-890054 mark
 
      #FUN-890054---add---start
      EXECUTE insert_prep USING
        sr.faj.faj89, sr.faj.faj90, sr.faj.faj02, sr.faj.faj022, sr.faj.faj06,
        sr.faj.faj07, sr.qty, sr.faj.faj87, sr.cost, sr.faj.faj47, sr.faj.faj58,
        sr.faj.faj14, sr.faj.faj141, sr.faj.faj59, sr.faj.faj32, sr.faj.faj60
      #FUN-890054---add---end
     END FOREACH
 
     #FINISH REPORT afar960_rep    #FUN-890054 mark
  #FUN-890054---add---start
     #準備抓取暫存檔裡的資料SL
     LET g_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
  
     #是否列印選擇條件
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc, 'faj89, faj90, faj47, faj20, faj22')
             RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
 
     #傳遞參數
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate,";",
               tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
               tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3]
 
     CALL cl_prt_cs3('afar960','afar960',g_sql,g_str)
  #FUN-890054---add---end 
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #FUN-890054 mark
END FUNCTION
 
#FUN-890054---mark---start
#REPORT afar960_rep(sr,p_str)
#   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
#          p_str        LIKE type_file.chr6,           #No.FUN-680070 VARCHAR(6)
#          p_str1       LIKE type_file.chr20,          #No.FUN-680070 VARCHAR(20)
#          l_faj87      LIKE faj_file.faj87,
#          l_faj14      LIKE faj_file.faj14,
#          sr           RECORD order1 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
#                              order2 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
#                              order3 LIKE faj_file.faj89,       #No.FUN-680070 VARCHAR(10)
#                              faj    RECORD  LIKE faj_file.*,
#                              qty    LIKE faj_file.faj17,       #數量
#                              cost   LIKE faj_file.faj14        #帳值
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET p_str1 = tm.bdate," ",g_x[14] CLIPPED," ",tm.edate
#      #PRINT p_str1   #FUN-660060 remark
#      PRINT COLUMN ((g_len-FGL_WIDTH(p_str1))/2)+1, p_str1 #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.faj.faj89,
#               COLUMN g_c[32],sr.faj.faj90,
#               COLUMN g_c[33],sr.faj.faj02,
#               COLUMN g_c[34],sr.faj.faj022,
#               COLUMN g_c[35],sr.faj.faj06,
#               COLUMN g_c[36],sr.faj.faj07,
#               COLUMN g_c[37],cl_numfor(sr.qty,37,0),
#               COLUMN g_c[38],cl_numfor(sr.faj.faj87,38,g_azi04),
#               COLUMN g_c[39],cl_numfor(sr.cost,39,g_azi04)
#   AFTER GROUP OF sr.order1
#     IF tm.v[1,1] = 'Y' THEN
#        LET l_faj87 = GROUP SUM(sr.faj.faj87)
#        LET l_faj14 = GROUP SUM(sr.cost)
#        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#              COLUMN g_c[38],cl_numfor(l_faj87,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(l_faj14,39,g_azi05)
#        SKIP 1 LINE
#     END IF
#
#   AFTER GROUP OF sr.order2
#     IF tm.v[2,2] = 'Y' THEN
#        LET l_faj87 = GROUP SUM(sr.faj.faj87)
#        LET l_faj14 = GROUP SUM(sr.cost)
#        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#              COLUMN g_c[38],cl_numfor(l_faj87,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(l_faj14,39,g_azi05)
#        SKIP 1 LINE
#     END IF
#
#   AFTER GROUP OF sr.order3
#     IF tm.v[3,3] = 'Y' THEN
#        LET l_faj87 = GROUP SUM(sr.faj.faj87)
#        LET l_faj14 = GROUP SUM(sr.cost)
#        PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#              COLUMN g_c[38],cl_numfor(l_faj87,38,g_azi05),
#              COLUMN g_c[39],cl_numfor(l_faj14,39,g_azi05)
#        SKIP 1 LINE
#     END IF
#
#   ON LAST ROW
#      LET l_faj87 =  SUM(sr.faj.faj87)
#      LET l_faj14 =  SUM(sr.cost)
#      PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#            COLUMN g_c[38],cl_numfor(l_faj87,38,g_azi05),
#            COLUMN g_c[39],cl_numfor(l_faj14,39,g_azi05)
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINE
#       END IF
#
#END REPORT
#----------------------------------#
#FUNCTION r960_getstatus(A)
#  DEFINE a CHAR,
#         l_str LIKE type_file.chr6         #No.FUN-680070 VARCHAR(6)
#  CASE a
#       WHEN "4" LET l_str=g_x[17] CLIPPED
#       WHEN "5" let l_str=g_x[20] CLIPPED
#       WHEN "6" let l_str=g_x[18] CLIPPED
#  END CASE
#  RETURN l_str
#END FUNCTION
#FUN-890054---mark---end
