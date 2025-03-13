# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr522.4gl
# Descriptions...: 庫存成本表
# Date & Author..: 92/05/18 By Lin
# Modify ........: No.MOD-480141 04/08/12 By Nicola 輸入順序錯誤
# Modify.........: No.FUN-510017 05/01/31 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify         : No.MOD-530868 05/03/30 by alexlin VAR CHAR->CHAR
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-590110 05/09/28 By jackie 報表轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051
 
DEFINE tm  RECORD			# Print condition RECORD
           wc   STRING,                 # Where Condition  #TQC-630166
           b    LIKE type_file.chr1,    # 單位成本選擇  #No.FUN-690026 VARCHAR(1)
           c    LIKE type_file.chr1,    # 庫存數量選擇  #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,    # 排列順序      #No.FUN-690026 VARCHAR(03)
           t    LIKE type_file.chr3,    # 跳頁控制      #No.FUN-690026 VARCHAR(03)
           y    LIKE type_file.chr1,    # group code choice  #No.FUN-690026 VARCHAR(1)
           u    LIKE type_file.chr3,    # 合計               #No.FUN-690026 VARCHAR(03)
           zero LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           more LIKE type_file.chr1                       # 特殊列印條件  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5,    #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_str      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
 
MAIN
#     DEFINE    l_time   LIKE type_file.chr8       #No.FUN-6A0074
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.c     = ARG_VAL(9)
   LET tm.zero  = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   LET tm.y     = ARG_VAL(13)
   LET tm.u     = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r522_tm(0,0)		# Input print condition
   ELSE
#No.FUN-590110 --start--
      CALL r522()
#No.FUN-590110 --end--
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r522_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
	  l_direct      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 10
   ELSE
       LET p_row = 2 LET p_col = 14
   END IF
   OPEN WINDOW r522_w AT p_row,p_col
        WITH FORM "aim/42f/aimr522"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.zero   = 'N'
   LET tm.s      = '123'
   LET tm.t      = 'NNN'
   LET tm.u      = 'NNN'
   LET tm.y      = '0'
   LET tm.b      = '1'
   LET tm.c      = '3'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   IF g_sma.sma12 = 'N' THEN
      CONSTRUCT BY NAME tm.wc ON ima01,ima06,ima10,ima12,ima07,ima09,ima11
 
#No.FUN-570240 --start
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
   ELSE
      CONSTRUCT BY NAME  tm.wc ON ima01,ima06,ima10,ima12,img03,ima07,ima09,
                         ima11,img02
 
#No.FUN-570240 --start
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
   END IF
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   DISPLAY BY NAME tm.b,tm.c,tm.zero,tm.s,tm.t,tm.u,tm.y
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
    INPUT BY NAME tm.b,tm.c,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, #No.MOD-480141
                 tm2.u1,tm2.u2,tm2.u3,tm.zero,tm.y,tm.more
                 WITHOUT DEFAULTS
 
     #單位成本選擇 (1).標準成本 (2).現時成本 (3).預設成本
     AFTER FIELD b    #庫存成本
		 IF tm.b IS NULL OR tm.b NOT MATCHES'[123]' THEN
			NEXT FIELD b
     	 END IF
		 LET l_direct='D'
 
     BEFORE FIELD  c
		  IF g_sma.sma12 MATCHES '[Nn]' THEN
			 IF l_direct='D' THEN
				NEXT FIELD zero
            ELSE
				NEXT FIELD b
            END IF
          END IF
     #在多倉時才需輸入
     #庫存數量選擇 (1).MPS/MRP 可用數量 (2)庫存數量(不含不可用庫存)
     #             (3).庫存數量(包含不可用庫存)
     AFTER FIELD  c
         IF tm.c IS NULL OR tm.c = ' ' OR tm.c NOT MATCHES'[123]' THEN
			NEXT FIELD c
 		 END IF
 
      AFTER FIELD zero
         IF tm.zero IS NULL OR tm.zero NOT MATCHES'[YN]'
         THEN NEXT FIELD zero
         END IF
		 LET l_direct='U'
 
     AFTER FIELD  y
         IF tm.y IS NULL OR tm.y = ' ' OR tm.y NOT MATCHES'[0-4]' THEN
			NEXT FIELD y
 		 END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF g_sma.sma12 matches'[Yy]' THEN
            IF tm.c IS NULL OR tm.c = ' ' THEN NEXT FIELD c END IF
         END IF
      #UI
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP CALL r522_wc()       # Detail condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r522_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr522'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr522','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.zero CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'" ,                #TQC-610072
                         " '",tm.u CLIPPED,"'",
                        #" '",tm.y CLIPPED,"'" ,                #TQC-610072 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr522',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r522_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
