# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr302.4gl
# Descriptions...: 料件模擬成本項目差異分析表
# Input parameter:
# Return code....:
# Date & Author..: 92/01/27 By MAY
#      Modify    : 92/05/28 By David
# Modify.........: No.FUN-510039 05/02/18 By pengu 報表轉XML
# Modify.........: No.MOD-530128 05/03/17 By pengu 欄位QBE與INPUT順序調整
# Modify.........: No.FUN-570244 05/07/22 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
#
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改 
 
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
    		wc  	LIKE type_file.chr1000,   #No.FUN-680071 VARCHAR(300)		# Where condition
                csb02  LIKE csb_file.csb02,
    		more	LIKE type_file.chr1000   #No.FUN-680071  VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD,
          l_cnt    LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          g_argv1       LIKE csb_file.csb02
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-690110 by xiake
 
 
   IF g_sma.sma58='N' THEN  #系統沒有使用成本項目結構
      CALL cl_err('','mfg0060',0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
#No.CHI-6A0004--begin
#   SELECT azi03 INTO g_azi03 FROM azi_file
#          WHERE azi01 = g_aza.aza17             # 本國幣別之成本小數位數
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET g_argv1= ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      LET tm.csb02 = g_argv1
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r302_tm()	        	# Input print condition
      ELSE CALL r302()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r302_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r302_w AT p_row,p_col
        WITH FORM "acs/42f/acsr302"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    #-----------------MOD-530128-------------------------------------
     #CONSTRUCT BY NAME tm.wc ON ima06,ima09,ima10,ima11,ima12,ima01
      CONSTRUCT BY NAME tm.wc ON ima06,ima10,ima12,ima09,ima11,ima01
   #-----------------END--------------------------------------------
#No.FUN-570244 --start--
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570244 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW r302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   IF g_argv1 IS NOT NULL OR g_argv1 != ' ' THEN
           DISPLAY g_argv1 TO csb02 		# Condition
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.csb02,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD csb02
         IF g_argv1 IS NOT NULL  AND g_argv1 != ' ' THEN
           LET tm.csb02 = g_argv1
           NEXT FIELD more
         ELSE
             IF tm.csb02 IS NULL OR
                tm.csb02 NOT MATCHES '[0123456789]' THEN
                NEXT FIELD csb02
             END IF
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
#     ON ACTION CONTROLP CALL r302_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr302','9031',1)   
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
                         " '",tm.csb02 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr302',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r302()
   ERROR ""
END WHILE
   CLOSE WINDOW r302_w
END FUNCTION
 
{
FUNCTION r302_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r302_w2 AT 2,2
        WITH FORM "acs/42f/acsi300"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acsi300")
 
   CALL cl_ui_locale("acsi300")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        csb02,csb03,csb05,csb04
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
   CLOSE WINDOW r302_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
}
 
FUNCTION r302()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_sql1	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
    #     l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10)  #No.TQC-6A0079
          sr            RECORD
                           g_csb    RECORD LIKE csb_file.*,
                           g_iml    RECORD LIKE iml_file.*,
                           ima02    LIKE ima_file.ima02,
                           ima05    LIKE ima_file.ima05,
                           ima06    LIKE ima_file.ima06,
                           ima08    LIKE ima_file.ima08,
                           ima86    LIKE ima_file.ima86,
                           imz02    LIKE imz_file.imz02,
                           smg02    LIKE smg_file.smg02,
                           smg03    LIKE smg_file.smg03
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND csbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND csbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND csbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('csbuser', 'csbgrup')
     #End:FUN-980030
 
     LET  l_cnt = 0
     LET l_sql = " SELECT csb_file.*,iml_file.*,ima02,ima05," ,
                 " ima06,ima08,ima86,imz02,smg02,smg03 ",
                 " FROM ima_file,csb_file,OUTER iml_file,OUTER smg_file,",
                 " OUTER imz_file ",
                 " WHERE csb01 = ima01  AND csb_file.csb01 = iml_file.iml01 AND ima_file.ima06 = imz_file.imz01 ",
                 " AND csb_file.csb04 = iml_file.iml02 ",
                 " AND smg_file.smg01 = csb_file.csb04 ",
                 " AND csb02 = '",tm.csb02,"'",
                 " AND ", tm.wc CLIPPED,
                 " ORDER BY csb01,smg03 "
 
     PREPARE r302_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r302_cs1 CURSOR FOR r302_prepare1
 
     CALL cl_outnam('acsr302') RETURNING l_name
     START REPORT r302_rep TO l_name
 
     #LET g_pageno = 0
     FOREACH r302_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.smg03 IS NULL THEN
          LET sr.smg03 = ' '
       END IF
      # LET  g_pageno = g_pageno + 1
       OUTPUT TO REPORT r302_rep(sr.*)
     END FOREACH
      # MESSAGE g_pageno
       SLEEP 1
 
    # LET g_pageno = 0
     LET  l_sql1 = " SELECT '','','','','',iml_file.*,ima02,ima05,",
                   " ima06,ima08,ima86,imz02,smg02,smg03 ",
                   " FROM ima_file,iml_file,OUTER smg_file,",
                   " OUTER imz_file ",
                   " WHERE ima01 = iml01 AND ima_file.ima06 = imz_file.imz01 ",
                   " AND smg_file.smg01 = iml_file.iml02 ",
                   " AND (iml01 NOT IN ",
                   " (SELECT csb01 FROM csb_file,iml_file ",
                   " WHERE csb02 = '0' AND csb01 = iml_file.iml01 and csb04 = iml_file.iml02 ) ",
                   " OR  iml_file.iml02 NOT IN (SELECT csb04 ",
                   " FROM csb_file ,iml_file ",
                   " WHERE csb02 = '0' AND csb01 = iml_file.iml01 and csb04 = iml_file.iml02 )) ",
                   " AND ", tm.wc CLIPPED,
                   " ORDER BY iml01,smg03 "
     PREPARE r302_pre1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r302_cs2 CURSOR FOR r302_pre1
     FOREACH r302_cs2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.smg03 IS NULL THEN
          LET sr.smg03 = ' '
       END IF
     #  LET  g_pageno = g_pageno + 1
       OUTPUT TO REPORT r302_rep(sr.*)
     END FOREACH
     #MESSAGE g_pageno
     FINISH REPORT r302_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r302_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          l_sum         LIKE iml_file.iml031,
          l_sum1        LIKE iml_file.iml031,
          l_count       LIKE csb_file.csb05,
          l_count1      LIKE csb_file.csb05,
          l_ima02       LIKE ima_file.ima02,
          sr            RECORD
                           g_csb    RECORD LIKE csb_file.*,
                           g_iml    RECORD LIKE iml_file.*,
                           ima02    LIKE ima_file.ima02,
                           ima05    LIKE ima_file.ima05,
                           ima06    LIKE ima_file.ima06,
                           ima08    LIKE ima_file.ima08,
                           ima86    LIKE ima_file.ima86,
                           imz02    LIKE imz_file.imz02,
                           smg02    LIKE smg_file.smg02,
                           smg03    LIKE smg_file.smg03
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.ima06,sr.smg03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len]
      PRINT COLUMN 2,g_x[20] CLIPPED,COLUMN 15,tm.csb02
      PRINT COLUMN 2,g_x[11] CLIPPED,
            COLUMN 15,sr.ima06,
            COLUMN 30,g_x[12] CLIPPED,
            COLUMN 40,sr.imz02
      SKIP 1 LINES
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima06
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      LET l_sum=0
      LET l_sum1=0
      LET l_count = 0
      LET l_count1= 0
 
