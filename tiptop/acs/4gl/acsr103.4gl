# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: acsr103.4gl
# Descriptions...: 料件成本要素差異分析表
# Date & Author..: 92/01/16 By Lin
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
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				     # Print condition RECORD
   		        wc  	STRING,   	     # Where condition No.TQC-630166
                a       LIKE type_file.chr1,         #No.FUN-680071 VARCHAR(01)
                b       LIKE type_file.chr1,         #No.FUN-680071 VARCHAR(01)
   		        more	LIKE type_file.chr1  #No.FUN-680071 VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)              #Dash line
#DEFINE   g_len           SMALLINT               #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT               #Report page no
#DEFINE   g_zz05          VARCHAR(1)                #Print tm.wc ?(Y/N)
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-690110 by xiake
 
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
   LET tm.b  = ARG_VAL(9)
   #LET tm.more  = ARG_VAL(10)  #TQC-610069
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r103_tm()	        	# Input print condition
      ELSE CALL r103()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r103_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW r103_w AT p_row,p_col
        WITH FORM "acs/42f/acsr103"
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
      LET INT_FLAG = 0 CLOSE WINDOW r103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-690110 by xiake
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
      AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CLOSE WINDOW r103_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by xiake
           EXIT PROGRAM
              
        END IF
         IF tm.a IS NULL OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
         IF tm.b IS NULL OR tm.b NOT MATCHES '[123]' THEN
            NEXT FIELD b
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP CALL r103_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by  xiake
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr103'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr103','9031',1)   
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
         CALL cl_cmdat('acsr103',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r103_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-690110 by  xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r103()
   ERROR ""
END WHILE
   CLOSE WINDOW r103_w
END FUNCTION
 
FUNCTION r103_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r103_w2 AT 2,2
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
   CLOSE WINDOW r103_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r103_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r103()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
#         l_order	ARRAY[5] OF LIKE apm_file.apm08,    #No.FUN-680071 VARCHAR(10) #No.TQC-6A0079
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        ima86      LIKE  ima_file.ima86   #成本單位
                        END RECORD,
          sr2 RECORD LIKE imb_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acsr103'
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
                 " imb_file.* ",
                 "  FROM ima_file,imb_file,OUTER imz_file ",
                 " WHERE ima01=imb01 AND ima_file.ima06=imz_file.imz01 ",
                 " AND imaacti='Y' AND imbacti='Y' ",
                 "   AND ",tm.wc CLIPPED
     PREPARE r103_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake 
        EXIT PROGRAM 
     END IF
     DECLARE r103_cs1 CURSOR FOR r103_prepare1
 
     CALL cl_outnam('acsr103') RETURNING l_name
     START REPORT r103_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r103_cs1 INTO sr.*,sr2.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06='  '  END IF
 
       OUTPUT TO REPORT r103_rep(sr.*,sr2.*)
 
     END FOREACH
 
     FINISH REPORT r103_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r103_rep(sr,sr2)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD
                        ima01      LIKE  ima_file.ima01,  #料件編號
                        ima02      LIKE  ima_file.ima02,  #品名規格
                        ima05      LIKE  ima_file.ima05,  #版本
                        ima06      LIKE  ima_file.ima06,  #分群碼
                        imz02      LIKE  imz_file.imz02,  #分群碼說明
                        ima08      LIKE  ima_file.ima08,  #來源碼
                        ima86      LIKE  ima_file.ima86   #成本單位
                        END RECORD,
          sr2 RECORD LIKE imb_file.* ,
          l_imb1 RECORD LIKE imb_file.* ,
          l_imb2 RECORD LIKE imb_file.* ,
          l_imb128 LIKE imb_file.imb118,
          l_sum    LIKE imb_file.imb118,    #No.FUN-680071 DECIMAL(20,6)   #合計
          l_sum2   LIKE imb_file.imb118,    #No.FUN-680071 DECIMAL(20,6)   #合計
          l_sub    LIKE imb_file.imb118,   #No.FUN-680071 DECIMAL(20,6)   #差異
          l_cost1  LIKE imb_file.imb111,
          l_cost2  LIKE imb_file.imb111,
          l_pre    LIKE type_file.num15_3,  #LIKE cpf_file.cpf112,    #No.FUN-680071 DECIMAL(6,2)    #差異%   #TQC-B90211
          l_stand  LIKE imb_file.imb118,    #No.FUN-680071 DECIMAL(20,6)   #標準成本合計
          l_curr   LIKE imb_file.imb218,    #No.FUN-680071 DECIMAL(20,6)   #現時成本合計
          l_prop   LIKE imb_file.imb318,    #No.FUN-680071 DECIMAL(20,6)   #預設成本合計
          l_str    LIKE ima_file.ima01,    #No.FUN-680071 VARCHAR(40)
          l_str2   LIKE ima_file.ima01     #No.FUN-680071 VARCHAR(40)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima06,sr.ima01
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
#     PRINT  g_x[13] CLIPPED, COLUMN 46,g_x[36] CLIPPED;
#     CASE tm.a
#        WHEN '1'  PRINT COLUMN 78,g_x[28] CLIPPED;
#        WHEN '2'  PRINT COLUMN 78,g_x[29] CLIPPED;
#        WHEN '3'  PRINT COLUMN 78,g_x[30] CLIPPED;
#     END CASE
      CASE tm.a
         WHEN '1'  LET g_zaa[47].zaa08 = g_x[28] CLIPPED
         WHEN '2'  LET g_zaa[47].zaa08 = g_x[29] CLIPPED
         WHEN '3'  LET g_zaa[47].zaa08 = g_x[30] CLIPPED
      END CASE
#     CASE tm.b
#        WHEN '1'  PRINT COLUMN 98,g_x[28] CLIPPED;
#        WHEN '2'  PRINT COLUMN 98,g_x[29] CLIPPED;
#        WHEN '3'  PRINT COLUMN 98,g_x[30] CLIPPED;
#     END CASE
      CASE tm.b
         WHEN '1'  LET g_zaa[48].zaa08 = g_x[28] CLIPPED   #TQC-6B0025 mark ,g_x[34] CLIPPED
         WHEN '2'  LET g_zaa[48].zaa08 = g_x[29] CLIPPED   #TQC-6B0025 mark ,g_x[34] CLIPPED
         WHEN '3'  LET g_zaa[48].zaa08 = g_x[30] CLIPPED   #TQC-6B0025 mark ,g_x[34] CLIPPED
      END CASE
#     PRINT COLUMN 104,g_x[34] CLIPPED,COLUMN 120,'%'
#     PRINT g_x[14] CLIPPED,COLUMN 46,g_x[27] CLIPPED,
#           COLUMN 72,'-------------------',COLUMN 93,'-------------------',
#           COLUMN 114,'-------------------  -------'
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
      NEED 6 LINES
      LET l_imb128=0
      LET l_sum=0
#No.FUN-580013  -begin
#     PRINT sr.ima01 CLIPPED,COLUMN 22,sr.ima05, #FUN-5B0013 add CLIPPED
#           COLUMN 28,sr.ima08,COLUMN 35,sr.ima86;
      PRINT COLUMN g_c[41],sr.ima01 CLIPPED, #FUN-5B0013 add CLIPPED
            COLUMN g_c[42],sr.ima05,
            COLUMN g_c[43],sr.ima08,
            COLUMN g_c[44],sr.ima86;
      IF sr.ima08 NOT MATCHES '[PV]' THEN
#        PRINT COLUMN 41,g_x[32] CLIPPED;
         PRINT COLUMN g_c[45],g_x[32] CLIPPED;
      END IF
#No.FUN-580013  -end
      CASE tm.a
         WHEN  '1'
             LET l_imb1.imb111 =sr2.imb111
             LET l_imb1.imb112 =sr2.imb112
             LET l_imb1.imb1131=sr2.imb1131
             LET l_imb1.imb1132=sr2.imb1132
             LET l_imb1.imb114 =sr2.imb114
             LET l_imb1.imb115 =sr2.imb115
             LET l_imb1.imb116 =sr2.imb116
             LET l_imb1.imb1171=sr2.imb1171
             LET l_imb1.imb1172=sr2.imb1172
             LET l_imb1.imb118 =sr2.imb118
             LET l_imb1.imb119 =sr2.imb119
             LET l_imb1.imb120 =sr2.imb120
             LET l_imb1.imb121 =sr2.imb121
             LET l_imb1.imb122 =sr2.imb122
             LET l_imb1.imb1231=sr2.imb1231
             LET l_imb1.imb1232=sr2.imb1232
             LET l_imb1.imb124 =sr2.imb124
             LET l_imb1.imb125 =sr2.imb125
             LET l_imb1.imb126 =sr2.imb126
             LET l_imb1.imb1271=sr2.imb1271
             LET l_imb1.imb1272=sr2.imb1272
             LET l_imb1.imb129 =sr2.imb129
             LET l_imb1.imb130 =sr2.imb130
          WHEN  '2'
             LET l_imb1.imb111 =sr2.imb211
             LET l_imb1.imb112 =sr2.imb212
             LET l_imb1.imb1131=sr2.imb2131
             LET l_imb1.imb1132=sr2.imb2132
             LET l_imb1.imb114 =sr2.imb214
             LET l_imb1.imb115 =sr2.imb215
             LET l_imb1.imb116 =sr2.imb216
             LET l_imb1.imb1171=sr2.imb2171
             LET l_imb1.imb1172=sr2.imb2172
             LET l_imb1.imb118 =sr2.imb218
             LET l_imb1.imb119 =sr2.imb219
             LET l_imb1.imb120 =sr2.imb220
             LET l_imb1.imb121 =sr2.imb221
             LET l_imb1.imb122 =sr2.imb222
             LET l_imb1.imb1231=sr2.imb2231
             LET l_imb1.imb1232=sr2.imb2232
             LET l_imb1.imb124 =sr2.imb224
             LET l_imb1.imb125 =sr2.imb225
             LET l_imb1.imb126 =sr2.imb226
             LET l_imb1.imb1271=sr2.imb2271
             LET l_imb1.imb1272=sr2.imb2272
             LET l_imb1.imb129 =sr2.imb229
             LET l_imb1.imb130 =sr2.imb230
         WHEN  '3'
             LET l_imb1.imb111 =sr2.imb311
             LET l_imb1.imb112 =sr2.imb312
             LET l_imb1.imb1131=sr2.imb3131
             LET l_imb1.imb1132=sr2.imb3132
             LET l_imb1.imb114 =sr2.imb314
             LET l_imb1.imb115 =sr2.imb315
             LET l_imb1.imb116 =sr2.imb316
             LET l_imb1.imb1171=sr2.imb3171
             LET l_imb1.imb1172=sr2.imb3172
             LET l_imb1.imb118 =sr2.imb318
             LET l_imb1.imb119 =sr2.imb319
             LET l_imb1.imb120 =sr2.imb320
             LET l_imb1.imb121 =sr2.imb321
             LET l_imb1.imb122 =sr2.imb322
             LET l_imb1.imb1231=sr2.imb3231
             LET l_imb1.imb1232=sr2.imb3232
             LET l_imb1.imb124 =sr2.imb324
             LET l_imb1.imb125 =sr2.imb325
             LET l_imb1.imb126 =sr2.imb326
             LET l_imb1.imb1271=sr2.imb3271
             LET l_imb1.imb1272=sr2.imb3272
             LET l_imb1.imb129 =sr2.imb329
             LET l_imb1.imb130 =sr2.imb330
      END CASE
      CASE tm.b
        WHEN '1'
             LET l_imb2.imb111 =sr2.imb111
             LET l_imb2.imb112 =sr2.imb112
             LET l_imb2.imb1131=sr2.imb1131
             LET l_imb2.imb1132=sr2.imb1132
             LET l_imb2.imb114 =sr2.imb114
             LET l_imb2.imb115 =sr2.imb115
             LET l_imb2.imb116 =sr2.imb116
             LET l_imb2.imb1171=sr2.imb1171
             LET l_imb2.imb1172=sr2.imb1172
             LET l_imb2.imb118 =sr2.imb118
             LET l_imb2.imb119 =sr2.imb119
             LET l_imb2.imb120 =sr2.imb120
             LET l_imb2.imb121 =sr2.imb121
             LET l_imb2.imb122 =sr2.imb122
             LET l_imb2.imb1231=sr2.imb1231
             LET l_imb2.imb1232=sr2.imb1232
             LET l_imb2.imb124 =sr2.imb124
             LET l_imb2.imb125 =sr2.imb125
             LET l_imb2.imb126 =sr2.imb126
             LET l_imb2.imb1271=sr2.imb1271
             LET l_imb2.imb1272=sr2.imb1272
             LET l_imb2.imb129 =sr2.imb129
             LET l_imb2.imb130 =sr2.imb130
          WHEN '2'
             LET l_imb2.imb111 =sr2.imb211
             LET l_imb2.imb112 =sr2.imb212
             LET l_imb2.imb1131=sr2.imb2131
             LET l_imb2.imb1132=sr2.imb2132
             LET l_imb2.imb114 =sr2.imb214
             LET l_imb2.imb115 =sr2.imb215
             LET l_imb2.imb116 =sr2.imb216
             LET l_imb2.imb1171=sr2.imb2171
             LET l_imb2.imb1172=sr2.imb2172
             LET l_imb2.imb118 =sr2.imb218
             LET l_imb2.imb119 =sr2.imb219
             LET l_imb2.imb120 =sr2.imb220
             LET l_imb2.imb121 =sr2.imb221
             LET l_imb2.imb122 =sr2.imb222
             LET l_imb2.imb1231=sr2.imb2231
             LET l_imb2.imb1232=sr2.imb2232
             LET l_imb2.imb124 =sr2.imb224
             LET l_imb2.imb125 =sr2.imb225
             LET l_imb2.imb126 =sr2.imb226
             LET l_imb2.imb1271=sr2.imb2271
             LET l_imb2.imb1272=sr2.imb2272
             LET l_imb2.imb129 =sr2.imb229
             LET l_imb2.imb130 =sr2.imb230
         WHEN '3'
             LET l_imb2.imb111 =sr2.imb311
             LET l_imb2.imb112 =sr2.imb312
             LET l_imb2.imb1131=sr2.imb3131
             LET l_imb2.imb1132=sr2.imb3132
             LET l_imb2.imb114 =sr2.imb314
             LET l_imb2.imb115 =sr2.imb315
             LET l_imb2.imb116 =sr2.imb316
             LET l_imb2.imb1171=sr2.imb3171
             LET l_imb2.imb1172=sr2.imb3172
             LET l_imb2.imb118 =sr2.imb318
             LET l_imb2.imb119 =sr2.imb319
             LET l_imb2.imb120 =sr2.imb320
             LET l_imb2.imb121 =sr2.imb321
             LET l_imb2.imb122 =sr2.imb322
             LET l_imb2.imb1231=sr2.imb3231
             LET l_imb2.imb1232=sr2.imb3232
             LET l_imb2.imb124 =sr2.imb324
             LET l_imb2.imb125 =sr2.imb325
             LET l_imb2.imb126 =sr2.imb326
             LET l_imb2.imb1271=sr2.imb3271
             LET l_imb2.imb1272=sr2.imb3272
             LET l_imb2.imb129 =sr2.imb329
             LET l_imb2.imb130 =sr2.imb330
      END CASE
      IF sr.ima08 MATCHES '[PV]' THEN
         LET l_stand=sr2.imb118   #標準
         LET l_curr =sr2.imb218   #現時
         LET l_prop =sr2.imb318   #預設
 
         LET l_sub= l_imb2.imb118-l_imb1.imb118
         IF l_imb1.imb118 =0 THEN LET l_pre=0
            ELSE LET l_pre=(l_sub/l_imb1.imb118)*100 END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[26] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb118,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb118,18,g_azi04),
