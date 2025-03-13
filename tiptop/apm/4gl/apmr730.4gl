# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr730.4gl
# Descriptions...: 已發出委外採購單檢核表
# Input parameter:
# Return code....:
# Date & Author..: 93/05/12 By Keith
# Modify.........: No.FUN-4C0095 04/12/29 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改報表結束定位點
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 採購項次對齊
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-850139 08/05/29 By zhaijie老報表修改為CR
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc  	LIKE type_file.chr1000, # Where condition   #TQC-630166 mark 	#No.FUN-680136 VARCHAR(500)
		wc  	STRING,		        # Where condition   #TQC-630166 
           	more	LIKE type_file.chr1   	# Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1)
              END RECORD
 
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
#NO.FUN-850139--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-850139--END---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#NO.FUN-850139-----START----
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmm09.pmm_file.pmm09,",
               "pmm22.pmm_file.pmm22,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "pmn041.pmn_file.pmn041,",
               "pmn20.pmn_file.pmn20,", 
               "pmn31.pmn_file.pmn31,",
               "l_ima021.ima_file.ima021,",
               "l_pmc03.pmc_file.pmc03,",
               "t_azi03.azi_file.azi03"
   LET l_table =cl_prt_temptable('apmr730',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                       
#NO.FUN-850139---END-----
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-----------No.TQC-610085 modify
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#-----------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r730_tm(0,0)		# Input print condition
      ELSE CALL apmr730()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r730_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r730_w AT p_row,p_col WITH FORM "apm/42f/apmr730"
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
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
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
      LET INT_FLAG = 0 CLOSE WINDOW r730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr730'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr730','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",           #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr730',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r730_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr730()
   ERROR ""
END WHILE
   CLOSE WINDOW r730_w
END FUNCTION
 
FUNCTION apmr730()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		              # RDSQL STATEMENT   #TQC-630166
          l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          sr            RECORD
                               pmm01    LIKE pmm_file.pmm01,  #採購單號
                               pmm09    LIKE pmm_file.pmm09,  #供應商編號
                               pmm22    LIKE pmm_file.pmm22,  #供應商編號
                               pmn02    LIKE pmn_file.pmn02,  #項次
                               pmn04    LIKE pmn_file.pmn04,  #料件編號
                               pmn041   LIKE pmn_file.pmn041, #料件 #FUN-4C0095
                               pmn20    LIKE pmn_file.pmn20,  #採購量
                               pmn31    LIKE pmn_file.pmn31   #單價
                        END RECORD
#NO.FUN-850139----start---
DEFINE    l_ima021       LIKE ima_file.ima021
DEFINE    l_pmc03        LIKE pmc_file.pmc03
 
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'apmr730'
#NO.FUN-850139----end----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
 
        LET l_sql = "SELECT ",
                 " pmm01,pmm09,pmm22,pmn02,pmn04,pmn041,pmn20,pmn31",
                 "  FROM pmm_file,pmn_file ",
                 " WHERE pmm01 = pmn01 ",
                 " AND pmn011 = 'SUB' ",
                 "   AND pmn16 IN ('2') AND ",tm.wc
 
     PREPARE r730_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r730_curs1 CURSOR FOR r730_prepare1
 
#     CALL cl_outnam('apmr730') RETURNING l_name            #NO.FUN-850139
#        START REPORT r730_rep TO l_name                    #NO.FUN-850139
     FOREACH r730_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#       OUTPUT TO REPORT r730_rep(sr.*)                     #NO.FUN-850139
#NO.FUN-850139--start----
      SELECT pmc03
        INTO l_pmc03
        FROM pmc_file
       WHERE pmc01=sr.pmm09
      IF SQLCA.sqlcode THEN
          LET l_pmc03 = NULL
      END IF
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
       FROM azi_file WHERE azi01=sr.pmm22
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      EXECUTE insert_prep USING
        sr.pmm01,sr.pmm09,sr.pmm22,sr.pmn02,sr.pmn04,sr.pmn041,
        sr.pmn20,sr.pmn31,l_ima021,l_pmc03,t_azi03
#NO.FUN-850139---end----
     END FOREACH
#     FINISH REPORT r730_rep                                #NO.FUN-850139
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850139
#NO.FUN-850139----start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'pmm01,pmm04')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",g_azi04,";",g_azi03,";",g_azi05
     CALL cl_prt_cs3('apmr730','apmr730',g_sql,g_str) 
#NO.FUN-850139--end---
END FUNCTION
#NO.FUN-850139--start---mark--
#REPORT r730_rep(sr)
#   DEFINE l_ima021      LIKE ima_file.ima021    #FUN-4C0095
#   DEFINE l_pmc03       LIKE pmc_file.pmc03     #FUN-4C0095
#   DEFINE l_print40     LIKE type_file.chr1       #FUN-4C0095    #No.FUN-680136 VARCHAR(1)
#   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          sr            RECORD
#                               pmm01    LIKE pmm_file.pmm01,  #採購單號
#                               pmm09    LIKE pmm_file.pmm09,  #供應商編號
#                               pmm22    LIKE pmm_file.pmm22,  #供應商編號
#                               pmn02    LIKE pmn_file.pmn02,  #項次
#                               pmn04    LIKE pmn_file.pmn04,  #料件編號
#                               pmn041   LIKE pmn_file.pmn041, #料件 #FUN-4C0095
#                               pmn20    LIKE pmn_file.pmn20,  #採購量
#                               pmn31    LIKE pmn_file.pmn31   #單價
#                        END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pmm01,sr.pmm09,sr.pmn02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#    PRINT g_dash1
#      LET l_last_sw = 'n'
#
#BEFORE GROUP OF sr.pmm01
#      SELECT pmc03
#        INTO l_pmc03
#        FROM pmc_file
#       WHERE pmc01=sr.pmm09
#      IF SQLCA.sqlcode THEN
#          LET l_pmc03 = NULL
#      END IF
#      PRINT COLUMN g_c[31],sr.pmm01,
#            COLUMN g_c[32],sr.pmm09,
#            COLUMN g_c[33],l_pmc03;
#
#ON EVERY ROW
#
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05        #No.CHI-6A0004
#       FROM azi_file WHERE azi01=sr.pmm22
#      LET l_print40 = NULL
#      IF cl_null(sr.pmm09) THEN
#         LET l_print40 = l_print40 CLIPPED,'*'
#      END IF
#      IF cl_null(sr.pmn31) OR sr.pmn31 = 0 THEN
#         LET l_print40 = l_print40 CLIPPED,'#'
#      END IF
#      SELECT ima021
#        INTO l_ima021
#        FROM ima_file
#       WHERE ima01=sr.pmn04
#      IF SQLCA.sqlcode THEN
#          LET l_ima021 = NULL
#      END IF
#      PRINT COLUMN g_c[34],sr.pmn02 USING '########', #No.TQC-5B0212
#            COLUMN g_c[35],sr.pmn04,
#            COLUMN g_c[36],sr.pmn041,
#            COLUMN g_c[37],l_ima021,
#            COLUMN g_c[38],cl_numfor(sr.pmn20,38,3),
#            COLUMN g_c[39],cl_numfor(sr.pmn31,39,t_azi03),  #NO.CHI-6A0004
#            COLUMN g_c[40],l_print40
#
#ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash
#             #TQC-630166
#             #IF tm.wc[001,070] > ' ' THEN			# for 80
# 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             #IF tm.wc[071,140] > ' ' THEN
#  	     #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             #IF tm.wc[141,210] > ' ' THEN
#  	     #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             #IF tm.wc[211,280] > ' ' THEN
#  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
##             IF tm.wc[001,120] > ' ' THEN			# for 132
##    		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##	     	 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##		      PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#      END IF
#       PRINT g_x[18] CLIPPED
#       PRINT g_dash
#       LET l_last_sw = 'y'
#       #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED  #TQC-5B0037 mark
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0037 add
#
#PAGE TRAILER
#    IF l_last_sw = 'n' THEN
#        PRINT g_x[18] CLIPPED
#        PRINT g_dash
#             #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED  #TQC-5B0037 mark
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0037 add
#        ELSE SKIP 3 LINES
#     END IF
#END REPORT
##Patch....NO.TQC-610036 <001> #
##NO.FUN-850139---end---mark--