#No.FUN-590110 --start--
   CALL r522()
#No.FUN-590110 --end--
   ERROR ""
END WHILE
CLOSE WINDOW r522_w
END FUNCTION
 
FUNCTION r522_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
 
   OPEN WINDOW r522_w2 AT 2,2
        WITH FORM "aim/42f/aimi100"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        ima05, ima08, ima02, ima03,
        ima13, ima14, ima70, ima57, ima15,
        ima09, ima10, ima11, ima12,
        ima16, ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42,
        ima29, imauser, imagrup,
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
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   CLOSE WINDOW r522_w2
END FUNCTION
 
FUNCTION r522()
   DEFINE l_name     LIKE type_file.chr20, 	      # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
      #   l_str	     ARRAY[3] OF LIKE zaa_file.zaa08, #No.FUN-690026 VARCHAR(8)
	  l_date     LIKE type_file.dat,              #No.FUN-690026 DATE
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     img02    LIKE img_file.img02, #倉庫
                     img03    LIKE img_file.img03, #存放位置
                     img04    LIKE img_file.img04, #批號
                     ima01    LIKE ima_file.ima01, #料件編號
                     ima02    LIKE ima_file.ima02, #品名
                     ima021   LIKE ima_file.ima021,#規格   #FUN-510017
                     ima05    LIKE ima_file.ima05, #版本
                     ima06    LIKE ima_file.ima06, #分群碼
                     ima09    LIKE ima_file.ima09, #分群碼
                     ima10    LIKE ima_file.ima10, #分群碼
                     ima11    LIKE ima_file.ima11, #分群碼
                     ima12    LIKE ima_file.ima12, #分群碼
                     ima07    LIKE ima_file.ima07, #ABC 碼
                     ima08    LIKE ima_file.ima08, #來源
                    #ima86    LIKE ima_file.ima86, #成本單位 #FUN-560183
                     img09    LIKE img_file.img09, #庫存單位
                     img10    LIKE img_file.img10, #庫存數量
                     img34    LIKE img_file.img34, #成本/庫存單位轉換率
#No.FUN-590110 --start--
                     ima25    LIKE  ima_file.ima25,  #庫存單位
#                    ima26    LIKE  ima_file.ima26,  #庫存數量            #FUN-A20044
#                    ima262   LIKE  ima_file.ima262, #庫存可用數量        #FUN-A20044
#                    ima261   LIKE  ima_file.ima261, #庫存不可用數量      #FUN-A20044
                     avl_stk_mpsmrp LIKE type_file.num15_3,               #FUN-A20044
                     avl_stk        LIKE type_file.num15_3,               #FUN-A20044
                     unavl_stk      LIKE type_file.num15_3,               #FUN-A20044  
                     ima271   LIKE  ima_file.ima271, #最高儲存數量
#No.FUN-590110 --end--
                     unit     LIKE imb_file.imb118, #MOD-530179 #FUN-510017
                     cost     LIKE imb_file.imb118, #MOD-530179 #FUN-510017
		     str1     LIKE zaa_file.zaa08,  #order1 的字串 #No.FUN-690026 VARCHAR(8)
		     str2     LIKE zaa_file.zaa08,  #order2 的字串 #No.FUN-690026 VARCHAR(8)
		     str3     LIKE zaa_file.zaa08   #order3 的字串 #No.FUN-690026 VARCHAR(8)
                     END RECORD
                     ,l_avl_stk_mpsmrp LIKE type_file.num15_3,    #FUN-A20044
                     l_unavl_stk       LIKE type_file.num15_3,    #FUN-A20044
                     l_avl_stk         LIKE type_file.num15_3     #FUN-A20044

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CASE tm.b  #單位成本
         WHEN tm.b='1'  LET g_x[25]=g_x[25] CLIPPED,' ',g_x[26]
         WHEN tm.b='2'  LET g_x[25]=g_x[25] CLIPPED,' ',g_x[27]
         WHEN tm.b='3'  LET g_x[25]=g_x[25] CLIPPED,' ',g_x[28]
         OTHERWISE EXIT CASE
     END CASE
 
