# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr300.4gl
# Descriptions...: 附加成本結構表
# Input parameter:
# Return code....:
# Date & Author..: 92/01/15 By Nora
# Modify.........: No.FUN-510039 05/02/18 By pengu 報表轉XML
# Modify.........: No.FUN-570244 05/07/22 By Trisy 料件編號開窗
# Modify.........: No.MOD-580215 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610069 06/01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
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
		wc  	STRING,   		# Where condition No.TQC-630166
   		more	LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #No.FUN-690110 by xiake
 
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
   LET tm.wc = ARG_VAL(7)
   #LET tm.more  = ARG_VAL(8)  #TQC-610069
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r300_tm()	        	# Input print condition
      ELSE CALL r300()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r300_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW r300_w AT p_row,p_col
        WITH FORM "acs/42f/acsr300"
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
   CONSTRUCT BY NAME tm.wc ON ima06,csd01
#No.FUN-570244 --start--
      ON ACTION CONTROLP
            IF INFIELD(csd01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO csd01
               NEXT FIELD csd01
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
      LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
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
      ON ACTION CONTROLP CALL r300_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr300','9031',1)   
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
                         #" '",tm.more CLIPPED,"'",             #TQC-610069
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr300',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r300()
   ERROR ""
END WHILE
   CLOSE WINDOW r300_w
END FUNCTION
 
FUNCTION r300_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r300_w2 AT 2,2
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
        csd02,csd03,csd05,csd04
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
   CLOSE WINDOW r300_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r300()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
      #   l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10)  #No.TQC-6A0079
          sr            RECORD
                        csd01      LIKE  csd_file.csd01,  #料件編號
                        csd02      LIKE  csd_file.csd02,  #成本項目
                        csd03      LIKE  csd_file.csd03,  #成本歸類
                        csd04      LIKE  csd_file.csd04,  #比率
                        csd05      LIKE  csd_file.csd05,  #成本(金額)
                        cse03      LIKE  cse_file.cse03,  #比率成本項目
                        smg02      LIKE  smg_file.smg02,  #說明
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima08      LIKE  ima_file.ima08   #來源碼
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
{
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND gkauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gkagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gkagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gkauser', 'gkagrup')
     #End:FUN-980030
 
}
     LET l_sql = "SELECT ",
                 " csd01,csd02,csd03,csd04,csd05,cse03,",
                 " smg02,ima02,ima05,ima08",
                 "  FROM csd_file, smg_file,",
                 " OUTER cse_file, ima_file",
                 " WHERE csd_file.csd01 = cse_file.cse01 ",
                 "   AND csd_file.csd02 = cse_file.cse02 ",
                 "   AND csd02 = smg01 ",
                 "   AND csd_file.csd01 = ima_file.ima01 ",
                 "   AND ",tm.wc
     PREPARE r300_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake 
        EXIT PROGRAM 
     END IF
     DECLARE r300_cs1 CURSOR FOR r300_prepare1
 
     CALL cl_outnam('acsr300') RETURNING l_name
     START REPORT r300_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r300_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
 
       OUTPUT TO REPORT r300_rep(sr.*)
 
     END FOREACH
 
     FINISH REPORT r300_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r300_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD
                        csd01      LIKE  csd_file.csd01,  #料件編號
                        csd02      LIKE  csd_file.csd02,  #成本項目
                        csd03      LIKE  csd_file.csd03,  #成本歸類
                        csd04      LIKE  csd_file.csd04,  #比率
                        csd05      LIKE  csd_file.csd05,  #成本(金額)
                        cse03      LIKE  cse_file.cse03,  #比率成本項目
                        smg02      LIKE  smg_file.smg02,  #說明
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima08      LIKE  ima_file.ima08   #來源碼
                        END RECORD,
         l_smg02                   LIKE  smg_file.smg02,  #說明
         l_cse03                   LIKE  cse_file.cse03   #比率成本項目
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.csd01,sr.csd03,sr.csd02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len]
      PRINT COLUMN 5,g_x[11] CLIPPED,COLUMN 15,sr.csd01;
      PRINT COLUMN 45,g_x[12] CLIPPED,COLUMN 55,sr.ima05;
      PRINT COLUMN 67,g_x[13] CLIPPED,sr.ima08
      PRINT COLUMN 5,g_x[14] CLIPPED,COLUMN 15,sr.ima02
      PRINT g_dash2
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.csd01
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.csd02
      PRINT COLUMN g_c[31],sr.csd03,
            COLUMN g_c[32],sr.csd02,
            COLUMN g_c[33],sr.smg02,
            COLUMN g_c[34],'= ';
      IF sr.cse03 IS NOT NULL AND sr.csd04 > 0 AND
         sr.csd04 IS NOT NULL THEN
         DECLARE r300_c2 CURSOR FOR
            SELECT cse03,smg02 FROM cse_file,smg_file
               WHERE cse01 = sr.csd01 AND cse02 = sr.csd02
                 AND smg01 = cse03
         FOREACH r300_c2 INTO l_cse03,l_smg02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,0)  
               EXIT FOREACH
            END IF
            PRINT COLUMN g_c[35],l_cse03,
                  COLUMN g_c[36],'* ',
                  COLUMN g_c[37],sr.csd04 USING'#############.####',  #No.MOD-580215
                  COLUMN g_c[38],l_smg02
         END FOREACH
      END IF
      IF sr.cse03 IS NULL OR sr.csd04 = 0 OR
         sr.csd04 IS NULL THEN
         PRINT COLUMN g_c[37],cl_numfor(sr.csd05,37,g_azi03) CLIPPED
      END IF
 
   AFTER GROUP OF sr.csd02
      SKIP 1 LINE
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #No.TQC-630166 --start--
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#                PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#        	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#        	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#        	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
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
