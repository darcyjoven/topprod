# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name....: afar550.4gl
# Desc/riptions...: 利息資本化明細表
# Date & Author...: 96/06/11 By Alan Kuan
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: NO.MOD-890265 08/09/30 By clover afar550財產名稱無法印出,將nmm_file 改為OUTER,faj_file改為fak_file
# MOdify.........: No.MOD-890267 08/10/01 By clover 報表增加欄位利息資本化金額
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                             # Print condition RECORD
             wc STRING,                      # Where condition
             yy LIKE type_file.num5,         #No.FUN-680070 SMALLINT
             mm LIKE type_file.num5          #No.FUN-680070 SMALLINT
          END RECORD,
       g_fcx02  LIKE fcx_file.fcx02,
       g_fcx03  LIKE fcx_file.fcx03,
       g_dates  LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(6)
       g_total  LIKE type_file.num20_6       #No.FUN-680070 DECIMAL(13,3)
DEFINE g_i      LIKE type_file.num5          #count/index for any purpose       #No.FUN-680070 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)   #TQC-610055
   LET tm.mm = ARG_VAL(9)   #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r520_tm(0,0)		# Input print condition
      ELSE CALL afar550()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r520_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680070 SMALLINT
       l_cmd         LIKE type_file.chr1000  #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 6 LET p_col =20
 
   OPEN WINDOW r520_w AT p_row,p_col WITH FORM "afa/42f/afar550"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                   # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   # LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fcx01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()            #No.FUN-550037 hmf
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
         LET INT_FLAG = 0 CLOSE WINDOW r520_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm
            END IF
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CLOSE WINDOW r520_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
               EXIT PROGRAM
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r520_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      {
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar550'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar550','9031',1)   #無系統執行指令, 無法執行!!
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_lang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc CLIPPED,
                      " '",tm.yy CLIPPED,   #TQC-610055
                      " '",tm.mm CLIPPED,   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar550',g_time,l_cmd)  # Execute cmd at later time
         END IF
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      }
      CALL cl_wait()
      CALL afar550()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r520_w
END FUNCTION
 
