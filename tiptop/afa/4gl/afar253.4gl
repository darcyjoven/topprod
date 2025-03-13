# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afar253.4gl
# Desc/riptions..: 量測儀器不良原因明細表
# Date & Author..: 00/03/23 By Iceman
# Modify.........: No.FUN-510035 05/02/02 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720082 07/02/12 By Smapmin 校驗日期判斷錯誤
# Modify.........: No.FUN-850015 08/05/06 By lala
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0316 10/11/30 By suncx1 函數返回值與接收返回值的變量的類型不一致，導致截位現象
 
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
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_table    STRING
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
   
#No.FUN-850015---start---
   LET g_sql="fga01.fga_file.fga01,",
             "fga06.fga_file.fga06,",
             "fga08.fga_file.fga08,",
             "fgc02.fgc_file.fgc02,",
             "fge03.fge_file.fge03,",
             #"bn.type_file.chr4,",    #TQC-AB0316 mark
             "bn.ze_file.ze03,",       #TQC-AB0316 modify
             "fga13.fga_file.fga13,",
             "fga10.fga_file.fga10,",
             "fgc05.fgc_file.fgc05"
   LET l_table = cl_prt_temptable('afar253',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850015---end---
 
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
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r253_tm(0,0)		# Input print condition
      ELSE CALL afar253()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r253_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r253_w AT p_row,p_col WITH FORM "afa/42f/afar253"
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
      CONSTRUCT BY NAME tm.wc ON fga01,fga13,fga10,fgc05
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
         LET INT_FLAG = 0 CLOSE WINDOW r253_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
    # DISPLAY BY NAME tm.s,tm.t,tm.more
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
         LET INT_FLAG = 0 CLOSE WINDOW r253_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar253'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar253','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
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
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('afar253',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r253_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar253()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r253_w
END FUNCTION
 
FUNCTION afar253()
   DEFINE l_name	LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,           # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,           #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE fga_file.fga01,     #No.FUN-680070 VARCHAR(10)
          sr         RECORD order1 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
                            order2 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
                            fga01  LIKE fga_file.fga01,   #儀器編號
                            fga06  LIKE fga_file.fga06,   #中文名稱
                            fgc02  LIKE fgc_file.fgc02,   #校驗日期
                            fge03  LIKE fge_file.fge03,   #不良原因
                            fga24  LIKE fga_file.fga24,   #校驗結果
                            #desc   LIKE type_file.chr4,   #校驗結果                        #No.FUN-680070 VARCHAR(4) #TQC-AB0316
                            desc   LIKE ze_file.ze03,     #校驗結果   #TQC-AB0316 modify
                            fga08  LIKE fga_file.fga08,   #規格型號
                            fga13  LIKE fga_file.fga13,
                            fga10  LIKE fga_file.fga10,
                            fgc05  LIKE fgc_file.fgc05
                     END RECORD
 
 
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
 
 
     LET l_sql = "SELECT '','',fga01,fga06,fgc02,fge03,fga24,'',fga08",
                 "  fga13,fga10,fgc05 ",
                 "  FROM fga_file,fgc_file,fge_file",
                 #" WHERE fga23 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-720082
                 " WHERE fga22 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-720082
                 "   AND fga01 = fgc01 ",
                 "   AND fgc05 = fge01 ",
                 "   AND fgc011 != 0 ",
                 "   AND fgc05 IS NOT NULL",
                 "   AND fgc05 != ' '",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE r253_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r253_cs1 CURSOR FOR r253_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#No.FUN-850015---start---     
#     CALL cl_outnam('afar253') RETURNING l_name
 
#     START REPORT r253_rep TO l_name
     LET g_pageno = 0
 
     FOREACH r253_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       CALL r253_fga24(sr.fga24) RETURNING sr.desc
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.fga01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fga13
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fga10
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.fgc05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
#       OUTPUT TO REPORT r253_rep(sr.*)
     EXECUTE insert_prep USING
        sr.fga01,sr.fga06,sr.fga08,sr.fgc02,sr.fge03,sr.desc,sr.fga13,sr.fga10,sr.fgc05
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'fga01,fga13,fga10,fgc05')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1]
     CALL cl_prt_cs3('afar253','afar253',g_sql,g_str)
 
#     FINISH REPORT r253_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r253_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
#          l_n           LIKE type_file.num5,              #No.FUN-680070 SMALLINT
#          g_head1       STRING,
#          sr         RECORD order1 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                            order2 LIKE fga_file.fga01,   #No.FUN-680070 VARCHAR(10)
#                            fga01  LIKE fga_file.fga01,   #儀器編號
#                            fga06  LIKE fga_file.fga06,   #中文名稱
#                            fgc02  LIKE fgc_file.fgc02,   #校驗日期
#                            fge03  LIKE fge_file.fge03,   #不良原因
#                            fga24  LIKE fga_file.fga24,   #校驗結果
#                            desc   LIKE type_file.chr4,   #校驗結果       #No.FUN-680070 VARCHAR(4)
#                            fga08  LIKE fga_file.fga08,   #規格型號
#                            fga13  LIKE fga_file.fga13,
#                            fga10  LIKE fga_file.fga10,
#                            fgc05  LIKE fgc_file.fgc05
#                     END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr.order1,sr.order2,sr.fga01
 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#      #PRINT g_head1          #FUN-660060 remark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#      PRINTX name=H2 g_x[36],g_x[37]
#      PRINT g_dash1
#      LET l_last_sw='n'
 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#   BEFORE GROUP OF sr.fga01
#      LET l_n=0
#      PRINTX name=D1 COLUMN g_c[31],sr.fga01;
 
#   ON EVERY ROW
#      LET l_n=l_n+1
#      CASE WHEN l_n=1 PRINTX name=D1 COLUMN g_c[32],sr.fga06,
#                            COLUMN g_c[33],sr.fgc02,
#                            COLUMN g_c[34],sr.fge03 CLIPPED,
#                            COLUMN g_c[35],sr.desc
#           WHEN l_n=2 PRINT COLUMN g_c[32],sr.fga08,
#                            COLUMN g_c[33],sr.fgc02,
#                            COLUMN g_c[34],sr.fge03 CLIPPED,
#                            COLUMN g_c[35],sr.desc
#           WHEN l_n>2 PRINT COLUMN g_c[33],sr.fgc02,
#                            COLUMN g_c[34],sr.fge03 CLIPPED,
#                            COLUMN g_c[35],sr.desc
#             OTHERWISE EXIT CASE
#      END CASE
 
#ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-850015---start---
FUNCTION r253_fga24(l_fga24)
DEFINE
      l_fga24   LIKE fga_file.fga24,
      #l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)  #TQC-AB0316 mark
      l_bn      LIKE ze_file.ze03            #TQC-AB0316 add
 
#－0:未校 1:正常 2:停用 3.退修 4.報廢
     CASE l_fga24
         WHEN '0'
            CALL cl_getmsg('afa-404',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-405',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-406',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-407',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-408',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
