# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: afar800.4gl
# Descriptions...: 生產設備清單
# Date & Author..: 96/05/16 By STAR
# Modify.........: No.MOD-590097 05/09/08 By Tracy 報表畫線寫入zaa
# Modify.........: No.MOD-590378 05/09/19 By Smapmin 程式碼被截斷至2.0 r.c2不會過
# Modify.........: No.TQC-5A0021 05/10/14 By Sarah 報表位置不正確，調整
# Modify.........: No.TQC-610039 06/01/12 BY cl 4gl中的全形字符維護到zaa中
# Modify.........: No.FUN-650017 06/06/15 By Echo 報表段的LEFT MARGIN的值改為 g_left_margin
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-850139 08/05/30 By zhaijie老報表修改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B30145 11/03/18 By Sarah 取資料時只取出免稅核准的資料即可
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(1000)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          m_codest  LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(34)
    define g_page_no LIKE type_file.num5         #No.FUN-680070 smallint
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#NO.FUN-850139--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-850139--END---
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
#NO.FUN-850139--START---
   LET g_sql = "fci02.fci_file.fci02,",
               "fci05.fci_file.fci05,",
               "fci06.fci_file.fci06,",
               "fci16.fci_file.fci16,",
               "fci08.fci_file.fci08,",
               "fci09.fci_file.fci09,",
               "fci10.fci_file.fci10,",
               "fci15.fci_file.fci15,",
               "fci17.fci_file.fci17,",
               "fci14.fci_file.fci14,",
               "fci04.fci_file.fci04,",
               "fci11.fci_file.fci11,",
               "fci18.fci_file.fci18,",
               "fci20.fci_file.fci20"
   LET l_table = cl_prt_temptable('afar800',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF            
#NO.FUN-850139--end----
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   #---- jeffery 85/11/21 update ----#
   let g_page_no = 16
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar800_tm(0,0)        # Input print condition
      ELSE CALL afar800()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar800_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW afar800_w AT p_row,p_col WITH FORM "afa/42f/afar800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fch01,fch02
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
         LET INT_FLAG = 0 CLOSE WINDOW afar800_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar800_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar800'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar800','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar800',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar800()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar800_w
END FUNCTION
 
FUNCTION afar800()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#         l_time    LIKE type_file.chr8          #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
          sr        RECORD fci02  LIKE fci_file.fci02,
                           fci05  LIKE fci_file.fci05,
                           fci06  LIKE fci_file.fci06,
                           fci16  LIKE fci_file.fci16,
                           fci08  LIKE fci_file.fci08,
                           fci09  LIKE fci_file.fci09,
                           fci10  LIKE fci_file.fci10,
                           fci15  LIKE fci_file.fci15,
                           fci17  LIKE fci_file.fci17,
                           fci14  LIKE fci_file.fci14,
                           fci04  LIKE fci_file.fci04,
                           fci11  LIKE fci_file.fci11,
                           fci18  LIKE fci_file.fci18,
                           fci20  LIKE fci_file.fci20
                    END RECORD
#NO.FUN-850139----start---
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar800'
#NO.FUN-850139----end----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar800'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fchuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fchgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fchgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fchuser', 'fchgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT fci02,fci05,fci06,fci16,fci08,fci09,fci10,fci15, ",
                 "       fci17,fci14,fci04,fci11,fci18,fci20 ",
                 "  FROM fch_file, fci_file   ",
                 " WHERE fch01 = fci01 ",
                 "   AND  fchconf != 'X' ", #010803增
                 #------ jeffery 96/10/23 update 扣掉被合併的-----#
                 "   AND ( fci07 =' ' or fci07 is null )",
                 "   AND fci19 ='4'",   #只抓免稅核准的資料   #MOD-B30145 add
                 "   AND ",tm.wc CLIPPED
#No.CHI-6A0004--begin
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
 
     PREPARE afar800_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar800_curs1 CURSOR FOR afar800_prepare1
 
#      CALL cl_outnam('afar800') RETURNING l_name           #NO.FUN-850139
 
#     START REPORT afar800_rep TO l_name                    #NO.FUN-850139
#     LET g_pageno = 0                                      #NO.FUN-850139
 
     FOREACH afar800_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.fci09) THEN
          LET sr.fci09 = 0
       END IF
#       OUTPUT TO REPORT afar800_rep(sr.*)                  #NO.FUN-850139
#NO.FUN-850139---START---
        EXECUTE insert_prep USING
          sr.fci02,sr.fci05,sr.fci06,sr.fci16,sr.fci08,sr.fci09,sr.fci10,
          sr.fci15,sr.fci17,sr.fci14,sr.fci04,sr.fci11,sr.fci18,sr.fci20