#              COLUMN 114,cl_numfor(l_sub,18,g_azi04),
#              COLUMN 134,l_pre USING "---&.&&"
#        PRINT COLUMN 4,sr.ima02 CLIPPED #FUN-5B0013 add CLIPPED
         PRINT COLUMN g_c[46],g_x[26] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb118,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb118,48,g_azi04),
               COLUMN g_c[49],cl_numfor(l_sub,49,g_azi04),
               COLUMN g_c[50],l_pre USING "--&.&&"
         #PRINT COLUMN g_c[41],sr.ima02[1,20] #FUN-5B0013 mark
         PRINT COLUMN g_c[41],sr.ima02 CLIPPED #FUN-5B0013 add
#No.FUN-580013  -end
         LET l_sum =l_imb1.imb118
         LET l_sum2=l_imb2.imb118
      ELSE
         LET l_stand=sr2.imb111 + sr2.imb112 + sr2.imb1131 +  #上階
                     sr2.imb1132+ sr2.imb114 + sr2.imb115  +
                     sr2.imb116 + sr2.imb1171+ sr2.imb1172 +
                     sr2.imb119 + sr2.imb120 +
                     sr2.imb121 + sr2.imb122 + sr2.imb1231 +  #下階
                     sr2.imb1232+ sr2.imb124 + sr2.imb125  +
                     sr2.imb126 + sr2.imb1271+ sr2.imb1272 +
                     sr2.imb129 + sr2.imb130
         LET l_curr =sr2.imb211 + sr2.imb212 + sr2.imb2131 +  #上階
                     sr2.imb2132+ sr2.imb214 + sr2.imb215  +
                     sr2.imb216 + sr2.imb2171+ sr2.imb2172 +
                     sr2.imb219 + sr2.imb220 +
                     sr2.imb221 + sr2.imb222 + sr2.imb2231 +  #下階
                     sr2.imb2232+ sr2.imb224 + sr2.imb225  +
                     sr2.imb226 + sr2.imb2271+ sr2.imb2272 +
                     sr2.imb229 + sr2.imb230
         LET l_prop =sr2.imb311 + sr2.imb312 + sr2.imb3131 +  #上階
                     sr2.imb3132+ sr2.imb314 + sr2.imb315  +
                     sr2.imb316 + sr2.imb3171+ sr2.imb3172 +
                     sr2.imb319 + sr2.imb320 +
                     sr2.imb321 + sr2.imb322 + sr2.imb3231 +  #下階
                     sr2.imb3232+ sr2.imb324 + sr2.imb325  +
                     sr2.imb326 + sr2.imb3271+ sr2.imb3272 +
                     sr2.imb329 + sr2.imb330
         CASE tm.a
            WHEN '1' LET l_sum=l_stand
            WHEN '2' LET l_sum=l_curr
            WHEN '3' LET l_sum=l_prop
         END CASE
         CASE tm.b
            WHEN '1' LET l_sum2=l_stand
            WHEN '2' LET l_sum2=l_curr
            WHEN '3' LET l_sum2=l_prop
         END CASE
         IF l_imb1.imb111 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb111-l_imb1.imb111)/l_imb1.imb111)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[15] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb111,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb111,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb111-l_imb1.imb111),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
