# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr303.4gl
# Descriptions...: 料件模擬成本差異分析表
# Input parameter:
# Return code....:
# Date & Author..: 92/01/24 By MAY
#        Modify  : 92/05/28 By David
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
    		wc     STRING,   		# Where condition No.TQC-630166
                csa02  LIKE csa_file.csa02,
    		more   LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD,
          g_argv1       LIKE csa_file.csa02
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690110 by xiake
 
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
   IF g_argv1 IS  NOT NULL THEN
      LET tm.csa02 = g_argv1
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r303_tm()	        	# Input print condition
      ELSE CALL r303()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r303_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r303_w AT p_row,p_col
        WITH FORM "acs/42f/acsr303"
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
    #-------------------MOD-530128-------------------------------------
     #CONSTRUCT BY NAME tm.wc ON ima06,ima09,ima10,ima11,ima12,csa01
      CONSTRUCT BY NAME tm.wc ON ima06,ima10,ima12,ima09,ima11,csa01
   #---------------------END-----------------------------------------
#No.FUN-570244 --start--
      ON ACTION CONTROLP
            IF INFIELD(csa01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO csa01
               NEXT FIELD csa01
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
      LET INT_FLAG = 0 CLOSE WINDOW r303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.csa02,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD csa02
         IF g_argv1 IS NOT NULL  AND g_argv1 != ' ' THEN
           LET tm.csa02 = g_argv1
           NEXT FIELD more
         ELSE
             IF tm.csa02 IS NULL OR
                tm.csa02 NOT MATCHES '[0123456789]' THEN
                NEXT FIELD csa02
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
#     ON ACTION CONTROLP CALL r303_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr303'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr303','9031',1)   
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
                         " '",tm.csa02 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr303',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r303_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r303()
   ERROR ""
END WHILE
   CLOSE WINDOW r303_w
END FUNCTION
 
{
FUNCTION r303_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r303_w2 AT 2,2
        WITH FORM "acs/42f/acsi300"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acsi300")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        csa02,csa03,csa05,csa04
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
   CLOSE WINDOW r303_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
}
 
FUNCTION r303()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
     #    l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10)  #No.TQC-6A0079
          sr            RECORD
                           g_csa    RECORD LIKE csa_file.*,
                           ima02    LIKE ima_file.ima02,
                           ima05    LIKE ima_file.ima05,
                           ima06    LIKE ima_file.ima06,
                           ima08    LIKE ima_file.ima08,
                           ima86    LIKE ima_file.ima86,
                           imz02    LIKE imz_file.imz02
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND csauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND csagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND csagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('csauser', 'csagrup')
     #End:FUN-980030
 
    LET l_sql = " SELECT csa_file.*,ima02,ima05," ,
                " ima06,ima08,ima86,imz02 ",
                " FROM csa_file,ima_file,imz_file ",
                " WHERE csa01 = ima01 AND ima06 = imz01 ",
                " AND csa02 = '",tm.csa02,"'",
                " AND ", tm.wc CLIPPED,
                " ORDER BY csa01 "
 
     PREPARE r303_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r303_cs1 CURSOR FOR r303_prepare1
 
     CALL cl_outnam('acsr303') RETURNING l_name
     START REPORT r303_rep TO l_name
     #LET g_pageno = 0
     FOREACH r303_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       OUTPUT TO REPORT r303_rep(sr.*)
 
     END FOREACH
 
     FINISH REPORT r303_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r303_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          l_imb     RECORD LIKE imb_file.*,
          l_diff    LIKE imb_file.imb118,     #No.FUN-680071 decimal(20,6)
          l_diff1   LIKE csa_file.csa0301,    #No.FUN-680071 decimal(20,6)
          l_ele     LIKE ima_file.ima01,      #No.FUN-680071 VARCHAR(40)
          l_ima02   LIKE ima_file.ima02,
          sr            RECORD
                           g_csa    RECORD LIKE csa_file.*,
                           ima02    LIKE ima_file.ima02,
                           ima05    LIKE ima_file.ima05,
                           ima06    LIKE ima_file.ima06,
                           ima08    LIKE ima_file.ima08,
                           ima86    LIKE ima_file.ima86,
                           imz02    LIKE imz_file.imz02
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.ima06,sr.g_csa.csa01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
     PRINT COLUMN 5,g_x[37] CLIPPED,
           COLUMN 20,tm.csa02
     PRINT COLUMN 5,g_x[11] CLIPPED,
           COLUMN 20,sr.ima06,
           COLUMN 30,g_x[12] CLIPPED,
           COLUMN 35,sr.imz02
      PRINT g_dash2
      PRINT g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,
            g_x[47] CLIPPED,g_x[48] CLIPPED,g_x[49] CLIPPED,g_x[50] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima06
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
{
      PRINT g_x[11] CLIPPED,sr.ima06,COLUMN 26,g_x[12] CLIPPED,sr.imz02
      SKIP 1 LINES
      PRINT g_x[13] CLIPPED
      PRINT g_x[14] CLIPPED,
            COLUMN 43,g_x[15] CLIPPED,
            COLUMN 66,g_x[16] CLIPPED,
            COLUMN 98,g_x[17] CLIPPED
      PRINT "-------------------- -- -- ---- ",
            "------------------------------- --------------",
            " -------------- -------------- -----"
}
ON EVERY ROW
      LET l_diff = 0
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.g_csa.csa01
      PRINT COLUMN g_c[41],sr.g_csa.csa01,
            COLUMN g_c[42],l_ima02,
            COLUMN g_c[43],sr.ima05,
            COLUMN g_c[44],sr.ima08,
            COLUMN g_c[45],sr.ima86;
      SELECT * INTO l_imb.* FROM imb_file WHERE imb01 = sr.g_csa.csa01
      IF sr.ima08 MATCHES '[PV]'  THEN
        IF sr.g_csa.csa03 = '1' THEN
         LET l_ele=g_x[32] CLIPPED,g_x[31] CLIPPED
         PRINT COLUMN g_c[46],l_ele CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb.imb118,47,g_azi04),
               COLUMN g_c[48],cl_numfor(sr.g_csa.csa0311,48,g_azi04),
               COLUMN g_c[49],cl_numfor((sr.g_csa.csa0311 -l_imb.imb118),49,g_azi04);
           IF l_imb.imb118 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb118 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0311 - l_imb.imb118)/l_imb.imb118 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb118
        END IF
        IF sr.g_csa.csa03 = '2' THEN
         LET l_ele=g_x[33] CLIPPED,g_x[31] CLIPPED
         PRINT COLUMN g_c[46],l_ele,
               COLUMN g_c[47],cl_numfor(l_imb.imb218,47,g_azi04),
               COLUMN g_c[48],cl_numfor(sr.g_csa.csa0311,48,g_azi04),
               COLUMN g_c[49],cl_numfor((sr.g_csa.csa0311 -l_imb.imb218),49,g_azi04);
           IF l_imb.imb218 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb218 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0311 - l_imb.imb218)/l_imb.imb218 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb218
        END IF
        IF sr.g_csa.csa03 = '3' THEN
         LET l_ele=g_x[34] CLIPPED,g_x[31] CLIPPED
         PRINT COLUMN g_c[46],l_ele,
               COLUMN g_c[47],cl_numfor(l_imb.imb318,47,g_azi04),
               COLUMN g_c[48],cl_numfor(sr.g_csa.csa0311,48,g_azi04),
               COLUMN g_c[49],cl_numfor((sr.g_csa.csa0311 -l_imb.imb318),49,g_azi04);
           IF l_imb.imb318 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb318 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0311 - l_imb.imb318)/l_imb.imb318 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb318
        END IF
