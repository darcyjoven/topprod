# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr852.4gl
# Descriptions...: 盤盈虧分析表－【現有庫存】
# Input parameter:
# Return code....:
# Date & Author..: 93/11/05 By Fiona
# Modify.........: 93/11/22 By Apple
# NOTE...........: 單位轉換皆在開始做
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將報表列印有寫到PRINT ...,g_x[14][1,30],...,g_x[14][31,35]的拆成不同的g_x[14],g_x[15]
# Modify.........: No.FUN-530001 05/03/02 By Mandy 報表單價,金額寬度修正,並加上cl_numfor()
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0137 05/12/01 By kim CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤編號放大至16碼
# Modify.........: No.TQC-620072 06/02/20 By Claire 調整報表
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/03/29 By TSD.Jin 改為Crystal Report
# Modify.........: No.FUN-750038 07/05/08 By Sarah 將tm.c選項3先移除
# Modify.........: No.FUN-770066 07/07/18 By Sarah 將tm.c選項3恢復,增加處理列印3的段落
# Modify.........: No.MOD-880100 08/08/13 By claire tm.c選項3,報表版面不美觀,或出現錯誤訊息, 故改為總表明細表分開一次產生
# Modify.........: No.MOD-910015 09/01/05 By claire tm.c選項3,不論是明細或總表的報表的總計會加總明細及總表的結果
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
# Modify.........: No.MOD-960359 09/06/30 By mike 刪除冗余代碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		
           wc      STRING,                 # Where Condition  #TQC-630166
           a       LIKE type_file.chr1,    #成本資料選項  #No.FUN-690026 VARCHAR(1)
           b       LIKE type_file.chr1,    #列印成本選擇  #No.FUN-690026 VARCHAR(1)
           c       LIKE type_file.chr1,    #報表格式選項  #No.FUN-690026 VARCHAR(1)
           d       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       m_len       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_costdesc  LIKE ze_file.ze03       # 表頭單位成本 #No.FUN-690026 VARCHAR(08)
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#070329 MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#070329 MOD-720046 By TSD.Jin--end
 
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
 
