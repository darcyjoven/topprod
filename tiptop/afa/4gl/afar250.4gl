# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afar250.4gl
# Desc/riptions..: 儀器校正到期通知單
# Date & Author..: 00/03/22 By Iceman
# Modify.........: No.8893 03/12/11 By Kitty 4gl組sql的人員取錯,construct人員欄位錯誤
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530662 05/03/28 By Smapmin 存放位置應列印中文
# Modify.........: No.FUN-550102 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710083 07/02/01 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/25 By Nicole 增加CR參數
# Modify.........: No.MOD-810004 08/01/08 By Smapmin 校正別多一免校選項
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B20129 11/02/25 By yinhy 免校的儀器應不可顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)
                bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
    	        edate   LIKE type_file.dat,          #No.FUN-680070 DATE
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*,
          g_desc              LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-710083 --begin
   LET g_sql ="fga01.fga_file.fga01,",
              "fga06.fga_file.fga06,",
              "fga14.fga_file.fga14,",
              "fga20.fga_file.fga20,",
              "fga22.fga_file.fga22,",
              "fga08.fga_file.fga08,",
              "gen02.gen_file.gen02,",
              "fga21.fga_file.fga21,",
              "fga23.fga_file.fga23,",
              "faf02.faf_file.faf02"
   LET l_table = cl_prt_temptable('afar250',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-710083 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r250_tm(0,0)		# Input print condition
      ELSE CALL afar250()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r250_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r250_w AT p_row,p_col WITH FORM "afa/42f/afar250"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fga01,fga03,fga21,fga13,fga14,fga16      #No:8893
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
         LET INT_FLAG = 0 CLOSE WINDOW r250_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
 
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
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         LET INT_FLAG = 0 CLOSE WINDOW r250_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar250'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar250','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar250',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r250_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar250()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r250_w
END FUNCTION
 
FUNCTION afar250()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_faf02       LIKE faf_file.faf02,         #No.FUN-710083
          l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr   RECORD
                     fga01     LIKE fga_file.fga01,    #儀器編號
                     fga06     LIKE fga_file.fga06,    #儀器編號
                     fga14     LIKE fga_file.fga14,    #存放位置
                     fga20     LIKE fga_file.fga20,    #校正週期
                     fga22     LIKE fga_file.fga22,    #最近送交
                     fga08     LIKE fga_file.fga08,    #規格型號
                     gen02     LIKE gen_file.gen02,    #校正人員
                     fga21     LIKE fga_file.fga21,    #校正別
                     fga23     LIKE fga_file.fga23     #待交日
        END RECORD
 
     CALL cl_del_data(l_table)     #No.FUN-710083
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
 
     LET l_sql = "SELECT fga01,fga06,fga14,fga20,fga22,fga08,",
                 "       gen02,fga21,fga23 ",
"  FROM fga_file ",
"LEFT OUTER JOIN gen_file ON fga25 = gen01 ",
" WHERE fga23 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND fga21 <> '3' ",     #TQC-B20129 
                 "   AND ",tm.wc CLIPPED,
                 "  ORDER BY fga23 "
 
     PREPARE r250_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r250_cs1 CURSOR FOR r250_prepare1
#No.FUN-710083 --begin
#    SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#    CALL cl_outnam('afar250') RETURNING l_name
 
#    START REPORT r250_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710083 --end
 
     FOREACH r250_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-710083 --begin
       LET l_faf02 = NULL
       SELECT faf02 INTO l_faf02 FROM faf_file WHERE faf01 = sr.fga14
       EXECUTE insert_prep USING sr.*,l_faf02
#      OUTPUT TO REPORT r250_rep(sr.*)
#No.FUN-710083 --end
     END FOREACH
 
#No.FUN-710083 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fga01,fga03,fga21,fga13,fga14,fga16')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('afar250',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('afar250','afar250',l_sql,g_str)
#    FINISH REPORT r250_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION
 
#No.FUN-710083 --begin
#REPORT r250_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          g_head1       STRING,
#           l_faf02       LIKE faf_file.faf02,     #MOD-530662
#          sr   RECORD
#                     fga01     LIKE fga_file.fga01,    #儀器編號
#                     fga06     LIKE fga_file.fga06,    #儀器編號
#                     fga14     LIKE fga_file.fga14,    #存放位置
#                     fga20     LIKE fga_file.fga20,    #校正週期
#                     fga22     LIKE fga_file.fga22,    #最近送交
#                     fga08     LIKE fga_file.fga08,    #規格型號
#                     gen02     LIKE gen_file.gen02,    #校正人員
#                     fga21     LIKE fga_file.fga21,    #校正別
#                     fga23     LIKE fga_file.fga23     #待交日
#        END RECORD
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.fga01
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#       PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[42],g_x[34],g_x[35]   #MOD-530662
#      PRINTX name=H2 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#      PRINT g_dash1
#      LET l_last_sw='n'
# 
#   BEFORE GROUP OF sr.fga01
#        PRINTX name=D1 COLUMN g_c[31],sr.fga01;
#
#   ON EVERY ROW
#    CALL r200_fga21(sr.fga21) RETURNING g_desc
#    SELECT faf02 INTO l_faf02 FROM faf_file WHERE faf01 = sr.fga14
#      PRINTX name=D1 COLUMN g_c[32],sr.fga06 CLIPPED,
#            COLUMN g_c[33],sr.fga14 CLIPPED,
#             COLUMN g_c[42],l_faf02 CLIPPED,   #MOD-530662
#            COLUMN g_c[34],sr.fga20 USING '####' CLIPPED,
#            COLUMN g_c[35], sr.fga22 CLIPPED
#      PRINTX name=D2 COLUMN g_c[37],sr.fga08 CLIPPED,
#            COLUMN g_c[38],sr.gen02 CLIPPED,
#            COLUMN g_c[39],g_desc CLIPPED,
#            COLUMN g_c[40],sr.fga23 CLIPPED
#
#   AFTER GROUP OF sr.fga01
#      PRINT g_dash2[1,g_len]
#
#  ## FUN-550102
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
#
#END REPORT
#No.FUN-710083 --end
 
FUNCTION r200_fga21(l_fga21)
DEFINE
      l_fga21   LIKE fga_file.fga21,
      l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
 
     CASE l_fga21
         WHEN '1'
            CALL cl_getmsg('afa-402',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-403',g_lang) RETURNING l_bn
         WHEN '3'   #MOD-810004
            CALL cl_getmsg('afa-414',g_lang) RETURNING l_bn   #MOD-810004
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
