# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr102.4gl
# Descriptions...: 料件成本項目結構表
# Date & Author..: 92/01/16 By Lin
# Modify.........: No.FUN-510039 05/02/17 By pengu 報表轉XML
# Modify.........: No.FUN-570244 05/07/22 By Trisy 料件編號開窗
# Modify.........: No.MOD-580215 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610069 06/01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	STRING,          	# Where condition No.TQC-630166
                a       LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
   		more	LIKE type_file.chr1       #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
DEFINE   g_head1         STRING
#CHI-710051
 
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
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
#No.CHI-6A0004--begin
#   SELECT azi03,azi05 INTO g_azi03,g_azi05 FROM azi_file
#          WHERE azi01 = g_aza.aza17             # 本國幣別之成本小數位數
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #LET tm.more  = ARG_VAL(9)      #TQC-610069
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r102_tm()	        	# Input print condition
      ELSE CALL r102()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r102_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW r102_w AT p_row,p_col
        WITH FORM "acs/42f/acsr102"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a='1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima06,ima01
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
      LET INT_FLAG = 0 CLOSE WINDOW r102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by  xiake
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.more 		# Condition
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
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
      ON ACTION CONTROLP CALL r102_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr102','9031',1)  
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
                         " '",tm.a CLIPPED,"'",
                         #" '",tm.more CLIPPED,"'",             #TQC-610069
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr102',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r102()
   ERROR ""
END WHILE
   CLOSE WINDOW r102_w
END FUNCTION
 