#No.FUN-590110 --start--
   IF g_sma.sma12='Y' THEN
     LET l_sql = " SELECT  '','','',img02,img03,img04,ima01,ima02,ima021,ima05,", #FUN-510017
		 " ima06,ima09,ima10,ima11,ima12,ima07,ima08,", #FUN-560183 del ima86
                 " img09,img10,img34,'','','','','','','','','','' ",   #No.FUN-590110
                 " FROM img_file,ima_file",
                 " WHERE img01=ima01  AND ",tm.wc CLIPPED
 
     #-->庫存為零是否列印
     IF tm.zero ='N'
     THEN LET l_sql = l_sql clipped," AND img10 != 0 "
     END IF
     #-->數量選項
     CASE
       WHEN tm.c = '1'
            LET  l_sql = l_sql clipped," AND img24 IN ('Y','y') "
       WHEN tm.c = '2'
            LET  l_sql = l_sql clipped," AND img23 IN ('Y','y') "
       OTHERWISE EXIT CASE
     END CASE
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                 #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                 #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
   ELSE
 
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
     #End:FUN-980030
 
     LET l_sql = " SELECT  '','','','','','',",
                 " ima01,ima02,ima021,ima05,ima06,ima09, ", #FUN-510017
                 " ima10, ima11, ima12, ima07,ima08,'','','',",        #No.FUN-590110
#                " ima25,ima26,ima262,ima261,",  #FUN-560183 拿掉 ima86   #FUN-A20044
                 " ima25,' ',' ',' ',",                                   #FUN-A20044
                 " ima271,'','', ", #FUN-560183 拿掉 ima86_fac
                 " '','','' ",
                 " FROM ima_file",
                 " WHERE ",tm.wc CLIPPED
 
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
     #End:FUN-980030
 
   END IF
#No.FUN-590110 --end--
     PREPARE r522_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r522_c2 CURSOR FOR r522_prepare2
 
     CALL cl_outnam('aimr522') RETURNING l_name
#No.FUN-590110 --start--
     IF g_sma.sma12='Y' THEN
        LET g_zaa[31].zaa06='N'
        LET g_zaa[32].zaa06='N'
        LET g_zaa[33].zaa06='N'
        LET g_zaa[43].zaa06='N'
     ELSE
        LET g_zaa[31].zaa06='Y'
        LET g_zaa[32].zaa06='Y'
        LET g_zaa[33].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
     END IF
     CALL cl_prt_pos_len()
#No.FUN-590110 --end--
 
     START REPORT r522_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r522_c2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-A20044 ---start---
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp, l_unavl_stk,l_avl_stk
       LET sr.avl_stk_mpsmrp = l_avl_stk_mpsmrp
       LET sr.unavl_stk = l_unavl_stk
       LET sr.avl_stk = l_avl_stk
       IF sr.avl_stk_mpsmrp IS NULL THEN LET sr.avl_stk_mpsmrp = ' ' END IF 
       IF sr.unavl_stk IS NULL THEN LET sr.avl_stk_mpsmrp = ' ' END IF
       IF sr.avl_stk IS NULL THEN LET sr.avl_stk_mpsmrp = ' ' END IF
