# Prog. Version..: '5.30.07-13.05.30(00003)'     #
# Pattern name...: aimx521.4gl
# Descriptions...:多餘短缺庫存檢核表
# Input parameter:
# Return code....:
# Date & Author..: 92/05/18 BY MAY
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 將料號欄位位置放大成40碼
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680025 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.MOD-A60093 10/06/14 By Sarah x521_2()段,imf_file是OUTER table,應將imf04條件移到FOREACH裡再做判斷
# Modify.........: No.FUN-C30190 12/03/29 By xumeimei 原报表改为CR报表
# Modify.........: No.FUN-CB0005 12/11/02 By chenying CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By yangtt 去掉頁脚排序顯示 
# Modify.........: No:FUN-D40129 13/05/07 By yangtt 1、WHERE條件錯誤  2、ima09,ima10,ima11新增開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			# Print condition RECORD
           wc   STRING,                 # Where Condition    #TQC-630166
           b    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,    # 排列順序           #No.FUN-690026 VARCHAR(03)
           y    LIKE type_file.chr1,    # group code choice  #No.FUN-690026 VARCHAR(1)
           more LIKE type_file.chr1     # 特殊列印條件       #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5          #count/index for any purpose  #No.FUN-690026 SMALLINT
#FUN-C30190 -----------STA
DEFINE g_sql     STRING
DEFINE g_str     STRING
DEFINE l_table   STRING
DEFINE l_table1  STRING
#FUN-C30190------------END
 
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

#FUN-C30190 --------------STA 
   IF g_sma.sma12 = 'N' THEN
      LET g_sql = "order1.ima_file.ima01,",
                  "order2.ima_file.ima01,",
                  "order3.ima_file.ima01,",
#FUN-CB0005--add--str---
                  "img01.img_file.img01,",
                  "img02.img_file.img02,",
                  "img03.img_file.img03,",
                  "img04.img_file.img04,",
                  "img09.img_file.img09,",
                  "img10.img_file.img10,",
                  "imf04.imf_file.imf04,",
#FUN-CB0005--add--str---
                  "ima01.ima_file.ima01,",
                  "ima02.ima_file.ima02,",
                  "ima021.ima_file.ima021,",     #FUN-CB0005 add
                  "ima05.ima_file.ima05,",
                  "ima06.ima_file.ima06,",
                  "ima09.ima_file.ima09,",
                  "ima10.ima_file.ima10,",
                  "ima11.ima_file.ima11,",
                  "ima12.ima_file.ima12,",
                  "ima07.ima_file.ima07,",
                  "ima08.ima_file.ima08,",
                  "ima25.ima_file.ima25,",
                  "avl_stk_mpsmrp.type_file.num15_3,",
                  "ima271.ima_file.ima271,",
                  "diff.img_file.img10,",
                  "sta.type_file.chr1,",
                  "l_sta.type_file.chr100,",    #FUN-CB0005 add
                  "l_num.type_file.num5,",        #FUN-CB0005 add
                  " imd02.imd_file.imd02,",      #FUN-CB0005 add
               " ime03.ime_file.ime03 "          #FUN-CB0005 add
      LET l_table = cl_prt_temptable('aimx521',g_sql) CLIPPED
      IF l_table = -1 THEN EXIT PROGRAM END IF
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #FUN-CB0005 add 12? 
      PREPARE insert_prep FROM g_sql
      IF STATUS THEN 
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
      END IF
   ELSE
      LET g_sql = "order1.ima_file.ima01,",
                  "order2.ima_file.ima01,",
                  "order3.ima_file.ima01,",
                  "img01.img_file.img01,",
                  "img02.img_file.img02,",
                  "img03.img_file.img03,",
                  "img04.img_file.img04,",
                  "img09.img_file.img09,",
                  "img10.img_file.img10,",
                  "imf04.imf_file.imf04,",
                  "ima01.ima_file.ima01,",   #FUN-CB0005
                  "ima02.ima_file.ima02,",
                  "ima021.ima_file.ima021,",  #FUN-CB0005
                  "ima05.ima_file.ima05,",
                  "ima06.ima_file.ima06,",
                  "ima09.ima_file.ima09,",
                  "ima10.ima_file.ima10,",
                  "ima11.ima_file.ima11,",
                  "ima12.ima_file.ima12,",
                  "ima07.ima_file.ima07,",
                  "ima08.ima_file.ima08,",
#FUN-CB0005--add--str--
                  "ima25.ima_file.ima25,",
                  "avl_stk_mpsmrp.type_file.num15_3,",
                  "ima271.ima_file.ima271,",