#合計
        PRINT COLUMN g_c[45],g_x[35] CLIPPED,
              COLUMN g_c[47],cl_numfor(l_diff,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0311,48,g_azi04),
              COLUMN g_c[49],cl_numfor((sr.g_csa.csa0311 - l_diff),49,g_azi04);
           IF l_diff = 0 THEN
                 PRINT COLUMN g_c[50],l_diff USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0311 - l_diff)/l_diff * 100) USING '--&.&&'
           END IF
       END IF
 
#+++++++++++++++++++++++++++非採購料件
    IF sr.ima08 MATCHES '[MXUR]'  THEN
         IF sr.g_csa.csa03 = '1' THEN
           LET l_ele=g_x[18] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb111,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0301,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((sr.g_csa.csa0301 -l_imb.imb111),49,g_azi04);
           IF l_imb.imb111 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb111 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0301 - l_imb.imb111)/l_imb.imb111 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb111
           LET l_diff1 = sr.g_csa.csa0301
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb112,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0302,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((sr.g_csa.csa0302 -l_imb.imb112),49,g_azi04);
 
           IF l_imb.imb112 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb112 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0302 - l_imb.imb112)/l_imb.imb112 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb112
           LET l_diff1 = l_diff1 + sr.g_csa.csa0302
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb1131,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0303,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb1131-sr.g_csa.csa0303 ),49,g_azi04);
           IF l_imb.imb1131 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1131 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0303 - l_imb.imb1131)/l_imb.imb1131 * 100)
                                                         USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1131
           LET l_diff1 = l_diff1 + sr.g_csa.csa0303
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb1132,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0304,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb1132 - sr.g_csa.csa0304),49,g_azi04);
           IF l_imb.imb1132= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1132 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0304 - l_imb.imb1132)/l_imb.imb1132 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1132
           LET l_diff1 = l_diff1 + sr.g_csa.csa0304
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb114,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0305,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb114 - sr.g_csa.csa0305),49,g_azi04);
 
           IF l_imb.imb114 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb114 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0305 - l_imb.imb114)/l_imb.imb114 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb114
           LET l_diff1 = l_diff1 + sr.g_csa.csa0305
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb115,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0306,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb115 - sr.g_csa.csa0306),49,g_azi04);
           IF l_imb.imb115 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb115 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0306 - l_imb.imb115)/l_imb.imb115 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb115
           LET l_diff1 = l_diff1 + sr.g_csa.csa0306
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb116,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0307,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb116 - sr.g_csa.csa0307),49,g_azi04);
           IF l_imb.imb116 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb116 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0307 - l_imb.imb116)/l_imb.imb116 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb116
           LET l_diff1 = l_diff1 + sr.g_csa.csa0307
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb1171,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0308,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb1171- sr.g_csa.csa0308),49,g_azi04);
 
           IF l_imb.imb1171= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1171 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0308 - l_imb.imb1171)/l_imb.imb1171* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1171
           LET l_diff1 = l_diff1 + sr.g_csa.csa0308
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb1172,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0309,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb1172- sr.g_csa.csa0309),49,g_azi04);
           IF l_imb.imb1172= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1172 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0309 - l_imb.imb1172)/l_imb.imb1172* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1172
           LET l_diff1 = l_diff1 + sr.g_csa.csa0309
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb119,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0310,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb119 - sr.g_csa.csa0310),49,g_azi04);
           IF l_imb.imb119 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb119 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0310 - l_imb.imb119)/l_imb.imb119 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb119
           LET l_diff1 = l_diff1 + sr.g_csa.csa0310
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
                 COLUMN g_c[47],cl_numfor(l_imb.imb120,47,g_azi04),
                 COLUMN g_c[48],cl_numfor(sr.g_csa.csa0312,48,g_azi04),
                 COLUMN g_c[49],cl_numfor((l_imb.imb120 - sr.g_csa.csa0312),49,g_azi04);
 
           IF l_imb.imb120 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb120 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0312 - l_imb.imb120)/l_imb.imb120 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb120
	   LET l_diff1 = l_diff1 + sr.g_csa.csa0312
 
           LET l_ele=g_x[19] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb121,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0321,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb121 - sr.g_csa.csa0321),49,g_azi04);
           IF l_imb.imb121 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb121 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0321 - l_imb.imb121)/l_imb.imb121 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb121
           LET l_diff1 = l_diff1 + sr.g_csa.csa0321
 
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb122,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0322,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb122 - sr.g_csa.csa0322),49,g_azi04);
 
           IF l_imb.imb122 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb122 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
	   ((sr.g_csa.csa0322 - l_imb.imb122)/l_imb.imb122 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb122
           LET l_diff1 = l_diff1 + sr.g_csa.csa0322
 
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb1231,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0322,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb1231 - sr.g_csa.csa0323),49,g_azi04);
 
           IF l_imb.imb1231= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1231 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0323 - l_imb.imb1231)/l_imb.imb1231* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1231
           LET l_diff1 = l_diff1 + sr.g_csa.csa0323
 
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb1232,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0324,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb1232 - sr.g_csa.csa0324),49,g_azi04);
 
           IF l_imb.imb1232= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1232 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0324 - l_imb.imb1232)/l_imb.imb1232* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1232
           LET l_diff1 = l_diff1 + sr.g_csa.csa0324
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb124,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0325,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb124 - sr.g_csa.csa0325),49,g_azi04);
 
           IF l_imb.imb124 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb124 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0325 - l_imb.imb124)/l_imb.imb124 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb124
           LET l_diff1 = l_diff1 + sr.g_csa.csa0325
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb125,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0326,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb125 - sr.g_csa.csa0326),49,g_azi04);
 
           IF l_imb.imb125 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb125 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0326 - l_imb.imb125)/l_imb.imb125 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb125
           LET l_diff1 = l_diff1 + sr.g_csa.csa0326
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb126,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0327,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb126 - sr.g_csa.csa0327),49,g_azi04);
 
           IF l_imb.imb126 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb126 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0327 - l_imb.imb126)/l_imb.imb126 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb126
           LET l_diff1 = l_diff1 + sr.g_csa.csa0327
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb1271,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0328,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb1271 - sr.g_csa.csa0328),49,g_azi04);
 
           IF l_imb.imb1271= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1271 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0328 - l_imb.imb1271)/l_imb.imb1271* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1271
           LET l_diff1 = l_diff1 + sr.g_csa.csa0328
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb1272,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0329,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb1272 - sr.g_csa.csa0329),49,g_azi04);
           IF l_imb.imb1272= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb1272 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0329 - l_imb.imb1272)/l_imb.imb1272* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb1272
           LET l_diff1 = l_diff1 + sr.g_csa.csa0329
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb129,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0330,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb129 - sr.g_csa.csa0330),49,g_azi04);
 
           IF l_imb.imb129 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb129 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0330 - l_imb.imb129)/l_imb.imb129 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb129
           LET l_diff1 = l_diff1 + sr.g_csa.csa0330
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb130,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0331,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb130 - sr.g_csa.csa0331),49,g_azi04);
 
           IF l_imb.imb130 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb130 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0331 - l_imb.imb130)/l_imb.imb130 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb130
           LET l_diff1 = l_diff1 + sr.g_csa.csa0331
 
