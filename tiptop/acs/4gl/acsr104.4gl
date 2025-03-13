# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr104.4gl
# Descriptions...: 料件成本項目結構差異分析表
# Date & Author..: 92/01/27 By Lin
# Modify.........: No.FUN-510039 05/03/02 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570244 05/07/22 By Trisy 料件編號開窗
# Modify.........: No.FUN-580013 05/08/17 By will 報表轉XML格式
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610069 06/01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6B0025 06/12/12 By Sarah 報表Title數量與資料數量不合
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				  # Print condition RECORD
        		wc  	STRING,           # Where condition No.TQC-630166
                a       LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
                b       LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
   		        more	LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
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
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
#No.CHI-6A0004--begin
#   SELECT azi03,azi05 INTO g_azi03,g_azi05 FROM azi_file
#         WHERE azi01 = g_aza.aza17             # 本國幣別之成本小數位數
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #LET tm.more  = ARG_VAL(10)   #TQC-610069
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   #LET tm.more  = ARG_VAL(9)    #TQC-610069
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r104_tm()	        	# Input print condition
      ELSE CALL r104()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time          #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r104_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW r104_w AT p_row,p_col
        WITH FORM "acs/42f/acsr104"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = '1'
   LET tm.b = '1'
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
      LET INT_FLAG = 0 CLOSE WINDOW r104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.more 		# Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES '[123]' THEN
            NEXT FIELD b
         END IF
         IF tm.b=tm.a THEN
            CALL cl_err(tm.a,'mfg6014',0)
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
      ON ACTION CONTROLP CALL r104_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr104'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr104','9031',1)   
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
                         " '",tm.b CLIPPED,"'",
                         #" '",tm.more CLIPPED,"'",             #TQC-610069
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr104',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r104_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r104()
   ERROR ""
END WHILE
   CLOSE WINDOW r104_w
END FUNCTION
 
FUNCTION r104_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r104_w2 AT 2,2
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
   CLOSE WINDOW r104_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r104_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r104()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
   #      l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10) #No.TQC-6A0079
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        ima86      LIKE  ima_file.ima86,  #成本單位
                        iml02      LIKE  iml_file.iml02,  #成本項目
                        iml031     LIKE  iml_file.iml031, #標準成本
                        iml032     LIKE  iml_file.iml032, #現時成本
                        iml033     LIKE  iml_file.iml033, #預設成本
                        smg02      LIKE  smg_file.smg02,  #成本項目說明
                        smg03      LIKE  smg_file.smg03   #成本歸類
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acsr104'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013  --end
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
                 " ima01,ima02,ima05,ima06,imz02,ima08,ima86, ",
                 " iml02,iml031,iml032,iml033,smg02,smg03 ",
                 "  FROM ima_file,iml_file,OUTER imz_file,OUTER smg_file ",
                 " WHERE ima_file.ima06=imz_file.imz01 ",
                 " AND ima01=iml01 AND iml_file.iml02=smg_file.smg01 ",
                 " AND imaacti='Y' ",
                 "   AND ",tm.wc CLIPPED
     PREPARE r104_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r104_cs1 CURSOR FOR r104_prepare1
 
     CALL cl_outnam('acsr104') RETURNING l_name
     START REPORT r104_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r104_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06='  '  END IF
 
       OUTPUT TO REPORT r104_rep(sr.*)
 
     END FOREACH
 
     FINISH REPORT r104_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r104_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        ima86      LIKE  ima_file.ima86,  #成本單位
                        iml02      LIKE  iml_file.iml02,  #成本項目
                        iml031     LIKE  iml_file.iml031, #標準成本
                        iml032     LIKE  iml_file.iml032, #現時成本
                        iml033     LIKE  iml_file.iml033, #預設成本
                        smg02      LIKE  smg_file.smg02,  #成本項目說明
                        smg03      LIKE  smg_file.smg03   #成本歸類
                        END RECORD,
          l_imb128 LIKE imb_file.imb118,
          l_sum1   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #合計
          l_sum2   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #合計
          l_smal1  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #小計
          l_smal2  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #小計
          l_stand  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #標準成本合計
          l_curr   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #現時成本合計
          l_prop   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #預設成本合計
          l_sub    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #差異
          l_pre    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(6,2)    #差異%
          l_cost1  LIKE iml_file.iml031,
          l_cost2  LIKE iml_file.iml031,
          l_sw     LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
          l_str    LIKE ima_file.ima01,    #No.FUN-680071 VARCHAR(40)
          l_str2   LIKE ima_file.ima01     #No.FUN-680071 VARCHAR(40)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima06,sr.ima01,sr.smg03
  FORMAT
   PAGE HEADER
#No.FUN-580013  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[11] CLIPPED,sr.ima06, COLUMN 30,g_x[12] CLIPPED,sr.imz02
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[11] CLIPPED,sr.ima06, COLUMN 30,g_x[12] CLIPPED,sr.imz02
#     SKIP 1 LINE
#     PRINT g_x[13] CLIPPED,COLUMN 42,g_x[15] CLIPPED,
#           COLUMN 56,g_x[17] CLIPPED;
      CASE tm.a
