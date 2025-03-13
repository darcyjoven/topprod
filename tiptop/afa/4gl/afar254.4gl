# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afar254.4gl
# Desc/riptions..: 量測儀器逾期待驗明細表
# Date & Author..: 00/03/23 By Iceman
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭制表日期等位置調整
# Modify.........: NO.FUN-750093 07/05/28 By destiny 報表改為使用crystal report
# Modify.........: NO.FUN-770033 07/07/30 By destiny 增加打印條件
# Modify.........: NO.TQC-780054 07/08/17 By sherry  out內有（+）/to_date的語法改為INFORMIX語法
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0317 10/12/01 By chenying DECLARE sql_cur1 發生語法錯誤
# Modify.........: No.MOD-B30370 11/03/16 By lixia l_sql增加過濾條件 fga24 <> '4'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)
                bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*,
          g_desc              LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
#No.FUN-580010 --start
#         g_dash1       LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(80)
#DEFINE   g_dash          LIKE type_file.chr1000  #Dash line       #No.FUN-680070 VARCHAR(400)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#DEFINE   g_len           LIKE type_file.num5     #Report width(79/132/136)       #No.FUN-680070 SMALLINT
#DEFINE   g_pageno        LIKE type_file.num5     #Report page no       #No.FUN-680070 SMALLINT
#DEFINE   g_zz05          LIKE type_file.chr1     #Print tm.wc ?(Y/N)       #No.FUN-680070 VARCHAR(1)
#No.FUN-580010 --end
DEFINE    g_str           STRING                #FUN-750093
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r254_tm(0,0)		# Input print condition
      ELSE CALL afar254()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION r254_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r254_w AT p_row,p_col WITH FORM "afa/42f/afar254"
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
      CONSTRUCT BY NAME tm.wc ON fga01,fga13,fga12,fga10
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
         LET INT_FLAG = 0 CLOSE WINDOW r254_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.bdate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate
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
         LET INT_FLAG = 0 CLOSE WINDOW r254_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar254'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar254','9031',1)
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
                            " '",tm.bdate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar254',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r254_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar254()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r254_w
END FUNCTION
 
FUNCTION afar254()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          sr   RECORD
                     fga13     LIKE fga_file.fga13,    #部門編號
                     gem02     LIKE gem_file.gem02,    #部門名稱
                     fga01     LIKE fga_file.fga01,    #儀器編號
                     fga06     LIKE fga_file.fga06,    #儀器名稱
                     fga23     LIKE fga_file.fga23,    #應校驗日
                     gen02     LIKE gen_file.gen02     #保管日期
        END RECORD
 
#No.FUN-580010 --start
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-770033
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afar254'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#No.FUN-580010 --end
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fgauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fgagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fgagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fgauser', 'fgagrup')
     #End:FUN-980030
 
 
     LET l_sql =  "SELECT fga13,gem02,fga01,fga06,fga23,gen02",
                  "  FROM fga_file ",
                  "LEFT OUTER JOIN gen_file ON fga12 = gen01 ",
                  "LEFT OUTER JOIN gem_file ON fga13 = gem01 ",
#                 " WHERE fga23 < cast('",tm.bdate,"' AS DATETIME)",   #TQC-AB0317 mark 
                  " WHERE fga23 < cast('",tm.bdate,"' AS DATE)",       #TQC-AB0317 add
               #No.FUN-780054---End
                  "   AND ",tm.wc CLIPPED,
                  "   AND  fga24 <> '4' "    #MOD-B30370
#No.FUN-770033--start--
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'fga01,fga13,fga12,fga10')                                                                                           
     RETURNING tm.wc                                                                                                              
     LET g_str = tm.wc
     END IF
     LET g_str= g_str
#No.FUN-770033--end--
#     LET g_str = ''                                      #FUN-750093
     CALL cl_prt_cs1('afar254','afar254',l_sql,g_str)    #FUN-7500093
#FUN-750093--begin 
    {PREPARE r254_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r254_cs1 CURSOR FOR r254_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
     CALL cl_outnam('afar254') RETURNING l_name
     START REPORT r254_rep TO l_name
     LET g_pageno = 0
     FOREACH r254_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       OUTPUT TO REPORT r254_rep(sr.*)     
     END FOREACH
 
     FINISH REPORT r254_rep                
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)} 
#FUN-750093--end
END FUNCTION
#FUN-750093--begin
 
{REPORT r254_rep(sr)
   DEFINE l_s1 LIKE type_file.chr1000          #No.FUN-580010       #No.FUN-680070 VARCHAR(100)
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          sr   RECORD
                     fga13     LIKE fga_file.fga13,    #部門編號
                     gem02     LIKE gem_file.gem02,    #部門名稱
                     fga01     LIKE fga_file.fga01,    #儀器編號
                     fga06     LIKE fga_file.fga06,    #儀器名稱
                     fga23     LIKE fga_file.fga23,    #應校驗日
                     gen02     LIKE gen_file.gen02     #保管日期
        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.fga13
 
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009 mark
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #No.TQC-6C0009
      PRINT
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,
            g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[36] CLIPPED
      PRINT g_dash1
      LET l_last_sw='n'
 
   BEFORE GROUP OF sr.fga13
      SKIP TO TOP OF PAGE
      LET l_s1=sr.fga13 CLIPPED,' ',sr.gem02 CLIPPED
      PRINT COLUMN g_c[31],l_s1 CLIPPED;
 
   ON EVERY ROW
      PRINT  COLUMN g_c[32],sr.fga01 CLIPPED,
             COLUMN g_c[33],sr.fga06 CLIPPED,
             COLUMN g_c[34],sr.fga23 CLIPPED,
             COLUMN g_c[35],sr.gen02 CLIPPED
#No.FUN-580010 --end
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#FUN-750093--end
#Patch....NO.TQC-610035 <> #
