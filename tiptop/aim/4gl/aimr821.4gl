# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aimr821.4gl
# Descriptions...: 初盤盤點表
# Date & Author..: 93/10/08 By fiona
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-590110 05/09/27 By jackie 報表轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.TQC-6C0222 06/12/29 By Ray 第一頁跳頁錯誤
# Modify.........: No.MOD-7B0158 07/11/14 By Pengu 修改OUTER語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.TQC-CB0098 12/11/26 By qirl 增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                       # Print condition RECORD
           wc   STRING,                 # Where Condition  #TQC-630166
           stk  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           type LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s    LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t    LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD,
#      l_diff LIKE ima_file.ima26 #,    # 盤點差異量     #FUN-A20044
       l_diff LIKE type_file.num15_3                     #FUN-A20044  
DEFINE g_i    LIKE type_file.num5,    #count/index for any purpose  #No.FUN-690026 SMALLINT
l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
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
   LET tm.stk   = ARG_VAL(8)
   LET tm.type  = ARG_VAL(9)
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
   THEN CALL r821_tm(0,0)    	       	# Input print condition
   ELSE
#No.FUN-590110 --start--
     CALL r821()
#No.FUN-590110 --end--
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r821_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       l_direct       LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW r821_w AT p_row,p_col
        WITH FORM "aim/42f/aimr821"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.stk    = 'Y'
   LET tm.type   = '1'
   LET tm.s      = '123'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON pia01,pia03,
                                pia04,pia05,pia02,ima08,pia31,pia41
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(pia02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pia02
               NEXT FIELD pia02
            END IF
#----TQC-CB0098----ADD---star---
         IF INFIELD(pia01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia01
            NEXT FIELD pia01
         END IF
         IF INFIELD(pia03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia03"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia03
            NEXT FIELD pia03
         END IF
         IF INFIELD(pia04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia04"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia04
            NEXT FIELD pia04
         END IF
         IF INFIELD(pia05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia05"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia05
            NEXT FIELD pia05
         END IF
         IF INFIELD(pia31) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia31"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia31
            NEXT FIELD pia31
         END IF
         IF INFIELD(pia41) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia41"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia41
            NEXT FIELD pia41
         END IF
#----TQC-CB0098----ADD---end-----
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r821_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     IF tm.wc =  " 1=1" THEN
        CALL cl_err('','9046',0)
        CONTINUE WHILE
     END IF
#UI
   INPUT BY NAME tm.stk,tm.type,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     AFTER FIELD stk     #是否列印現有庫存數量
         IF tm.stk IS NOT NULL AND tm.stk NOT MATCHES'[YN]'
			THEN NEXT FIELD stk
		 END IF
 
     AFTER FIELD type     #資料選擇
         IF tm.type IS NULL OR tm.type = ' ' OR tm.type NOT MATCHES'[12]'
			THEN NEXT FIELD type
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r821_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr821'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr821','9031',1)
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
                         " '",tm.stk CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr821',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r821_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
#No.FUN-590110 --start--
      CALL r821()
#No.FUN-590110 --end--
   ERROR ""
END WHILE
CLOSE WINDOW r821_w
END FUNCTION
 
#---->多倉處理
FUNCTION r821()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     pia01    LIKE pia_file.pia01, #標籤編號
                     pia02    LIKE pia_file.pia02, #料件編號
                     pia03    LIKE pia_file.pia03, #倉庫別
                     pia04    LIKE pia_file.pia04, #儲    位
                     pia05    LIKE pia_file.pia05, #批    號
                     pia08    LIKE pia_file.pia08, #現有庫存量
                     pia09    LIKE pia_file.pia09, #庫存單位
                     pia31    LIKE pia_file.pia31, #資料人員(一)
                     pia34    LIKE pia_file.pia34, #初盤員(一)
                     pia40    LIKE pia_file.pia40, #盤點量(二)
                     pia41    LIKE pia_file.pia41, #資料人員(二)
                     pia44    LIKE pia_file.pia44, #初盤員(二)
                     ima02    LIKE ima_file.ima02, #品名
                     ima021   LIKE ima_file.ima021,#規格   #FUN-5C0002
                     ima05    LIKE ima_file.ima05, #版本
                     ima08    LIKE ima_file.ima08, #來源
                     ima07    LIKE ima_file.ima07, #ABC 碼
                     pia30    LIKE pia_file.pia30, #盤點量(二)
                     gen02    LIKE gen_file.gen02,
                     count    LIKE pia_file.pia30
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE r821_za1 CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "aimr821" AND za03 = g_lang
     FOREACH r821_za1 INTO g_i,l_za05 LET g_x[g_i] = l_za05 END FOREACH
 
#No.FUN-590110 --start
IF g_sma.sma12='Y' THEN   #多倉儲
     LET l_sql = " SELECT  '','','',",
                 " pia01, pia02, pia03, pia04, pia05,",
                 " pia08, pia09, pia31, pia34,",
                 " pia40, pia41, pia44,",
                #" ima02, ima05, ima08, ima07,pia30,gen02,''",          #FUN-5C0002 mark
                 " ima02, ima021,ima05, ima08, ima07,pia30,gen02,''",   #FUN-5C0002
                 " FROM pia_file,",
                 " OUTER gen_file,ima_file ",
                 " WHERE pia02 = ima_file.ima01",
                 " AND pia02 IS NOT NULL AND ",tm.wc CLIPPED
 
    IF tm.type ='1'
    THEN LET l_sql = l_sql clipped," AND pia_file.pia34 = gen_file.gen01"   #No.MOD-7B0158 modify
    ELSE LET l_sql = l_sql clipped," AND pia_file.pia44 = gen_file.gen01"   #No.MOD-7B0158 modify
    END IF
ELSE
     LET l_sql = " SELECT  '','','',",
                 " pia01, pia02, '', '','',",
                 " pia08, pia09, pia31, pia34,",
                 " '', pia41, pia44,",
                #" ima02, ima05, ima08, ima07,"          #FUN-5C0002 mark
                 " ima02, ima021,ima05, ima08, ima07,"   #FUN-5C0002
                 IF tm.type = '1'  THEN
                    LET l_sql = l_sql CLIPPED, " '',gen02,pia30 "
                 ELSE                #使用者(二)
                    LET l_sql = l_sql CLIPPED, " '',gen02,pia40 "
                 END IF
     LET l_sql = l_sql CLIPPED,
                 " FROM pia_file,",
                 " OUTER gen_file, ima_file",
                 " WHERE pia02 IS NOT NULL AND ",tm.wc CLIPPED,
                 " AND ima_file.ima01 = pia02 "
    IF tm.type = '1' THEN
       LET l_sql = l_sql CLIPPED,
                 " AND pia_file.pia34 = gen_file.gen01"
    ELSE
       LET l_sql = l_sql CLIPPED,
                 " AND pia_file.pia44 = gen_file.gen01"
    END IF
END IF
 
     PREPARE r821_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r821_c1 CURSOR FOR r821_prepare1
#No.FUN-590110 --end--
     CALL cl_outnam('aimr821') RETURNING l_name
#No.FUN-590110 --start--
     IF g_sma.sma12='N' THEN
        LET g_zaa[31].zaa06='Y'
        LET g_zaa[32].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
        LET g_zaa[44].zaa06='Y'
     ELSE
        LET g_zaa[31].zaa06='N'
        LET g_zaa[32].zaa06='N'
        LET g_zaa[43].zaa06='N'
        LET g_zaa[44].zaa06='N'
     END IF
     CALL cl_prt_pos_len()
#No.FUN-590110 --end--
     START REPORT r821_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r821_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
	   IF sr.pia01 IS NULL THEN LET sr.pia01 = ' ' END IF
	   IF sr.pia02 IS NULL THEN LET sr.pia02 = ' ' END IF
	   IF sr.pia03 IS NULL THEN LET sr.pia03 = ' ' END IF
	   IF sr.pia04 IS NULL THEN LET sr.pia04 = ' ' END IF
	   IF sr.pia05 IS NULL THEN LET sr.pia05 = ' ' END IF
#No.FUN-590110 --start--
      IF g_sma.sma12='Y' THEN
       IF tm.type = '1'
       THEN LET sr.count = sr.pia30
       ELSE LET sr.count = sr.pia40
       END IF
      END IF
#No.FUN-590110 --end--
 
       FOR g_i = 1 TO 3
		CASE
			WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pia01
                                                 LET l_orderA[g_i] =g_x[13]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pia03
                                                 LET l_orderA[g_i] =g_x[48]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pia04
                                                 LET l_orderA[g_i] =g_x[49]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pia05
                                                 LET l_orderA[g_i] =g_x[21]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pia02
                                                 LET l_orderA[g_i] =g_x[14]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima08
                                                 LET l_orderA[g_i] =g_x[22]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pia31
                                                 LET l_orderA[g_i] =g_x[24]    #TQC-6A0088
			WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.pia41
                                                 LET l_orderA[g_i] =g_x[25]    #TQC-6A0088
            OTHERWISE LET l_order[g_i]  = '-'
                                                 LET l_orderA[g_i] =''    #TQC-6A0088
        END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT r821_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r821_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r821_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr         RECORD
                     order1   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                     pia01    LIKE  pia_file.pia01, #標籤編號
                     pia02    LIKE  pia_file.pia02, #料件編號
                     pia03    LIKE  pia_file.pia03, #倉庫別
                     pia04    LIKE  pia_file.pia04, #儲    位
                     pia05    LIKE  pia_file.pia05, #批    號
                     pia08    LIKE  pia_file.pia08, #現有庫存量
                     pia09    LIKE  pia_file.pia09, #庫存單位
                     pia31    LIKE  pia_file.pia31, #資料人員(一)
                     pia34    LIKE  pia_file.pia34, #初盤員(一)
                     pia40    LIKE  pia_file.pia40, #盤點量(二)
                     pia41    LIKE  pia_file.pia41, #資料人員(二)
                     pia44    LIKE  pia_file.pia44, #初盤員(二)
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格   #FUN-5C0002
                     ima05    LIKE  ima_file.ima05, #版本
                     ima08    LIKE  ima_file.ima08, #來源
                     ima07    LIKE  ima_file.ima07, #ABC 碼
                     pia30    LIKE  pia_file.pia30, #盤點量(二)
                     gen02    LIKE  gen_file.gen02,
                     count    LIKE  pia_file.pia08
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
      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                     g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
     #PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46]           #FUN-5C0002 mark
      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]   #FUN-5C0002
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[1,1] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[2,2] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[3,3] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      #---->盤點差異量
      LET l_diff = sr.count - sr.pia08
 
      IF tm.stk = 'N' THEN
         PRINTX name=D1
               COLUMN g_c[31], sr.pia03 CLIPPED,
               COLUMN g_c[32], sr.pia04 CLIPPED,
               COLUMN g_c[33], sr.pia01 CLIPPED,
               COLUMN g_c[34], sr.pia02 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
               COLUMN g_c[35], sr.ima05 CLIPPED,
               COLUMN g_c[36], sr.ima08 CLIPPED,
               COLUMN g_c[37], sr.ima07 CLIPPED,
               COLUMN g_c[38], sr.pia09 CLIPPED,
               COLUMN g_c[39], sr.count USING'##########&.&&&',
               COLUMN g_c[42], sr.gen02 CLIPPED
 
      ELSE
         PRINTX name=D1
               COLUMN g_c[31], sr.pia03 CLIPPED,
               COLUMN g_c[32], sr.pia04 CLIPPED,
               COLUMN g_c[33], sr.pia01 CLIPPED,
               COLUMN g_c[34], sr.pia02 CLIPPED,
               COLUMN g_c[35], sr.ima05 CLIPPED,
               COLUMN g_c[36], sr.ima08 CLIPPED,
               COLUMN g_c[37], sr.ima07 CLIPPED,
               COLUMN g_c[38], sr.pia09 CLIPPED,
               COLUMN g_c[39], sr.count USING'##########&.&&&',
             # COLUMN g_c[40], sr.pia08 USING'##########&.&&&',                #TQC-CB0098----MARK--
               COLUMN g_c[40], sr.pia08 USING'----------&.&&&',                 #TQC-CB0098--- ADD
               COLUMN g_c[41], l_diff USING'----------&.&&&',
               COLUMN g_c[42], sr.gen02 CLIPPED
      END IF
      PRINTX name=D2
            COLUMN g_c[44],sr.pia05 CLIPPED,
            COLUMN g_c[46],sr.ima02 CLIPPED
           ,COLUMN g_c[47],sr.ima021 CLIPPED   #FUN-5C0002
#No.FUN-590110 --end--
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
        CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05')
             RETURNING tm.wc
        PRINT g_dash[1,g_len]
#TQC-630166
#       IF tm.wc[001,080] > ' ' THEN
#                     PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#       IF tm.wc[071,140] > ' ' THEN
#                     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#       IF tm.wc[141,210] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
# ff end
#Patch....NO.TQC-610036 <> #