#        WHEN '1'  PRINT COLUMN 90,g_x[25] CLIPPED;
#        WHEN '2'  PRINT COLUMN 90,g_x[26] CLIPPED;
#        WHEN '3'  PRINT COLUMN 90,g_x[27] CLIPPED;
         WHEN '1'  LET g_zaa[47].zaa08 = g_x[25] CLIPPED
         WHEN '2'  LET g_zaa[47].zaa08 = g_x[26] CLIPPED
         WHEN '3'  LET g_zaa[47].zaa08 = g_x[27] CLIPPED
      END CASE
      CASE tm.b
#        WHEN '1'  PRINT COLUMN 112,g_x[25] CLIPPED;
#        WHEN '2'  PRINT COLUMN 112,g_x[26] CLIPPED;
#        WHEN '3'  PRINT COLUMN 112,g_x[27] CLIPPED;
         WHEN '1'  LET g_zaa[48].zaa08 = g_x[25] CLIPPED   #TQC-6B0025 mark,g_x[30] CLIPPED
         WHEN '2'  LET g_zaa[48].zaa08 = g_x[26] CLIPPED   #TQC-6B0025 mark,g_x[30] CLIPPED
         WHEN '3'  LET g_zaa[48].zaa08 = g_x[27] CLIPPED   #TQC-6B0025 mark,g_x[30] CLIPPED
      END CASE
#     PRINT COLUMN 116,g_x[30] CLIPPED,COLUMN 132,'  %'
#     PRINT g_x[14] CLIPPED,COLUMN 39,'--------------',
#           COLUMN 55,'---------------------------',COLUMN 83,'------------------',
#           COLUMN 107,'-------------------',COLUMN 128,'-------------------',
#           COLUMN 148,'------'
      PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
      PRINT g_dash1
#No.FUN-580013  -end
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ima06
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.ima01
      LET l_sum1=0
      LET l_sum2=0
#No.FUN-580013  -begin
#     PRINT sr.ima01,COLUMN 22,sr.ima05,
#           COLUMN 28,sr.ima08,COLUMN 34,sr.ima86;
      PRINT COLUMN g_c[41],sr.ima01 CLIPPED, #FUN-5B0013 add
            COLUMN g_c[42],sr.ima05,
            COLUMN g_c[43],sr.ima08,
            COLUMN g_c[44],sr.ima86;
#No.FUN-580013  -end
      LET l_sw='Y'
 
   BEFORE GROUP OF sr.smg03
      LET l_smal1=0
      LET l_smal2=0
 
   ON EVERY ROW
#No.FUN-580013  -begin
      CASE sr.smg03
#        WHEN '1' PRINT COLUMN 39,"1: ",g_x[19] CLIPPED;
#        WHEN '2' PRINT COLUMN 39,"2: ",g_x[20] CLIPPED;
#        WHEN '3' PRINT COLUMN 39,"3: ",g_x[21] CLIPPED;
#        WHEN '4' PRINT COLUMN 39,"4: ",g_x[22] CLIPPED;
#        WHEN '5' PRINT COLUMN 39,"5: ",g_x[23] CLIPPED;
#        WHEN '9' PRINT COLUMN 39,"9: ",g_x[32] CLIPPED;
         WHEN '1' PRINT COLUMN g_c[45],"1: ",g_x[19] CLIPPED;
         WHEN '2' PRINT COLUMN g_c[45],"2: ",g_x[20] CLIPPED;
         WHEN '3' PRINT COLUMN g_c[45],"3: ",g_x[21] CLIPPED;
         WHEN '4' PRINT COLUMN g_c[45],"4: ",g_x[22] CLIPPED;
         WHEN '5' PRINT COLUMN g_c[45],"5: ",g_x[23] CLIPPED;
         WHEN '9' PRINT COLUMN g_c[45],"9: ",g_x[32] CLIPPED;
      END CASE
#     PRINT COLUMN 55,sr.smg02,' ',sr.iml02;
      PRINT COLUMN g_c[46],sr.smg02,' ',sr.iml02;
      CASE tm.a
#        WHEN '1' PRINT COLUMN 83,cl_numfor(sr.iml031,18,g_azi04);
         WHEN '1' PRINT COLUMN g_c[47],cl_numfor(sr.iml031,47,g_azi04);
                  LET l_sum1=l_sum1+sr.iml031
                  LET l_smal1=l_smal1+sr.iml031
                  LET l_cost1=sr.iml031
#        WHEN '2' PRINT COLUMN 83,cl_numfor(sr.iml032,18,g_azi04);
         WHEN '2' PRINT COLUMN g_c[47],cl_numfor(sr.iml032,47,g_azi04);
                  LET l_sum1=l_sum1+sr.iml032
                  LET l_smal1=l_smal1+sr.iml032
                  LET l_cost1=sr.iml032
