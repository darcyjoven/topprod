# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gfar120.4gl
# Desc/riptions..: 資產減值準備明細表
# Date & Author..: 03/11/18 By Danny
# Modify.........: No.CHI-480001 04/08/11 By Danny   新增報表
# Modify.........: No.FUN-510035 05/02/14 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0097 06/10/31 By hongmei l_time轉g_time
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80025 11/08/03 By minpp EXIT PROGRAM 前加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD				# Print condition RECORD
	        #wc   VARCHAR(1000),		# Where condition
		wc	STRING,			#TQC-630166
   		s    	LIKE type_file.chr3,    #NO FUN-690009 VARCHAR(3)  # Order by sequence
   		t    	LIKE type_file.chr3,    #NO FUN-690009 VARCHAR(3)  # Eject sw
         	v    	LIKE type_file.chr3,    #NO FUN-690009 VARCHAR(3)	
                a       LIKE type_file.chr1,    #NO FUN-690009 VARCHAR(1)
                b    	LIKE type_file.chr1,    #NO FUN-690009 VARCHAR(1)		
   		more	LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1) 	# Input more condition(Y/N)
              END RECORD
DEFINE   g_orderA ARRAY[3] OF   LIKE cre_file.cre08    #NO FUN-690009 VARCHAR(10)
DEFINE   g_i            LIKE type_file.num5     #NO FUN-690009 SMALLINT #count/index for any purpose
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   LET g_trace = 'N'		             # default trace off
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
LET tm.s  = ARG_VAL(8)
LET tm.t  = ARG_VAL(9)
LET tm.a  = ARG_VAL(10)
LET tm.b  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B80025
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN #If background job sw is off
        CALL r120_tm(0,0)		   # Input print condition
   ELSE CALL gfar120()		           # Read data and create out-file
   END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80025
END MAIN
 
 
FUNCTION r120_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_cmd		LIKE type_file.chr1000   #NO FUN-690009 VARCHAR(1000)
 
   OPEN WINDOW r120_w WITH FORM "gfa/42f/gfar120"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '1'
   LET tm.t    = 'Y  '
   LET tm.a    = '3'
   LET tm.b    = '3'
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
CONSTRUCT BY NAME tm.wc ON faj04,fbt03,fbs01,fbs02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET INT_FLAG = 0 CLOSE WINDOW r120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80025
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.s,tm.t,tm.more #ATTRIBUTE(YELLOW)   #TQC-8C0076
INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm.a,tm.b,tm.more
                 WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' THEN NEXT FIELD b END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                     g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                     g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80025
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gfar120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gfar120','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                      " '",tm.s CLIPPED,"'",
                      " '",tm.t CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gfar120',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80025
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gfar120()
   ERROR ""
END WHILE
   CLOSE WINDOW r120_w
END FUNCTION
 