FUNCTION r102_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r102_w2 AT 2,2
        WITH FORM "aim/42f/aimi100"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
   CALL cl_ui_locale("aimi100")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
    CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        ima05, ima08, ima02, ima03,
        ima13, ima14, ima24, ima70, ima57, ima15,
        ima09, ima10, ima11, ima12, ima07,
        ima16, ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42, ima40,
        ima41, ima29, imauser, imagrup,
        imamodu, imadate, imaacti
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
   CLOSE WINDOW r102_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r102()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
     #    l_order	ARRAY[5] OF  LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10) #No.TQC-6A0079
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        iml02      LIKE  iml_file.iml02,  #成本項目
                        iml031     LIKE  iml_file.iml031, #標準成本
                        iml032     LIKE  iml_file.iml032, #現時成本
                        iml033     LIKE  iml_file.iml033, #預設成本
                        smg02      LIKE  smg_file.smg02,  #成本項目說明
                        smg03      LIKE  smg_file.smg03   #成本歸類
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT ",
                 " ima01,ima02,ima05,ima06,imz02,ima08, ",
                 " iml02,iml031,iml032,iml033,smg02,smg03 ",
                 "  FROM ima_file,iml_file,OUTER imz_file,OUTER smg_file ",
                 " WHERE ima_file.ima06=imz_file.imz01 ",
                 " AND ima01=iml01 AND iml_file.iml02=smg_file.smg01 ",
                 " AND imaacti='Y' ",
                 "   AND ",tm.wc CLIPPED
     PREPARE r102_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r102_cs1 CURSOR FOR r102_prepare1
 
     CALL cl_outnam('acsr102') RETURNING l_name
     START REPORT r102_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r102_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06='  '  END IF
 
       OUTPUT TO REPORT r102_rep(sr.*)
 
     END FOREACH
 
     FINISH REPORT r102_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r102_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        iml02      LIKE  iml_file.iml02,  #成本項目
                        iml031     LIKE  iml_file.iml031, #標準成本
                        iml032     LIKE  iml_file.iml032, #現時成本
                        iml033     LIKE  iml_file.iml033, #預設成本
                        smg02      LIKE  smg_file.smg02,  #成本項目說明
                        smg03      LIKE  smg_file.smg03   #成本歸類
                        END RECORD,
          l_imb128 LIKE imb_file.imb118,
          l_sum    LIKE  iml_file.iml033,   #合計
          l_stand  LIKE  iml_file.iml033,   #標準成本合計
          l_curr   LIKE  iml_file.iml033,   #現時成本合計
          l_prop   LIKE  iml_file.iml033,   #預設成本合計
          l_str    LIKE ima_file.ima01,    #No.FUN-680071 VARCHAR(40)
          l_str2   LIKE ima_file.ima01     #No.FUN-680071 VARCHAR(40)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.ima06,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      CASE tm.a
           WHEN '1'  LET l_str=g_x[31] CLIPPED,' ',g_x[25] CLIPPED
           WHEN '2'  LET l_str=g_x[31] CLIPPED,' ',g_x[26] CLIPPED
           WHEN '3'  LET l_str=g_x[31] CLIPPED,' ',g_x[27] CLIPPED
          OTHERWISE EXIT CASE
      END CASE
      LET g_head1= COLUMN (g_len-FGL_WIDTH(l_str))/2,l_str CLIPPED
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,sr.ima06, COLUMN 30,g_x[12] CLIPPED,sr.imz02
      PRINT g_x[41] CLIPPED,g_x[42] CLIPPED,g_x[43] CLIPPED,g_x[44] CLIPPED,
            g_x[45] CLIPPED,g_x[46] CLIPPED,g_x[47] CLIPPED,g_x[48] CLIPPED,
            g_x[49] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima06
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.ima01
      LET l_sum=0
      PRINT COLUMN g_c[41],sr.ima01,
            COLUMN g_c[42],sr.ima02,
            COLUMN g_c[43],sr.ima05,
            COLUMN g_c[44],sr.ima08;
 
   ON EVERY ROW
      CASE sr.smg03
         WHEN '1' PRINT COLUMN g_c[45],"1:",COLUMN g_c[46],g_x[19] CLIPPED;
         WHEN '2' PRINT COLUMN g_c[45],"2:",COLUMN g_c[46],g_x[20] CLIPPED;
         WHEN '3' PRINT COLUMN g_c[45],"3:",COLUMN g_c[46],g_x[21] CLIPPED;
         WHEN '4' PRINT COLUMN g_c[45],"4:",COLUMN g_c[46],g_x[22] CLIPPED;
         WHEN '5' PRINT COLUMN g_c[45],"5:",COLUMN g_c[46],g_x[23] CLIPPED;
         WHEN '9' PRINT COLUMN g_c[45],"9:",COLUMN g_c[46],g_x[32] CLIPPED;
      END CASE
      PRINT COLUMN g_c[47],sr.smg02,COLUMN g_c[48],sr.iml02;
      CASE tm.a
         WHEN '1' PRINT COLUMN g_c[49],cl_numfor(sr.iml031,49,g_azi04)  #No.MOD-580215
                  LET l_sum=l_sum+sr.iml031
         WHEN '2' PRINT COLUMN g_c[49],cl_numfor(sr.iml032,49,g_azi04)   #No.MOD-580215
                  LET l_sum=l_sum+sr.iml032
         WHEN '3' PRINT COLUMN g_c[49],cl_numfor(sr.iml033,49,g_azi04)   #No.MOD-580215
                  LET l_sum=l_sum+sr.iml033
      END CASE
 
   AFTER GROUP OF sr.ima01
      PRINT COLUMN g_c[48],g_dash2[1,(g_w[48]+g_w[49])]
      PRINT COLUMN g_c[48],g_x[28] CLIPPED,
            COLUMN g_c[49],cl_numfor(l_sum,49,g_azi05) CLIPPED
      PRINT
      LET l_sum=0
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
           #  IF tm.wc[001,070] > ' ' THEN			# for 80
      	   #     PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
           #  IF tm.wc[071,140] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
           #  IF tm.wc[141,210] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
           #  IF tm.wc[211,280] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
           #No.TQC-630166 --start--
           #  IF tm.wc[001,120] > ' ' THEN			# for 132
 	   #     PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
           #  IF tm.wc[121,240] > ' ' THEN
 	   #     PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
           #  IF tm.wc[241,300] > ' ' THEN
 	# PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
