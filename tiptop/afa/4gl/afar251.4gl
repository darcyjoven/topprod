# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afar251.4gl
# Desc/riptions..: 儀器校正彙總表
# Date & Author..: 00/03/22 By Iceman
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530660 05/03/26 By Smapmin 存放位置及保管人應顯示中文
# Modify.........: No.FUN-550102 05/05/25 By echo 新增報表備註
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/01/31 By Judy Crystal Report修改
# Modify.........: No.TQC-730088 07/03/25 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)
                bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
    	        edate   LIKE type_file.dat,          #No.FUN-680070 DATE
                s       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
                t       LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*,
          g_desc              LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#FUN-710083.....begin
DEFINE    g_sql        STRING
DEFINE    l_table      STRING
DEFINE    g_str        STRING
#FUN-710083.....end
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.s = ARG_VAL(10)
   LET tm.t = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#FUN-710083.....begin
   LET g_sql = "fga13.fga_file.fga13,",
               "fga03.fga_file.fga03,",
               "fga031.fga_file.fga031,",
               "fga01.fga_file.fga01,",
               "fga06.fga_file.fga06,",
               "fga14.fga_file.fga14,",
               "fga12.fga_file.fga12,",
               "fga22.fga_file.fga22,",
               "fga20.fga_file.fga20,",
               "fga23.fga_file.fga23,",
               "fga21.fga_file.fga21,",
               "fga16.fga_file.fga16,",
               "l_gen02.gen_file.gen02,",
               "l_gem02.gem_file.gem02,",
               "l_faf02.faf_file.faf02"
   LET l_table = cl_prt_temptable('afar251',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-710083.....end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r251_tm(0,0)		# Input print condition
      ELSE CALL afar251()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r251_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r251_w AT p_row,p_col WITH FORM "afa/42f/afar251"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '12'
   LET tm.t = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fga12,fga01,fga03,fga21,fga14,fga16
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
         LET INT_FLAG = 0 CLOSE WINDOW r251_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
   #  DISPLAY BY NAME tm.s,tm.t,tm.more
         INPUT BY NAME
            tm.bdate,tm.edate,tm2.s1,tm2.s2,
            tm2.t1,tm2.t2,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD bdate
               IF cl_null(tm.bdate) THEN
                  NEXT FIELD bdate
               END IF
 
            AFTER FIELD edate
               IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD edate
               END IF
 
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
                  NEXT FIELD more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()	# Command execution
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
               LET tm.t = tm2.t1,tm2.t2
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
         LET INT_FLAG = 0 CLOSE WINDOW r251_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar251'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar251','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
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
                            " '",tm.s CLIPPED,"'" ,   #TQC-610055
                            " '",tm.t CLIPPED,"'" ,   #TQC-610055
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar251',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r251_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar251()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r251_w
END FUNCTION
 
FUNCTION afar251()
   DEFINE l_name     LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0069
          l_sql      LIKE type_file.chr1000,              # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_gen02    LIKE gen_file.gen02,     #FUN-710083
          l_gem02    LIKE gem_file.gem02,     #FUN-710083
          l_faf02    LIKE faf_file.faf02,     #FUN-710083
          l_chr	     LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,              #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE fga_file.fga01,     #No.FUN-680070 VARCHAR(10)
          sr         RECORD order1 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
                            order2 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
                            fga13  LIKE fga_file.fga13,   #部門
                            fga03  LIKE fga_file.fga03,   #財產編號
                            fga031 LIKE fga_file.fga031,  #附號
                            fga01  LIKE fga_file.fga01,   #儀器編號
                            fga06  LIKE fga_file.fga06,   #儀器中/英文名稱
                            fga14  LIKE fga_file.fga14,   #存放位置
                            fga12  LIKE fga_file.fga12,   #保管人
                            fga22  LIKE fga_file.fga22,   #校正別
                            fga20  LIKE fga_file.fga20,   #校正週期
                            fga23  LIKE fga_file.fga23,   #校正日期
                            fga21  LIKE fga_file.fga21,   #校正別
                            fga16  LIKE fga_file.fga16    #校正日期
                     END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)    #FUN-710083
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fgauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fgagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fgagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fgauser', 'fgagrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','',fga13,fga03,fga031,fga01,fga06,fga14,fga12,",
                 "      fga22,fga20,fga23,fga21,fga16 ",
                 "  FROM fga_file ",
                 " WHERE fga23 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE r251_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r251_cs1 CURSOR FOR r251_prepare1