#合計
        PRINT COLUMN g_c[45],g_x[35] CLIPPED,
              COLUMN g_c[47],cl_numfor(l_diff,47,g_azi05),
              COLUMN g_c[48],cl_numfor(l_diff1,48,g_azi05),
              COLUMN g_c[49],cl_numfor((l_diff1 - l_diff),49,g_azi05);
           IF l_diff = 0 THEN
                 PRINT COLUMN g_c[50],l_diff USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((l_diff1 - l_diff)/l_diff * 100) USING '--&.&&'
           END IF
        END IF
#+++++++++++++++++
         IF sr.g_csa.csa03 = '2' THEN
           LET l_ele=g_x[18] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb211,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0301,48,g_azi04),
              COLUMN g_c[49],cl_numfor((sr.g_csa.csa0301 - l_imb.imb211),49,g_azi04);
 
           IF l_imb.imb211 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb211 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0301 - l_imb.imb211)/l_imb.imb211 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb211
           LET l_diff1 = sr.g_csa.csa0301
 
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb212,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0302,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb212 - sr.g_csa.csa0302),49,g_azi04);
 
           IF l_imb.imb212 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb212 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0302 - l_imb.imb212)/l_imb.imb212 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb212
           LET l_diff1 = l_diff1 + sr.g_csa.csa0302
 
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2131,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0303,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2131 - sr.g_csa.csa0303),49,g_azi04);
 
           IF l_imb.imb2131 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2131 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0303 - l_imb.imb2131)/l_imb.imb2131 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2131
           LET l_diff1 = l_diff1 + sr.g_csa.csa0303
 
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2132,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0304,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2132 - sr.g_csa.csa0304),49,g_azi04);
 
           IF l_imb.imb2132= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2132 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0304 - l_imb.imb2132)/l_imb.imb2132 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2132
           LET l_diff1 = l_diff1 + sr.g_csa.csa0304
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb214,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0305,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb214 - sr.g_csa.csa0305),49,g_azi04);
 
           IF l_imb.imb214 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb214 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0305 - l_imb.imb214)/l_imb.imb214 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb214
           LET l_diff1 = l_diff1 + sr.g_csa.csa0305
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb215,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0306,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb215 - sr.g_csa.csa0306),49,g_azi04);
 
           IF l_imb.imb215 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb215 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0306 - l_imb.imb215)/l_imb.imb215 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb215
           LET l_diff1 = l_diff1 + sr.g_csa.csa0306
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb216,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0307,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb216 - sr.g_csa.csa0307),49,g_azi04);
 
           IF l_imb.imb216 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb216 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0307 - l_imb.imb216)/l_imb.imb216 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb216
           LET l_diff1 = l_diff1 + sr.g_csa.csa0307
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2171,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0308,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2171 - sr.g_csa.csa0308),49,g_azi04);
 
           IF l_imb.imb2171= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2171 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0308 - l_imb.imb2171)/l_imb.imb2171* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2171
           LET l_diff1 = l_diff1 + sr.g_csa.csa0308
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2172,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0309,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2172 - sr.g_csa.csa0309),49,g_azi04);
 
           IF l_imb.imb2172= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2172 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0309 - l_imb.imb2172)/l_imb.imb2172* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2172
           LET l_diff1 = l_diff1 + sr.g_csa.csa0309
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb219,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0310,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb219 - sr.g_csa.csa0310),49,g_azi04);
 
           IF l_imb.imb219 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb219 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0310 - l_imb.imb219)/l_imb.imb219 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb219
           LET l_diff1 = l_diff1 + sr.g_csa.csa0310
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb220,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0312,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb220 - sr.g_csa.csa0312),49,g_azi04);
 
           IF l_imb.imb220 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb220 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0312 - l_imb.imb220)/l_imb.imb220 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb220
           LET l_diff1 = l_diff1 + sr.g_csa.csa0312
 
           LET l_ele=g_x[19] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb221,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0321,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb221 - sr.g_csa.csa0321),49,g_azi04);
 
           IF l_imb.imb221 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb221 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0321 - l_imb.imb221)/l_imb.imb221 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb221
           LET l_diff1 = l_diff1 + sr.g_csa.csa0321
 
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb222,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0322,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb222 - sr.g_csa.csa0322),49,g_azi04);
 
           IF l_imb.imb222 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb222 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0322 - l_imb.imb222)/l_imb.imb222 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb222
           LET l_diff1 = l_diff1 + sr.g_csa.csa0322
 
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2231,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0323,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2231 - sr.g_csa.csa0323),49,g_azi04);
 
           IF l_imb.imb2231= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2231 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0323 - l_imb.imb2231)/l_imb.imb2231* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2231
           LET l_diff1 = l_diff1 + sr.g_csa.csa0323
 
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2232,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0324,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2232 - sr.g_csa.csa0324),49,g_azi04);
 
           IF l_imb.imb2232= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2232 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0324 - l_imb.imb2232)/l_imb.imb2232* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2232
           LET l_diff1 = l_diff1 + sr.g_csa.csa0324
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb224,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0325,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb224 - sr.g_csa.csa0325),49,g_azi04);
 
           IF l_imb.imb224 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb224 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0325 - l_imb.imb224)/l_imb.imb224 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb224
           LET l_diff1 = l_diff1 + sr.g_csa.csa0325
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb225,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0326,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb225 - sr.g_csa.csa0326),49,g_azi04);
 
           IF l_imb.imb225 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb225 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0326 - l_imb.imb225)/l_imb.imb225 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb225
           LET l_diff1 = l_diff1 + sr.g_csa.csa0326
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb226,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0327,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb226 - sr.g_csa.csa0327),49,g_azi04);
 
           IF l_imb.imb226 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb226 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0327 - l_imb.imb226)/l_imb.imb226 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb226
           LET l_diff1 = l_diff1 + sr.g_csa.csa0327
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2271,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0328,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2271 - sr.g_csa.csa0328),49,g_azi04);
 
           IF l_imb.imb2271= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2271 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0328 - l_imb.imb2271)/l_imb.imb2271* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2271
           LET l_diff1 = l_diff1 + sr.g_csa.csa0328
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb2272,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0329,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb2272 - sr.g_csa.csa0329),49,g_azi04);
 
           IF l_imb.imb2272= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb2272 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0329 - l_imb.imb2272)/l_imb.imb2272* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb2272
           LET l_diff1 = l_diff1 + sr.g_csa.csa0329
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb229,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0330,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb229 - sr.g_csa.csa0330),49,g_azi04);
 
           IF l_imb.imb229 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb229 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0330 - l_imb.imb229)/l_imb.imb229 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb229
           LET l_diff1 = l_diff1 + sr.g_csa.csa0330
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb230,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0331,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb230 - sr.g_csa.csa0331),49,g_azi04);
 
           IF l_imb.imb230 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb230 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0331 - l_imb.imb230)/l_imb.imb230 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb230
           LET l_diff1 = l_diff1 + sr.g_csa.csa0331
 