#FUN-CB0005--add--end--
                  "diff.img_file.img10,",
                  "sta.type_file.chr1,",
                  "l_sta.type_file.chr100,",    #FUN-CB0005 add
                  "l_num.type_file.num5,",        #FUN-CB0005 add
                  " imd02.imd_file.imd02,",      #FUN-CB0005 add
               " ime03.ime_file.ime03 "          #FUN-CB0005 add
      LET l_table1 = cl_prt_temptable('aimx521',g_sql) CLIPPED
      IF l_table1 = -1 THEN EXIT PROGRAM END IF
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?) "  #FUN-CB0005 add 9? 
      PREPARE insert_prep1 FROM g_sql
      IF STATUS THEN 
         CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
      END IF
   END IF
#FUN-C30190 --------------END 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.b = ARG_VAL(08)
   LET tm.s = ARG_VAL(9)
   LET tm.y = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL x521_tm(0,0)		    # Input print condition
   ELSE
      IF g_sma.sma12 = 'N' THEN         # Read data and create out-file
         CALL x521_1()		            # 單倉儲管理	
      ELSE
         CALL x521_2()                      # 多倉儲管理
      END IF
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION x521_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW x521_w AT p_row,p_col
        WITH FORM "aim/42f/aimx521"
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more   = 'N'
   LET tm.s      = '123'
   LET tm.b      = '3'
   LET tm.y      = '0'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm2.s1    = '1'
   LET tm2.s2    = '2'
   LET tm2.s3    = '3'