#        PRINT COLUMN 4,sr.ima02 CLIPPED;#FUN-5B0013 add CLIPPED
         PRINT COLUMN g_c[46],g_x[15] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb111,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb111,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb111-l_imb1.imb111),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
         #PRINT COLUMN g_c[41],sr.ima02[1,20];#FUN-5B0013 mark
         PRINT COLUMN g_c[41],sr.ima02 CLIPPED;#FUN-5B0013 add
#No.FUN-580013  -end
         IF l_imb1.imb112 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb112-l_imb1.imb112)/l_imb1.imb112)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[16] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb112,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb112,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb112-l_imb1.imb112),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[16] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb112,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb112,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb112-l_imb1.imb112),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1131 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1131-l_imb1.imb1131)/l_imb1.imb1131)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[17] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1131,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1131,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1131-l_imb1.imb1131),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[17] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1131,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1131,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1131-l_imb1.imb1131),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1132 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1132-l_imb1.imb1132)/l_imb1.imb1132)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[18] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1132,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1132,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1132-l_imb1.imb1132),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[18] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1132,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1132,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1132-l_imb1.imb1132),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb114 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb114-l_imb1.imb114)/l_imb1.imb114)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[19] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb114,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb114,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb114-l_imb1.imb114),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[19] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb114,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb114,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb114-l_imb1.imb114),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb115 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb115-l_imb1.imb115)/l_imb1.imb115)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[20] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb115,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb115,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb115-l_imb1.imb115),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[20] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb115,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb115,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb115-l_imb1.imb115),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb116 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb116-l_imb1.imb116)/l_imb1.imb116)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[21] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb116,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb116,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb116-l_imb1.imb116),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[21] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb116,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb116,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb116-l_imb1.imb116),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1171 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1171-l_imb1.imb1171)/l_imb1.imb1171)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[22] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1171,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1171,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1171-l_imb1.imb1171),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[22] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1171,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1171,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1171-l_imb1.imb1171),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1172 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1172-l_imb1.imb1172)/l_imb1.imb1172)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[23] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1172,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1172,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1172-l_imb1.imb1172),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[23] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1172,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1172,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1172-l_imb1.imb1172),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb119 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb119-l_imb1.imb119)/l_imb1.imb119)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[25] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb119,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb119,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb119-l_imb1.imb119),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[25] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb119,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb119,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb119-l_imb1.imb119),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb120 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb120-l_imb1.imb120)/l_imb1.imb120)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[24] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb120,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb120,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb120-l_imb1.imb120),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[24] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb120,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb120,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb120-l_imb1.imb120),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
        #下階成本