#NO.FUN-850139----END---
     END FOREACH
 
#     FINISH REPORT afar800_rep                             #NO.FUN-850139
#NO.FUN-850139----start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'fch01,fch02')
           RETURNING tm.wc
     END IF
     LET g_str = g_azi04
     CALL cl_prt_cs3('afar800','afar800',g_sql,g_str) 
#NO.FUN-850139--end---
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850139
END FUNCTION
#NO.FUN-850139---START---MARK---
#REPORT afar800_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_last_fa    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_fci15      LIKE     fci_file.fci15,
#          l_fci15t     LIKE     fci_file.fci15,
#          sr               RECORD fci02  LIKE fci_file.fci02,
#                                  fci05  LIKE fci_file.fci05,
#                                  fci06  LIKE fci_file.fci06,
#                                  fci16  LIKE fci_file.fci16,
#                                  fci08  LIKE fci_file.fci08,
#                                  fci09  LIKE fci_file.fci09,
#                                  fci10  LIKE fci_file.fci10,
#                                  fci15  LIKE fci_file.fci15,
#                                  fci17  LIKE fci_file.fci17,
#                                  fci14  LIKE fci_file.fci14,
#                                  fci04  LIKE fci_file.fci04,
#                                  fci11  LIKE fci_file.fci11,
#                                  fci18  LIKE fci_file.fci18,
#                                  fci20  LIKE fci_file.fci20
#                        END RECORD
#  define qty LIKE type_file.num5         #No.FUN-680070 smallint
#  define l_page_no LIKE type_file.num5         #No.FUN-680070 smallint
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin                  #FUN-650017
#         right MARGIN 8
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.fci18,sr.fci02,sr.fci05
#  FORMAT
#   PAGE HEADER
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN 14 ,g_x[1] CLIPPED;
#      IF sr.fci18 = '1' THEN
#         PRINT COLUMN 62,g_x[59], g_x[11] CLIPPED, g_x[13] CLIPPED # No.TQC-610039
#         PRINT COLUMN 62,g_x[60], g_x[12] CLIPPED, g_x[13] CLIPPED # No.TQC-610039
#      ELSE
#         PRINT COLUMN 62,g_x[60], g_x[11] CLIPPED, g_x[13] CLIPPED # No.TQC-610039
#         PRINT COLUMN 62,g_x[59], g_x[12] CLIPPED, g_x[13] CLIPPED # No.TQC-610039
#      END IF
#      PRINT COLUMN 103, g_x[14] CLIPPED
##No.MOD-590097 --start--
#      PRINT g_x[36],g_x[37],g_x[38],g_x[40],g_x[41],g_x[42],g_x[44]
#      PRINT g_x[39],g_x[15] CLIPPED,g_x[39],
#            g_x[30] CLIPPED,"                  ",g_x[39],
#            g_x[31] CLIPPED,"  ",g_x[39],
#            g_x[32] CLIPPED,"      ",g_x[39],
#            g_x[33] CLIPPED,"  ",g_x[39],
#            g_x[34] CLIPPED,g_x[39],
#            g_x[35] CLIPPED,g_x[39],
#            g_x[16] CLIPPED,"            ",g_x[39],
#            g_x[17] CLIPPED,"  ",g_x[39],
#            g_x[18] CLIPPED,"       ",g_x[39]
##No.MOD-590097 --end--
#
#      LET l_last_sw = 'n'
#      LET l_fci15 = 0
#
#    BEFORE GROUP OF sr.fci18
#      let l_page_no =0
#      SKIP TO TOP OF PAGE
#
#    ON EVERY ROW
##No.MOD-590097 --start--
#      PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#      PRINT COLUMN 1,  g_x[39],sr.fci02 USING '###&',
#            COLUMN 7,  g_x[39],sr.fci05,
#            COLUMN 39, g_x[39],sr.fci06[1,10],
#            COLUMN 51, g_x[39],sr.fci16[1,10],
#            COLUMN 63, g_x[39],sr.fci08,
#            COLUMN 75, g_x[39],sr.fci09 USING '###&',
#            COLUMN 81, g_x[39],sr.fci10,
#            COLUMN 87, g_x[39],cl_numfor(sr.fci15,18,g_azi04),
#            COLUMN 109,g_x[39],sr.fci17,
#            COLUMN 121,g_x[39],sr.fci14[1,18],
#            COLUMN 141,"  ",g_x[39]
#      PRINT g_x[43],
#            COLUMN 9, sr.fci04 CLIPPED,
#            COLUMN 39,g_x[39],
#            COLUMN 51,g_x[39],
#            COLUMN 63,g_x[39],
#            COLUMN 75,g_x[39],
#            COLUMN 81,g_x[39],
#            COLUMN 87,g_x[39],
#            COLUMN 109,g_x[39],
#            COLUMN 121,g_x[39],
#            COLUMN 123,sr.fci11,
#            COLUMN 141,"  ",g_x[39]
##No.MOD-590097 --end--
#         LET l_fci15 = l_fci15 + sr.fci15
#         LET l_page_no = l_page_no + 1
#         IF l_page_no mod g_page_no =0 THEN
##No.MOD-590097 --start--
#            PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#            PRINT g_x[43], COLUMN 9,g_x[19] clipped,
#                   "                        ",g_x[39],
#                  COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#                  COLUMN 75,g_x[39], COLUMN 81,g_x[39],
##                  COLUMN 87,g_x[39], COLUMN 89,cl_numfor(l_fci15,18,g_azi04),g_x     #MOD-590378
#                 #COLUMN 87,g_x[39], COLUMN 89,cl_numfor(l_fci15,18,g_azi04),g_x[39],    #MOD-590378   #TQC-5A0021 mark
#                  COLUMN 87,g_x[39], COLUMN 89,cl_numfor(l_fci15,18,g_azi04)," ",g_x[39],              #TQC-5A0021
#                  COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#            PRINT g_x[43], "                              ",g_x[39],
#                  COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#                  COLUMN 75,g_x[39], COLUMN 81,g_x[39],
#                  COLUMN 87,g_x[39], COLUMN 109,g_x[39],
#                  COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#           #PRINT g_x[45],g_x[46],g_x[47]                                   #TQC-5A0021 mark
#            PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]   #TQC-5A0021
##No.MOD-590097 --end--
#         END IF
#
#
#   #ON LAST ROW
#   AFTER GROUP OF sr.fci18
#      LET l_fci15t = GROUP SUM(sr.fci15)
#      LET l_last_fa = 'y'
##No.MOD-590097 --start--
#      PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#      PRINT g_x[43], COLUMN 9,g_x[19] clipped,
#            "                        ",g_x[39],
#            COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#            COLUMN 75,g_x[39], COLUMN 81,g_x[39],
#            COLUMN 87,g_x[39],
#            COLUMN 89,cl_numfor(l_fci15,18,g_azi04)," ",g_x[39],
#            COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#      PRINT g_x[43], "                              ",g_x[39],
#            COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#            COLUMN 75,g_x[39], COLUMN 81,g_x[39],
#            COLUMN 87,g_x[39], COLUMN 109,g_x[39],
#            COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#      PRINT g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#      PRINT g_x[43], COLUMN 9,g_x[20] clipped,
#            "                        ",g_x[39],
#            COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#            COLUMN 75,g_x[39], COLUMN 81,g_x[39],
#            COLUMN 87,g_x[39], COLUMN 89,
#            cl_numfor(l_fci15t,18,g_azi04)," ",g_x[39],
#            COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#      PRINT g_x[43], "                              ",g_x[39],
#            COLUMN 51,g_x[39], COLUMN 63,g_x[39],
#            COLUMN 75,g_x[39], COLUMN 81,g_x[39],
#            COLUMN 87,g_x[39], COLUMN 109,g_x[39],
#            COLUMN 121,g_x[39], COLUMN 133,"          ",g_x[39]
#      PRINT g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
##No.MOD-590097 --end--
#         LET l_last_sw = 'y'
#      #------ jeffery update ----#
#         SKIP 1 LINE
#
#   PAGE TRAILER
#          skip 1 line
#          PRINT COLUMN  1,g_x[21] CLIPPED , COLUMN 36, g_x[22] CLIPPED ,
#                COLUMN 64,g_x[23] CLIPPED ,
#                COLUMN 88,g_x[24] CLIPPED , COLUMN 120,g_x[25] CLIPPED ,
#                COLUMN 124,g_pageno USING '<<<',COLUMN 127, g_x[26]
#          PRINT COLUMN  1,g_x[27] CLIPPED , COLUMN 36, g_x[28] CLIPPED ,
#                COLUMN 64,g_x[29] CLIPPED
#END REPORT
#
##Patch....NO.TQC-610035 <001,002,003> #
##NO.FUN-850139---END--MARK--
