# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr853.4gl
# Descriptions...:盤盈虧分析表－【在製工單】
# Input parameter:
# Return code....:
# Date & Author..: 93/11/05 By Fiona
# Modify.........: 93/11/22 By Apple
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580006 05/08/24 By Claire 含取替代量計算
# Modify.........: No.FUN-5B0137 05/12/01 By kim 報表料號放大到30
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤編號放大至16碼
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/04/02 By TSD.Jin 改為Crystal Report
# Modify.........: No.FUN-750038 07/05/08 By Sarah 將tm.c選項3先移除
# Modify.........: No.MOD-850266 08/05/27 By claire 取替代料的未入庫總量有錯
# Modify.........: No.FUN-770071 07/07/19 By Sarah 將tm.c選項3恢復,增加處理列印3的段落
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/11 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段 
# Modify.........: No.MOD-C70065 12/07/06 By Sakura 計算取替代時，應先計算實際已用量，並需乘上替代率(sfa28)，再計算未入庫量=(已發量+超領量-實際已用量)* 單位轉換率
# Modify.........: No.MOD-D10229 13/01/25 By bart 替代料應盤數量直接抓pie153

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD		
                   wc   STRING,                     # Where Condition  #TQC-630166
                   a    LIKE type_file.chr1,        #成本資料選項  #No.FUN-690026 VARCHAR(1)
                   b    LIKE type_file.chr1,        #列印成本選擇  #No.FUN-690026 VARCHAR(1)
                   c    LIKE type_file.chr1,        #報表格式選項  #No.FUN-690026 VARCHAR(1)
                   d    LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
  	           more LIKE type_file.chr1  	    # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                   END RECORD,
       m_len       LIKE type_file.num5,             #No.FUN-690026 SMALLINT
       g_costdesc  LIKE ze_file.ze03                # 表頭單位成本 #No.FUN-690026 VARCHAR(08)                
DEFINE g_i         LIKE type_file.num5              #count/index for any purpose  #No.FUN-690026 SMALLINT
 
#070402 MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#070402 MOD-720046 By TSD.Jin--end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#070402 MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = "sw.type_file.chr1,",  
               "seq.type_file.num5,",     #SMALLINT
               "pid02.pid_file.pid02,",   #工單編號
               "pid03.pid_file.pid03,",   #生產料件
               "pie01.pie_file.pie01,",   #標籤編號
               "pie02.pie_file.pie02,",   #料號
               "pie03.pie_file.pie03,",   #作業序號
               "pie04.pie_file.pie04,",   #發料單位
               "pie07.pie_file.pie07,",   #項次
               "pie05.pie_file.pie05,",   #工作站
               "uninv.pie_file.pie50,",   #庫存總數(應盤數量)
               "cnt.pie_file.pie50,",     #盤點總數
               "diff.pie_file.pie50,",    #盤點差量
               "cost.pie_file.pie66,",    #單位成本
               "tot.pie_file.pie66,",
               "ima02.ima_file.ima02,",   #品名規格
               "ima08.ima_file.ima08,",   #來源碼
               "ima25.ima_file.ima25,",   #庫存單位
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "rpt_type.type_file.chr1,",   #FUN-770071 add   #記錄這筆資料是1.總表 2.明細表
               "pie012.pie_file.pie012,", #NO.FUN-A60080
               "pie013.pie_file.pie013"  #NO.FUN-A60080
   LET l_table = cl_prt_temptable('aimr853',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?) "   #FUN-770071 add ?  #NO.FUN-A60080 add ?
  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#070402 MOD-720046 By TSD.Jin--end
 
   LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r853_tm(0,0)		# Input print condition
      ELSE CALL r853()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r853_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r853_w AT p_row,p_col
        WITH FORM "aim/42f/aimr853"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.a = '1'
   LET tm.b = '1'
   LET tm.c = '3'
   LET tm.d = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pid03,pie02,pid01,pid02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r853_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME  tm.a, tm.b, tm.c, tm.d, tm.more
                       WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     #BEFORE FIELD c
        #IF g_sma.sma12= 'N' THEN
        #   IF cl_null()
        #      THEN NEXT FIELD b
        #      ELSE NEXT FIELD s
        #   END IF
        #END IF
      AFTER FIELD a
         IF tm.a NOT MATCHES'[12]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES'[123]' THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES'[123]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]' THEN
            NEXT FIELD d
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW r853_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr853'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr853','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr853',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r853_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r853()
   ERROR ""
END WHILE
   CLOSE WINDOW r853_w
END FUNCTION
 
FUNCTION r853()
DEFINE
	l_name	    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
	l_name2     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(20)