#070329 MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " seq.type_file.num5,",   #SMALLINT
               " sw.type_file.chr1,",    #判斷正負值
               " pia01.pia_file.pia01,", #標籤號碼
               " pia02.pia_file.pia02,", #料件編號
               " pia03.pia_file.pia03,", #倉庫別
               " pia04.pia_file.pia04,", #儲  位
               " pia05.pia_file.pia05,", #批  號
               " pia08.pia_file.pia08,", #現有庫存量
               " count.pia_file.pia50,", #盤點量
               " diff.pia_file.pia50,",  #盤點差量
               " cost.pia_file.pia66,",  #單位成本
               " tot.pia_file.pia66,",   #盈虧總成本
               " ima02.ima_file.ima02,", #品名規格
               " ima05.ima_file.ima05,", #版本
               " ima08.ima_file.ima08,",
               " ima25.ima_file.ima25,",
               " l_invsum.pia_file.pia66,",
               " l_cntsum.pia_file.pia67,",
               " azi03.azi_file.azi03,", 
               " azi04.azi_file.azi04,", 
               " azi05.azi_file.azi05,", 
               " rpt_type.type_file.chr1"   #FUN-770066 add   #記錄這筆資料是1.總表 2.明細表
 
   LET l_table = cl_prt_temptable('aimr852',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?) "   #FUN-770066 add ? 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#070329 MOD-720046 By TSD.Jin--end
 
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
      THEN CALL r852_tm(0,0)		# Input print condition
      ELSE CALL r852()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r852_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r852_w AT p_row,p_col
        WITH FORM "aim/42f/aimr852"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
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
   CONSTRUCT BY NAME tm.wc ON pia01,pia02,pia03,pia04,pia05,ima08,pia931           #FUN-930122 Add pia931
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r852_w 
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
 
      BEFORE FIELD c
         IF g_sma.sma12= 'N' THEN
            IF cl_null(tm.c)
               THEN NEXT FIELD b
               ELSE NEXT FIELD s
            END IF
         END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r852_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr852'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr852','9031',1)
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
         CALL cl_cmdat('aimr852',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r852_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r852()
   ERROR ""
END WHILE
   CLOSE WINDOW r852_w
END FUNCTION
 
FUNCTION r852()
DEFINE
	l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
	l_name2 LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(20)
#	l_time	LIKE type_file.chr8,  	# Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
        l_sql   STRING,                 # RDSQL STATEMENT     #TQC-630166
   	l_chr   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
	l_cmd 	LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(30)
        l_cnt   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_count LIKE pia_file.pia30,
        l_diff  LIKE pia_file.pia30,
        l_part  LIKE pia_file.pia02,
        l_seq   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	sr2     RECORD
                pia01     LIKE  pia_file.pia01, #標籤號碼
                pia02     LIKE  pia_file.pia02, #料件編號
                pia03     LIKE  pia_file.pia03, #倉庫別
                pia04     LIKE  pia_file.pia04, #儲位
                pia05     LIKE  pia_file.pia05, #批號
                pia08     LIKE  pia_file.pia08, #現有庫存
                pia10     LIKE  pia_file.pia10, #庫存/料件轉換率
                pia30     LIKE  pia_file.pia30, #初盤量
                pia50     LIKE  pia_file.pia50, #複盤量
                pia66     LIKE  pia_file.pia66,
                pia67     LIKE  pia_file.pia67,
                pia68     LIKE  pia_file.pia68,
                cost      LIKE  pia_file.pia66,
                ima08     LIKE  ima_file.ima08
                END RECORD,
	sr3     RECORD
                seq       LIKE  type_file.num5,  #No.FUN-690026 SMALLINT
                pia01     LIKE  pia_file.pia01,  #標籤號碼
                pia02     LIKE  pia_file.pia02,  #料件編號
                pia03     LIKE  pia_file.pia03,  #倉庫別
                pia04     LIKE  pia_file.pia04,  #儲  位
                pia05     LIKE  pia_file.pia05,  #批  號
                pia08     LIKE  pia_file.pia08,  #現有庫存量
                count     LIKE  pia_file.pia50,  #盤點量
                diff      LIKE  pia_file.pia50,  #盤點差量
                cost      LIKE  pia_file.pia66,  #單位成本
                ima08     LIKE  ima_file.ima08,
                tot       LIKE  pia_file.pia66,
                ima02     LIKE  ima_file.ima02,  #品名規格
                ima05     LIKE  ima_file.ima05,  #版本
                ima25     LIKE  ima_file.ima25
    		END RECORD,
	sr4     RECORD
                sw        LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
                pia02     LIKE  pia_file.pia02,  #料件編號
                pia08     LIKE  pia_file.pia08,  #總庫存量
                diff      LIKE  pia_file.pia50,  #總盤點差量
                count     LIKE  pia_file.pia50,  #總盤點量
                tot       LIKE  pia_file.pia66   #盈虧總成本
		END RECORD
 
#070329 MOD-720046 By TSD.Jin--start
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima25   LIKE ima_file.ima25,
          l_cost    LIKE pia_file.pia66,
          l_invsum  LIKE pia_file.pia66,
          l_cntsum  LIKE pia_file.pia67
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   DELETE FROM aim_r852
#070329 MOD-720046 By TSD.Jin--end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr852'
  #LET g_len = 153   #FUN-5A0199 mark
   LET g_len = 168   #TQC-620072 157   #FUN-5A0199
   LET m_len = 166
#NO.CHI-6A0004--BEGIN
#  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#       FROM azi_file WHERE azi01 = g_aza.aza17
#NO.CHI-6A00004--END
  #FOR g_i = 1 TO m_len LET g_dash2[g_i,g_i] = '=' END FOR  #MOD-960359
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR   #MOD-960359
   CALL r852_temp()
 
   LET l_sql = " SELECT pia01,pia02,pia03,pia04,pia05,pia08,pia10,",
               " pia30,pia50,pia66,pia67,pia68,0,",
               " ima08",
               " FROM pia_file,OUTER ima_file",
               " WHERE pia_file.pia02 = ima_file.ima01 ",
               "   AND (pia30 IS NOT NULL OR pia50 IS NOT NULL)",
               "   AND (pia02 IS NOT NULL ) AND ",
                tm.wc CLIPPED
 
   PREPARE r852_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   DECLARE r852_cs  CURSOR FOR r852_prepare
   LET l_cnt = 0
   FOREACH r852_cs  INTO sr2.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      IF sr2.pia10 IS NULL OR sr2.pia10 =' ' OR sr2.pia10 = 0
      THEN LET sr2.pia10 = 1
      END IF
 
      #--->盤點時成本
      IF tm.a = '1' THEN
        CASE
         WHEN tm.b = '1'  LET sr2.cost = sr2.pia66
         WHEN tm.b = '2'  LET sr2.cost = sr2.pia67
         WHEN tm.b = '3'  LET sr2.cost = sr2.pia68
         OTHERWISE EXIT CASE
        END CASE
      ELSE
        CALL s_cost(tm.b,sr2.ima08,sr2.pia02)
             RETURNING sr2.cost
      END IF
 
      #--->盤點數量(單位轉換)
      IF sr2.pia50 IS NOT NULL AND sr2.pia50 != ' '
      THEN LET l_count = sr2.pia50 * sr2.pia10
      ELSE LET l_count = sr2.pia30 * sr2.pia10
      END IF
 
      #--->現有庫存(單位轉換)
      LET  sr2.pia08 = sr2.pia08 * sr2.pia10
 
      #--->盤點差異量
      LET l_diff = (l_count - sr2.pia08)
 
      #--->無盤點差異者是否列印
      IF tm.d = 'N' THEN
         IF l_diff = 0 THEN CONTINUE FOREACH  END IF
      END IF
      INSERT INTO aim_r852 VALUES(sr2.pia01,sr2.pia02,
                                  sr2.pia03,sr2.pia04,
                                  sr2.pia05,sr2.pia08,
                                  l_count,  l_diff,
                                  sr2.cost, sr2.ima08)
      IF SQLCA.sqlcode THEN
         #CALL cl_err(SQLCA.sqlcode,'insert errror',0) #No.+045 010403 by plum
         #CALL cl_err('insert errror',SQLCA.SQLCODE,0)
         CALL cl_err3("ins","aim_r852",sr2.pia01,"",SQLCA.sqlcode,"",
                      "insert error",0)   #NO.FUN-640266 #No.FUN-660156
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   #--->無任何資料
   IF l_cnt = 0 THEN
      CALL cl_err('no data','aap-999',1)
      RETURN
   END IF
   #---->讀取料件排行(總表)
   LET l_sql = " SELECT pia02,",
               " SUM(pia08),SUM(diff),SUM(cnt),",
               " SUM(diff*cost) ",
               " FROM aim_r852 ",
               "  GROUP BY pia02",
               "  ORDER BY 5,1"
 
   PREPARE r852_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   DECLARE r852_cs2  CURSOR FOR r852_prepare2
 
   #---->讀取料件排行(明細表)
   #=====>取正值(由大至小)
   LET l_sql = " SELECT pia02,SUM(diff),SUM(diff*cost) ",
               " FROM aim_r852 ",
               "  GROUP BY pia02   ",
               "  HAVING (SUM(diff*cost) > 0 OR SUM(diff) >=0)",
               "  ORDER BY 3 desc,1 "
 
   PREPARE r852_ppart2  FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   DECLARE r852_cpart2  CURSOR FOR r852_ppart2
 
   #=====>取負值(由小至大)
   LET l_sql = " SELECT pia02,SUM(diff),SUM(diff*cost) ",
               " FROM aim_r852 ",
               "  GROUP BY pia02   ",
               "  HAVING (SUM(diff*cost) < 0 OR SUM(diff) < 0)",
               "  ORDER BY 3,1 "
 
   PREPARE r852_ppart1  FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   DECLARE r852_cpart1  CURSOR FOR r852_ppart1
 
   LET l_sql = " SELECT '',aim_r852.*,0,ima02,ima05,ima25 ",
               " FROM aim_r852 ,OUTER ima_file",
               " WHERE aim_r852.pia02 = ima_file.ima01 AND  pia02 = ? "
 
   PREPARE r852_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   DECLARE r852_cs3  CURSOR FOR r852_prepare3
 
   #---->讀取相關資料
   LET l_sql = "SELECT unique ima02,ima25,cost ",
               "  FROM ima_file,aim_r852",
               " WHERE ima01 = ?  ",
               "   AND ima01 = pia02 "
   PREPARE r852_p5  FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   DECLARE r852_cs5  CURSOR FOR r852_p5
 
  #070329 MOD-720046 By TSD.Jin--start mark
  #CALL cl_outnam('aimr852') RETURNING l_name
  #LET l_name2=l_name
  #LET l_name2[11,11]='x'
 
  ##--->報表格式選擇
  #CASE tm.c
  #   WHEN '1'                                  #總表
  #      START REPORT r852_rep  TO l_name
  #   WHEN '2'                                  #明細表
  #      START REPORT r852_rep2 TO l_name2
  #   WHEN '3'                                  #全部
  #      START REPORT r852_rep TO l_name
  #      START REPORT r852_rep2 TO l_name2
  #   OTHERWISE EXIT CASE
  #END CASE
  #070329 MOD-720046 By TSD.Jin--end mark
   CALL s_costdesc(tm.b) RETURNING g_costdesc
 
   LET g_pageno= 0
   IF tm.c ='1' OR tm.c ='3' THEN
      FOREACH r852_cs2  INTO sr4.pia02, sr4.pia08, sr4.diff,
                             sr4.count, sr4.tot
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach r852_cs2:',SQLCA.sqlcode,1)
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
 
      #070329 MOD-720046 By TSD.Jin--start
      #  OUTPUT TO REPORT r852_rep(sr4.*)
         LET l_ima02 = NULL
         LET l_ima25 = NULL
         LET l_cost  = 0
         OPEN r852_cs5 USING sr4.pia02
         FETCH r852_cs5 INTO l_ima02,l_ima25,l_cost
         IF SQLCA.sqlcode THEN
            LET l_ima02 = ' '  LET l_ima25 = ' ' LET l_cost = ' '
         END IF
         CLOSE r852_cs5
         LET l_invsum = sr4.pia08 * l_cost
         LET l_cntsum = sr4.count * l_cost
 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
         EXECUTE insert_prep USING
            '',sr4.sw,'',sr4.pia02,'',
            '','',sr4.pia08,sr4.count,sr4.diff,
            l_cost,sr4.tot,l_ima02,'','',
            l_ima25,l_invsum,l_cntsum,g_azi03,g_azi04,
            g_azi05,'1'   #FUN-770066 add '1'   #1.總表
      #070329 MOD-720046 By TSD.Jin--end  
      END FOREACH
   END IF
   IF tm.c = '2' OR tm.c ='3' THEN
      LET l_seq = 0
      #--->負值排列
      FOREACH r852_cpart1  INTO l_part
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach r852_cpart1 error:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
          LET l_seq = l_seq + 1
          FOREACH r852_cs3
          USING l_part
          INTO sr3.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach r852_cs3 error:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
               LET l_sw = '1'
               LET sr3.seq = l_seq
               LET sr3.tot = sr3.diff * sr3.cost
 
              #070329 MOD-720046 By TSD.Jin--start
              #OUTPUT TO REPORT r852_rep2(l_sw,sr3.*)    #明細
 
               EXECUTE insert_prep USING
                  sr3.seq,  l_sw,     sr3.pia01,sr3.pia02,sr3.pia03,
                  sr3.pia04,sr3.pia05,sr3.pia08,sr3.count,sr3.diff,
                  sr3.cost, sr3.tot,  sr3.ima02,sr3.ima05,sr3.ima08,
                  sr3.ima25,'','',g_azi03,g_azi04, 
                  g_azi05,'2'   #FUN-770066 add '2'   #2.明細表 
              #070329 MOD-720046 By TSD.Jin--end
          END FOREACH
      END FOREACH
      #--->正值排列
      FOREACH r852_cpart2  INTO l_part
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach r852_cpart2 error:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_seq = l_seq + 1
         FOREACH r852_cs3 USING l_part INTO sr3.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach r852_cs3 error:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_sw = '2'
            LET sr3.seq = l_seq
            LET sr3.tot = sr3.diff * sr3.cost
           #070329 MOD-720046 By TSD.Jin--start
           #OUTPUT TO REPORT r852_rep2(l_sw,sr3.*) #明細
 
            EXECUTE insert_prep USING
               sr3.seq,  l_sw,     sr3.pia01,sr3.pia02,sr3.pia03,
               sr3.pia04,sr3.pia05,sr3.pia08,sr3.count,sr3.diff,
               sr3.cost, sr3.tot,  sr3.ima02,sr3.ima05,sr3.ima08,
               sr3.ima25,'','',g_azi03,g_azi04, 
               g_azi05,'2'   #FUN-770066 add '2'   #2.明細表  
           #070329 MOD-720046 By TSD.Jin--end
         END FOREACH
      END FOREACH
   END IF
   #070329 MOD-720046 By TSD.Jin--start
   #CASE
   #  WHEN tm.c = '1' FINISH REPORT r852_rep
   #                  DELETE FROM aim_r852
   #  WHEN tm.c = '2' FINISH REPORT r852_rep2
   #                 #No.+366 010705 plum
   #                  LET l_cmd = "chmod 777 ", l_name2
   #                  RUN l_cmd
   #                 #No.+366..end
   #                  LET l_name = l_name2
   #  WHEN tm.c = '3' FINISH REPORT r852_rep
   #                  FINISH REPORT r852_rep2
   #                 #No.+366 010705 plum
   #                  LET l_cmd = "chmod 777 ", l_name2
   #                  RUN l_cmd
   #                 #No.+366..end
   #                  LET l_sql='cat ',l_name2,'>> ',l_name
   #                  RUN l_sql
   #                  DELETE FROM aim_r852
   #  OTHERWISE EXIT CASE
   #END CASE
   # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    #是否列印選擇條件
    LET g_str = NULL
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05,ima08,pia931')            #FUN-930122 Add pia931
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",g_costdesc
 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    CASE tm.c WHEN '1' CALL cl_prt_cs3('aimr852','aimr852_1',l_sql,g_str)
              WHEN '2' CALL cl_prt_cs3('aimr852','aimr852_2',l_sql,g_str)
              #MOD-880100-begin-modify
              #WHEN '3' CALL cl_prt_cs3('aimr852','aimr852_3',l_sql,g_str)   #FUN-770066 add
              WHEN  '3'
                 #MOD-910015-begin-add
                 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                             ," WHERE rpt_type = '1'"                 
                 #MOD-910015-end-add
                 CALL cl_prt_cs3('aimr852','aimr852_1',l_sql,g_str)
                 CALL cl_err('','lib-002',1)
                 #MOD-910015-begin-add
                 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                             ," WHERE rpt_type = '2'"                 
                 #MOD-910015-end-add
                 CALL cl_prt_cs3('aimr852','aimr852_2',l_sql,g_str)
              #MOD-880100-end-modify
    END CASE
   #070329 MOD-720046 By TSD.Jin--end
END FUNCTION
 
#070329 MOD-720046 By TSD.Jin--start mark
##-----------------------------
##  格  式: 總 表 列 印
##-----------------------------
#REPORT r852_rep(sr4)
#DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_j       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       sr4       RECORD
#                 sw        LIKE  type_file.chr1,  #正負值 #No.FUN-690026 VARCHAR(01)
#                 pia02     LIKE  pia_file.pia02,  #料件編號
#                 pia08     LIKE  pia_file.pia08,  #總庫存量
#                 diff      LIKE  pia_file.pia50,  #總盤點差量
#                 count     LIKE  pia_file.pia50,  #總盤點量
#                 tot       LIKE  pia_file.pia66   #盈虧總成本
#                 END RECORD,
#       l_ima02   LIKE ima_file.ima02,
#       l_ima25   LIKE ima_file.ima25,
#       l_sum     LIKE pia_file.pia66,
#       l_cost    LIKE pia_file.pia66,
#       l_invsum  LIKE pia_file.pia66,
#       l_cntsum  LIKE pia_file.pia67
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr4.sw,sr4.tot,sr4.pia02
#  FORMAT
#   PAGE HEADER
#      PRINT (m_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (m_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (m_len-FGL_WIDTH(g_x[12]))/2 SPACES,g_x[12]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
#            IF sr4.sw = '2' THEN
#                 PRINT COLUMN 58,g_x[23] clipped;
#            ELSE PRINT COLUMN 58,g_x[24] clipped;
#            END IF
#            PRINT COLUMN m_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash2[1,m_len]
#      PRINT column 06,g_x[13] clipped,
#            column 40,g_costdesc clipped,
#            column 54,g_x[14] CLIPPED, #MOD-520129
#            column 91,g_x[26] CLIPPED, #MOD-520129
#            column 108,g_x[15] clipped, #FUN-530001
#            column 128,g_x[28] clipped,#FUN-530001
#            column 148,g_x[29] clipped #FUN-530001
#      PRINT column 06,g_x[16] clipped
#      PRINT '------------------------------ ---- ---------------- ',
#            '----------------- ----------------- ----------------- ',
#            '------------------- ------------------- ------------------- ' #FUN-530001
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr4.sw
#      IF (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   ON EVERY ROW
#      OPEN r852_cs5 USING sr4.pia02
#      FETCH r852_cs5 INTO l_ima02,l_ima25,l_cost
#      IF SQLCA.sqlcode THEN
#         LET l_ima02 = ' '  LET l_ima25 = ' ' LET l_cost = ' '
#      END IF
#      LET l_invsum = sr4.pia08 * l_cost
#      LET l_cntsum = sr4.count * l_cost
#      IF sr4.sw = '2' THEN LET sr4.tot = sr4.tot * -1 END IF
#      PRINT COLUMN 01, sr4.pia02,                       #料號
#            COLUMN 32, l_ima25,                         #單位
#            COLUMN 37,cl_numfor(l_cost,15,g_azi03),     #單位成本 #FUN-530001
#            COLUMN 54,sr4.pia08 USING '------------&.&&&',    #總庫存量
#            COLUMN 72,sr4.count USING '------------&.&&&',    #盤點總量
#            COLUMN 90,sr4.diff  USING '------------&.&&&',    #總盤差量
#            COLUMN 108,cl_numfor(l_invsum,18,g_azi05)    #FUN-530001
#                      CLIPPED,                          #總庫存金額
#            COLUMN 128,cl_numfor(l_cntsum,18,g_azi05)   #FUN-530001
#                      CLIPPED,                          #總盤點金額
#            COLUMN 148,cl_numfor(sr4.tot,18,g_azi05)    #FUN-530001
#                      CLIPPED                           #盈虧金額
#      PRINT column 3,l_ima02
#      CLOSE r852_cs5
# 
#   AFTER GROUP OF sr4.sw
#    IF sr4.sw ='2' THEN
#        LET l_sum = GROUP SUM(sr4.tot) * -1
#        PRINT PRINT COLUMN 128,g_x[25] clipped,
#                    COLUMN 148,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#    ELSE
#        LET l_sum = GROUP SUM(sr4.tot)
#        PRINT PRINT COLUMN 128,g_x[27] clipped,
#                    COLUMN 148,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#    END IF
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05')
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
#
##---> 明細表
#REPORT r852_rep2(l_sw,sr3)
#DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_sw      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr3       RECORD
#                 seq       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#                 pia01     LIKE pia_file.pia01,    #標籤號碼
#                 pia02     LIKE pia_file.pia02,    #料件編號
#                 pia03     LIKE pia_file.pia03,    #倉庫別
#                 pia04     LIKE pia_file.pia04,    #儲  位
#                 pia05     LIKE pia_file.pia05,    #批  號
#                 pia08     LIKE pia_file.pia08,    #現有庫存量
#                 count     LIKE pia_file.pia50,    #盤點量
#                 diff      LIKE pia_file.pia50,    #盤點差量
#                 cost      LIKE pia_file.pia66,    #單位成本
#                 ima08     LIKE ima_file.ima08,   
#                 tot       LIKE pia_file.pia66,   
#                 ima02     LIKE ima_file.ima02,    #品名規格
#                 ima05     LIKE ima_file.ima05,    #版本
#                 ima25     LIKE ima_file.ima25    
#       	         END RECORD,
#       l_cnt     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_sum     LIKE pia_file.pia66,
#       l_tot     LIKE pia_file.pia66
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY l_sw,sr3.seq,sr3.tot,sr3.pia03
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
#                 PRINT COLUMN 60,g_x[23] clipped;
#            ELSE PRINT COLUMN 60,g_x[24] clipped;
#            END IF
#            PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      PRINT column 07,g_x[17] clipped,
#            column 45,g_costdesc CLIPPED,
#            column 61,g_x[18] clipped,
#           #column 96,g_x[19] clipped,column 135,g_x[20] clipped  #FUN-530001    #FUN-5A0199 mark
#            column 100,g_x[19] clipped,column 139,g_x[20] clipped  #FUN-530001   #FUN-5A0199
#      PRINT column 07,g_x[21] clipped,column 61, g_x[22] clipped  #FUN-530001
#      PRINT '------------------------------ -- -- ---- ----------------  ',
#           #'---------- ---------- ----------   ',         #FUN-5A0199 mark
#            '---------- ---------- ---------------- ',     #FUN-5A0199
#            '------------ ------------ ------------ -------------------' #FUN-530001
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF l_sw
#      IF (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   BEFORE GROUP OF sr3.seq
#      PRINT COLUMN 01,sr3.pia02 CLIPPED,
#            COLUMN 32,sr3.ima05 CLIPPED,
#            COLUMN 35,sr3.ima08,
#            COLUMN 38,sr3.ima25,
#            COLUMN 43,cl_numfor(sr3.cost,15,g_azi03) clipped; #FUN-530001
#      LET l_cnt = 1
# 
#   ON EVERY ROW
#      PRINT COLUMN 61,sr3.pia03,
#            COLUMN 72,sr3.pia04,
#            COLUMN 83,sr3.pia01,
#           #start FUN-5A0199
#           #COLUMN  96,sr3.pia08 using'#######&.&&&',
#           #COLUMN 109,sr3.count using'#######&.&&&',
#           #COLUMN 122,sr3.diff using'-------&.&&&',
#           #COLUMN 135,cl_numfor(sr3.tot,18,g_azi04) CLIPPED  #FUN-530001
#            COLUMN 100,sr3.pia08 using'#######&.&&&',
#            COLUMN 113,sr3.count using'#######&.&&&',
#            COLUMN 126,sr3.diff using'-------&.&&&',
#            COLUMN 139,cl_numfor(sr3.tot,18,g_azi04) CLIPPED  #FUN-530001
#           #end FUN-5A0199
#      IF l_cnt = 1 THEN
#         PRINT column 3,sr3.ima02
#      END IF
#      LET l_cnt = l_cnt + 1
# 
#   AFTER GROUP OF l_sw
#     LET l_sum = GROUP SUM(sr3.tot)
#    IF l_sw ='2' THEN
#       #start FUN-5A0199
#       #PRINT PRINT COLUMN 122,g_x[25] clipped,
#       #            COLUMN 135,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#        PRINT PRINT COLUMN 126,g_x[25] clipped,
#                    COLUMN 139,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#       #end FUN-5A0199
#    ELSE
#       #start FUN-5A0199
#       #PRINT PRINT COLUMN 122,g_x[27] clipped,
#       #            COLUMN 135,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#        PRINT PRINT COLUMN 126,g_x[27] clipped,
#                    COLUMN 139,cl_numfor(l_sum,18,g_azi05) #FUN-530001
#       #end FUN-5A0199
#    END IF
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'pia01,pia02,pia03,pia04,pia05')
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
#070329 MOD-720046 By TSD.Jin--end mark 
 