#No.FUN-A20044 ---end---  

       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima07 IS NULL THEN LET sr.ima07 = ' ' END IF
       IF sr.img02 IS NULL THEN LET sr.img02 = ' ' END IF
       IF sr.img03 IS NULL THEN LET sr.img03 = ' ' END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
					LET l_str[g_i]=g_x[20]
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima07
	             			LET l_str[g_i]=g_x[21]
               WHEN tm.s[g_i,g_i] = '3'
                  CASE WHEN tm.y = '0'  LET l_order[g_i] = sr.ima06
				        LET l_str[g_i]=g_x[22]
                       WHEN tm.y = '1'  LET l_order[g_i] = sr.ima09
				        LET l_str[g_i]=g_x[22]
                       WHEN tm.y = '2'  LET l_order[g_i] = sr.ima10
	        			LET l_str[g_i]=g_x[22]
                       WHEN tm.y = '3'  LET l_order[g_i] = sr.ima11
		        		LET l_str[g_i]=g_x[22]
                       WHEN tm.y = '4'  LET l_order[g_i] = sr.ima12
	        			LET l_str[g_i]=g_x[22]
                  END CASE
 
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img02
					LET l_str[g_i]=g_x[23]
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.img03
					LET l_str[g_i]=g_x[24]
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.str1 = l_str[1]
       LET sr.str2 = l_str[2]
       LET sr.str3 = l_str[3]
 
   IF g_sma.sma12='N' THEN
#     LET sr.ima26=sr.ima262               #FUN-A20044
      LET sr.avl_stk_mpsmrp = sr.avl_stk   #FUN-A20044
   END IF
 
       CASE tm.b
		 WHEN '1' CALL s_cost('1',sr.ima08,sr.ima01)
	                  RETURNING sr.unit    #標準成本
           WHEN '2' CALL s_cost('2',sr.ima08,sr.ima01)
	                  RETURNING sr.unit    #現時成本
           WHEN '3' CALL s_cost('3',sr.ima08,sr.ima01)
	                  RETURNING sr.unit    #預設成本
           OTHERWISE EXIT CASE
       END CASE
	  IF sr.unit IS NULL THEN LET sr.unit=0 END IF
 
       IF g_sma.sma12='Y' THEN
	  IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       ELSE
#         IF sr.ima26 IS NULL THEN LET sr.ima26=0 END IF   #FUN-A20044
          IF sr.avl_stk_mpsmrp IS NULL THEN LET sr.avl_stk_mpsmrp = 0 END IF #FUN-A20044
       END IF
 
       IF g_sma.sma12='Y' THEN
          LET sr.img34=1
          LET sr.cost = sr.unit * sr.img10 * sr.img34   #庫存成本
       ELSE
#         LET sr.cost = sr.unit * sr.ima26 * 1           #FUN-A20044
          LET sr.cost = sr.unit * sr.avl_stk_mpsmrp * 1  #FUN-A20044
       END IF
 
       OUTPUT TO REPORT r522_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r522_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r522_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_cost     LIKE imb_file.imb118,   #MOD-530179 #FUN-510017
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-690026 VARCHAR(20)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-690026 VARCHAR(20)
                     img02    LIKE img_file.img02, #倉庫
                     img03    LIKE img_file.img03, #存放位置
                     img04    LIKE img_file.img04, #批號
                     ima01    LIKE ima_file.ima01, #料件編號
                     ima02    LIKE ima_file.ima02, #品名
                     ima021   LIKE ima_file.ima021,#規格   #FUN-510017
                     ima05    LIKE ima_file.ima05, #版本
                     ima06    LIKE ima_file.ima06, #分群碼
                     ima09    LIKE ima_file.ima09, #分群碼
                     ima10    LIKE ima_file.ima10, #分群碼
                     ima11    LIKE ima_file.ima11, #分群碼
                     ima12    LIKE ima_file.ima12, #分群碼
                     ima07    LIKE ima_file.ima07, #ABC 碼
                     ima08    LIKE ima_file.ima08, #來源
                    #ima86    LIKE ima_file.ima86, #成本單位  #FUN-560183
                     img09    LIKE img_file.img09, #庫存單位
                     img10    LIKE img_file.img10, #庫存數量
                     img34    LIKE img_file.img34, #成本/庫存單位轉換率
#No.FUN-590110 --start--
                     ima25    LIKE ima_file.ima25,  #庫存單位
#                    ima26    LIKE ima_file.ima26,  #庫存數量           #FUN-A20044
#                    ima262   LIKE ima_file.ima262, #庫存可用數量       #FUN-A20044
#                    ima261   LIKE ima_file.ima261, #庫存不可用數量     #FUN-A20044
                     avl_stk_mpsmrp LIKE type_file.num15_3,             #FUN-A20044
                     avl_stk        LIKE type_file.num15_3,             #FUN-A20044
                     unavl_stk      LIKE type_file.num15_3,             #FUN-A20044
                     ima271   LIKE ima_file.ima271, #最高儲存數量