#FUN-710083.....begin  mark
#     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#     CALL cl_outnam('afar251') RETURNING l_name
#
#     START REPORT r251_rep TO l_name
#     LET g_pageno = 0
#FUN-710083.....end mark
     FOREACH r251_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
        FOR g_i = 1 TO 2
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fga12
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fga01
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fga03
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fga21
                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.fga14
                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fga16
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
        END FOR
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
#FUN-710083.....begin
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fga12
       IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fga13
       IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
       SELECT faf02 INTO l_faf02 FROM faf_file WHERE faf01=sr.fga14
       IF SQLCA.sqlcode THEN LET l_faf02 = ' ' END IF
       EXECUTE insert_prep USING sr.fga13,sr.fga03,sr.fga031,sr.fga01,sr.fga06,sr.fga14,sr.fga12,sr.fga22,sr.fga20,sr.fga23,sr.fga21,sr.fga16,l_gen02,l_gem02,l_faf02
#       OUTPUT TO REPORT r251_rep(sr.*)
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fga12,fga01,fga03,fga21,fga14,fga16')
          RETURNING tm.wc
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2]
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('afar251',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('afar251','afar251',l_sql,g_str)
 
#     FINISH REPORT r251_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-710083.....end
END FUNCTION
#FUN-710083.....begin mark
#REPORT r251_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
#          g_head1       STRING,
#          l_faf02       LIKE faf_file.faf02,                 #MOD-530660
#          l_gen02       LIKE gen_file.gen02,                 #MOD-530660
#          sr            RECORD order1 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                               order2 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                               fga13  LIKE fga_file.fga13,   #部門
#                               fga03  LIKE fga_file.fga03,   #財產編號
#                               fga031 LIKE fga_file.fga031,  #附號
#                               fga01  LIKE fga_file.fga01,   #儀器編號
#                               fga06  LIKE fga_file.fga06,   #儀器中文名稱
#                               fga14  LIKE fga_file.fga14,   #存放位置
#                               fga12  LIKE fga_file.fga12,   #保管人
#                               fga22  LIKE fga_file.fga22,   #最近校正日期
#                               fga20  LIKE fga_file.fga20,   #校正週期
#                               fga23  LIKE fga_file.fga23,   #下次校正日期
#                               fga21  LIKE fga_file.fga21,   #校正別
#                               fga16  LIKE fga_file.fga16    #取得日期
#                        END RECORD
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#      #PRINT g_head1                                         #FUN-660060 remark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw='n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#       SELECT faf02 INTO l_faf02 FROM faf_file WHERE faf01=sr.fga14  #MOD-530660
#       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fga12  #MOD-530660
#      PRINT COLUMN g_c[31],sr.fga13,
#            COLUMN g_c[32],sr.fga03,
#            COLUMN g_c[33],sr.fga031,
#            COLUMN g_c[34],sr.fga01,
#            COLUMN g_c[35],sr.fga06,
#            COLUMN g_c[36],sr.fga14,
#             COLUMN g_c[37],l_faf02,   #MOD-530660
#            COLUMN g_c[38],sr.fga12,
#             COLUMN g_c[39],l_gen02,   #MOD-530660
#            COLUMN g_c[40],sr.fga22,
#            COLUMN g_c[41],sr.fga20,
#            COLUMN g_c[42],sr.fga23,
#            COLUMN g_c[43],sr.fga21,
#            COLUMN g_c[44],sr.fga16
#   ## FUN-550102
#   ON LAST ROW
#        LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n'
#      THEN
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#      PRINT ' '
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[10]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[10]
#             PRINT g_memo
#      END IF
#   ## END FUN-550102
#END REPORT
#FUN-710083.....end mark