FUNCTION r852_temp()
 
  #CREATE TEMP TABLE aim_r852
  #  (
  #    pia01   VARCHAR(16),         #標籤編號  #FUN-5A0199 10碼放大成16碼
  #    pia02   VARCHAR(40),         #料號      #FUN-560011 #FUN-5B0137
  #    pia03   VARCHAR(10),         #倉庫
  #    pia04   VARCHAR(10),         #儲位
  #    pia05   VARCHAR(24),         #批號
  #    pia08   decimal(12,3),    #庫存總數
  #    cnt     decimal(12,3),    #盤點總數
  #    diff    decimal(12,3),    #盤點差量
  #    cost    decimal(20,6),    #單位成本
  # Prog. Version..: '5.30.06-13.03.12(01)          #來源碼
  #  );
  CREATE TEMP TABLE aim_r852(
      pia01   LIKE pia_file.pia01,
      pia02   LIKE pia_file.pia02,
      pia03   LIKE pia_file.pia03,
      pia04   LIKE pia_file.pia04,
      pia05   LIKE pia_file.pia05,
      pia08   LIKE pia_file.pia08,
      cnt     LIKE pia_file.pia08,
      diff    LIKE pia_file.pia08,
      cost    LIKE pia_file.pia66,
      ima08   LIKE ima_file.ima08);
    CREATE  index s_1  on aim_r852 (pia02);
END FUNCTION
#Patch....NO.TQC-610036 <001,002> #