#合計
        PRINT COLUMN g_c[45],g_x[35] CLIPPED,
              COLUMN g_c[47],cl_numfor(l_diff,47,g_azi05),
              COLUMN g_c[48],cl_numfor(l_diff1,48,g_azi05),
              COLUMN g_c[49],cl_numfor((l_diff1 - l_diff),49,g_azi05);
           IF l_diff = 0 THEN
                 PRINT COLUMN g_c[50],l_diff USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((l_diff1 - l_diff)/l_diff * 100) USING '--&.&&'
           END IF
        END IF
#+++++++++++++++++
         IF sr.g_csa.csa03 = '3' THEN
           LET l_ele=g_x[18] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb311,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0301,48,g_azi04),
              COLUMN g_c[49],cl_numfor((sr.g_csa.csa0301 - l_imb.imb311),49,g_azi04);
 
           IF l_imb.imb311 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb311 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0301 - l_imb.imb311)/l_imb.imb311 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_imb.imb311
           LET l_diff1 = sr.g_csa.csa0301
 
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb312,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0302,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb312 - sr.g_csa.csa0302),49,g_azi04);
 
           IF l_imb.imb312 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb312 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0302 - l_imb.imb312)/l_imb.imb312 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb312
           LET l_diff1 = l_diff1 + sr.g_csa.csa0302
 
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3131,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0303,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3131 - sr.g_csa.csa0303),49,g_azi04);
 
           IF l_imb.imb3131 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3131 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0303 - l_imb.imb3131)/l_imb.imb3131 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3131
           LET l_diff1 = l_diff1 + sr.g_csa.csa0303
 
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3132,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0304,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3132 - sr.g_csa.csa0304),49,g_azi04);
 
           IF l_imb.imb3132= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3132 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0304 - l_imb.imb3132)/l_imb.imb3132 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3132
           LET l_diff1 = l_diff1 + sr.g_csa.csa0304
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb314,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0305,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb314 - sr.g_csa.csa0305),49,g_azi04);
 
           IF l_imb.imb314 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb314 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0305 - l_imb.imb314)/l_imb.imb314 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb314
           LET l_diff1 = l_diff1 + sr.g_csa.csa0305
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb315,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0306,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb315 - sr.g_csa.csa0306),49,g_azi04);
 
           IF l_imb.imb315 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb315 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0306 - l_imb.imb315)/l_imb.imb315 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb315
           LET l_diff1 = l_diff1 + sr.g_csa.csa0306
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb316,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0307,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb316 - sr.g_csa.csa0307),49,g_azi04);
 
           IF l_imb.imb316 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb316 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0307 - l_imb.imb316)/l_imb.imb316 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb316
           LET l_diff1 = l_diff1 + sr.g_csa.csa0307
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3171,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0308,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3171 - sr.g_csa.csa0308),49,g_azi04);
 
           IF l_imb.imb3171= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3171 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0308 - l_imb.imb3171)/l_imb.imb3171* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3171
           LET l_diff1 = l_diff1 + sr.g_csa.csa0308
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3172,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0309,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3172 - sr.g_csa.csa0309),49,g_azi04);
           IF l_imb.imb3172= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3172 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0309 - l_imb.imb3172)/l_imb.imb3172* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3172
           LET l_diff1 = l_diff1 + sr.g_csa.csa0309
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb319,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0310,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb319 - sr.g_csa.csa0310),49,g_azi04);
 
           IF l_imb.imb319 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb319 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0310 - l_imb.imb319)/l_imb.imb319 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb319
           LET l_diff1 = l_diff1 + sr.g_csa.csa0310
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb320,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0312,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb320 - sr.g_csa.csa0312),49,g_azi04);
 
           IF l_imb.imb320 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb320 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0312 - l_imb.imb320)/l_imb.imb320 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb320
           LET l_diff1 = l_diff1 + sr.g_csa.csa0312
 
           LET l_ele=g_x[19] CLIPPED,g_x[32] CLIPPED,g_x[20] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb321,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0321,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb321 - sr.g_csa.csa0321),49,g_azi04);
 
           IF l_imb.imb321 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb321 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0321 - l_imb.imb321)/l_imb.imb321 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb321
           LET l_diff1 = l_diff1 + sr.g_csa.csa0321
 
           LET l_ele=g_x[32] CLIPPED,g_x[21] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb322,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0322,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb322 - sr.g_csa.csa0322),49,g_azi04);
 
           IF l_imb.imb322 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb322 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0322 - l_imb.imb322)/l_imb.imb322 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb322
           LET l_diff1 = l_diff1 + sr.g_csa.csa0322
 
           LET l_ele=g_x[32] CLIPPED,g_x[22] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3231,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0323,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3231 - sr.g_csa.csa0323),49,g_azi04);
 
           IF l_imb.imb3231= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3231 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0323 - l_imb.imb3231)/l_imb.imb3231* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3231
           LET l_diff1 = l_diff1 + sr.g_csa.csa0323
 
           LET l_ele=g_x[32] CLIPPED,g_x[23] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3232,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0324,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3232 - sr.g_csa.csa0324),49,g_azi04);
 
           IF l_imb.imb3232= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3232 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0324 - l_imb.imb3232)/l_imb.imb3232* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3232
           LET l_diff1 = l_diff1 + sr.g_csa.csa0324
 
           LET l_ele=g_x[32] CLIPPED,g_x[24] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb324,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0325,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb324 - sr.g_csa.csa0325),49,g_azi04);
 
           IF l_imb.imb324 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb324 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0325 - l_imb.imb324)/l_imb.imb324 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb324
           LET l_diff1 = l_diff1 + sr.g_csa.csa0325
 
           LET l_ele=g_x[32] CLIPPED,g_x[25] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb325,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0326,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb325 - sr.g_csa.csa0326),49,g_azi04);
 
           IF l_imb.imb325 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb325 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0326 - l_imb.imb325)/l_imb.imb325 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb325
           LET l_diff1 = l_diff1 + sr.g_csa.csa0326
 
           LET l_ele=g_x[32] CLIPPED,g_x[26] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb326,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0327,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb326 - sr.g_csa.csa0327),49,g_azi04);
 
           IF l_imb.imb326 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb326 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0327 - l_imb.imb326)/l_imb.imb326 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb326
           LET l_diff1 = l_diff1 + sr.g_csa.csa0327
 
           LET l_ele=g_x[32] CLIPPED,g_x[27] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3271,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0328,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3271 - sr.g_csa.csa0328),49,g_azi04);
 
           IF l_imb.imb3271= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3271 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0328 - l_imb.imb3271)/l_imb.imb3271* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3271
           LET l_diff1 = l_diff1 + sr.g_csa.csa0328
 
           LET l_ele=g_x[32] CLIPPED,g_x[28] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb3272,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0329,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb3272 - sr.g_csa.csa0329),49,g_azi04);
 
           IF l_imb.imb3272= 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb3272 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0329 - l_imb.imb3272)/l_imb.imb3272* 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb3272
           LET l_diff1 = l_diff1 + sr.g_csa.csa0329
 
           LET l_ele=g_x[32] CLIPPED,g_x[30] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb329,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0330,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb329 - sr.g_csa.csa0330),49,g_azi04);
 
           IF l_imb.imb329 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb329 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0330 - l_imb.imb329)/l_imb.imb329 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb329
           LET l_diff1 = l_diff1 + sr.g_csa.csa0330
 
           LET l_ele=g_x[32] CLIPPED,g_x[29] CLIPPED
           PRINT COLUMN g_c[46],l_ele,
              COLUMN g_c[47],cl_numfor(l_imb.imb330,47,g_azi04),
              COLUMN g_c[48],cl_numfor(sr.g_csa.csa0331,48,g_azi04),
              COLUMN g_c[49],cl_numfor((l_imb.imb330 - sr.g_csa.csa0331),49,g_azi04);
 
           IF l_imb.imb330 = 0 THEN
                 PRINT COLUMN g_c[50],l_imb.imb330 USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((sr.g_csa.csa0331 - l_imb.imb330)/l_imb.imb330 * 100) USING '--&.&&'
           END IF
           LET l_diff = l_diff + l_imb.imb330
           LET l_diff1 = l_diff1 + sr.g_csa.csa0331
 
#合計
        PRINT COLUMN g_c[45],g_x[35] CLIPPED,
              COLUMN g_c[47],cl_numfor(l_diff,47,g_azi05),
              COLUMN g_c[48],cl_numfor(l_diff1,48,g_azi05),
              COLUMN g_c[49],cl_numfor((l_diff1 - l_diff),49,g_azi05);
           IF l_diff = 0 THEN
                 PRINT COLUMN g_c[50],l_diff USING '--&.&&'
           ELSE
           PRINT COLUMN g_c[50],
           ((l_diff1 - l_diff)/l_diff * 100) USING '--&.&&'
           END IF
        END IF
#+++++++++++++++++
     END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,150,210,280   /   (132)-120,250,300
         THEN PRINT g_dash[1,g_len]
              #No.TQC-630166 --start--
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#       	 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#        	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#        	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
              #No.TQC-630166 ---end---
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