#       l_time      LIKE type_file.chr8,    # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
        l_sql       STRING,                 # RDSQL STATEMENT     #TQC-630166
   	l_chr       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_za05	    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
	l_cmd 	    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(30)
        l_cnt       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_count     LIKE pie_file.pie30,
        l_part      LIKE pie_file.pie02,
        l_diff      LIKE pie_file.pie30,
        l_cost      LIKE pie_file.pie66,
        l_actuse    LIKE pie_file.pie30,
        l_uninv     LIKE pie_file.pie30,
        l_uninv_2   LIKE pie_file.pie30,    #MOD-580006
        l_sfa26     LIKE sfa_file.sfa26,    #MOD-580006
        l_sfa28     LIKE sfa_file.sfa28,    #MOD-850266
        l_sfa27     LIKE sfa_file.sfa27,    #MOD-580006
        l_sfa27_2   LIKE sfa_file.sfa27,    #MOD-580006
        l_sfa03     LIKE sfa_file.sfa03,    #MOD-580006
        l_sw        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_seq       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	sr2         RECORD
                    pid01    LIKE  pid_file.pid01,   #標籤編號
                    pid02    LIKE  pid_file.pid02,   #工單編號
                    pid03    LIKE  pid_file.pid03,   #生產料件
                    pid13    LIKE  pid_file.pid13,   #完工入庫量
                    pid17    LIKE  pid_file.pid17,   #報廢量
                    pie07    LIKE  pie_file.pie07,   #項    次
                    pie02    LIKE  pie_file.pie02,   #材料編號
                    pie04    LIKE  pie_file.pie04,   #發料單位
                    pie05    LIKE  pie_file.pie05,   #工作站
                    pie03    LIKE  pie_file.pie03,   #作業序號
                    pie30    LIKE  pie_file.pie30,   #初盤數量
                    pie50    LIKE  pie_file.pie50,   #複盤數量
                    pie14    LIKE  pie_file.pie14,   #QPA
                    pie15    LIKE  pie_file.pie15,   #報廢數量
                    pie151   LIKE  pie_file.pie151,  #代買數量
                    pie152   LIKE  pie_file.pie152,  #轉換率
                    pie12    LIKE  pie_file.pie12,   #已發量
                    pie13    LIKE  pie_file.pie13,   #超領量
                    pie66    LIKE  pie_file.pie66,
                    pie67    LIKE  pie_file.pie67,
                    pie68    LIKE  pie_file.pie68,
                    pie900   LIKE  pie_file.pie900, #No.FUN-870051
                    ima08    LIKE  ima_file.ima08,
                    pie012   LIKE pie_file.pie012,  #No.FUN-A60027
                    pie013   LIKE pie_file.pie013,  #No.FUN-A60027
                    pie153   LIKE pie_file.pie153   #MOD-D10229 
                    END RECORD,
	sr3         RECORD
                    seq      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
                    pid02    LIKE pid_file.pid02,    #工單編號
                    pid03    LIKE pid_file.pid03,    #生產料件
                    pie01    LIKE pie_file.pie01,    #標籤編號
                    pie02    LIKE pie_file.pie02,    #料號
                    pie03    LIKE pie_file.pie03,    #作業序號
                    pie04    LIKE pie_file.pie04,    #發料單位
                    pie07    LIKE pie_file.pie07,    #項次
                    pie05    LIKE pie_file.pie05,    #工作站
                    uninv    LIKE pie_file.pie50,    #庫存總數(應盤數量)
                    cnt      LIKE pie_file.pie50,    #盤點總數
                    diff     LIKE pie_file.pie50,    #盤點差量
                    cost     LIKE pie_file.pie66,    #單位成本
                    ima08    LIKE ima_file.ima08,    #來源碼
                    pie012   LIKE pie_file.pie012,   #No.FUN-A60080
                    pie013   LIKE pie_file.pie013,   #No.FUN-A60080
                    tot      LIKE pie_file.pie66,
                    ima02    LIKE ima_file.ima02,    #品名規格
                    ima25    LIKE ima_file.ima25     #庫存單位
		    END RECORD,
	sr4         RECORD
                    sw        LIKE type_file.chr1,  #No.FUN-690026 VARCHAR(1)
                    pie02     LIKE pie_file.pie02,  #料件編號
                    pie012   LIKE pie_file.pie012,   #No.FUN-A60080
                    pie013   LIKE pie_file.pie013,   #No.FUN-A60080
                    uninv     LIKE pie_file.pie50,  #總庫存量
                    diff      LIKE pie_file.pie50,  #總盤點差量
                    count     LIKE pie_file.pie50,  #總盤點量
                    tot       LIKE pie_file.pie66   #盈虧總成本
		    END RECORD
 