WHILE TRUE
   IF g_sma.sma12 = 'N' THEN
      CONSTRUCT BY NAME tm.wc ON ima01,ima07,ima06,ima09,ima10,ima11,ima12
 
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
       #FUN-CB0005---ADD--
            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima06"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            END IF
            IF INFIELD(ima12) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima12_1"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            END IF
            IF INFIELD(img02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img02" 
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img02
               NEXT FIELD img02
            END IF
            IF INFIELD(img03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img32"  
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img03
               NEXT FIELD img03
            END IF
       #FUN-CB0005---END--
#No.FUN-570240 --end
            #FUN-D40129----add---str---
            IF INFIELD(ima07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima07
               NEXT FIELD ima07
            END IF
            IF INFIELD(ima09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima09_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            END IF
            IF INFIELD(ima10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima10_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima10 
            END IF
            IF INFIELD(ima11) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima11_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            END IF
            #FUN-D40129----add---end---
 
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
 
   ELSE
      CONSTRUCT BY NAME  tm.wc ON ima01,ima07,ima06,ima09,ima10,
                                 ima11,ima12,img02,img03
 
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
       #FUN-CB0005---ADD--
            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima06"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            END IF
            IF INFIELD(ima12) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima12_1"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            END IF
            IF INFIELD(img02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img02"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img02
               NEXT FIELD img02
            END IF
            IF INFIELD(img03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img32"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img03
               NEXT FIELD img03
            END IF
       #FUN-CB0005---END---
#No.FUN-570240 --end
            #FUN-D40129----add---str---
            IF INFIELD(ima07) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima07
               NEXT FIELD ima07
            END IF
            IF INFIELD(ima09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima09_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            END IF
            IF INFIELD(ima10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima10_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima10
            END IF
            IF INFIELD(ima11) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima11_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            END IF
            #FUN-D40129----add---end---
 
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
 
 
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW x521_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.b,tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b = ' ' OR tm.b NOT MATCHES'[123]' THEN
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW x521_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimx521'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimx521','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimx521',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW x521_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
#  LET g_sma.sma12='N'               #FUN-680025
   IF g_sma.sma12 = 'N' THEN         # Read data and create out-file
      CALL x521_1()		        # 單倉儲管理	
   ELSE
      CALL x521_2()                      # 多倉儲管理
   END IF
   ERROR ""
END WHILE
CLOSE WINDOW x521_w
END FUNCTION
 
#單倉
FUNCTION x521_1()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                            # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD
                     order1   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE  ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#FUN-CB0005---add---str---
                     img01    LIKE img_file.img01, #料件編號
                     img02    LIKE img_file.img02, #倉庫代號
                     img03    LIKE img_file.img03, #存放位置
                     img04    LIKE img_file.img04, #批號
                     img09    LIKE img_file.img09,
                     img10    LIKE img_file.img10,
                     imf04    LIKE imf_file.imf04,           
#FUN-CB0005---add---end---
                     ima01    LIKE  ima_file.ima01, #料件編號
                     ima02    LIKE  ima_file.ima02, #品名規格
                     ima021   LIKE  ima_file.ima021,     #FUN-CB0005
                     ima05    LIKE  ima_file.ima05, #版本
                     ima06    LIKE  ima_file.ima06, #分群碼
                     ima09    LIKE  ima_file.ima09, #
                     ima10    LIKE  ima_file.ima10, #
                     ima11    LIKE  ima_file.ima11, #
                     ima12    LIKE  ima_file.ima12, #
                     ima07    LIKE  ima_file.ima07, #ABC 碼
                     ima08    LIKE  ima_file.ima08, #來源
                     ima25    LIKE  ima_file.ima25, #庫存單位
#                    ima26    LIKE  ima_file.ima26, #        #FUN-A20044
                     avl_stk_mpsmrp LIKE type_file.num15_3,  #FUN-A20044      
                     ima271   LIKE  ima_file.ima271,#
#		     diff     LIKE  ima_file.ima261,#差異    #FUN-A20044
                     diff     LIKE type_file.num15_3,        #FUN-A20044 
                     sta      LIKE  type_file.chr1  #狀態  #No.FUN-690026 VARCHAR(1)
                     END RECORD
          ,l_avl_stk_mpsmrp   LIKE type_file.num15_3,        #FUN-A20044
           l_unavl_stk        LIKE type_file.num15_3,        #FUN-A20044
           l_avl_stk          LIKE type_file.num15_3         #FUN-A20044  
     DEFINE l_sta   LIKE type_file.chr100  #FUN-CB0005 add
     DEFINE l_num   LIKE type_file.num5    #FUN-CB0005 add
     DEFINE l_str   STRING   #FUN-CB0005 add
     DEFINE l_imd02    LIKE imd_file.imd02  #FUN-CB0005
     DEFINE l_ime03    LIKE ime_file.ime03  #FUN-CB0005

     CALL cl_del_data(l_table)                     #FUN-C30190 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimx521'
    #LET g_len = 85    #TQC-5B0019
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
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
 
     LET l_sql = " SELECT UNIQUE ' ',' ',' ','','','','','',0,0,ima01,ima02,ima021,ima05,ima06,",  #FUN-CB0005 add 5'',0,0,ima021
                 " ima09, ima10, ima11,ima12, ",
#                " ima07,ima08,ima25,ima261 + ima262,ima271,",   #FUN-A20044
#                " (ima261 + ima262) - ima271,''",               #FUN-A20044
                 " ima07,ima08,ima25,' ',ima271,",               #FUN-A20044
                 " ' ' ,''",                                     #FUN-A20044 
                 " FROM ima_file",
#                " WHERE (ima261 + ima262) != ima271 ",          #FUN-A20044
#                " AND ",tm.wc CLIPPED                           #FUN-A20044
                 " WHERE ",tm.wc CLIPPED                         #FUN-A20044  

#No.FUN-A20044 ---mark---start 
#     IF tm.b = '1' THEN     #多餘料件
#        LET l_sql = l_sql CLIPPED," AND (ima261 + ima262) - ima271 > 0 "
#     END IF
#     IF tm.b = '2' THEN     #短缺料件
#        LET l_sql = l_sql CLIPPED," AND (ima261 + ima262) - ima27  < 0 "
#     END IF
#No.FUN-A20044 ---mark---end 

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
 
     PREPARE x521_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM 
         END IF
     DECLARE x521_c1 CURSOR FOR x521_prepare1
 
     #CALL cl_outnam('aimx521') RETURNING l_name              #FUN-C30190 mark
     #START REPORT x521_rep1 TO l_name                        #FUN-C30190 mark
#FUN-680035--begin
     LET g_pageno = 0
     LET g_zaa[36].zaa06='Y'                                                                                                        
     LET g_zaa[37].zaa06='Y'                                                                                                        
     LET g_zaa[38].zaa06='Y'                                                                                                        
     LET g_zaa[39].zaa06='Y'                                                                                                        
     LET g_zaa[40].zaa06='Y'
     LET g_zaa[50].zaa06='Y'                                                                                                        
     LET g_zaa[51].zaa06='Y'                                                                                                        
     LET g_zaa[52].zaa06='Y'                                                                                                        
     LET g_zaa[53].zaa06='Y'                                                                                                        
     LET g_zaa[54].zaa06='Y' 
     CALL cl_prt_pos_len()                          
 #FUN-680025--end
     FOREACH x521_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF

#No.FUN-A20044 ---start---
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp, l_unavl_stk,l_avl_stk
       IF (l_avl_stk + l_unavl_stk) = sr.ima271 THEN
           CONTINUE FOREACH
       ELSE
          IF tm.b = '1' THEN
             IF l_unavl_stk + l_avl_stk  - sr.ima271 <= 0 THEN
                CONTINUE FOREACH
             END IF 
          END IF  
          IF tm.b = '2' THEN 
             IF l_unavl_stk + l_avl_stk - sr.ima271 >= 0 THEN   
                CONTINUE FOREACH
             END IF 
          END IF 
       END IF 
       LET sr.avl_stk_mpsmrp = l_avl_stk + l_unavl_stk 
       LET  sr.diff = l_unavl_stk + l_avl_stk - sr.ima271
#No.FUN-A20044 ----end---       

       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima07
               WHEN tm.s[g_i,g_i] = '3'
               CASE
                  WHEN tm.y ='0'  LET l_order[g_i] = sr.ima06
                  WHEN tm.y ='1'  LET l_order[g_i] = sr.ima09
                  WHEN tm.y ='2'  LET l_order[g_i] = sr.ima10
                  WHEN tm.y ='3'  LET l_order[g_i] = sr.ima11
                  WHEN tm.y ='4'  LET l_order[g_i] = sr.ima12
               END CASE
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF sr.ima271 = 0 THEN   #若最高存放量為零則不顯示此筆資料為多餘或缺
          LET sr.sta = ' '
       ELSE
          IF sr.diff > 0 THEN   #多餘
		     LET sr.sta =  '1'
          ELSE LET sr.sta = '2'
	      END IF
       END IF
       CASE sr.sta   #FUN-CB0005 add
          WHEN '1'  LET l_sta = cl_getmsg('aim-080',g_lang)   #FUN-CB0005 add
          WHEN '2'  LET l_sta = cl_getmsg('aim-081',g_lang)   #FUN-CB0005 add
          OTHERWISE LET l_sta = " "     #FUN-CB0005 add
       END CASE   #FUN-CB0005 add
       LET l_num = 3   #FUN-CB0005 add
       SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = sr.img02   #FUN-CB0005 add
      #SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime01 = sr.img03   #FUN-CB0005 add  #FUN-D40129 mark
       SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime02 = sr.img03   #FUN-D40129 add
       #OUTPUT TO REPORT x521_rep1(sr.*)              #FUN-C30190 mark
       EXECUTE insert_prep USING sr.*,l_sta,l_num,l_imd02,l_ime03     #FUN-C30190 add   #FUN-CB0005 add l_sta,l_num,l_imd02,l_ime03
     END FOREACH
 
     #FINISH REPORT x521_rep1                         #FUN-C30190 mark
  
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #FUN-C30190 mark
     #FUN-C30190-----add---str----
###XtraGrid###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY order1,order2,order3,diff"
     CALL cl_wcchp(tm.wc,'ima01')
          RETURNING tm.wc
###XtraGrid###     LET g_str = tm.wc
###XtraGrid###     CALL cl_prt_cs3("aimx521","aimx521_1",l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = 'aimx521'   #FUN-CB0005 add
    #FUN-CB0005----add----str--
    CASE tm.y
       WHEN 0
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima06")  #FUN-CB0005 add
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima06")  #FUN-D30070  mark
       WHEN 1
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima09")  #FUN-CB0005 add
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima09")  #FUN-D30070  mark
       WHEN 2
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima10")  #FUN-CB0005 add
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima10")  #FUN-D30070  mark
       WHEN 3
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima11")  #FUN-CB0005 add
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima11")  #FUN-D30070  mark
       WHEN 4
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima12")  #FUN-CB0005 add
         #LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima12")   #FUN-D30070  mark
    END CASE
   #LET l_str = cl_replace_str(l_str,',','-')  #FUN-D30070  mark
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str  #FUN-D30070
    #FUN-CB0005----add----end--
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-CB0005 add
    CALL cl_xg_view()    ###XtraGrid###
     #FUN-C30190-----add---end----
END FUNCTION

#FUN-C30190--------mark------str-----  
#REPORT x521_rep1(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	  l_sta      LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(04)
#          sr         RECORD
#                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     ima01    LIKE ima_file.ima01, #料件編號
#                     ima02    LIKE ima_file.ima02, #品名規格
#                     ima05    LIKE ima_file.ima05, #版本
#                     ima06    LIKE ima_file.ima06, #分群碼
#                     ima09    LIKE ima_file.ima09, #
#                     ima10    LIKE ima_file.ima10, #
#                     ima11    LIKE ima_file.ima11, #
#                     ima12    LIKE ima_file.ima12, #
#                     ima07    LIKE ima_file.ima07, #ABC 碼
#                     ima08    LIKE ima_file.ima08, #來源
#                     ima25    LIKE ima_file.ima25, #庫存單位
##                    ima26    LIKE ima_file.ima26, #       #FUN-A20044
#                     avl_stk_mpsmrp LIKE type_file.num15_3,#FUN-A20044   
#                     ima271   LIKE ima_file.ima271,#
##                    diff     LIKE ima_file.ima261,#差異   #FUN-A20044
#                     diff     LIKE type_file.num15_3,      #FUN-A20044 
#                     sta      LIKE type_file.chr1  #狀態  #No.FUN-690026 VARCHAR(1)
#                     END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.diff
#  FORMAT
#   PAGE HEADER
##FUN-680025--begin
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' ' THEN
##        PRINT '';
##     ELSE
##        PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            LET g_pageno = g_pageno + 1 
#            LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]     
##FUN--680025--end
#      PRINT g_dash[1,g_len]
##FUN-680025--begin
##     PRINT g_x[11] CLIPPED,g_x[12] CLIPPED
##     PRINT g_x[13] CLIPPED,
##          #start TQC-5B0019
##          #COLUMN 41,g_x[14] CLIPPED,
##          #COLUMN 82,g_x[23] CLIPPED
##           COLUMN  58,g_x[14] CLIPPED,
##            COLUMN 100,g_x[23] CLIPPED
##          #end TQC-5B0019
##    #PRINT "-------------------- -  -    -  ----   ---- ",                      #TQC-5B0019 mark
##     PRINT "---------------------------------------- -  -  -   ------ ---- ",   #TQC-5B0019
##           "----------------- ----------------- ----"
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],
#             g_x[35],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],
#             g_x[49],g_x[55],g_x[56],g_x[57],g_x[58]
#      PRINT g_dash1
##FUN-680025--end
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#	  CALL x521_sta(sr.sta) RETURNING l_sta
##FUN-680025--begin
##    PRINT sr.ima01,      
#     PRINTX name=D1 COLUMN g_c[31],sr.ima01,
#     #start TQC-5B0019
#     #      COLUMN 23,sr.ima05,
#     #      COLUMN 26,sr.ima08,
#     #      COLUMN 31,sr.ima07,
#     #      COLUMN 34,sr.ima06,
#     #      COLUMN 41,sr.ima25,
#     #      COLUMN 46,sr.ima26  USING '------------&.&&&',
#     #      COLUMN 64,sr.diff   USING '------------&.&&&' ,
#     #      ' ' ,l_sta
##           COLUMN 42,sr.ima05,
##           COLUMN 45,sr.ima08,
##           COLUMN 48,sr.ima07,
##           COLUMN 52,sr.ima06,
##           COLUMN 59,sr.ima25,
##           COLUMN 64,sr.ima26  USING '------------&.&&&',
##           COLUMN 82,sr.diff   USING '------------&.&&&' ,
##           ' ' ,l_sta
#            COLUMN g_c[32],sr.ima05,
#            COLUMN g_c[33],sr.ima08,
#            COLUMN g_c[34],sr.ima07,
#            COLUMN g_c[35],sr.ima06,
#            COLUMN g_c[41],sr.ima25,
##           COLUMN g_c[42],cl_numfor(sr.ima26,42,3),          #FUN-A20044
#            COLUMN g_c[42],cl_numfor(sr.avl_stk_mpsmrp,42,3), #FUN-A20044
#            COLUMN g_c[43],cl_numfor(sr.diff,43,3), 
#            COLUMN g_c[44],l_sta 
#     #PRINT COLUMN  6,sr.ima01,
#     #      COLUMN 46,sr.ima271 USING '------------&.&&&'
##     PRINT COLUMN  6,sr.ima02,
##           COLUMN 82,sr.ima271 USING '------------&.&&&'
#      PRINTX name=D2 COLUMN  g_c[45],sr.ima02,
#            COLUMN g_c[56],cl_numfor(sr.ima271,56,3) 
#     #end TQC-5B0019
##FUN-680025-end
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        #str MOD-A60093 add
#         IF g_sma.sma12 = 'N' THEN
#            CALL cl_wcchp(tm.wc,'ima01,ima07,ima06,ima09,ima10,ima11,ima12')
#                 RETURNING tm.wc
#         ELSE
#            CALL cl_wcchp(tm.wc,'ima01,ima07,ima06,ima09,ima10,ima11,ima12,img02,img03')
#                 RETURNING tm.wc
#         END IF
#        #end MOD-A60093 add
#         PRINT g_dash[1,g_len]
##TQC-630166
##        IF tm.wc[001,070] > ' ' THEN			# for 80
##	    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##        IF tm.wc[071,140] > ' ' THEN
## 	    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##        IF tm.wc[141,210] > ' ' THEN
## 	    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##        IF tm.wc[211,280] > ' ' THEN
## 	    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##        IF tm.wc[001,120] > ' ' THEN			# for 132
##	    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##        IF tm.wc[121,240] > ' ' THEN
##	    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##        IF tm.wc[241,300] > ' ' THEN
##	    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#FUN-C30190--------mark------end----- 
 
FUNCTION x521_sta(p_cmd)
DEFINE   l_sta     LIKE zaa_file.zaa08,   #No.FUN-690026 VARCHAR(04)
         p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
      CASE p_cmd
		   WHEN '1' LET l_sta = g_x[15] CLIPPED
		   WHEN '2' LET l_sta = g_x[16] CLIPPED
		   OTHERWISE LET l_sta =  ' '
      END CASE
	  RETURN l_sta
END FUNCTION
 
#--->多倉
FUNCTION x521_2()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
    #     l_sql      LIKE type_file.chr1000,          # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)  #FUN-CB0005
          l_sql      STRING,                          # FUN-CB0005 
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
	  l_sta      LIKE zaa_file.zaa08,             #No.FUN-690026 VARCHAR(04)
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     img01    LIKE img_file.img01, #料件編號
                     img02    LIKE img_file.img02, #倉庫代號
                     img03    LIKE img_file.img03, #存放位置
                     img04    LIKE img_file.img04, #批號
                     img09    LIKE img_file.img09,
                     img10    LIKE img_file.img10,
                     imf04    LIKE imf_file.imf04, #MOD-A60093 mod img19->imf04
                     ima01    LIKE  ima_file.ima01, #料件編號    #FUN-CB0005
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021, #FUN-CB0005 add
                     ima05    LIKE ima_file.ima05,
                     ima06    LIKE ima_file.ima06,
                     ima09    LIKE ima_file.ima09, #
                     ima10    LIKE ima_file.ima10, #
                     ima11    LIKE ima_file.ima11, #
                     ima12    LIKE ima_file.ima12, #
                     ima07    LIKE ima_file.ima07,
                     ima08    LIKE ima_file.ima08,
                     ima25    LIKE  ima_file.ima25, #庫存單位  #FUN-CB0005
                     avl_stk_mpsmrp LIKE type_file.num15_3,    #FUN-CB0005
                     ima271   LIKE  ima_file.ima271,           #FUN-CB0005              
                     diff     LIKE img_file.img10, #MOD-A60093 mod
                     sta      LIKE type_file.chr1  #No.FUN-690026 VARCHAR(04)
                     END RECORD
     DEFINE l_sta1  LIKE type_file.chr100  #FUN-CB0005 add
     DEFINE l_num1  LIKE type_file.num5    #FUN-CB0005 add
     DEFINE l_str   STRING   #FUN-CB0005 add
     DEFINE l_imd02    LIKE imd_file.imd02  #FUN-CB0005
     DEFINE l_ime03    LIKE ime_file.ime03  #FUN-CB0005	
   
     CALL cl_del_data(l_table1)                     #FUN-C30190 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE x521_zc2 CURSOR FOR
                  SELECT za02,za05
                    FROM za_file
                    WHERE za01 = "aimx521" AND za03 = g_lang
     FOREACH x521_zc2 INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimx521'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #最高存放量改成由imf_file抓取
     LET l_sql = " SELECT UNIQUE '','','',img01,img02,img03,",   
                #"               img04,img09,img10,imf04,ima02,",   #MOD-A60093 mark
                 "               img04,img09,img10,0,'',ima02,ima021,",       #MOD-A60093  #FUN-CB0005 add 1'' #FUN-CB0005 add ima021
                 "               ima05,ima06,ima09,ima10,ima11,ima12, ",
                #"               ima07,ima08,(img10-imf04),''",     #MOD-A60093 mark
                 "               ima07,ima08,'',0,0,0,''",                 #MOD-A60093   #FUN-CB0005 add '',0,0
                 " FROM img_file,ima_file,OUTER imf_file",
                 " WHERE img01 = ima01 ",
                 " AND img_file.img01 = imf_file.imf01 ",
                 " AND img_file.img02 = imf_file.imf02 AND img_file.img03 = imf_file.imf03 ",
                 " AND ",tm.wc CLIPPED
 
    #str MOD-A60093 mark
    #IF tm.b = '1' THEN     #多餘料件
    #   LET l_sql = l_sql CLIPPED," AND (img10 - imf04) > 0 "
    #END IF
    #IF tm.b = '2' THEN     #短缺料件
    #   LET l_sql = l_sql CLIPPED," AND (img10 - imf04) < 0 "
    #END IF
    #end MOD-A60093 mark
     PREPARE x521_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE x521_c2 CURSOR FOR x521_prepare2
 
     #CALL cl_outnam('aimx521') RETURNING l_name                #FUN-C30190 mark
     #START REPORT x521_rep2 TO l_name                          #FUN-C30190 mark
 
     LET g_pageno = 0
#FUN-680025--begin
     LET g_zaa[41].zaa06='Y'                                                                                                        
     LET g_zaa[42].zaa06='Y'                                                                                                        
     LET g_zaa[54].zaa06='Y'   #MOD-A60093 add
     LET g_zaa[55].zaa06='Y'
    #LET g_zaa[56].zaa06='Y'   #MOD-A60093 mark
     CALL cl_prt_pos_len() 
#FUN-680025--end
     FOREACH x521_c2 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT imf04 INTO sr.imf04   #MOD-A60093 mod img19->imf04
        # FROM img_file
          FROM imf_file    #No.B071 010322 by linda mod
          WHERE imf01 = sr.img01
          AND imf02 = sr.img02
          AND imf03 = sr.img03
        IF SQLCA.sqlcode OR sr.imf04 IS NULL THEN  #MOD-A60093 mod img19->imf04
           LET sr.imf04 = 0                        #MOD-A60093 mod img19->imf04
        END IF
        LET sr.diff = sr.img10 - sr.imf04          #MOD-A60093 mod img19->imf04
       #str MOD-A60093 add
        IF cl_null(sr.diff) THEN LET sr.diff=0 END If
        IF tm.b = '1' THEN     #多餘料件
           IF sr.diff <= 0 THEN CONTINUE FOREACH END IF
        END IF
        IF tm.b = '2' THEN     #短缺料件
           IF sr.diff >= 0 THEN CONTINUE FOREACH END IF
        END IF
       #end MOD-A60093 add
        #--->不做存量控制
        IF sr.imf04 = 0 THEN   #MOD-A60093 mod img19->imf04
           LET sr.sta = ' '
        ELSE
           IF sr.diff > 0 THEN
              LET sr.sta = '1'
           ELSE
              LET sr.sta = '2'
           END IF
        END IF
        FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.img01
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima07
                WHEN tm.s[g_i,g_i] = '3'
                CASE
                   WHEN tm.y ='0'  LET l_order[g_i] = sr.ima06
                   WHEN tm.y ='1'  LET l_order[g_i] = sr.ima09
                   WHEN tm.y ='2'  LET l_order[g_i] = sr.ima10
                   WHEN tm.y ='3'  LET l_order[g_i] = sr.ima11
                   WHEN tm.y ='4'  LET l_order[g_i] = sr.ima12
                END CASE
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img02
                WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.img03
                OTHERWISE LET l_order[g_i] = '-'
           END CASE
        END FOR
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
        LET sr.order3 = l_order[3]
        #OUTPUT TO REPORT x521_rep2(sr.*)              #FUN-C30190 mark
        CASE sr.sta   #FUN-CB0005 add
           WHEN '1'  LET l_sta1 = cl_getmsg('aim-080',g_lang)   #FUN-CB0005 add
           WHEN '2'  LET l_sta1 = cl_getmsg('aim-081',g_lang)   #FUN-CB0005 add
           OTHERWISE LET l_sta1 = " "     #FUN-CB0005 add
        END CASE   #FUN-CB0005 add
        LET l_num1 = 3  #FUN-CB0005 add
       SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = sr.img02    #FUN-CB0005
      #SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime01 = sr.img03    #FUN-CB0005  #FUN-D40129 mark
       SELECT ime03 INTO l_ime03 FROM ime_file WHERE ime02 = sr.img03    #FUN-D40129 add
        EXECUTE insert_prep1 USING sr.*,l_sta1,l_num1,l_imd02,l_ime03   #FUN-C30190 add  #FUN-CB0005 add l_sta,l_num,l_imd02,l_ime03
     END FOREACH
 
     #FINISH REPORT x521_rep2                          #FUN-C30190 mark
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #FUN-C30190 mark
     #FUN-C30190-----add---str----
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED," ORDER BY order1,order2,order3,diff"
     CALL cl_wcchp(tm.wc,'ima01')
          RETURNING tm.wc
     LET g_str = tm.wc
###XtraGrid###     CALL cl_prt_cs3("aimx521","aimx521_2",l_sql,g_str)
    LET g_xgrid.table = l_table1   ###XtraGrid###
    LET g_xgrid.template = 'aimx521_1'   #FUN-CB0005 add
    #FUN-CB0005----add----str--
    CASE tm.y
       WHEN 0
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima06")  #FUN-CB0005 add
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima06")
       WHEN 1
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima09")  #FUN-CB0005 add
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima09")
       WHEN 2
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima10")  #FUN-CB0005 add
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima10")
       WHEN 3
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima11")  #FUN-CB0005 add
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima11")
       WHEN 4
          LET g_xgrid.order_field = cl_get_order_field(tm.s,"ima01,ima07,ima12")  #FUN-CB0005 add
          LET l_str = cl_wcchp(g_xgrid.order_field,"ima01,ima07,ima12")
    END CASE
    LET l_str = cl_replace_str(l_str,',','-')
    LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str
    #FUN-CB0005----add----end--
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-CB0005 add
    CALL cl_xg_view()    ###XtraGrid###
     #FUN-C30190-----add---end----
END FUNCTION
 
#FUN-C30190--------mark------str----- 
#REPORT x521_rep2(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          l_sw1      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	  l_sta      LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(04)
#          sr         RECORD
#                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                     img01    LIKE img_file.img01, #料件編號
#                     img02    LIKE img_file.img02, #倉庫代號
#                     img03    LIKE img_file.img03, #存放位置
#                     img04    LIKE img_file.img04, #批號
#                     img09    LIKE img_file.img09,
#                     img10    LIKE img_file.img10,
#                     imf04    LIKE imf_file.imf04, #MOD-A60093 mod img19->imf04
#                     ima02    LIKE ima_file.ima02,
#                     ima05    LIKE ima_file.ima05,
#                     ima06    LIKE ima_file.ima06,
#                     ima09    LIKE ima_file.ima09, #
#                     ima10    LIKE ima_file.ima10, #
#                     ima11    LIKE ima_file.ima11, #
#                     ima12    LIKE ima_file.ima12, #
#                     ima07    LIKE ima_file.ima07,
#                     ima08    LIKE ima_file.ima08,
#                     diff     LIKE img_file.img10, #MOD-A60093 mod
#                     sta      LIKE type_file.chr1  #No.FUN-690026 VARCHAR(04)
#                     END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#ORDER BY sr.order1,sr.order2,sr.order3,sr.diff
#  FORMAT
#   PAGE HEADER
##FUN-680025--begin
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno = g_pageno + 1 
#      LET pageno_total = PAGENO USING '<<<',"/pageno" 
#      PRINT g_head CLIPPED,pageno_total 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] 
##FUN-680025--end
#      PRINT g_dash[1,g_len]
##FUN-680025--begin
##     PRINT g_x[17] CLIPPED,g_x[18] CLIPPED,
##          #COLUMN 88,g_x[19] CLIPPED   #TQC-5B0019 mark
##           COLUMN 89,g_x[19] CLIPPED   #TQC-5B0019
##     PRINT g_x[20] CLIPPED,
##          #start TQC-5B0019
##          #COLUMN  88,g_x[21] CLIPPED,
##          #COLUMN 129,g_x[23] CLIPPED
##           COLUMN  89,g_x[21] CLIPPED,
##           COLUMN 169,g_x[23] CLIPPED
##          #end TQC-5B0019
##     PRINT "--------------------  -  -   -   ----  ---------- -----",
## 	    "----- ------------------------  ---- ----------------- ----",
##           "------------- ----"
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                     g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                     g_x[43],g_x[44]
#      PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],
#                     g_x[50],g_x[51],g_x[52],g_x[53],g_x[56],  #MOD-A60093 mod 54->56
#                     g_x[57],g_x[58]
#      PRINT  g_dash1 
##FUN-680025--end       
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      CALL x521_sta(sr.sta) RETURNING l_sta
##FUN-680025--begin
##     PRINT sr.img01,COLUMN 23,sr.ima05,COLUMN 26,sr.ima08,COLUMN 30,
##           sr.ima07,COLUMN 34,sr.ima06,COLUMN 40,sr.img02,COLUMN 51,
##           sr.img03,COLUMN 62,sr.img04,COLUMN 88,sr.img09,COLUMN 93,
##           sr.img10 USING '------------&.&&&'
##           ,COLUMN 111,sr.diff USING '------------&.&&&',' ',l_sta
##     PRINT COLUMN 7,sr.ima02,COLUMN 93,sr.imf04 USING '------------&.&&&'  #MOD-A60093 mod img19->imf04
#      PRINTX name=D1 COLUMN g_c[31],sr.img01,
#                     COLUMN g_c[32],sr.ima05,
#                     COLUMN g_c[33],sr.ima08,
#                     COLUMN g_c[34],sr.ima07,                                                               
#                     COLUMN g_c[35],sr.ima06,
#                     COLUMN g_c[36],sr.img02,
#                     COLUMN g_c[37],sr.img03,                                                               
#                     COLUMN g_c[38],sr.img04,
#                     COLUMN g_x[39],sr.img09,
#                     COLUMN g_c[40],cl_numfor(sr.img10,40,3),                                                               
#                     COLUMN g_c[43],cl_numfor(sr.diff,43,3),
#                     COLUMN g_c[44],l_sta                                                                 
#      PRINTX name=D2 COLUMN g_c[45],sr.ima02,
#                     COLUMN g_c[56],cl_numfor(sr.imf04,56,3)  #MOD-A60093 mod img19->imf04
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        #str MOD-A60093 add
#         IF g_sma.sma12 = 'N' THEN
#            CALL cl_wcchp(tm.wc,'ima01,ima07,ima06,ima09,ima10,ima11,ima12')
#                 RETURNING tm.wc
#         ELSE
#            CALL cl_wcchp(tm.wc,'ima01,ima07,ima06,ima09,ima10,ima11,ima12,img02,img03')
#                 RETURNING tm.wc
#         END IF
#        #end MOD-A60093 add
#         PRINT g_dash[1,g_len]
##TQC-630166
##        IF tm.wc[001,120] > ' ' THEN			# for 132
##	    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##        IF tm.wc[121,240] > ' ' THEN
##	    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##        IF tm.wc[241,300] > ' ' THEN
##	    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#FUN-C30190--------mark------end-----
#Patch....NO.TQC-610036 <> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