FUNCTION gfar120()
   DEFINE l_name	LIKE type_file.chr20,     #NO FUN-690009 VARCHAR(20)   # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0097
          l_sql 	LIKE type_file.chr1000,   #NO FUN-690009 VARCHAR(1000) # RDSQL STATEMENT
          l_chr		LIKE type_file.chr1,      #NO FUN-690009 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,   #NO FUN-690009 VARCHAR(40)
       l_order	ARRAY[6] OF  LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
       sr            RECORD
                        order1 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        order2 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        order3 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        fbs01  LIKE fbs_file.fbs01,	
                        fbs02  LIKE fbs_file.fbs02,	
                        fbt02  LIKE fbt_file.fbt01,	
                        fbt03  LIKE fbt_file.fbt03,	
                        fbt031 LIKE fbt_file.fbt031,
                        fbt04  LIKE fbt_file.fbt04, 	
                        fbt05  LIKE fbt_file.fbt05, 	
                        fbt06  LIKE fbt_file.fbt06, 	
                        fbt07  LIKE fbt_file.fbt07, 	
                        fbt08  LIKE fbt_file.fbt08, 	
                        faj04  LIKE faj_file.faj04,	
                        faj06  LIKE faj_file.faj06, 	
                        fag03  LIKE fag_file.fag03 	
                        END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND fbsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND fbsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND fbsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fbsuser', 'fbsgrup')
     #End:FUN-980030
 
 
     IF tm.a='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbsconf='Y' " END IF
     IF tm.a='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbsconf='N' " END IF
     IF tm.b='1' THEN LET tm.wc=tm.wc CLIPPED," AND fbspost='Y' " END IF
     IF tm.b='2' THEN LET tm.wc=tm.wc CLIPPED," AND fbspost='N' " END IF
 
  LET l_sql = "SELECT '','','',",
                 "       fbs01,fbs02,fbt02,fbt03,fbt031,fbt04,",
                 "       fbt05,fbt06,fbt07,fbt08,faj04,faj06,fag03",
                 " FROM fbs_file,fbt_file,",
                 "      OUTER faj_file,OUTER fag_file ",
                 " WHERE fbs01  = fbt01 ",
                 "   AND fbt_file.fbt03  = faj_file.faj02 ",
                 "   AND fbt_file.fbt031 = faj_file.faj022 ",
                 "   AND fbt_file.fbt08  = fag_file.fag01  ",
                 "   AND fbsconf <> 'X' ",
                 "   AND ",tm.wc CLIPPED
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r120_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80025
        EXIT PROGRAM
     END IF
     DECLARE r120_cs1 CURSOR FOR r120_prepare1
 
     CALL cl_outnam('gfar120') RETURNING l_name
     START REPORT r120_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r120_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
    IF g_trace='Y' THEN DISPLAY sr.fbs01 END IF
    FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fbt03
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.fbs01
                WHEN tm.s[g_i,g_i] = '4'
                     LET l_order[g_i] = sr.fbs02 USING 'yyyymmdd'
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT r120_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r120_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT r120_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(1) 
          l_str         LIKE type_file.chr50,        #NO FUN-690009 VARCHAR(50)    #列印排列順序說明
       sr            RECORD
                        order1 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        order2 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        order3 LIKE fbs_file.fbs01,   #NO FUN-690009 VARCHAR(10)
                        fbs01  LIKE fbs_file.fbs01,	
                        fbs02  LIKE fbs_file.fbs02,	
                        fbt02  LIKE fbt_file.fbt01,	
                        fbt03  LIKE fbt_file.fbt03,	
                        fbt031 LIKE fbt_file.fbt031,
                        fbt04  LIKE fbt_file.fbt04, 	
                        fbt05  LIKE fbt_file.fbt05, 	
                        fbt06  LIKE fbt_file.fbt06, 	
                        fbt07  LIKE fbt_file.fbt07, 	
                        fbt08  LIKE fbt_file.fbt08, 	
                        faj04  LIKE faj_file.faj04,	
                        faj06  LIKE faj_file.faj06, 	
                        fag03  LIKE fag_file.fag03 	
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.fbs01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.fbs01
       PRINT  COLUMN g_c[31],sr.fbs01,
              COLUMN g_c[32],sr.fbs02;
 
   ON EVERY ROW
       LET l_str = sr.fbt08,' ',sr.fag03
       PRINT  COLUMN g_c[33],sr.fbt02 USING '###&',
              COLUMN g_c[34],sr.fbt03,
              COLUMN g_c[35],sr.fbt031,
              COLUMN g_c[36],sr.faj06,
              COLUMN g_c[37],cl_numfor(sr.fbt04,37,g_azi04),
              COLUMN g_c[38],cl_numfor(sr.fbt05,38,g_azi04),
              COLUMN g_c[39],cl_numfor(sr.fbt07,39,g_azi04),
              COLUMN g_c[40],l_str
 
  ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
	#TQC-630166
        #      IF tm.wc[001,120] > ' ' THEN			# for 132
 	#	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #      IF tm.wc[121,240] > ' ' THEN
 	#	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #      IF tm.wc[241,300] > ' ' THEN
 	#	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610037 <001> #