#070402 MOD-720046 By TSD.Jin--start
   DEFINE l_ima02  LIKE ima_file.ima02,     #品名規格
          l_ima08  LIKE ima_file.ima08,     #來源碼
          l_ima25  LIKE ima_file.ima25      #庫存單位
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   DELETE FROM aim_r853
#070402 MOD-720046 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr853'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 148 END IF
#NO.CHI-6A0004--BEGIN
	#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#          FROM azi_file WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004--END
     LET m_len = 167
    #LET g_len = 155       #No.FUN-550029   #FUN-5A0199 mark
     LET g_len = 161       #No.FUN-550029   #FUN-5A0199
     FOR g_i = 1 TO m_len LET g_dash2[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     CALL r853_temp()
 
     LET l_sql = " SELECT pid01, pid02, pid03, pid13, pid17,  ",
                       "  pie07, pie02, pie04, pie05, pie03,  ",
                       "  pie30, pie50, pie14, pie15, pie151, ",
                       "  pie152, pie12, pie13, pie66, pie67, ",
                       "  pie68, pie900, ima08, pie012, pie013, ",  #No.FUN-870051 add pie900   #FUN-A60027 add pie012,pie013
                       "  pie153 ",  #MOD-D10229
                 " FROM pid_file,pie_file, ima_file ",
                 " WHERE pid01 = pie01 ",
                 "   AND pie02 = ima01 ",
                 "   AND (pie30 IS NOT NULL OR pie50 IS NOT NULL)",
                 "   AND (pie02 IS NOT NULL ) AND ",
                  tm.wc CLIPPED
 
     PREPARE r853_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cs  CURSOR FOR r853_prepare
     LET l_cnt = 0
     FOREACH r853_cs  INTO sr2.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr2.pie152 IS NULL OR sr2.pie152 = ' ' OR sr2.pie152 = 0
       THEN LET sr2.pie152 = 1
       END IF
       #--->盤點時成本
       IF tm.a = '1' THEN
         CASE
          WHEN tm.b = '1'  LET l_cost = sr2.pie66
          WHEN tm.b = '2'  LET l_cost = sr2.pie67
          WHEN tm.b = '3'  LET l_cost = sr2.pie68
          OTHERWISE EXIT CASE
         END CASE
       ELSE
         CALL s_cost(tm.b,sr2.ima08,sr2.pie02)
              RETURNING l_cost
       END IF
 
       #--->盤點數量(單位轉換)
       IF sr2.pie50 IS NOT NULL
       THEN LET l_count = sr2.pie50 * sr2.pie152
       ELSE LET l_count = sr2.pie30 * sr2.pie152
       END IF
 
       #--->計算未入庫數量(應盤數量)
       #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
       #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
       LET l_actuse = ((sr2.pid13 + sr2.pid17) * sr2.pie14) + sr2.pie15
 
       #MOD-850266-begin-mark
       ##---->考慮單位轉換
       #LET l_uninv = (sr2.pie12 + sr2.pie13 - l_actuse) * sr2.pie152
       #MOD-850266-end-mark
 
       IF cl_null(sr2.pie900) THEN LET sr2.pie900=sr2.pie02 END IF #FUN-870051 
       LET l_uninv = sr2.pie153  #MOD-D10229 
#MOD-D10229---begin mark
#        #MOD-580006-Begin 計算取替代料件
#        SELECT sfa26,sfa27,sfa03,sfa28          #MOD-850266 add sfa28 
#          INTO l_sfa26,l_sfa27,l_sfa03,l_sfa28  #MOD-850266 add sfa28
#          FROM sfa_file
#         WHERE sfa01 = sr2.pid02
#           AND sfa03 = sr2.pie02
#           AND sfa08 = sr2.pie03
#           AND sfa12 = sr2.pie04
#           AND sfa27 = sr2.pie900   #No.FUN-870051
#           AND sfa012 = sr2.pie012 AND sfa013 = sr2.pie013    #FUN-A60027
# 
#            IF NOT cl_null(l_sfa27) AND l_sfa27_2 = l_sfa27 THEN
#                  #MOD-850266-begin-modify
#                  #LET l_uninv = l_uninv - l_uninv_2
#                  #---->考慮單位轉換
#                 #LET l_uninv_2 = l_uninv_2 * l_sfa28                            #MOD-C70065 mark
#                 #LET l_uninv = (sr2.pie12 + sr2.pie13 - l_uninv_2) * sr2.pie152 #MOD-C70065 mark
#                  #MOD-850266-end-modify
##MOD-C70065---add---START
#                  LET l_uninv_2 = ((sr2.pid13 + sr2.pid17) * sr2.pie14*l_sfa28) + sr2.pie15
#                  #未入庫量=(已發量+超領量-實際已用量)* 單位轉換率
#                  LET l_uninv = (sr2.pie12 + sr2.pie13 - l_uninv_2) * sr2.pie152
##MOD-C70065---add-----END
#                  IF l_uninv < 0  THEN
#                     LET l_uninv_2=0-l_uninv  #絕對值
#                     LET l_uninv  = 0
#                  ELSE
#                     LET l_uninv_2=0
#                     LET l_sfa27=''
#                  END IF
#            #MOD-850266-begin-add
#            ELSE
#                 #---->考慮單位轉換
#                 LET l_uninv = (sr2.pie12 + sr2.pie13 - l_actuse) * sr2.pie152
#            END IF
#            #MOD-850266-end-add
#           #IF l_sfa26=3 OR l_sfa26=4 AND l_uninv < 0 THEN   #MOD-850266 mark
#           #MOD-850266-begin-modify
#           #IF (l_sfa26=3 OR l_sfa26=4) THEN                      #FUN-A20037
#            IF (l_sfa26='3' OR l_sfa26='4' OR l_sfa26 = '8') THEN     #FUN-A20037
#                LET l_sfa27_2  = l_sfa27
#                LET l_uninv_2  = 0            #取替代料已入量  #MOD-850266 add
#                IF  l_uninv < 0 THEN    
#                  LET l_uninv_2= 0- l_uninv   # 絕對值
#                  LET l_uninv  = 0
#                END IF 
#            END IF
#           #MOD-850266-end-modify
#        #MOD-580006-End
#MOD-D10229---end---end
       #---->考慮單位轉換
       LET l_diff = l_count - l_uninv
 
       #--->無盤點差異者是否列印
       IF tm.d = 'N' THEN
          IF l_diff = 0 THEN CONTINUE FOREACH  END IF
       END IF
       INSERT INTO aim_r853 VALUES(sr2.pid02,sr2.pid03,
                                   sr2.pid01,sr2.pie02,
                                   sr2.pie03,sr2.pie04,
                                   sr2.pie07,sr2.pie05,
                                   l_uninv,  l_count,
                                   l_diff,   l_cost,
                                   sr2.ima08,sr2.pie012,sr2.pie013) #No.FUN-A60080
       IF SQLCA.sqlcode THEN
          #CALL cl_err(SQLCA.sqlcode,'insert errror',0)  #No.+045 010403 by plum
          #CALL cl_err('insert errror',SQLCA.SQLCODE,0)
          CALL cl_err3("ins","aim_r853",sr2.pid02,"",SQLCA.sqlcode,"",
                       "insert error",1)   #NO.FUN-640266 #No.FUN-660156
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
     END FOREACH
     #--->無任何資料
     IF l_cnt = 0 THEN
        CALL cl_err('','agl-115',1)
        RETURN
     END IF
 
     #---->讀取料件排行(總表)
     LET l_sql = " SELECT pie02,pie012,pie013",    #No.FUN-A60080
                 " SUM(uninv),SUM(diff),SUM(cnt),",
                 " SUM(diff*cost) ",
                 " FROM aim_r853 ",
                 #"  GROUP BY pie02",              #No.FUN-A60080
                 "  GROUP BY pie02,pie012,pie013", #No.FUN-A60080  
                 #"  ORDER BY 5,1"                  #No.FUN-A60080
                  "  ORDER BY 7,1"                  #No.FUN-A60080 
                  
     PREPARE r853_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cs2  CURSOR FOR r853_prepare2
 
     #---->讀取料件排行(明細表)
     LET l_sql = " SELECT '',aim_r853.*,0,ima02,ima25 ",
                 " FROM aim_r853 ,OUTER ima_file",
                 " WHERE aim_r853.pie02 = ima_file.ima01 AND  pie02 = ? "
 
     PREPARE r853_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cs3  CURSOR FOR r853_prepare3
 
     #---->讀取料件排行(明細表)
     #=====>取正值(由大至小)
     LET l_sql = " SELECT pie02,SUM(diff),SUM(diff*cost) ",
                 " FROM aim_r853 ",
                 "  GROUP BY pie02   ",
                 "  HAVING (SUM(diff*cost) > 0 OR SUM(diff) >=0)",
                 "  ORDER BY 3 desc,1 "
 
     PREPARE r853_ppart2  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cpart2  CURSOR FOR r853_ppart2
 
     #=====>取負值(由小至大)
     LET l_sql = " SELECT pie02,SUM(diff),SUM(diff*cost) ",
                 " FROM aim_r853 ",
                 "  GROUP BY pie02   ",
                 "  HAVING (SUM(diff*cost) < 0 OR SUM(diff) <0)",
                 "  ORDER BY 3,1 "
 
     PREPARE r853_ppart1  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cpart1  CURSOR FOR r853_ppart1
 
     #---->讀取相關資料
     LET l_sql = "SELECT unique ima02,ima25,ima_file.ima08,cost ",
                 "  FROM ima_file,aim_r853",
                 " WHERE ima01 = ?  ",
                 "   AND ima01 = pie02 "
     PREPARE r853_p5  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r853_cs5  CURSOR FOR r853_p5
 
    #070402 MOD-720046 By TSD.Jin--start mark
    #CALL cl_outnam('aimr853') RETURNING l_name
    #LET l_name2=l_name
    #LET l_name2[11,11]='x'
 
    ##--->報表格式選擇
    #CASE tm.c
    #   WHEN '1'                                  #總表
    #      START REPORT r853_rep  TO l_name
    #   WHEN '2'                                  #明細表
    #      START REPORT r853_rep2 TO l_name2
    #   WHEN '3'                                  #全部
    #      START REPORT r853_rep TO l_name
    #      START REPORT r853_rep2 TO l_name2
    #   OTHERWISE EXIT CASE
    #END CASE
    #070402 MOD-720046 By TSD.Jin--end mark
 
     CALL s_costdesc(tm.b) RETURNING g_costdesc
     LET g_pageno= 0
     IF tm.c ='1' OR tm.c ='3' THEN
        FOREACH r853_cs2  INTO sr4.pie02, sr4.uninv, sr4.diff,
                               sr4.count, sr4.tot
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach r853_cs2:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF tm.d = 'N' THEN
              IF sr4.diff = 0 THEN CONTINUE FOREACH END IF
           END IF
           IF sr4.diff < 0 THEN
                LET sr4.sw = '1'
           ELSE LET sr4.sw = '2'
                LET sr4.tot = sr4.tot * -1
           END IF
        #070402 MOD-720046 By TSD.Jin--start
        #  OUTPUT TO REPORT r853_rep(sr4.*)
           LET l_ima02 = NULL
           LET l_ima08 = NULL
           LET l_ima25 = NULL
           LET l_cost  = 0
           OPEN r853_cs5 USING sr4.pie02
           FETCH r853_cs5 INTO l_ima02,l_ima25,l_ima08,l_cost
           CLOSE r853_cs5 
 
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
           EXECUTE insert_prep USING
              sr4.sw,'','','','',
              sr4.pie02,'','','','',
              sr4.uninv,sr4.count,sr4.diff,l_cost,sr4.tot,
              l_ima02,l_ima08,l_ima25,g_azi03,g_azi04,
              g_azi05,'1'   #FUN-770071 add '1'   #1.總表
              ,sr4.pie012,sr4.pie013  #No.FUN-A60080
        #070402 MOD-720046 By TSD.Jin--end  
        END FOREACH
    END IF
    IF tm.c = '2' OR tm.c ='3' THEN
       LET l_seq = 0
       #--->負值排列
       FOREACH r853_cpart1  INTO l_part
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach r853_cpart1 error:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
           LET l_seq = l_seq + 1
           FOREACH r853_cs3
           USING l_part
           INTO sr3.*
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach r853_cs3 error:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
                LET l_sw = '1'
                LET sr3.seq = l_seq
                LET sr3.tot = sr3.diff * sr3.cost
             #070402 MOD-720046 By TSD.Jin--start
             #  OUTPUT TO REPORT r853_rep2(l_sw,sr3.*)    #明細
                ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
                EXECUTE insert_prep USING
                   l_sw,sr3.seq,sr3.pid02,sr3.pid03,sr3.pie01,
                   sr3.pie02,sr3.pie03,sr3.pie04,sr3.pie07,sr3.pie05,
                   sr3.uninv,sr3.cnt,sr3.diff,sr3.cost,sr3.tot,
                   sr3.ima02,sr3.ima08,sr3.ima25,g_azi03,g_azi04,
                   g_azi05,'2'   #FUN-770071 add '2'   #2.明細表
                   ,sr3.pie012,sr3.pie013 #No.FUN-A60080
             #070402 MOD-720046 By TSD.Jin--end  
           END FOREACH
       END FOREACH
       #--->正值排列
       FOREACH r853_cpart2  INTO l_part
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach r853_cpart2 error:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
           LET l_seq = l_seq + 1
           FOREACH r853_cs3
           USING l_part
           INTO sr3.*
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach r853_cs3 error:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
                LET l_sw = '2'
                LET sr3.seq = l_seq
                LET sr3.tot = sr3.diff * sr3.cost
             #070402 MOD-720046 By TSD.Jin--start
             #  OUTPUT TO REPORT r853_rep2(l_sw,sr3.*) #明細
                ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
                EXECUTE insert_prep USING
                   l_sw,sr3.seq,sr3.pid02,sr3.pid03,sr3.pie01,
                   sr3.pie02,sr3.pie03,sr3.pie04,sr3.pie07,sr3.pie05,
                   sr3.uninv,sr3.cnt,sr3.diff,sr3.cost,sr3.tot,
                   sr3.ima02,sr3.ima08,sr3.ima25,g_azi03,g_azi04,
                   g_azi05,'2'   #FUN-770071 add '2'   #2.明細表
                   ,sr3.pie012,sr3.pie013 #No.FUN-A60080
             #070402 MOD-720046 By TSD.Jin--end  
           END FOREACH
       END FOREACH
    END IF
   #070402 MOD-720046 By TSD.Jin--start
   #CASE
   #  WHEN tm.c = '1' FINISH REPORT r853_rep
   #                  DELETE FROM aim_r853
   #  WHEN tm.c = '2' FINISH REPORT r853_rep2
   #                 #No.+366 010705 plum
   #                  LET l_cmd = "chmod 777 ", l_name2
   #                  RUN l_cmd
   #                 #No.+366..end
   #                  LET l_name = l_name2
   #  WHEN tm.c = '3' FINISH REPORT r853_rep
   #                  FINISH REPORT r853_rep2
   #                 #No.+366 010705 plum
   #                  LET l_cmd = "chmod 777 ", l_name2
   #                  RUN l_cmd
   #                 #No.+366..end
   #                  LET l_sql='cat ',l_name2,'>> ',l_name
   #                  RUN l_sql
   #                  DELETE FROM aim_r853
   #  OTHERWISE EXIT CASE
   #END CASE
   # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    #是否列印選擇條件
    LET g_str = NULL
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pid03,pie02,pid01,pid02')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",g_costdesc
 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #No.FUN-A60080--begin
    #CASE tm.c WHEN '1' CALL cl_prt_cs3('aimr853','aimr853_1',l_sql,g_str)
    #          WHEN '2' CALL cl_prt_cs3('aimr853','aimr853_2',l_sql,g_str)
    #          WHEN '3' CALL cl_prt_cs3('aimr853','aimr853_3',l_sql,g_str)   #FUN-770071 add
    #END CASE
    CASE tm.c WHEN '1' 
              IF g_sma.sma541='N' THEN 
                 CALL cl_prt_cs3('aimr853','aimr853_1',l_sql,g_str)
              ELSE
                 CALL cl_prt_cs3('aimr853','aimr853_4',l_sql,g_str)                 
              END IF            
              WHEN '2' 
              IF g_sma.sma541='N' THEN 
                 CALL cl_prt_cs3('aimr853','aimr853_2',l_sql,g_str)
              ELSE
                 CALL cl_prt_cs3('aimr853','aimr853_5',l_sql,g_str)                 
              END IF            
              WHEN '3'
              IF g_sma.sma541='N' THEN 
                 CALL cl_prt_cs3('aimr853','aimr853_3',l_sql,g_str)
              ELSE
                 CALL cl_prt_cs3('aimr853','aimr853_6',l_sql,g_str)                 
              END IF            
    END CASE
    #No.FUN-A60080--end
   #070402 MOD-720046 By TSD.Jin--end  
END FUNCTION
 
#070402 MOD-720046 By TSD.Jin--start mark
##-----------------------------
##  格  式: 總 表 列 印
##-----------------------------
#REPORT r853_rep(sr4)
#DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_j           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       sr4           RECORD
#                     sw        LIKE  type_file.chr1,  #正負值 #No.FUN-690026 VARCHAR(01)
#                     pie02     LIKE  pie_file.pie02,  #料件編號
#                     uninv     LIKE  pie_file.pie50,  #總庫存量
#                     diff      LIKE  pie_file.pie50,  #總盤點差量
#                     count     LIKE  pie_file.pie50,  #總盤點量
#                     tot       LIKE  pie_file.pie66   #盈虧總成本
#                     END RECORD,
#      l_sum          LIKE pie_file.pie66,
#      l_cost         LIKE pie_file.pie66,
#      l_ima02        LIKE ima_file.ima02,
#      l_ima25        LIKE ima_file.ima25,
#      l_ima08        LIKE ima_file.ima08,
#      l_seq          LIKE type_file.num5    #No.FUN-690026 SMALLINT
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr4.sw,sr4.tot,sr4.pie02
#  FORMAT
#   PAGE HEADER
#      PRINT (m_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (m_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (m_len-FGL_WIDTH(g_x[21]))/2 SPACES,g_x[21]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
#            IF sr4.sw = '2' THEN
#                 PRINT COLUMN 58,g_x[23] clipped;
#            ELSE PRINT COLUMN 58,g_x[24] clipped;
#            END IF
#            PRINT COLUMN m_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash2[1,m_len]
#      PRINT column 01,g_x[11] clipped,
#            column 45,g_x[12] clipped,
#            column 80,g_costdesc clipped,
#            column 91,g_x[13] clipped,
#            column 127,g_x[14] clipped
#      PRINT '---- ------------------------------ ------------------------------ ',
#            '---- ---- ---------------- ----------------- ',
#            '----------------- ----------------- -------------------'
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr4.sw
#      IF (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#      LET l_seq = 0
# 
#   ON EVERY ROW
#      OPEN r853_cs5 USING sr4.pie02
#      FETCH r853_cs5 INTO l_ima02,l_ima25,l_ima08,l_cost
#      IF sr4.sw = '2' THEN LET sr4.tot = sr4.tot * -1 END IF
#      LET l_seq = l_seq + 1
#      PRINT COLUMN  1,l_seq USING'###&',' ',                          #序號
##No.FUN-550029-begin
#            COLUMN  6,sr4.pie02 CLIPPED,
#            COLUMN 37,l_ima02 CLIPPED,                      #料號
#            COLUMN 69,l_ima08 CLIPPED,
#            COLUMN 73,l_ima25 CLIPPED,
##No.FUN-550029-end
#            COLUMN 78,cl_numfor(l_cost,15,g_azi03),                    #單位成本
#            COLUMN 95,sr4.count  USING'------------&.&&&',    #盤點總量
#            COLUMN 113,sr4.uninv  USING'------------&.&&&',    #總庫存量
#            COLUMN 131,sr4.diff   USING'------------&.&&&',    #總盤差量
#            COLUMN 149,cl_numfor(sr4.tot,18,g_azi05) CLIPPED  #盈虧金額
#      CLOSE r853_cs5
# 
#   AFTER GROUP OF sr4.sw
#    IF sr4.sw ='2' THEN
#        LET l_sum = GROUP SUM(sr4.tot) * -1
#        PRINT PRINT COLUMN 131,g_x[25] clipped,
#                    COLUMN 149,cl_numfor(l_sum,18,g_azi05)
#    ELSE
#        LET l_sum = GROUP SUM(sr4.tot)
#        PRINT PRINT COLUMN 131,g_x[26] clipped,
#                    COLUMN 149,cl_numfor(l_sum,18,g_azi05)
#    END IF
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pid03,pie02,pid01,pid02')
#              RETURNING tm.wc
#         PRINT g_dash2[1,m_len]
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash2[1,m_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (m_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash2[1,m_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (m_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
##---> 明細表
#REPORT r853_rep2(l_sw,sr3)
#DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_cnt     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_sw      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_sum     LIKE pie_file.pie66,
#    	sr3      RECORD
#                 seq      LIKE type_file.num5,     #No.FUN-690026 SMALLINT
#                 pid02    LIKE pid_file.pid02,     #工單編號
#                 pid03    LIKE pid_file.pid03,     #生產料件
#                 pid01    LIKE pid_file.pid01,     #標籤編號
#                 pie02    LIKE pie_file.pie02,     #料號
#                 pie03    LIKE pie_file.pie03,     #作業序號
#                 pie04    LIKE pie_file.pie04,     #發料單位
#                 pie07    LIKE pie_file.pie07,     #項次
#                 pie05    LIKE pie_file.pie05,     #工作站
#                 uninv    LIKE pie_file.pie50,     #庫存總數(應盤數量)
#                 cnt      LIKE pie_file.pie50,     #盤點總數
#                 diff     LIKE pie_file.pie50,     #盤點差量
#                 cost     LIKE pie_file.pie66,     #單位成本
#                 ima08    LIKE ima_file.ima08,     #來源碼
#                 tot      LIKE pie_file.pie66,
#                 ima02    LIKE ima_file.ima02,     #品名規格
#                 ima25    LIKE ima_file.ima25      #庫存單位
#        	 END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY l_sw,sr3.seq,sr3.tot,sr3.pie02
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[01]))/2 SPACES,g_x[01]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME;
#            IF l_sw = '2' THEN
#                 PRINT COLUMN 60,g_x[23] clipped;   #盤盈
#            ELSE PRINT COLUMN 60,g_x[24] clipped;   #盤虧
#            END IF
#            PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
##No.FUN-550029-begin
#      PRINT COLUMN 06,g_x[15] clipped,
#            COLUMN 39,g_costdesc clipped,
#            COLUMN 54,g_x[16] clipped,
#           #start FUN-5A0199
#           #COLUMN  98, g_x[17] clipped,
#           #COLUMN 137,g_x[18] clipped
#            COLUMN 104, g_x[17] clipped,
#            COLUMN 143,g_x[18] clipped
#           #end FUN-5A0199
#      PRINT COLUMN 06,g_x[19] clipped,
#            COLUMN 88,g_x[20] clipped
#      PRINT '------------------------------ ---- ---------------- ',
#           #'---------- ---------------- ---- ---------- ',         #FUN-5A0199 mark
#            '---------------- ---------------- ---- ---------- ',   #FUN-5A0199
#            '------------ ------------ ------------ -------------------'
#      LET l_last_sw = 'n'
# 
# 
#   BEFORE GROUP OF l_sw
#      IF (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr3.seq
#      PRINT sr3.pie02,' ',sr3.ima25,
#            column 27,cl_numfor(sr3.cost,15,g_azi03) CLIPPED;
#      LET l_cnt = 1
# 
#   ON EVERY ROW
#      PRINT COLUMN 54,sr3.pid01 CLIPPED,' ',
#            COLUMN 71,sr3.pid02 CLIPPED,' ',
#           #start FUN-5A0199
#           #COLUMN  82,sr3.pie07 using'###&',' ',
#           #COLUMN  98,sr3.cnt   using'#######&.&&&',' ',
#           #           sr3.uninv using'#######&.&&&',' ',
#           #           sr3.diff  using'-------&.&&&',' ',
#           #COLUMN 137,cl_numfor(sr3.tot,18,g_azi04) CLIPPED
#            COLUMN  88,sr3.pie07 using'###&',' ',
#            COLUMN 104,sr3.cnt   using'#######&.&&&',' ',
#                       sr3.uninv using'#######&.&&&',' ',
#                       sr3.diff  using'-------&.&&&',' ',
#            COLUMN 144,cl_numfor(sr3.tot,18,g_azi04) CLIPPED
#           #end FUN-5A0199
#      IF l_cnt = 1 THEN
#         PRINT column 3,sr3.ima02 CLIPPED;
#      END IF
#      PRINT column 86,sr3.pie03 CLIPPED
#      LET l_cnt = l_cnt + 1
# 
#   AFTER GROUP OF l_sw
#    LET l_sum = GROUP SUM(sr3.tot)
#    IF l_sw ='2' THEN
#        #盤盈
#       #start FUN-5A0199
#       #PRINT PRINT COLUMN 124,g_x[25] clipped,
#       #            COLUMN 137,cl_numfor(l_sum,18,g_azi05)
#        PRINT PRINT COLUMN 128,g_x[25] clipped,
#                    COLUMN 144,cl_numfor(l_sum,18,g_azi05)
#       #end FUN-5A0199
#    ELSE
#        #盤虧
#       #start FUN-5A0199
#       #PRINT PRINT COLUMN 124,g_x[26] clipped,
#       #            COLUMN 137,cl_numfor(l_sum,18,g_azi05)
#        PRINT PRINT COLUMN 128,g_x[26] clipped,
#                    COLUMN 144,cl_numfor(l_sum,18,g_azi05)
#       #end FUN-5A0199
#    END IF
##No.FUN-550029-end
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pid03,pie02,pid01,pid02')
#              RETURNING tm.wc
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##       PRINT g_dash[1,g_len]
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#070402 MOD-720046 By TSD.Jin--end mark
 
FUNCTION r853_temp()
 
  #CREATE TEMP TABLE aim_r853
  #  (
  #    pid02   VARCHAR(16),         #工單編號    #No.FUN-550029
  #    pid03   VARCHAR(40),         #生產料件    #FUN-560074
  #    pie01   VARCHAR(16),         #標籤編號    #FUN-5A0199 10碼放大成16碼
  #    pie02   VARCHAR(40),         #料號        #FUN-560074
  # Prog. Version..: '5.30.06-13.03.12(06),         #作業序號
  #    pie04   VARCHAR(40),         #發料單位
  #    pie07   smallint,         #項次
  #    pie05   VARCHAR(10),         #工作站
  #    uninv   decimal(12,3),    #庫存總數(應盤數量)
  #    cnt     decimal(12,3),    #盤點總數
  #    diff    decimal(12,3),    #盤點差量
  #    cost    decimal(20,6),    #單位成本
  # Prog. Version..: '5.30.06-13.03.12(01)          #來源碼
  #  );
  CREATE TEMP TABLE aim_r853(
      pid02   LIKE pid_file.pid02,
      pid03   LIKE pid_file.pid03,
      pie01   LIKE pie_file.pie01,
      pie02   LIKE pie_file.pie02,
      pie03   LIKE pie_file.pie03,
      pie04   LIKE pie_file.pie04,
      pie07   LIKE pie_file.pie07,
      pie05   LIKE pie_file.pie05,
      uninv   LIKE pie_file.pie30,
      cnt     LIKE pie_file.pie30,
      diff    LIKE pie_file.pie30,
      cost    LIKE pie_file.pie66,
      ima08   LIKE ima_file.ima08,
      pie012  LIKE pie_file.pie012,   #No.FUN-A60080
      pie013  LIKE pie_file.pie013);  #No.FUN-A60080
    CREATE  index s_1  on aim_r853 (pie02);
END FUNCTION
#Patch....NO.TQC-610036 <001,002> #