#        PRINT COLUMN 41,g_x[33] CLIPPED;
         PRINT COLUMN g_c[45],g_x[33] CLIPPED;
#No.FUN-580013  -end
         IF l_imb1.imb121 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb121-l_imb1.imb121)/l_imb1.imb121)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[15] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb121,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb121,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb121-l_imb1.imb121),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[15] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb121,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb121,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb121-l_imb1.imb121),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb122 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb122-l_imb1.imb122)/l_imb1.imb122)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[16] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb122,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb122,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb122-l_imb1.imb122),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[16] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb122,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb122,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb122-l_imb1.imb122),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1231 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1231-l_imb1.imb1231)/l_imb1.imb1231)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[17] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1231,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1231,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1231-l_imb1.imb1231),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[17] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1231,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1231,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1231-l_imb1.imb1231),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1232 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1232-l_imb1.imb1232)/l_imb1.imb1232)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[18] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1232,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1232,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1232-l_imb1.imb1232),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[18] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1232,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1232,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1232-l_imb1.imb1232),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb124 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb124-l_imb1.imb124)/l_imb1.imb124)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[19] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb124,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb124,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb124-l_imb1.imb124),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[19] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb124,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb124,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb124-l_imb1.imb124),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb125 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb125-l_imb1.imb125)/l_imb1.imb125)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[20] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb125,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb125,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb125-l_imb1.imb125),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[20] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb125,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb125,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb125-l_imb1.imb125),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb126 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb126-l_imb1.imb126)/l_imb1.imb126)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[21] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb126,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb126,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb126-l_imb1.imb126),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[21] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb126,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb126,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb126-l_imb1.imb126),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
         IF l_imb1.imb1271 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1271-l_imb1.imb1271)/l_imb1.imb1271)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[22] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1271,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1271,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1271-l_imb1.imb1271),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[22] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1271,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1271,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1271-l_imb1.imb1271),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb1272 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb1272-l_imb1.imb1272)/l_imb1.imb1272)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[23] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb1272,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb1272,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb1272-l_imb1.imb1272),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[23] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb1272,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb1272,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb1272-l_imb1.imb1272),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb129 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb129-l_imb1.imb129)/l_imb1.imb129)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[25] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb129,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb129,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb129-l_imb1.imb129),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[25] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb129,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb129,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb129-l_imb1.imb129),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
         IF l_imb1.imb130 = 0 THEN LET l_pre=0
         ELSE LET l_pre= ((l_imb2.imb130-l_imb1.imb130)/l_imb1.imb130)*100
         END IF
