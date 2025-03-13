# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#,
# Pattern name...: cimr802.4gl
# Descriptions...: 滯料分析表
# Input parameter:
# Return code....:
# Date & Author..: 91/10/29 By Nora
# Modify.........: 92/05/04 By Wu
# Modify.........: 92/05/08 By Lin
# Note ..........: 此程式不加其他分群碼的QBE及排列方式選擇,是因畫面已經放不下了
# Modify.........: No.FUN-530001 05/03/01 By Mandy 報表單價,金額寬度修正,並加上cl_numfor()
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: NO.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-570300 05/08/26 By kim 庫存數量出現星號(位數太小)
# Modify.........: No.FUN-590110 05/09/28 By jackie 報表轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-6A0043 06/11/16 By pengu sr.cost是成本單位,與 img_file 的單位可能會不同,所以應該要有轉換率
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-840055 08/04/29 By lutingting報表轉為使用CR
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/03/24 By vealxu ima26x 調整
# Modify.........: No:TQC-CC0074 12/12/12 By qirl 增加欄位
 
DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
#CHI-710051
 
DEFINE tm  RECORD		             # Print condition RECORD
           wc   STRING,                      # Where Condition  #TQC-630166
           s    LIKE type_file.chr2,         # 排列順序 #No.FUN-690026 VARCHAR(02)
           t    LIKE type_file.chr2,         # 跳頁控制 #No.FUN-690026 VARCHAR(02)
           f    LIKE type_file.chr1,         # 庫存成本  #No.FUN-690026 VARCHAR(1)
           g    LIKE type_file.chr1,         # 採購性料件成本  #No.FUN-690026 VARCHAR(1)
           h    LIKE type_file.chr1,         # 大宗發料件  #No.FUN-690026 VARCHAR(1)
           b    LIKE type_file.chr1,         # 雜項料件是否列印  #No.FUN-690026 VARCHAR(1)
           c    LIKE type_file.chr1,         # 工程性料是否列印  #No.FUN-690026 VARCHAR(1)
           e    LIKE type_file.num10,        # 呆滯天數起始天數  #No.FUN-690026 INTEGER
           i    LIKE type_file.num10,        # 呆滯天數截止天數  #No.FUN-690026 INTEGER
           zero LIKE type_file.chr1,         #No.FUN-690026 VARCHAR(1)
           more LIKE type_file.chr1          # 特殊列印條件  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5               #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_str    STRING                       #No.FUN-840055
DEFINE g_sql    STRING                       #No.FUN-840055
DEFINE l_table  STRING                       #No.FUN-840055
MAIN
#    DEFINE   l_time   LIKE type_file.chr8     #MOD-580222 add  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-840055--------start--
   LET g_sql = "ima06.ima_file.ima06,", 
               "ima01.ima_file.ima01,", 
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,", 
               "ima08.ima_file.ima08,", 
               "ima07.ima_file.ima07,", 
               "ima23.ima_file.ima23,", 
               "img02.img_file.img02,", 
               "img03.img_file.img03,", 
             #----TQC-CC0074--add--star-
               "gen02.gen_file.gen02,",
               "imd02.imd_file.imd02,",
               "ime03.ime_file.ime03,",
             #----TQC-CC0074--add--end--
               "img04.img_file.img04,", 
               "img22.img_file.img22,", 
               "img23.img_file.img23,", 
               "img24.img_file.img24,", 
               "img09.img_file.img09,", 
               "img10.img_file.img10,", 
               "cost.ima_file.ima531,", 
               "ima25.ima_file.ima25,",
#              "ima262.ima_file.ima262,",   #FUN-A40023
               "avl_stk.type_file.num15_3,",#FUN-A40023 
               "ima73.ima_file.ima73,",
               "ima74.ima_file.ima74,",
               "img15.img_file.img15,",
               "img16.img_file.img16,",
               "img18.img_file.img18,",
               "l_day.type_file.num10,",
               "delay.type_file.num10,",
               "ima71.ima_file.ima71,",
               "bz.type_file.chr1"
   LET l_table = cl_prt_temptable('cimr802',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?   ,?,?,?,?,?, ?)"          	     #---TQC-CC0074--add--
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',STATUS,1)  EXIT PROGRAM 
   END IF
   #No.FUN-840055--------end
 
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.f     = ARG_VAL(10)
   LET tm.g     = ARG_VAL(11)
   LET tm.h     = ARG_VAL(12)
   LET tm.b     = ARG_VAL(13)
   LET tm.c     = ARG_VAL(14)
   LET tm.zero  = ARG_VAL(15)
   LET tm.e     = ARG_VAL(16)
   LET tm.i     = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r802_tm(0,0)		# Input print condition
   ELSE