#        WHEN '3' PRINT COLUMN 83,cl_numfor(sr.iml033,18,g_azi04);
         WHEN '3' PRINT COLUMN g_c[47],cl_numfor(sr.iml033,47,g_azi04);
                  LET l_sum1=l_sum1+sr.iml033
                  LET l_smal1=l_smal1+sr.iml033
                  LET l_cost1=sr.iml033
      END CASE
      CASE tm.b
#        WHEN '1' PRINT COLUMN 107,cl_numfor(sr.iml031,18,g_azi04);
         WHEN '1' PRINT COLUMN g_c[48],cl_numfor(sr.iml031,48,g_azi04);
                  LET l_sum2=l_sum2+sr.iml031
                  LET l_smal2=l_smal2+sr.iml031
                  LET l_cost2=sr.iml031
#        WHEN '2' PRINT COLUMN 107,cl_numfor(sr.iml032,18,g_azi04);
         WHEN '2' PRINT COLUMN g_c[48],cl_numfor(sr.iml032,48,g_azi04);
                  LET l_sum2=l_sum2+sr.iml032
                  LET l_smal2=l_smal2+sr.iml032
                  LET l_cost2=sr.iml032
#        WHEN '3' PRINT COLUMN 107,cl_numfor(sr.iml033,18,g_azi04);
         WHEN '3' PRINT COLUMN g_c[48],cl_numfor(sr.iml033,48,g_azi04);
                  LET l_sum2=l_sum2+sr.iml033
                  LET l_smal2=l_smal2+sr.iml033
                  LET l_cost2=sr.iml033
      END CASE
      LET l_sub=l_cost2-l_cost1
      IF l_cost1=0 THEN LET l_pre=0
         ELSE LET l_pre=(l_sub/l_cost1)*100 END IF
#     PRINT COLUMN 128,cl_numfor(l_sub,18,g_azi04),
#           COLUMN 148,l_pre USING '---&.&&'
      PRINT COLUMN g_c[49],cl_numfor(l_sub,49,g_azi04),
            COLUMN g_c[50],l_pre USING '---&.&&'
      IF l_sw='Y' THEN
         LET l_sw='N'
#        PRINT COLUMN 4,sr.ima02;
         #PRINT COLUMN g_c[41],sr.ima02[1,20];#FUN-5B0013 mark
         PRINT COLUMN g_c[41],sr.ima02 CLIPPED; #FUN-5B0013 add
      END IF
#No.FUN-580013  --end
 
   AFTER GROUP OF sr.ima01
      LET l_sub=l_sum2-l_sum1
      IF l_sum1=0 THEN LET l_pre=0
         ELSE LET l_pre=(l_sub/l_sum1)*100 END IF
#No.FUN-580013  -begin
#     PRINT COLUMN 36,g_x[28] CLIPPED,
#           COLUMN 83,cl_numfor(l_sum1,18,g_azi05) CLIPPED,
#           COLUMN 107,cl_numfor(l_sum2,18,g_azi05) CLIPPED,
#           COLUMN 128,cl_numfor(l_sub,18,g_azi05) CLIPPED,
#           COLUMN 148,l_pre USING '---&.&&'
      PRINT COLUMN g_c[44],g_x[28] CLIPPED,
            COLUMN g_c[47],cl_numfor(l_sum1,47,g_azi05) CLIPPED,
            COLUMN g_c[48],cl_numfor(l_sum2,48,g_azi05) CLIPPED,
            COLUMN g_c[49],cl_numfor(l_sub,49,g_azi05) CLIPPED,
            COLUMN g_c[50],l_pre USING '---&.&&'
#No.FUN-580013  -end
      SKIP 2 LINE
      LET l_sum1=0
      LET l_sum2=0
 
   AFTER GROUP OF sr.smg03
      LET l_sub=l_smal2-l_smal1
      IF l_smal1=0 THEN LET l_pre=0
         ELSE LET l_pre=(l_sub/l_smal1)*100 END IF
#No.FUN-580013  -begin
#     PRINT COLUMN 36,g_x[29] CLIPPED,
#           COLUMN 83,cl_numfor(l_smal1,18,g_azi05) CLIPPED,
#           COLUMN 107,cl_numfor(l_smal2,18,g_azi05) CLIPPED,
#           COLUMN 128,cl_numfor(l_sub, 18,g_azi05) CLIPPED,
#           COLUMN 148,l_pre USING '---&.&&'
      PRINT COLUMN g_c[44],g_x[29] CLIPPED,
            COLUMN g_c[47],cl_numfor(l_smal1,47,g_azi05) CLIPPED,
            COLUMN g_c[48],cl_numfor(l_smal2,48,g_azi05) CLIPPED,
            COLUMN g_c[49],cl_numfor(l_sub, 49,g_azi05) CLIPPED,
            COLUMN g_c[50],l_pre USING '---&.&&'
#No.FUN-580013  -end
      LET l_smal1=0
      LET l_smal2=0
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
           #  IF tm.wc[001,070] > ' ' THEN			# for 80
      	   #     PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
           #  IF tm.wc[071,140] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
           #  IF tm.wc[141,210] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
           #  IF tm.wc[211,280] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
           #No.TQC-630166 --start--
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#	         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