#No.FUN-580013  -begin
#        PRINT COLUMN 46,g_x[24] CLIPPED,
#              COLUMN 72,cl_numfor(l_imb1.imb130,18,g_azi04),
#              COLUMN 93,cl_numfor(l_imb2.imb130,18,g_azi04),
#              COLUMN 114,cl_numfor((l_imb2.imb130-l_imb1.imb130),18,g_azi04),
#              COLUMN 134,l_pre USING '---&.&&'
         PRINT COLUMN g_c[46],g_x[24] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_imb1.imb130,47,g_azi04),
               COLUMN g_c[48],cl_numfor(l_imb2.imb130,48,g_azi04),
               COLUMN g_c[49],cl_numfor((l_imb2.imb130-l_imb1.imb130),49,g_azi04),
               COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
      END IF
      #合計
      IF l_sum=0 THEN LET l_pre=0
      ELSE LET l_pre=((l_sum2-l_sum)/l_sum)*100  END IF
      LET l_sub=l_sum2-l_sum
 
#No.FUN-580013  -begin
#     PRINT COLUMN 41,g_x[31] CLIPPED,
#           COLUMN 72,cl_numfor(l_sum,18,g_azi05) CLIPPED,
#           COLUMN 93,cl_numfor(l_sum2,18,g_azi05) CLIPPED,
#           COLUMN 114,cl_numfor(l_sub ,18,g_azi05) CLIPPED,
#           COLUMN 134,l_pre USING '---&.&&'
      PRINT COLUMN g_c[45],g_x[31] CLIPPED,
            COLUMN g_c[47],cl_numfor(l_sum,47,g_azi05) CLIPPED,
            COLUMN g_c[48],cl_numfor(l_sum2,48,g_azi05) CLIPPED,
            COLUMN g_c[49],cl_numfor(l_sub ,49,g_azi05) CLIPPED,
            COLUMN g_c[50],l_pre USING '--&.&&'
#No.FUN-580013  -end
 
   AFTER GROUP OF sr.ima01
      SKIP 2 LINE
      LET l_sum=0
      LET l_sum2=0
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140g_azi0410g_azi0480   /   (132)-134g_azi0440,300
         THEN PRINT g_dash[1,g_len]
           #  IF tm.wc[001,070] > ' ' THEN			# for 80
      	   #     PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
           #  IF tm.wc[072,140] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[072,140] CLIPPED END IF
           #  IF tm.wc[141g_azi0410] > ' ' THEN
 
	   #     PRINT COLUMN 10,     tm.wc[141g_azi0410] CLIPPED END IF
           #  IF tm.wc[211g_azi0480] > ' ' THEN
	   #     PRINT COLUMN 10,     tm.wc[211g_azi0480] CLIPPED END IF
           #No.TQC-630166 --start--
#             IF tm.wc[001,134] > ' ' THEN			# for 132
#	         PRINT g_x[8] CLIPPED,tm.wc[001,134] CLIPPED END IF
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
