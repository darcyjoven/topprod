# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr110.4gl
# Descriptions...: 無成本資料料件表
# Return code....:
# Date & Author..: 92/01/30 By Carol
# Modify.........: No.FUN-5100339 05/01/20 By pengu 報表轉XML
#
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	    a       LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)		# Including family parts(Y/N)
	    b       LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)		# Including Configer & Feature (Y/N)
   		more 	LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-690110 by xiake
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.a = ARG_VAL(7)
   LET tm.b = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r110_tm()	        	# Input print condition
      ELSE CALL acsr110()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r110_tm()
   DEFINE l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
   DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 16
   END IF
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "acs/42f/acsr110"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   DISPLAY BY NAME tm.a,tm.b,tm.more 		# Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
	  AFTER FIELD a
		 IF tm.a  IS NULL OR tm.a NOT MATCHES '[YN]' THEN
			NEXT FIELD a
		 END IF
	  AFTER FIELD b
		 IF tm.b  IS NULL OR tm.b NOT MATCHES '[YN]' THEN
			NEXT FIELD b
		 END IF
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
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr110','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a,"'",
                         " '",tm.b,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr110',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acsr110()
   ERROR ""
END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION acsr110()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
     #    l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10)  #No.TQC-6A0079
          sr            RECORD ima08 LIKE ima_file.ima08,	# 來源碼
                               ima01 LIKE ima_file.ima01,   # 料件編號
                               ima02 LIKE ima_file.ima02,   # 品名規格
                               ima05 LIKE ima_file.ima05    # 目前版本
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima08, ima01, ima02, ima05",
                 "  FROM ima_file",
                 " WHERE ima01 NOT IN (SELECT imb01 FROM imb_file)",
	             "   AND imaacti = 'Y'"
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
	 IF tm.a ='N' THEN LET l_sql = l_sql CLIPPED, " AND ima08 != 'A' " END IF
	 IF tm.b ='N' THEN
		LET l_sql = l_sql CLIPPED, " AND ima08 NOT IN ('C','D') "
     END IF
     PREPARE r110_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time              #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r110_curs1 CURSOR FOR r110_prepare1
 
     CALL cl_outnam('acsr110') RETURNING l_name
     START REPORT r110_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r110_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       OUTPUT TO REPORT r110_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r110_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r110_rep(sr)
   DEFINE l_last_sw 	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD ima08 LIKE ima_file.ima08,	# 來源碼
                               ima01 LIKE ima_file.ima01,   # 料件編號
                               ima02 LIKE ima_file.ima02,   # 品名規格
                               ima05 LIKE ima_file.ima05    # 目前版本
                        END RECORD,
         l_dscr     LIKE oea_file.oea01    #No.FUN-680071 VARCHAR(12)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima08,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
	  CASE sr.ima08
		   WHEN 'C' LET l_dscr = g_x[13] CLIPPED
		   WHEN 'T' LET l_dscr = g_x[14] CLIPPED
		   WHEN 'D' LET l_dscr = g_x[15] CLIPPED
		   WHEN 'A' LET l_dscr = g_x[16] CLIPPED
		   WHEN 'M' LET l_dscr = g_x[17] CLIPPED
		   WHEN 'P' LET l_dscr = g_x[18] CLIPPED
		   WHEN 'X' LET l_dscr = g_x[19] CLIPPED
		   WHEN 'K' LET l_dscr = g_x[20] CLIPPED
		   WHEN 'U' LET l_dscr = g_x[21] CLIPPED
		   WHEN 'V' LET l_dscr = g_x[22] CLIPPED
		   WHEN 'W' LET l_dscr = g_x[23] CLIPPED
		   WHEN 'R' LET l_dscr = g_x[24] CLIPPED
		   WHEN 'Z' LET l_dscr = g_x[25] CLIPPED
		   WHEN 'S' LET l_dscr = g_x[26] CLIPPED
		   OTHERWISE LET l_dscr = ' '
	  END CASE
      PRINT COLUMN g_c[31],sr.ima08,
            COLUMN g_c[32],l_dscr,
            COLUMN g_c[33],sr.ima01,
            COLUMN g_c[34],sr.ima02,
            COLUMN g_c[35],sr.ima05
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