ON EVERY ROW
    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.g_csb.csb01
    IF (sr.g_csb.csb01 IS NOT NULL AND sr.g_csb.csb01 != ' ') AND
       (sr.g_iml.iml01 IS NOT NULL AND sr.g_iml.iml01 != ' ') THEN
       PRINT COLUMN g_c[31],sr.g_csb.csb01,
             COLUMN g_c[32],l_ima02,
             COLUMN g_c[33],sr.ima05,
             COLUMN g_c[34],sr.ima08,
             COLUMN g_c[35],sr.ima86,
             COLUMN g_c[36],sr.smg03,
             COLUMN g_c[37],sr.g_csb.csb04,
             COLUMN g_c[38],sr.smg02;
      IF sr.g_csb.csb03 = '1' THEN
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml031,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.g_csb.csb05,40,g_azi04),
            COLUMN g_c[41],cl_numfor((sr.g_csb.csb05 - sr.g_iml.iml031),41,g_azi04);
          IF sr.g_iml.iml031 = 0 THEN
            PRINT COLUMN g_c[42],sr.g_iml.iml031 USING '---&.&&'
          ELSE
            PRINT COLUMN g_c[42],
             ((sr.g_csb.csb05 - sr.g_iml.iml031)/sr.g_iml.iml031 * 100)
             USING '---&.&&'
          END IF
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml032,39,g_azi04)
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml033,39,g_azi04)
      END IF
 
      IF sr.g_csb.csb03 = '2' THEN
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml031 ,39,g_azi04)
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml032 ,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.g_csb.csb05,40,g_azi04),
            COLUMN g_c[41],cl_numfor((sr.g_csb.csb05 - sr.g_iml.iml032),41,g_azi04);
          IF sr.g_iml.iml032 = 0 THEN
            PRINT COLUMN g_c[42],sr.g_iml.iml032 USING '---&.&&'
          ELSE
            PRINT COLUMN g_c[42],
             ((sr.g_csb.csb05 - sr.g_iml.iml032)/sr.g_iml.iml032 * 100)
             USING '---&.&&'
          END IF
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml033,39,g_azi04)
      END IF
 
      IF sr.g_csb.csb03 = '3' THEN
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml031 ,39,g_azi04)
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml032 ,39,g_azi04)
      PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml033 ,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.g_csb.csb05,40,g_azi04),
            COLUMN g_c[41],cl_numfor((sr.g_csb.csb05 - sr.g_iml.iml033),41,g_azi04);
          IF sr.g_iml.iml033 = 0 THEN
            PRINT COLUMN g_c[42],sr.g_iml.iml033 USING '---&.&&'
          ELSE
            PRINT COLUMN g_c[42],
             ((sr.g_csb.csb05 - sr.g_iml.iml033)/sr.g_iml.iml033 * 100)
             USING '---&.&&'
          END IF
     END IF
   # LET l_count = sr.g_iml.iml031 + sr.g_iml.iml032 + sr.g_iml.iml033
     LET l_count = sr.g_csb.csb05 + l_count
     LET l_count1= sr.g_csb.csb05 + l_count1
     LET l_sum = sr.g_iml.iml031 + sr.g_iml.iml032 + sr.g_iml.iml033+l_sum
     LET l_sum1= sr.g_iml.iml031 + sr.g_iml.iml032 + sr.g_iml.iml033+l_sum1
   ELSE   IF (sr.g_csb.csb01 IS NOT NULL AND sr.g_csb.csb01 != ' ' ) AND
             (sr.g_iml.iml01 IS NULL OR sr.g_iml.iml01 = ' ' ) THEN
              PRINT COLUMN g_c[31],sr.g_csb.csb01,
                    COLUMN g_c[32],l_ima02,
                    COLUMN g_c[33],sr.ima05,
                    COLUMN g_c[34],sr.ima08,
                    COLUMN g_c[35],sr.ima86,
                    COLUMN g_c[36],sr.smg03,
                    COLUMN g_c[37],sr.g_csb.csb04,
                    COLUMN g_c[38],sr.smg02;
            PRINT COLUMN g_c[40],cl_numfor(sr.g_csb.csb05,40,g_azi04)
            LET l_count = sr.g_csb.csb05 + l_count
            LET l_count1= sr.g_csb.csb05 + l_count1
            LET l_sum   = 0+l_sum
            LET l_sum1  = 0+l_sum1
          ELSE
              SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.g_iml.iml01
              PRINT COLUMN g_c[31],sr.g_iml.iml01,
                    COLUMN g_c[32],l_ima02,
                    COLUMN g_c[33],sr.ima05,
                    COLUMN g_c[34],sr.ima08,
                    COLUMN g_c[35],sr.ima86,
                    COLUMN g_c[36],sr.smg03,
                    COLUMN g_c[37],sr.g_iml.iml02,
                    COLUMN g_c[38],sr.smg02;
               PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml031 ,39,g_azi04)
               PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml032 ,39,g_azi04)
               PRINT COLUMN g_c[39],cl_numfor(sr.g_iml.iml033 ,39,g_azi04)
               LET l_count = l_count + 0
               LET l_count1= l_count1+ 0
               LET l_sum   = sr.g_iml.iml031 + sr.g_iml.iml032 + sr.g_iml.iml033
                             +l_sum
               LET l_sum1  = sr.g_iml.iml031 + sr.g_iml.iml032 + sr.g_iml.iml033
                             +l_sum1
          END IF
    END IF
 
   AFTER GROUP OF sr.ima06
     PRINT COLUMN g_c[35],g_x[18] CLIPPED,
           COLUMN g_c[39],cl_numfor(l_sum,39,g_azi05),
           COLUMN g_c[40],cl_numfor(l_count,40,g_azi05),
           COLUMN g_c[41],cl_numfor((l_count - l_sum),41,g_azi05);
           IF l_sum IS NULL OR l_sum = ' ' OR l_sum = 0 THEN
                PRINT COLUMN g_c[42],l_sum  USING '---&.&&'
           ELSE
                PRINT COLUMN g_c[42],((l_count -  l_sum)/l_sum * 100 ) USING '---&.&&'
           END IF
 
   AFTER GROUP OF sr.smg03
     PRINT COLUMN g_c[35],g_x[19] CLIPPED,
           COLUMN g_c[39],cl_numfor(l_sum1,39,g_azi05),
           COLUMN g_c[40],cl_numfor(l_count1,40,g_azi05),
           COLUMN g_c[41],cl_numfor((l_count1-l_sum1),41,g_azi05 );
           IF l_sum1 IS NULL OR l_sum1= ' ' OR l_sum1= 0 THEN
                PRINT COLUMN g_c[42],l_sum1 USING '---&.&&'
           ELSE
                PRINT COLUMN g_c[42],((l_count1 -  l_sum1)/l_sum1* 100 ) USING '---&.&&'
           END IF
     LET l_sum1=0
     LET l_count1 = 0
 
   ON LAST ROW
#     PRINT l_cnt
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              IF tm.wc[001,070] > ' ' THEN			# for 80
		 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
              IF tm.wc[071,140] > ' ' THEN
	 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
              IF tm.wc[141,210] > ' ' THEN
	 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
              IF tm.wc[211,280] > ' ' THEN
	 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
      END IF
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
#Patch....NO.TQC-610035 <001> #
