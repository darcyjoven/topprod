# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aecr650.4gl
# Descriptions...: 製令製程明細表
# Return code....:
# Date & Author..: 97/10/30 BY Sophia
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.MOD-530132 05/03/17 By pengu 欄位QBE順序調整
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610070 01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-640093 06/04/010 By pengu 報表最後一頁的"列印條件:"後面跟的資料欄位代號改為欄位說明
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690112 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	        wc  	STRING,			# Where condition
                s       LIKE type_file.chr3,    #LIKE cqo_file.cqo01,    # No.FUN-680073 VARCHAR(3)   #TQC-B90211
                more    LIKE type_file.chr1     # No.FUN-680073 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690112 by baogui
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r650_tm()	        	# Input print condition
      ELSE CALL aecr650()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
END MAIN
 
FUNCTION r650_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680073 SMALLINT 
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(400) 
 
      LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r650_w AT p_row,p_col WITH FORM "aec/42f/aecr650"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '213'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
WHILE TRUE
    #-----------MOD-530132------------------------------
     # CONSTRUCT BY NAME tm.wc ON ecm01,ecm03_par,ecm03
       CONSTRUCT BY NAME tm.wc ON ecm01,ecm03,ecm03_par
   #-----------END-------------------------------------
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
      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.s,tm.more 		# Condition
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aecr650'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aecr650','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",              #TQC-610070
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aecr650',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r650_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aecr650()
   ERROR ""
END WHILE
   CLOSE WINDOW r650_w
END FUNCTION
 
FUNCTION aecr650()
   DEFINE#l_name VARCHAR(20),# External(Disk) file name
          l_name        LIKE type_file.chr20,   # No.FUN-680073 VARCHAR(20),# External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql 	LIKE type_file.chr1000, # No.FUN-680073 VARCHAR(1000)  # RDSQL STATEMENT 
          l_chr		LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1)
          l_za05        LIKE type_file.chr1000, # No.FUN-680073 VARCHAR(40)
	  l_azi03       LIKE azi_file.azi03,
          l_order       ARRAY[5] OF LIKE type_file.chr1000,   #No.FUN-680073 #FUN-5B0105 20->40
          sr            RECORD
                  order1    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40
                  order2    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40   
                  order3    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40
                  ecm01     LIKE ecm_file.ecm01,     #
                  ecm03_par LIKE ecm_file.ecm03_par,
                  ecm03     LIKE ecm_file.ecm03,
                  ecm06     LIKE ecm_file.ecm06,
                  ecm05     LIKE ecm_file.ecm05,
                  ecm301    LIKE ecm_file.ecm301
                  END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ecmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ecmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ecmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecmuser', 'ecmgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',ecm01,ecm03_par,ecm03,ecm06,ecm05,ecm301+ecm302+ecm303 ",
                 "  FROM ecm_file",
                 " WHERE (ecm301+ecm302> 0) AND ",tm.wc
     PREPARE r650_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
        EXIT PROGRAM
           
     END IF
     DECLARE r650_curs1 CURSOR FOR r650_prepare1
 
     CALL cl_outnam('aecr650') RETURNING l_name
     START REPORT r650_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r650_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ecm01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ecm03_par
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ecm03
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
 
       OUTPUT TO REPORT r650_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r650_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r650_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,     # No.FUN-680073 VARCHAR(1) 
          sr                RECORD
                  order1    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40    
                  order2    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40
                  order3    LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),  #FUN-5B0105 20->40
                  ecm01     LIKE ecm_file.ecm01,     #
                  ecm03_par LIKE ecm_file.ecm03_par,
                  ecm03     LIKE ecm_file.ecm03,
                  ecm06     LIKE ecm_file.ecm06,
                  ecm05     LIKE ecm_file.ecm05,
                  ecm301     LIKE ecm_file.ecm301
                  END RECORD,
         l_chr		LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.order3
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ecm01,
            COLUMN g_c[32],sr.ecm03_par,
            COLUMN g_c[33],sr.ecm03 USING '&&',
            COLUMN g_c[34],sr.ecm301 USING '##,###,###&',
            COLUMN g_c[35],sr.ecm06,
            COLUMN g_c[36],sr.ecm05
 
   AFTER GROUP OF sr.order1
      PRINT
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
       #----------No.FUN-640093 add
         CALL cl_wcchp(tm.wc,'ecm01,ecm03,ecm03_par')
              RETURNING tm.wc
       #----------No.FUN-640093 end
            #-- TQC-630166 begin
              #IF tm.wc[001,120] > ' ' THEN			# for 80
	      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
              #IF tm.wc[071,240] > ' ' THEN
	      #   PRINT COLUMN 10,     tm.wc[071,240] CLIPPED END IF
              #IF tm.wc[141,300] > ' ' THEN
	      #   PRINT COLUMN 10,     tm.wc[141,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
