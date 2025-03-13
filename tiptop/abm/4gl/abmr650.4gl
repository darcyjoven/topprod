# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abmr650.4gl
# Descriptions...: 尚未使用於產品結構中料件
# Input parameter:
# Return code....:
# Date & Author..: 91/08/05 By Lee
#      Modify    : 92/05/28 By David
# Modify.........: 93/09/16 By Apple(增列保稅否)
# Modify.........: No.FUN-510033 05/01/17 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致'
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-750093 07/05/25 By arman  報表改為使用crystal report
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至21
# Modify.........: No.FUN-750093 07/07/30 By arman 增加打印條件
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		        	        # Print condition RECORD   #CHI-710051 
	        	wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		s    	LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
           		t    	LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
   	        	y    	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           		more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_str           STRING                       #NO.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
 
   LET g_pdate = ARG_VAL(1)		        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.y  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r650_tm(0,0)	     	# Input print condition
      ELSE CALL abmr650()		     	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r650_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r650_w AT p_row,p_col
        WITH FORM "abm/42f/abmr650"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima08,ima06,
                           ima09,ima10,ima11,ima12,ima37
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
 
#No.FUN-570240  --start-
     ON ACTION controlp
           IF INFIELD(ima01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima01
              NEXT FIELD ima01
           END IF
#No.FUN-570240 --end--
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.y,tm.more 		# Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.y,tm.more WITHOUT DEFAULTS
      AFTER FIELD y
         IF tm.y IS NULL OR tm.y NOT MATCHES '[0-4]' THEN
            NEXT FIELD y
         END IF
      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
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
      ON ACTION CONTROLP CALL r650_wc()   # Input detail Where Condition
         IF INT_FLAG THEN EXIT INPUT END IF
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr650'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr650','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",                 #TQC-610068
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr650',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r650_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr650()
   ERROR ""
END WHILE
   CLOSE WINDOW r650_w
END FUNCTION
 
FUNCTION r650_wc()
   DEFINE l_wc   LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r650_w2 AT 2,2
        WITH FORM "aim/42f/aimi101"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimi101")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        ima01,ima02,ima05,ima03,ima04,
        ima13,ima14,ima15,ima08,ima16,
        ima07,ima06,ima09,ima10,ima11,
        ima12,ima42,ima34,ima37,ima38,
        ima35,ima36,ima23,ima39,
        ima18,ima19,ima20,ima21,ima22,
#        ima24,ima26,ima25,ima27,ima31,  #FUN-A20044
        ima24,ima25,ima27,ima31,         #FUN-A20044
        ima32,ima33,ima40,ima41,
        imauser,imagrup,imamodu,imadate,imaacti
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
 
   CLOSE WINDOW r650_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
END FUNCTION
 
FUNCTION abmr650()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_time2       LIKE type_file.chr8,  	# Used time for running the job   #No.FUN-680096 VARCHAR(8)
          l_time_used	LIKE eca_file.eca09,    #No.FUN-680096 DEC(8,2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE ima_file.ima01,  #No.FUN-680096 VARCHAR(40)
          sr RECORD
             order1 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order2 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order3 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             ima01 LIKE ima_file.ima01,	       # 料件編號
             ima02 LIKE ima_file.ima02,        #品名規格
             ima021 LIKE ima_file.ima021,        #品名規格 #FUN-510033
             ima05 LIKE ima_file.ima05,        #版本
             ima06 LIKE ima_file.ima06,        # group code
             ima09 LIKE ima_file.ima09,        # group code
             ima10 LIKE ima_file.ima10,        # group code
             ima11 LIKE ima_file.ima11,        # group code
             ima12 LIKE ima_file.ima12,        # group code
             ima08 LIKE ima_file.ima08,        #來源
             ima15 LIKE ima_file.ima15,        #保稅否
             ima25 LIKE ima_file.ima25,        #單位
             bmb01 LIKE bmb_file.bmb01,        #單位
             imadate LIKE ima_file.imadate     #建檔日期(修改日期)
          END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " ima01,ima02,ima021,ima05,ima06,ima09,ima10, ", #FUN-510033 add ima021
                 " ima11,ima12,ima08,ima15,ima25,'',imadate",
                 " FROM ima_file",
                 " WHERE ima01 NOT IN ",
                 " (SELECT bmb01 FROM bmb_file ",
               # "   WHERE bmb01 IS NOT NULL AND bmb01 = ima01)",
                 "   WHERE bmb01 IS NOT NULL )",   #No.3427
                 " AND ima01 NOT IN ",
                 " (SELECT DISTINCT bmb03 FROM bmb_file ",
                #No.+088 010426 BY PLUM
                #"   WHERE bmb03 IS NOT NULL AND bmb01 = ima01)",
               # "   WHERE bmb03 IS NOT NULL AND bmb03 = ima01)",
                 "   WHERE bmb03 IS NOT NULL )",    #No.3427
                #No.+088..end
                 " AND ima08!='Z'",
                 " AND ",tm.wc
#NO.FUN-750093  -----begin
#    PREPARE r650_prepare1 FROM l_sql
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE r650_cs1 CURSOR FOR r650_prepare1
#
#    CALL cl_outnam('abmr650') RETURNING l_name
#    START REPORT r650_rep TO l_name              
 
#    LET g_pageno = 0
#    LET g_cnt=0
#    FOREACH r650_cs1 INTO sr.*
#      IF SQLCA.sqlcode THEN
#        CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
#      END IF
#      IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
#      IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
#      IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
#      LET g_cnt=g_cnt+1
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima08
#              WHEN tm.s[g_i,g_i] = '4'
#                  CASE
#				 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#				 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#				 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#				 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#				 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#                  END CASE
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r650_rep(sr.*)            
#    END FOREACH
 
    #DISPLAY "" AT 2,1
#    FINISH REPORT r650_rep                       
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #NO.FUN-750093 -----end 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #NO.FUN-750093
     LET  g_str=tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.y,";",tm.t,";",g_sma.sma888[1,1]        #NO.FUN-750093 
#NO.FUN-750093  ---------begin ------------
     IF g_zz05 = 'Y' THEN  
        CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')
             RETURNING tm.wc
     LET g_str = g_str,";",tm.wc
     END IF 
#NO.FUN-750093 ----------end --------------------
    CALL cl_prt_cs1('abmr650','abmr650',l_sql,g_str)  #NO.FUN-750093
END FUNCTION
 
# NO.FUN-750093  ----begin
{REPORT r650_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
          sr RECORD
             order1 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order2 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order3 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             ima01 LIKE ima_file.ima01,	       # 料件編號
             ima02 LIKE ima_file.ima02,        #品名規格
             ima021 LIKE ima_file.ima021,      #品名規格 #FUN-510033
             ima05 LIKE ima_file.ima05,        #版本
             ima06 LIKE ima_file.ima06,        # group code
             ima09 LIKE ima_file.ima09,        # group code
             ima10 LIKE ima_file.ima10,        # group code
             ima11 LIKE ima_file.ima11,        # group code
             ima12 LIKE ima_file.ima12,        # group code
             ima08 LIKE ima_file.ima08,        #來源
             ima15 LIKE ima_file.ima15,        #保稅否
             ima25 LIKE ima_file.ima25,        #單位
             bmb01 LIKE bmb_file.bmb01,        #單位
             imadate LIKE ima_file.imadate     #建檔日期(修改日期)
          END RECORD,
      l_chr	     LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 11)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],sr.ima05,
            COLUMN g_c[35],sr.ima08,
            COLUMN g_c[36],sr.ima25,
            COLUMN g_c[37],sr.imadate;
     IF g_sma.sma888[1,1] ='Y'
     THEN PRINT COLUMN g_c[38],sr.ima15
     ELSE PRINT COLUMN g_c[38],' '
     END IF
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-5B0030 modify
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED  #No.TQC-5B0030 modify
         ELSE SKIP 2 LINE
      END IF
END REPORT}
# NO.FUN-750093  -----end