FUNCTION afar550()
   DEFINE l_name	LIKE type_file.chr20, 		    # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,		    # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,                #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,             #No.FUN-680070 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE type_file.chr20,   #No.FUN-680070 VARCHAR(10)
          sr            RECORD fcx02 LIKE fcx_file.fcx02,   # Year
                               fcx03 LIKE fcx_file.fcx03,   # Month
                               fcx01 LIKE fcx_file.fcx01,   #財產編號
                               fcx011 LIKE fcx_file.fcx011, #財產附號
                               #faj06 LIKE faj_file.faj06,   #財產名稱
                               fak06 LIKE fak_file.fak06,              #MOD-890265
                               fcx04 LIKE fcx_file.fcx04,   #月初累計
                               fcx05 LIKE fcx_file.fcx05,   #當月支出
                               nmm03 LIKE nmm_file.nmm03,   #月利率
                               fcx06 LIKE fcx_file.fcx06,   #利息資本化金額 MOD-890267
                               fcx07 LIKE fcx_file.fcx07,   #按成本利息
                               fcx08 LIKE fcx_file.fcx08    #實際利息
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                  #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fcxuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                  #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fcxgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                     #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fcxgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fcxuser', 'fcxgrup')
     #End:FUN-980030
 
     #MOD-890265--start
  #  LET l_sql = "SELECT fcx02,fcx03,fcx01,fcx011,faj06,fcx04,fcx05,",
  #              " nmm03,fcx07,fcx08",
  #              " FROM fcx_file, nmm_file,OUTER faj_file  ",   #MOD-890265
  #              " WHERE nmm_file.nmm01 = fcx_file.fcx02 " ,
  #              "   AND nmm_file.nmm02 = fcx_file.fcx03 " ,
  #              "   AND faj02 = fcx01 " ,
  #              "   AND faj022 = fcx011 " ,
  #              "   AND fcx02 = '",tm.yy, "'",
  #              "   AND fcx03 = '",tm.mm, "'",
  #              " AND ",tm.wc
     LET l_sql = "SELECT fcx02,fcx03,fcx01,fcx011,fak06,fcx04,fcx05,",
                 " nmm03,fcx06,fcx07,fcx08",                         #MOD-890267
                 " FROM fcx_file,OUTER nmm_file,OUTER fak_file  ",   #MOD-890265
                 " WHERE nmm_file.nmm01 = fcx_file.fcx02 " ,
                 "   AND nmm_file.nmm02 = fcx_file.fcx03 " ,
                 "   AND fak_file.fak02 = fcx_file.fcx01 " ,
                 "   AND fak_file.fak022 = fcx_file.fcx011 " ,
                 "   AND fcx02 = '",tm.yy, "'",
                 "   AND fcx03 = '",tm.mm, "'",
                 " AND ",tm.wc
 
     #MOD-890265--end
 
     LET  g_total = 0
 
     PREPARE r520_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r520_cs1 CURSOR FOR r520_prepare1
     CALL cl_outnam('afar550') RETURNING l_name
 
     START REPORT r520_rep TO l_name
     LET g_pageno = 0
 
     FOREACH r520_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
     # INITIALIZE g_fcx03 TO NULL
     # IF cl_null(sr.fav07) THEN LET sr.fav07=0 END IF
     OUTPUT TO REPORT r520_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r520_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r520_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_total      LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3)
          g_head1      STRING,
          sr    RECORD fcx02 LIKE fcx_file.fcx02,   # Year
                       fcx03 LIKE fcx_file.fcx03,   # Month
                       fcx01 LIKE fcx_file.fcx01,   #財產編號
                       fcx011 LIKE fcx_file.fcx011, #附號
                       #faj06 LIKE faj_file.faj06,   #財產名稱
                       fak06 LIKE fak_file.fak06,        #MOD-890265
                       fcx04 LIKE fcx_file.fcx04,   #月初累計
                       fcx05 LIKE fcx_file.fcx05,   #當月支出
                       nmm03 LIKE nmm_file.nmm03,   #月利率
                       fcx06 LIKE fcx_file.fcx06,   #利息資本化金額 MOD-890267
                       fcx07 LIKE fcx_file.fcx07,   #按成本利息
                       fcx08 LIKE fcx_file.fcx08    #實際利息
                END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.fcx02,sr.fcx03,sr.fcx01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = sr.fcx02,g_x[9] CLIPPED,
                    sr.fcx03,g_x[10] CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[41],  #MOD-890267
            g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.fcx02
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.fcx03
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      IF sr.fcx07 >= sr.fcx08 THEN
         PRINT COLUMN g_c[31],sr.fcx01,
         COLUMN g_c[32], sr.fcx011 CLIPPED,
         #COLUMN g_c[33], sr.faj06 CLIPPED,
         COLUMN g_c[33], sr.fak06 CLIPPED,             #MOD-890265
         COLUMN g_c[34], cl_numfor(sr.fcx04,34,g_azi04),
         COLUMN g_c[35], cl_numfor(sr.fcx05,35,g_azi04),
         COLUMN g_c[36], cl_numfor(sr.fcx04+(sr.fcx05/2),36,g_azi04),
         COLUMN g_c[37],(sr.nmm03)/100 USING '##.#&',
         COLUMN g_c[41],cl_numfor(sr.fcx06,41,g_azi04), #MOD-890267
         COLUMN g_c[38],cl_numfor(sr.fcx07,38,g_azi04),
         COLUMN g_c[39],cl_numfor(sr.fcx08,39,g_azi04),
         COLUMN g_c[40],cl_numfor(sr.fcx04+sr.fcx05+sr.fcx08,40,g_azi04)
      ELSE
         PRINT COLUMN g_c[31],sr.fcx01,
         COLUMN g_c[32], sr.fcx011 CLIPPED,
         #COLUMN g_c[33], sr.faj06 CLIPPED,
         COLUMN g_c[33], sr.fak06 CLIPPED,            #MOD-890265
         COLUMN g_c[34], cl_numfor(sr.fcx04,34,g_azi04),
         COLUMN g_c[35], cl_numfor(sr.fcx05,35,g_azi04),
         COLUMN g_c[36], cl_numfor(sr.fcx04+(sr.fcx05/2),36,g_azi04),
         COLUMN g_c[37],(sr.nmm03)/100 USING '##.#&',
         COLUMN g_c[41],cl_numfor(sr.fcx06,41,g_azi04), #MOD-890267
         COLUMN g_c[38],cl_numfor(sr.fcx07,38,g_azi04),
         COLUMN g_c[39],cl_numfor(sr.fcx08,39,g_azi04),
         COLUMN g_c[40],cl_numfor((sr.fcx04+sr.fcx05+sr.fcx07),40,g_azi04)
      END IF
   AFTER GROUP OF sr.fcx03
      IF sr.fcx07 >= sr.fcx08 THEN
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.fcx04),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.fcx05),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.fcx04+(sr.fcx05/2)),36,g_azi04),
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fcx06),41,g_azi04),              #MOD-890267
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.fcx07),38,g_azi04),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.fcx08),39,g_azi04),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.fcx04+sr.fcx05+sr.fcx08),40,g_azi04)
      ELSE
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.fcx04),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.fcx05),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.fcx04+(sr.fcx05/2)),36,g_azi04),
               COLUMN g_c[41],cl_numfor(GROUP SUM(sr.fcx06),41,g_azi04),              #MOD-890267
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.fcx07),38,g_azi04),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.fcx08),39,g_azi04),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.fcx04+sr.fcx05+sr.fcx08),40,g_azi04)
      END IF
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
       #-- TQC-630166 begin
         #IF tm.wc[001,120] > ' ' THEN			# for 132
 	 #   PRINT COLUMN 10,tm.wc[001,120] CLIPPED END IF
         #IF tm.wc[121,240] > ' ' THEN
         #   PRINT COLUMN 10,tm.wc[121,240] CLIPPED END IF
         #IF tm.wc[241,300] > ' ' THEN
 	 #   PRINT COLUMN 10,tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
       #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      # PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n' THEN
       PRINT g_dash[1,g_len]
       PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
    ELSE SKIP 2 LINES
    END IF
END REPORT