#No.FUN-590110 --start--
      CALL r802_2()                   # 多倉儲管理
#No.FUN-590110 --end--
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r802_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_flag        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col =16
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW r802_w AT p_row,p_col
        WITH FORM "cim/42f/cimr802"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '12'
   LET tm.f      = '1'
   LET tm.g      = '1'
   LET tm.h      = 'Y'
   LET tm.b      = 'Y'
   LET tm.c      = 'Y'
   LET tm.e      = 1
   LET tm.zero   = 'N'
   LET tm.i      = 9999
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm2.s1     = '1'
   LET tm2.s2     = '2'
   LET tm2.t1     = 'N'
   LET tm2.t2     = 'N'
WHILE TRUE
   IF g_sma.sma12 = 'N' THEN
      CONSTRUCT BY NAME tm.wc ON ima06,ima01,ima07
 
#No.FUN-570240 --start
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF

#--TQC-CC0074---add--star--
            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            END IF
            IF INFIELD(ima07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima07"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima07
               NEXT FIELD ima07
            END IF
            IF INFIELD(img02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img021"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img02
               NEXT FIELD img02
            END IF
#--TQC-CC0074---add--end--
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
      CONSTRUCT BY NAME  tm.wc ON ima06,ima01,img02,ima07
 
#No.FUN-570240 --start
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#--TQC-CC0074---add--star--
            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            END IF
            IF INFIELD(ima07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima07"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima07
               NEXT FIELD ima07
            END IF
            IF INFIELD(img02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img021"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img02
               NEXT FIELD img02
            END IF
#--TQC-CC0074---add--end--
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
 
   DISPLAY BY NAME tm.s,tm.f,tm.g,tm.h,tm.b,tm.c,tm.zero,tm.e,tm.i
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r802_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME #UI
                 tm2.s1,tm2.s2,tm2.t1,tm2.t2,
                 tm.f,tm.g,tm.h,tm.b,tm.c,tm.zero,tm.e,tm.i,
                 tm.more WITHOUT DEFAULTS
 
      AFTER FIELD f    #庫存成本
		 IF tm.f IS NULL OR tm.f NOT MATCHES'[12]' THEN
			NEXT FIELD f
     	 END IF
 
     AFTER FIELD  g    #採購性料件成本
         IF tm.g IS NULL OR tm.g = ' ' OR tm.g NOT MATCHES'[123]' THEN
			NEXT FIELD g
 		 END IF
 
     AFTER FIELD  h    #大宗發料是否列印
         IF tm.h IS NULL OR tm.h NOT MATCHES'[YN]' THEN
            NEXT FIELD h
         END IF
 
     AFTER FIELD  b    #雜項料件是否列印
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]' THEN
            NEXT FIELD b
         END IF
 
     AFTER FIELD c     #工程料件是否列印
         IF tm.c IS NULL OR tm.c NOT MATCHES'[YN]' THEN
            NEXT FIELD c
         END IF
 
     AFTER FIELD zero
         IF tm.zero IS NULL OR tm.zero NOT MATCHES'[YN]' THEN
            NEXT FIELD zero
         END IF
 
      AFTER FIELD e    #起始呆滯天數
         IF tm.e IS NULL THEN
            NEXT FIELD e
         END IF
 
      AFTER FIELD i    #截止呆滯天數
         IF tm.i IS NULL OR tm.i = ' ' OR tm.i < tm.e THEN
            NEXT FIELD i
         END IF
 
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         LET l_flag='N'
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.e IS NULL OR tm.e = 0 THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.e
         END IF
         IF tm.i IS NULL OR tm.i = ' ' OR tm.i < tm.e THEN
            LET l_flag='Y'
            DISPLAY BY NAME tm.i
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD f
         END IF
      #UI
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP CALL r802_wc()       # Detail condition
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r802_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cimr802'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cimr802','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.zero CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.i CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('cimr802',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r802_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
#No.FUN-590110 --start--
   CALL r802_2()                      # 多倉儲管理
#No.FUN-590110 --end--
   ERROR ""
END WHILE
CLOSE WINDOW r802_w
END FUNCTION
 
FUNCTION r802_wc()
   DEFINE l_wc   STRING     #TQC-630166
 
   OPEN WINDOW r802_w2 AT 2,2
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
   CLOSE WINDOW r802_w2
END FUNCTION
 
FUNCTION r802_2()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#          l_time     LIKE type_file.chr8,             # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
          l_sql      STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          l_sw       LIKE type_file.num5,                #No.MOD-6A0043 add
          l_fac      LIKE ima_file.ima86_fac, #No.MOD-6A0043 add
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     ima06    LIKE ima_file.ima06, #分群碼
                     ima01    LIKE ima_file.ima01, #料件編號
                     ima02    LIKE ima_file.ima02, #品名
                     ima021   LIKE ima_file.ima021,#規格   #FUN-5C0002
                     img02    LIKE img_file.img02, #倉庫代號
                     img03    LIKE img_file.img03, #存放位置
             #----TQC-CC0074--add--star-
                     gen02    LIKE gen_file.gen02,
                     imd02    LIKE imd_file.imd02,
                     ime03    LIKE ime_file.ime03,
             #----TQC-CC0074--add--star-
                     img04    LIKE img_file.img04, #批號
                     ima05    LIKE ima_file.ima05, #版本
                     ima08    LIKE ima_file.ima08, #來源
                     ima07    LIKE ima_file.ima07, #ABC 碼
                     ima25    LIKE ima_file.ima25, #庫存單位（單倉儲）
                     img09    LIKE img_file.img09, #庫存單位（多倉儲）
                     ima23    LIKE ima_file.ima23, #倉管員
                     ima30    LIKE ima_file.ima30, #最近盤點日期
                     ima73    LIKE ima_file.ima73, #上次入庫日
                     ima74    LIKE ima_file.ima74, #上次出庫日
                     ima902   LIKE ima_file.ima902,#呆滯日期
                     ima29    LIKE ima_file.ima29, #最近異動日期
                     img14    LIKE img_file.img14, #最近盤點日期
                     img15    LIKE img_file.img15, #最近收料日
                     img16    LIKE img_file.img16, #最近發料日
                     img37    LIKE img_file.img37, #呆滯日期
                     img17    LIKE img_file.img17, #最近異動日
                     img18    LIKE img_file.img18, #有效日期
                     img23    LIKE img_file.img23, #是否為可用倉儲
                     img22    LIKE img_file.img22, #倉儲類別
                     img24    LIKE img_file.img24, #MRP 可用否
                     img10    LIKE img_file.img10, #庫存數量
                     delay    LIKE type_file.num10, #呆滯天數  #No.FUN-690026 INTEGER
#                    ima262   LIKE ima_file.ima262,#庫存可用數量     #FUN-A40023
                     avl_stk  LIKE type_file.num15_3,                #FUN-A40023  
                     ima53    LIKE ima_file.ima53, #最近採購單價
                     ima531   LIKE ima_file.ima531,#市價
    		     ima86    LIKE  ima_file.ima86, #成本單位    #No.MOD-6A0043 add
                     cost     LIKE ima_file.ima531, #Cost
                     ima71    LIKE ima_file.ima71,
                     bz       LIKE type_file.chr1
                     END RECORD
DEFINE    l_day      LIKE type_file.num10   #No.FUN-840055
         ,l_avl_stk_mpsmrp  LIKE type_file.num15_3,   #FUN-A40023
          l_unavl_stk       LIKE type_file.num15_3,   #FUN-A40023
          l_avl_stk         LIKE type_file.num15_3    #FUN-A40023 
     
     #No.FUN-840055-------start--
     CALL cl_del_data(l_table)
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'cimr802'
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #FOR g_i = 1 TO 2
     #    CASE
     #       WHEN tm.s[g_i,g_i]='1'  LET g_x[24]=g_x[24] CLIPPED,' ',g_x[25]
     #       WHEN tm.s[g_i,g_i]='2'  LET g_x[24]=g_x[24] CLIPPED,' ',g_x[26]
     #       WHEN tm.s[g_i,g_i]='3'  LET g_x[24]=g_x[24] CLIPPED,' ',g_x[27]
     #       WHEN tm.s[g_i,g_i]='4'  LET g_x[24]=g_x[24] CLIPPED,' ',g_x[28]
     #       OTHERWISE EXIT CASE
     #    END CASE
     #END FOR
     #No.FUN-840055------end
#No.FUN-590110 --start--
   IF g_sma.sma12='Y' THEN
    #LET l_sql = " SELECT UNIQUE '','',ima06,ima01,ima02,img02,img03,",          #FUN-5C0002 mark
     LET l_sql = " SELECT UNIQUE '','',ima06,ima01,ima02,ima021,img02,img03,'','','',",   #FUN-5C0002 #-TQC-CC0074
                 " img04,ima05,ima08,ima07,'',img09,ima23,'','','','','',img14,",
                 " img15,img16,img37,img17,img18,img23,img22,img24,img10,'',",
                              #---------No.MOD-6A0043 modify
				#" ima262,ima53,ima531",
#				 " ima262,ima53,ima531,ima86",      #FUN-A40023
                                 " ' ',ima53,ima531,ima86,0,ima71,''",      #FUN-A40023
                              #---------No.MOD-6A0043 end
                 " FROM ima_file,img_file",
                 " WHERE ima01 = img01 ",
                 " AND ",tm.wc CLIPPED
     IF tm.h matches'[Nn]' THEN    #大宗發料件
        LET l_sql = l_sql CLIPPED," AND ima08 NOT IN ('U','V') "
 	 END IF
     IF tm.b matches'[Nn]' THEN     #雜項料件不列印
        LET l_sql = l_sql CLIPPED," AND ima08 NOT IN ('Z','z') "
     END IF
     IF tm.c matches'[Nn]' THEN    #工程料件
        LET l_sql = l_sql CLIPPED," AND ima14 NOT IN ('Y','y') "
 	 END IF
     IF tm.zero matches'[Nn]' THEN
        LET l_sql = l_sql CLIPPED," AND img10 != 0 "
 	 END IF
   ELSE
    #LET l_sql = " SELECT  '','',ima06,ima01,ima02,'','',",          #FUN-5C0002 mark
     LET l_sql = " SELECT  '','',ima06,ima01,ima02,ima021,'','',",   #FUN-5C0002
                 " '',ima05,ima08,ima07,ima25,'',ima23,ima30,ima73,ima74,",
                 " ima902,ima29,'',",
                 " '','','','','','','','','','',",
#				 " ima262,ima53,ima531,0",     #FUN-A40023
                                 " ' ',ima53,ima531,0,ima71,''",     #FUN-A40023
                 " FROM ima_file",
                 " WHERE ",tm.wc CLIPPED
     IF tm.h matches'[Nn]' THEN    #大宗發料件
        LET l_sql = l_sql CLIPPED," AND ima08 NOT IN ('U','V') "
         END IF
     IF tm.b matches'[Nn]' THEN     #雜項料件不列印
        LET l_sql = l_sql CLIPPED," AND ima08 NOT IN ('Z','z') "
     END IF
     IF tm.c matches'[Nn]' THEN    #工程料件
        LET l_sql = l_sql CLIPPED," AND ima14 NOT IN ('Y','y') "
         END IF
#     IF tm.zero matches'[Nn]' THEN                       #FUN-A40023 mark
#        LET l_sql = l_sql CLIPPED," AND ima262 != 0 "    #FUN-A40023 mark
#         END IF                                          #FUN-A40023 mark
   END IF
#No.FUN-590110 --end--
 
    #FUN-530001
    #小數位----------------------------------------------
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,zai05
#     INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#     WHERE azi01=g_azi.azi17
#NO.CHI-6A0004--END
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
 
     PREPARE r802_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r802_c2 CURSOR FOR r802_prepare2
 
     #CALL cl_outnam('cimr802') RETURNING l_name   #No.FUN-840055
#No.FUN-590110 --start--
     #No.FUN-840055-----start--
     IF g_sma.sma12='Y' THEN
        #LET g_zaa[38].zaa06='N'
        #LET g_zaa[39].zaa06='N'
        #LET g_zaa[40].zaa06='N'
        #LET g_zaa[41].zaa06='N'
        #LET g_zaa[42].zaa06='N'
        #LET g_zaa[43].zaa06='N'
        #LET g_zaa[49].zaa06='N'
        #LET g_zaa[50].zaa06='N'
        #LET g_zaa[51].zaa06='N'
        #LET g_zaa[47].zaa06='Y'
        #LET g_zaa[48].zaa06='Y'
        LET l_name = 'cimr802'
     ELSE
        #LET g_zaa[38].zaa06='Y'
        #LET g_zaa[39].zaa06='Y'
        #LET g_zaa[40].zaa06='Y'
        #LET g_zaa[41].zaa06='Y'
        #LET g_zaa[42].zaa06='Y'
        #LET g_zaa[43].zaa06='Y'
        #LET g_zaa[49].zaa06='Y'
        #LET g_zaa[50].zaa06='Y'
        #LET g_zaa[51].zaa06='Y'
        #LET g_zaa[47].zaa06='N'
        #LET g_zaa[48].zaa06='N'
        LET l_name = 'cimr802_1'
     END IF
     #No.FUN-840055----end
     CALL cl_prt_pos_len()
#No.FUN-590110 --end--
     #START REPORT r802_rep2 TO l_name  #No.FUN-840055
 
     LET g_pageno = 0
     FOREACH r802_c2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

#----TQC-CC0074---add--star---
     SELECT gen02 INTO sr.gen02  FROM gen_file WHERE gen01=sr.ima23
     SELECT imd02 INTO sr.imd02  FROM imd_file WHERE imd01=sr.img02
     SELECT ime03 INTO sr.ime03  FROM ime_file WHERE ime01=sr.img03
#----TQC-CC0074---add---end---
#No.FUN-A40023 ---start---
     LET sr.bz = 'Y'
     
      CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp, l_unavl_stk,l_avl_stk
      IF g_sma.sma12 != 'Y' THEN
         IF tm.zero matches'[Nn]' THEN
            IF l_avl_stk  = 0 THEN
               CONTINUE FOREACH
            END IF 
         END IF 
      END IF    
      LET sr.avl_stk = l_avl_stk
#No.FUN-A40023 ---end---

#No.FUN-590110 --start--
     IF g_sma.sma12='Y' THEN
       LET sr.delay = g_today - sr.img37  #呆滯天數
     ELSE
       LET sr.delay = g_today - sr.ima902
     END IF
#No.FUN-590110 --end--
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
	   IF sr.img02 IS NULL THEN LET sr.img02 = ' ' END IF
	   IF sr.ima07 IS NULL THEN LET sr.ima07 = ' ' END IF
	     #No.FUN-840055-----start--
       #FOR g_i = 1 TO 2
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima06
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima01
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img02
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima07
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #No.FUN-840055-----END
          IF sr.ima08 MATCHES'[PVZ]' THEN   #採購性料件
          CASE tm.g
  		     WHEN '1'       #同庫存成本之選擇
  	     	     IF tm.f = '1'
		             THEN CALL s_cost('1',sr.ima08,sr.ima01)
     		             RETURNING sr.cost    #標準成本
     		        ELSE CALL s_cost('2',sr.ima08,sr.ima01)
     	   	             RETURNING sr.cost    #實際成本
     		     END IF
 		     WHEN '2' LET sr.cost = sr.ima53      #依最近採購單價
 		     WHEN '3' LET sr.cost = sr.ima531      #依市價
              OTHERWISE EXIT CASE
	      END CASE
        ELSE
 	     IF tm.f = '1'
	         THEN CALL s_cost('1',sr.ima08,sr.ima01)
	              RETURNING sr.cost    #標準成本
	         ELSE CALL s_cost('2',sr.ima08,sr.ima01)
	              RETURNING sr.cost    #實際成本
	      END IF
       END IF
#No.FUN-590110 --start--
     IF g_sma.sma12='Y' THEN
      #----------No.MOD-6A0043 add
       CALL s_umfchk(sr.ima01,sr.img09,sr.ima86)
                    RETURNING l_sw,l_fac
       IF l_sw = '1' THEN
          LET l_fac =1
       END IF
      #LET sr.cost = sr.cost * sr.img10            #庫存成本
       LET sr.cost = sr.cost * sr.img10 * l_fac    #庫存成本
      #----------No.MOD-6A0043 end
     ELSE
#      LET sr.cost = sr.cost * sr.ima262    #庫存成本         #FUN-A40023
       LET sr.cost = sr.cost * sr.avl_stk   #FUN-A40023
     END IF
#No.FUN-590110 --end--
       IF sr.delay >= tm.e AND sr.delay < tm.i THEN    #介於天數區間
          #No.FUN-840055-----start--
          IF cl_null(sr.img18)  OR sr.img18=MDY(12,31,9999)
               THEN LET l_day=''
          ELSE LET l_day = sr.img18 - g_today   #有效截止天數
          END IF 
          IF sr.ima71 / 2 >  l_day THEN 
             LET sr.bz='N'
          END IF
          EXECUTE insert_prep USING
              sr.ima06,sr.ima01,sr.ima02,sr.ima021,sr.ima05,sr.ima08,sr.ima07, 
              sr.ima23,sr.img02,sr.img03,sr.gen02,sr.imd02,sr.ime03,sr.img04,sr.img22,sr.img23,sr.img24, 
               #---TQC-CC0074--addsr.gen02,sr.imd02,sr.ime03
#             sr.img09,sr.img10,sr.cost,sr.ima25,sr.ima262,sr.ima73,sr.ima74,   #FUN-A40023
              sr.img09,sr.img10,sr.cost,sr.ima25,sr.avl_stk,sr.ima73,sr.ima74,  #FUN-A40023  
              sr.img15,sr.img16,sr.img18,l_day,sr.delay,sr.ima71,sr.bz
          #OUTPUT TO REPORT r802_rep2(sr.*)
          #No.FUN-840055-----end                    
       END IF
     END FOREACH
 
     #No.FUN-840055-----start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 	= 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ima06,ima01,img02,ima07')
            RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",
                 tm.t[2,2],";",tm.f,";",tm.g,";",g_sma.sma12,";",g_azi03 
                 
     CALL cl_prt_cs3('cimr802',l_name,g_sql,g_str)   
     #FINISH REPORT r802_rep2
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-840055-----end
END FUNCTION
 
#No.FUN-840055-----start--
#REPORT r802_rep2(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          l_day      LIKE type_file.num10,   #No.FUN-690026 INTEGER
#          sr         RECORD
#                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     ima06    LIKE ima_file.ima06, #分群碼
#                     ima01    LIKE ima_file.ima01, #料件編號
#                     ima02    LIKE ima_file.ima02, #品名
#                     ima021   LIKE ima_file.ima021,#規格   #FUN-5C0002
#                     img02    LIKE img_file.img02, #倉庫代號
#                     img03    LIKE img_file.img03, #存放位置
#                     img04    LIKE img_file.img04, #批號
#                     ima05    LIKE ima_file.ima05, #版本
#                     ima08    LIKE ima_file.ima08, #來源
#                     ima07    LIKE ima_file.ima07, #ABC 碼
#                     ima25    LIKE ima_file.ima25, #庫存單位（單倉儲）
#                     img09    LIKE img_file.img09, #庫存單位（多倉儲）
#                     ima23    LIKE ima_file.ima23, #倉管員
#                     ima30    LIKE ima_file.ima30, #最近盤點日期
#                     ima73    LIKE ima_file.ima73, #上次入庫日
#                     ima74    LIKE ima_file.ima74, #上次出庫日
#                     ima902   LIKE ima_file.ima902,#呆滯日期
#                     ima29    LIKE ima_file.ima29, #最近異動日期
#                     img14    LIKE img_file.img14, #最近盤點日期
#                     img15    LIKE img_file.img15, #最近收料日
#                     img16    LIKE img_file.img16, #最近發料日
#                     img37    LIKE img_file.img37, #呆滯日期
#                     img17    LIKE img_file.img17, #最近異動日
#                     img18    LIKE img_file.img18, #有效日期
#                     img23    LIKE img_file.img23, #是否為可用倉儲
#                     img22    LIKE img_file.img22, #倉儲類別
#                     img24    LIKE img_file.img24, #MRP 可用否
#                     img10    LIKE img_file.img10, #庫存數量
#                     delay    LIKE type_file.num10, #呆滯天數  #No.FUN-690026 INTEGER
#                     ima262   LIKE ima_file.ima262,#庫存可用數量
#                     ima53    LIKE ima_file.ima53, #最近採購單價
#                     ima531   LIKE ima_file.ima531,#市價
#    		     ima86    LIKE  ima_file.ima86, #成本單位    #No.MOD-6A0043 add
#                     cost     LIKE ima_file.ima531 #Cost
#                     END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#      ORDER BY sr.order1,sr.order2,sr.ima06,sr.ima01
#  FORMAT
#   PAGE HEADER
##No.FUN-590110 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      LET g_pageno = g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT COLUMN (g_len-FGL_WIDTH(g_x[23]))/2,g_x[23]
#      PRINT g_dash[1,g_len]
#     #PRINT g_x[53],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#      PRINT g_x[53],g_x[31],g_x[32],g_x[33],g_x[54],g_x[34],g_x[35],g_x[36],
#            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],
#            g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#            g_x[51],g_x[52]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.ima06    #分群碼
#      IF sr.ima08 MATCHES'[UV]' THEN
#         PRINT COLUMN g_c[53],'*';
#      END IF
#      PRINT COLUMN g_c[31],sr.ima06 CLIPPED;
#
#   BEFORE GROUP OF sr.ima01    #料件編號
#      PRINT COLUMN g_c[32],sr.ima01 CLIPPED,        #FUN-5B0014 [1,20] CLIPPED,
#            COLUMN g_c[33],sr.ima02 CLIPPED,
#            COLUMN g_c[54],sr.ima021 CLIPPED,   #FUN-5C0002
#            COLUMN g_c[34],sr.ima05 CLIPPED,
#	    COLUMN g_c[35],sr.ima08 CLIPPED,
#            COLUMN g_c[36],sr.ima07 CLIPPED,
#            COLUMN g_c[37],sr.ima23; #MOD-570300  91->95
#
#   ON EVERY ROW
#      IF cl_null(sr.img18)  OR sr.img18=MDY(12,31,9999)
#         THEN LET l_day=''
#         ELSE LET l_day = sr.img18 - g_today   #有效截止天數
#       END IF
#      IF sr.img23 matches'[Nn]' THEN
#          PRINT COLUMN g_c[38],'* ',sr.img02[1,10];
#      ELSE
#          PRINT COLUMN g_c[38],sr.img02[1,10];
#      END IF
#      PRINT
#            COLUMN  g_c[39],sr.img03[1,10],
#            COLUMN  g_c[40],sr.img04[1,10],
#            COLUMN  g_c[41],sr.img22 CLIPPED,
#            COLUMN  g_c[42],sr.img23,
#            COLUMN  g_c[43],sr.img24 CLIPPED;
#        IF g_sma.sma12='Y' THEN
#            PRINT COLUMN  g_c[44],sr.img09 CLIPPED,
#                  COLUMN  g_c[45],cl_numfor(sr.img10,45,3), #MOD-570300
#                  COLUMN  g_c[46],cl_numfor(sr.cost,46,g_azi03); #MOD-570300
#        ELSE
#            PRINT COLUMN  g_c[44],sr.ima25 CLIPPED,
#                  COLUMN  g_c[45],sr.ima262 using '----------&.&&&',
#                  COLUMN  g_c[46],cl_numfor(sr.cost,46,g_azi03);
#        END IF
#      PRINT COLUMN g_c[47],sr.ima73,
#            COLUMN g_c[48],sr.ima74,
#            COLUMN g_c[49],sr.img15, #MOD-570300 108->114
#            COLUMN g_c[50],sr.img16, #MOD-570300 117->123
#            COLUMN g_c[51],l_day    using '-------&', #MOD-570300 123->129
#            COLUMN g_c[52],sr.delay using '#######&'
#
#   ON LAST ROW
#      PRINT
##      PRINT COLUMN 62,'Total:',SUM(sr.cost)
#      PRINT COLUMN g_c[45],g_x[24],
#            COLUMN g_c[46],SUM(sr.cost) USING '#############&.&&&'
##No.FUN-590110 --end--
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN			# for 132
##		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-840055---end
#Patch....NO.TQC-610036 <> #