#No.FUN-590110 --end--
                     unit     LIKE imb_file.imb118, #MOD-530179 #FUN-510017
                     cost     LIKE imb_file.imb118, #MOD-530179 #FUN-510017
		     str1     LIKE zaa_file.zaa08,  #order1 的字串 #No.FUN-690026 VARCHAR(8)
		     str2     LIKE zaa_file.zaa08,  #order2 的字串 #No.FUN-690026 VARCHAR(8)
		     str3     LIKE zaa_file.zaa08   #order3 的字串 #No.FUN-690026 VARCHAR(8)
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
#No.FUN-590110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[25]))/2,g_x[25]
      PRINT g_x[9] CLIPPED,l_str[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_str[2] CLIPPED,'-',l_str[3] CLIPPED
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
                     g_x[39],g_x[40],g_x[41],g_x[41],g_x[42]
     #PRINTX name=H2 g_x[43],g_x[44]           #FUN-5C0002 mark
      PRINTX name=H2 g_x[43],g_x[44],g_x[45]   #FUN-5C0002
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINTX name=D1
             COLUMN  g_c[31],sr.img02 CLIPPED,
             COLUMN  g_c[32],sr.img03 CLIPPED,
             COLUMN  g_c[33],sr.img04 CLIPPED,
             COLUMN  g_c[34],sr.ima01 CLIPPED,  #FUN-5B0014 [1,20],
             COLUMN  g_c[35],sr.ima05 CLIPPED,
             COLUMN  g_c[36],sr.ima08 CLIPPED,
             COLUMN  g_c[37],sr.ima07 CLIPPED,
             COLUMN  g_c[38],sr.ima06 CLIPPED;
        IF g_sma.sma12='Y' THEN
            PRINTX name=D1
                   COLUMN g_c[39],sr.img09 CLIPPED,
                   COLUMN g_c[40],sr.img10 USING  "----------&.&&&";
        ELSE
            PRINTX name=D1
                   COLUMN g_c[39],sr.ima25 CLIPPED,
#                  COLUMN g_c[40],sr.ima26 USING "----------&.&&&";    #FUN-A20044
                   COLUMN g_c[40],sr.avl_stk_mpsmrp USING "----------&.&&&";    #FUN-A20044
        END IF
      PRINTX name=D1
             COLUMN  g_c[41],sr.unit USING  "----------&.&&&",
             COLUMN  g_c[42],sr.cost  USING "----------&.&&&"
      PRINTX name=D2
             COLUMN  g_c[44],sr.ima02 CLIPPED
            ,COLUMN  g_c[45],sr.ima021 CLIPPED   #FUN-5C0002
#            COLUMN  95,sr.unit  USING  "------------&.&&&"
           #'/',sr.ima86 #FUN-560183
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_cost = GROUP SUM(sr.cost)
         PRINTX name=S1
                COLUMN g_c[39],sr.str1 CLIPPED,g_x[29] CLIPPED,' ',
                COLUMN g_c[40],l_cost USING "----------&.&&&"
         SKIP 1 LINE
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_cost = GROUP SUM(sr.cost)
         PRINTX name=S1
                COLUMN g_c[39],sr.str2 CLIPPED,g_x[29] CLIPPED,' ',
                COLUMN g_c[40],l_cost USING "----------&.&&&"
         SKIP 1 LINE
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_cost = GROUP SUM(sr.cost)
         PRINTX name=S1
                COLUMN g_c[39],sr.str3 CLIPPED,g_x[29] CLIPPED,' ',
                COLUMN g_c[40],l_cost USING "----------&.&&&"
         SKIP 1 LINE
      END IF
#No.FUN-590110 --end--
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
        CALL cl_wcchp(tm.wc,'ima01,ima07,ima06,img02,img03')
             RETURNING tm.wc
         PRINT g_dash
#TQC-630166
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
              PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
#Patch....NO.TQC-610036 <> #
