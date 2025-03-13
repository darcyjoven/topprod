# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr212.4gl
# Descriptions...: 工程 B O M 成本明細表
# Input parameter:
# Return code....:
# Date & Author..: 93/05/30 By Apple
# Modify.........: No.FUN-4B0061 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.MOD-530204 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-560030 05/06/15 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-560129 05/06/19 By 在未使用特性料件時,畫面不要出現特性代碼
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加controlp
# Modify.........: No.MOD-590022 05/09/07 By vivien 報表結構調整
# Modify.........: No.TQC-5A0029 05/10/12 By Carrier 報表格式調整
# Modify.........: No.TQC-620107 06/02/22 By Claire 再給一次 g_len值
# Modify.........: No.FUN-610092 06/05/24 By Joe 報表增加採購單位欄位
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0081 06/11/14 By baogui 報表問題修改
# Modify.........: No.TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位
# Modify.........: No.CHI-6C0026 06/12/29 By kim 如果是正式料號的話則展開P-BOM
# Modify.........: No.MOD-720044 07/02/02 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-790004 07/09/03 By Sarah 將tm.choice選項3先移除
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10067 10/01/13 By Pengu FUN-870151的調整漏加了一段
# Modify.........: No.TQC-AC0014 10/12/13 By destiny 主件开窗应当开工程bom的资料
# Modify.........: No.TQC-AC0019 10/12/16 By destiny 组成用量计算不正确,未考虑跨阶qpa的组成
# Modify.........: No:MOD-BB0006 11/11/12 By johung 單位抓bmp10

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD				  # Print condition RECORD
            wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
            choice        LIKE type_file.chr1,    #是否列印彙總  #No.FUN-680096 VARCHAR(1)
            loccur        LIKE aza_file.aza17,    #本幣  #No.FUN-680096 VARCHAR(4)
            cur           LIKE aza_file.aza17,    #轉換幣別  #No.FUN-680096 VARCHAR(4)
            rate1         LIKE azk_file.azk03,    #匯率
            rate2         LIKE azk_file.azk03,    #匯率
            s             LIKE type_file.chr1,    # Sort Sequence  #No.FUN-680096 VARCHAR(1)
            more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
           END RECORD,
       g_azi02,g_azi02_2  LIKE azi_file.azi02,
#No.CHI-6A0004-------Begin---
#       g_azi03_2          LIKE azi_file.azi03,
#       g_azi04_2          LIKE azi_file.azi04,
#       g_azi05_2          LIKE azi_file.azi05,
#No.CHI-6A0004-----End---------
       g_tot              LIKE type_file.num10,   #No.FUN-680096 INTEGER
       g_str1,g_str2,g_str3    LIKE type_file.chr1000, #MOD-590022  #No.FUN-680096 VARCHAR(200)
       g_cur,g_cur2       LIKE aab_file.aab02,    #No.FUN-680096 VARCHAR(6)
       g_bmo01_a          LIKE bmo_file.bmo01,
       g_bmo011_a         LIKE bmo_file.bmo011,
       g_bmo06            LIKE bmo_file.bmo06     #FUN-560030
       #g_dash2           VARCHAR(159)               #No.TQC-5A0029
 
DEFINE g_chr              LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE g_i                LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE g_cnt              LIKE type_file.num5     #CHI-6C0026
DEFINE l_table            STRING,                 #MOD-720044 add
       g_str              STRING,                 #MOD-720044 add
       g_sql              STRING,                 #MOD-720044 add
       g_rpt_type         LIKE type_file.chr1     #FUN-770072 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
   #MOD-720044 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
   LET g_sql = "bmo01.bmo_file.bmo01,        ",#主件料件
               "bmp01.bmp_file.bmp01,        ",#本階主件
               "bmp03.bmp_file.bmp03,        ",#元件料號
               "bmp011.bmp_file.bmp011,      ",#版本
               "bmp02.bmp_file.bmp02,        ",#項次
               "bmp06.bmp_file.bmp06,        ",#QPA/BASE
               "bmq02.bmq_file.bmq02,        ",#品名規格
               "bmq021.bmq_file.bmq021,      ",#No.TQC-5A0029
               "bmq08.bmq_file.bmq08,        ",#來源
               "bmq103.bmq_file.bmq103,      ",
               "bmq53.bmq_file.bmq53,        ",
               "bmq531.bmq_file.bmq531,      ",
               "bmq91.bmq_file.bmq91,        ",#月平均單價
               "ima44.ima_file.ima44,        ",#採購單位   ##NO.FUN-610092
               "p_bmo01_a.bmo_file.bmo01,    ", 
               "p_bmo011_a.bmo_file.bmo011,  ", 
               "p_acode.bmo_file.bmo06,      ",    
               "l_bmq02.bmq_file.bmq02,      ", 
               "l_bmq021.bmq_file.bmq021,    ", 
               "l_bmq08.bmq_file.bmq08,      ",
               "l_bmq25.bmq_file.bmq25,      ", 
               "l_desc.type_file.chr8,       ", 
               "g_azi03.azi_file.azi03,      ",
               "azi03.azi_file.azi03,        ",
               "azi07.azi_file.azi07,        ",    #No.FUN-870151
               "azi07_1.azi_file.azi07,      ",    #No.FUN-870151
               "rpt_type.type_file.chr1,     ",     #FUN-770072 add #記錄這筆資料是1.明細 2.總表
               "l_bmp06.bmp_file.bmp06       "     #TQC-AC0019 add bmp06
   LET l_table = cl_prt_temptable('abmr212',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)"   #FUN-770072 add ?  #FUN-870151 ADD ?,? #TQC-AC0019 add ?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720044 - END
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.choice= ARG_VAL(8)
   LET tm.loccur= ARG_VAL(9)
   LET tm.cur   = ARG_VAL(10)
   LET tm.rate1 = ARG_VAL(11)
   LET tm.rate2 = ARG_VAL(12)
   LET tm.s     = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r212_tm(0,0)			# Input print condition
      ELSE CALL r212()			# Read bmota and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r212_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_flag           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_fld            LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
       l_one            LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       l_bdate          LIKE bmx_file.bmx07,
       l_edate          LIKE bmx_file.bmx08,
       l_bmo01          LIKE bmo_file.bmo01,
       l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE
      LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r212_w AT p_row,p_col
        WITH FORM "abm/42f/abmr212"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-560129................begin
   CALL cl_set_comp_visible("bmo06",g_sma.sma118='Y')
   #FUN-560129................end
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL	
   LET tm.s      = '1'
   LET tm.choice = '1'   #FUN-790004 mod 3->1
   LET tm.loccur = g_aza.aza17
   LET tm.cur    = g_aza.aza17
   LET tm.rate1  = 1
   LET tm.rate2  = 1
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   LET l_one='N'
 
   CONSTRUCT tm.wc ON bmo01,bmo011,bmo06 FROM bmo01,bmo011,bmo06 #FUN-560030
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      AFTER FIELD bmo01
         LET l_fld = GET_FLDBUF(bmo01)
         IF l_fld IS NOT NULL THEN
            LET l_one  ='Y'
         END IF
 
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
         IF INFIELD(bmo01) THEN
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_ima"    #TQC-AC0014
            LET g_qryparam.form = "q_bmo01"  #TQC-AC0014
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO bmo01
            NEXT FIELD bmo01
         END IF
#No.FUN-570240 --end--
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
 
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.choice,tm.loccur,tm.cur,tm.rate1,tm.rate2,tm.s,tm.more
                 WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD choice
        #IF tm.choice IS NULL OR tm.choice NOT MATCHES'[123]' THEN   #FUN-790004 mark
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[12]' THEN    #FUN-790004
            NEXT FIELD choice
         END IF
 
      AFTER FIELD cur
         IF tm.cur IS NULL OR tm.cur = ' ' THEN
            NEXT FIELD cur
         ELSE 
            SELECT azi01 FROM azi_file WHERE azi01 = tm.cur
            IF SQLCA.sqlcode THEN
           #   CALL cl_err(tm.cur,'mfg3008',1)
               CALL cl_err3("sel","azi_file",tm.cur,"","mfg3008","","",1)    #No.TQC-660046
               NEXT FIELD cur
            END IF
            CALL s_curr3(tm.cur,g_today,'B')     #買入
                 RETURNING tm.rate1
            CALL s_curr3(tm.cur,g_today,'S')     #賣出
                 RETURNING tm.rate2
            DISPLAY BY NAME tm.rate1,tm.rate2
         END IF
 
      AFTER FIELD rate1
         IF tm.rate1 IS NULL OR tm.rate1 = ' ' OR
            tm.rate1 = 0     OR tm.rate1 <= 0  THEN
            NEXT FIELD rate1
         END IF
 
      AFTER FIELD rate2
         IF tm.rate2 IS NULL OR tm.rate2 = ' ' OR
            tm.rate2 = 0     OR tm.rate2 <= 0  THEN
            NEXT FIELD rate2
         END IF
 
      AFTER FIELD s
         IF tm.s IS NULL OR tm.s NOT MATCHES'[12]' THEN
            NEXT FIELD s
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF tm.loccur IS NULL OR tm.loccur = ' ' THEN
            NEXT FIELD loccur
         END IF
         IF tm.cur IS NULL OR tm.cur = ' ' THEN
            NEXT FIELD cur
         END IF
         IF tm.rate1 IS NULL OR tm.rate1 = ' ' THEN
            LET tm.rate1 = 1
         END IF
         IF tm.rate2 IS NULL OR tm.rate2 = ' ' THEN
            LET tm.rate2 = 1
         END IF
 
      ON ACTION CONTROLP     #查詢條件
         CASE
            WHEN INFIELD(cur)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = tm.cur
               CALL cl_create_qry() RETURNING tm.cur
               DISPLAY BY NAME tm.cur
               NEXT FIELD cur
#FUN-4B0061 add
            WHEN INFIELD(rate2)
               CALL s_rate(tm.cur,tm.rate2) RETURNING tm.rate2
               DISPLAY BY NAME tm.rate2
               NEXT FIELD rate2
##
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r212_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr212'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr212','9031',1)
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
                         " '",tm.choice    CLIPPED,"'",
                         " '",tm.loccur    CLIPPED,"'",
                         " '",tm.cur       CLIPPED,"'",
                         " '",tm.rate1     CLIPPED,"'",
                         " '",tm.rate2     CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr212',g_time,l_cmd)
      END IF
      CLOSE WINDOW r212_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r212()
   ERROR ""
END WHILE
   CLOSE WINDOW r212_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION r212()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_name2       LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#          l_time        LIKE type_file.chr8	#No.FUN-6A0060
          l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_cmd 	LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(30)
          l_bmo01       LIKE bmo_file.bmo01,    #主件料件
          l_bmo011      LIKE bmo_file.bmo011,   #版本
          l_bmo06       LIKE bmo_file.bmo06     #FUN-560030
   DEFINE l_azi07 LIKE azi_file.azi07   #No.FUN-870151
   #MOD-720044 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #MOD-720044 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr212'
 # IF g_len = 0 OR g_len IS NULL THEN LET g_len = 200 END IF     #TQC-6A0081
   LET g_len = 201    #TQC-6A0081
   FOR g_i = 1 TO 200 LET g_dash[g_i,g_i] = '=' END FOR   #TQC-6A0081
   FOR g_i = 1 TO 200 LET g_dash2[g_i,g_i] = '-' END FOR #TQC-6A0081
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND bmouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同部門的資料
   #      LET tm.wc = tm.wc clipped," AND bmogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND bmogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmouser', 'bmogrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT bmo01,bmo011,bmo06", #FUN-560030
               " FROM bmo_file",
               " WHERE ",tm.wc,
               " ORDER BY 1 "
   PREPARE r212_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM 
   END IF
   DECLARE r212_c1 CURSOR FOR r212_prepare1
 
  #str FUN-770072 mark
  #IF tm.choice = '3' THEN
  #   LET l_name2=l_name
  #   LET l_name2[11,11]='x'
  #ELSE 
  #   LET l_name2= l_name
  #END IF
  #end FUN-770072 mark
 
   #---->讀取本幣資料
   SELECT azi02 INTO g_azi02 FROM azi_file WHERE azi01 = g_aza.aza17
   LET g_cur = g_azi02[1,6]
 
   #---->讀取外幣資料
   SELECT azi02,azi03,azi04,azi05,azi07              #No.FUN-870151 add azi07
     INTO g_azi02_2,t_azi03,t_azi04,t_azi05,t_azi07  #No.FUN-870151 add azi07   #No.CHI-6A0004
     FROM azi_file
    WHERE azi01 = tm.cur
   LET g_cur2 = g_azi02_2[1,6]
 
   SELECT azi07 INTO l_azi07 FROM azi_file WHERE azi01 = g_aza.aza17 #No.FUN-870151
   LET g_pageno = 0
   LET g_tot=0
   FOREACH r212_c1 INTO l_bmo01,l_bmo011,l_bmo06 #FUN-560030
      IF SQLCA.sqlcode THEN
         CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_bmo01_a  =l_bmo01
      LET g_bmo011_a =l_bmo011
      LET g_bmo06    =l_bmo06                    #FUN-560030
      IF cl_null(g_bmo06) THEN LET g_bmo06 = ' ' END IF   #FUN-770072 add
      # Prog. Version..: '5.30.06-13.03.12(0,l_bmo01,l_bmo011,l_bmo06)  #FUN-560030 #TQC-AC0019
      CALL r212_bom(0,l_bmo01,l_bmo011,l_bmo06,1)  #FUN-560030 #TQC-AC0019
   END FOREACH
 
   #MOD-720044 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bmo01,bmo011,bmo06') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   
   LET g_str = g_str,";",tm.s,";",tm.rate1,";",tm.rate2,";",g_cur,";",g_cur2 
   IF tm.choice = '1' THEN   
      CALL cl_prt_cs3('abmr212','abmr212',l_sql,g_str)     #FUN-710080 modify
   END IF 
   IF tm.choice = '2' THEN   
      CALL cl_prt_cs3('abmr212','abmr212_1',l_sql,g_str)   #FUN-710080 modify
   END IF 
   LET g_str = g_str,";",tm.s,";",tm.rate1,";",tm.rate2,";",g_cur,";",g_cur2
   #------------------------------ CR (4) ------------------------------#
   #MOD-720044 - END
END FUNCTION
 
#FUNCTION r212_bom(p_total,p_key,p_ver,p_acode) #FUN-560030 #TQC-AC0019
FUNCTION r212_bom(p_total,p_key,p_ver,p_acode,p_qpa) #FUN-560030 #TQC-AC0019
   DEFINE p_total       LIKE bmp_file.bmp06,   #FUN-560231
          l_total       LIKE bmp_file.bmp06,   #FUN-560231
          p_key		LIKE bmo_file.bmo01,   #主件料件編號
          p_ver 	LIKE bmo_file.bmo011,  #主件料件編號
          p_acode       LIKE bmo_file.bmo06,   #FUN-560030
          l_ac,i	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num10,  #No.FUN-680096 INTEGER
          l_tot         LIKE type_file.num10,  #No.FUN-680096 INTEGER
          l_chr		LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              order0    LIKE type_file.num5,   #階次 #CHI-6C0026
              order1    LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20)
              order2    LIKE bmp_file.bmp03,   #No.FUN-680096 VARCHAR(20)
              bmo01     LIKE bmo_file.bmo01,   #主件料件
              bmp01     LIKE bmp_file.bmp01,   #本階主件
              bmp03     LIKE bmp_file.bmp03,   #元件料號
              bmp011    LIKE bmp_file.bmp011,  #版本
              bmp02     LIKE bmp_file.bmp02,   #項次
              bmp06     LIKE bmp_file.bmp06,   #QPA/BASE
              bmq02     LIKE bmq_file.bmq02,   #品名規格
              bmq021    LIKE bmq_file.bmq021,  #No.TQC-5A0029
              bmq08     LIKE bmq_file.bmq08,   #來源
              bmq103    LIKE bmq_file.bmq103,  #購料特性
              bmq53     LIKE bmq_file.bmq53,   #最近採購
              bmq531    LIKE bmq_file.bmq531,  #市價
              bmq91     LIKE bmq_file.bmq91,   #月平均單價
              bmp10     LIKE bmp_file.bmp10    #發料單位   #NO.TQC-6C0034
            ##ima44     LIKE ima_file.ima44    #採購單位   #NO.FUN-610092 #NO.TQC-6C0034
          END RECORD,
          l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,  #TQC-5A0029
          l_ima08       LIKE ima_file.ima08,
          l_ima103      LIKE ima_file.ima103,
          l_ima53       LIKE ima_file.ima53,
          l_ima531      LIKE ima_file.ima531,
          l_imb218      LIKE imb_file.imb218,
          l_ima63       LIKE ima_file.ima63,   #發料單位 #NO.TQC-6C0034
          l_bmq02       LIKE bmq_file.bmq02,   #品名規格
          l_bmq021      LIKE bmq_file.bmq021,  #TQC-5A0029
          l_bmq05       LIKE bmq_file.bmq05,   #版本
          l_bmq08       LIKE bmq_file.bmq08,   #來源
          l_bmq25       LIKE bmq_file.bmq25,   #庫存單位
          l_desc        LIKE type_file.chr8,   #MOD-590022  #No.FUN-680096 VARCHAR(8)
          l_ima44       LIKE ima_file.ima44,   #NO.FUN-610092 #NO.TQC-6C0034
          l_cmd		LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(1000)
   DEFINE l_azi07 LIKE azi_file.azi07   #No.FUN-870151
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
   DEFINE p_qpa         LIKE bmp_file.bmp06   #TQC-AC0019
   DEFINE l_qpa         LIKE bmp_file.bmp06   #TQC-AC0019
   DEFINE l_bmp06       LIKE bmp_file.bmp06   #TQC-AC0019
   LET arrno = 600
   WHILE TRUE
      #CHI-6C0026..................begin
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM ima_file
                                WHERE ima01=p_key
      IF g_cnt > 0 THEN
         LET l_cmd=
             "SELECT distinct 0,'','',bma01, bmb01, bmb03, '', bmb02,",
             " ((bmb06/bmb07) * bmb10_fac),'','','','',0,0,0 ",
             "  FROM bmb_file, OUTER bma_file",
             " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
             " AND (bmb04 <='",g_today,"'",
             " OR bmb04 IS NULL) AND (bmb05 >'",g_today,"'",
             " OR bmb05 IS NULL)",
             " AND bmb_file.bmb03 = bma_file.bma01" ,
             " AND bmb29='",p_acode,"'"
      #CHI-6C0026..................end
      ELSE
         LET l_cmd=
             "SELECT distinct 0,'','',bmo01, bmp01, bmp03, bmp011, bmp02,", #CHI-6C0026
             " ((bmp06/bmp07) * bmp10_fac),'','','','',0,0,0 ", #TQC-5A0029
             "  FROM bmp_file, OUTER bmo_file",
             " WHERE bmp01='", p_key,"' AND bmp02 >",b_seq,
             " AND bmp011='",p_ver,"'",
             " AND bmp_file.bmp03 = bmo_file.bmo01" ,
             " AND bmp28='",p_acode,"'" #FUN-560030
      END IF
 
      PREPARE r212_precur FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL cl_err('P1:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
         EXIT PROGRAM 
         END IF
      DECLARE r212_cur CURSOR FOR r212_precur
      LET l_ac = 1
      FOREACH r212_cur INTO sr[l_ac].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('r212_cur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
        #SELECT ima02,ima08,ima103,ima53,ima531,imb218
        #NO.TQC-6C0034...........................................................
        ##NO.FUN-610092...........................................................
        ###No.TQC-5A0029  --begin
        #SELECT ima02,ima021,ima08,ima103,(ima53/ima44_fac),(ima531/ima44_fac),(imb218/ima44_fac) #BugNo:4237
        #  INTO l_ima02,l_ima021,l_ima08,l_ima103,l_ima53,l_ima531,l_imb218
        ###No.TQC-5A0029  --end
        #SELECT ima02,ima021,ima08,ima103,(ima53/ima44_fac),(ima531/ima44_fac),(imb218/ima44_fac),ima44 
        #  INTO l_ima02,l_ima021,l_ima08,l_ima103,l_ima53,l_ima531,l_imb218,l_ima44
         SELECT ima02,ima021,ima08,ima103,(ima53/ima44_fac),(ima531/ima44_fac),
                (imb218/ima44_fac),ima63 
           INTO l_ima02,l_ima021,l_ima08,l_ima103,l_ima53,l_ima531,
                l_imb218,l_ima63
        ##NO.FUN-610092...........................................................
        #NO.TQC-6C0034...........................................................
           FROM ima_file,OUTER imb_file
          WHERE ima01 = sr[l_ac].bmp03
            AND ima_file.ima01 = imb_file.imb01
         IF SQLCA.sqlcode THEN
           #No.TQC-6C0034  --begin
           #SELECT bmq02,bmq08,bmq103,bmq53,bmq531,bmq91
           ##No.TQC-5A0029  --begin
           #SELECT bmq02,bmq021,bmq08,bmq103,(bmq53/bmq44_fac),(bmq531/bmq44_fac),(bmq91/bmq44_fac) #BugNo:4237
           #  INTO l_ima02,l_ima021,l_ima08,l_ima103,l_ima53,l_ima531,l_imb218
            SELECT bmq02,bmq021,bmq08,bmq103,(bmq53/bmq44_fac),
                   (bmq531/bmq44_fac),(bmq91/bmq44_fac),bmq55 #BugNo:4237
              INTO l_ima02,l_ima021,l_ima08,l_ima103,l_ima53,
                   l_ima531,l_imb218,l_ima63
           ##No.TQC-5A0029  --end
           #No.TQC-6C0034  --end
              FROM bmq_file
             WHERE bmq01 = sr[l_ac].bmp03
            IF SQLCA.sqlcode THEN
               LET l_ima02 =' ' LET l_ima08 =' ' LET l_ima103 =''
               LET l_ima53 =0   LET l_ima531=0   LET l_imb218 =0
               LET l_ima021=' '   #No.TQC-5A0029
            END IF
         END IF
         #FUN-8B0015--BEGIN--                                                                                                     
         LET l_ima910[l_ac]=''
         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmp03
         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
         #FUN-8B0015--END-- 
         IF cl_null(l_ima53)   THEN LET l_ima53 = 0 END IF
         IF cl_null(l_ima531)  THEN LET l_ima531 = 0 END IF
         IF cl_null(l_imb218)  THEN LET l_imb218 = 0 END IF
         LET sr[l_ac].bmq02 =l_ima02
         LET sr[l_ac].bmq021=l_ima021 #No.TQC-5A0029
         LET sr[l_ac].bmq08 =l_ima08
         LET sr[l_ac].bmq103=l_ima103
         LET sr[l_ac].bmq53 =l_ima53
         LET sr[l_ac].bmq531=l_ima531
         LET sr[l_ac].bmq91 =l_imb218
        #LET sr[l_ac].ima44 =l_ima44   #NO.FUN-610092 #NO.TQC-6C0034
         LET sr[l_ac].bmp10 =l_ima63   #NO.FUN-610092 #NO.TQC-6C0034
         LET l_ac = l_ac + 1		
         IF l_ac = arrno THEN EXIT FOREACH END IF
      END FOREACH
      LET l_tot = l_ac -1
      FOR i = 1 TO l_ac-1	
         LET l_bmp06=sr[i].bmp06           #TQC-AC0019
         LET sr[i].bmp06=sr[i].bmp06*p_qpa #TQC-AC0019
         LET l_total=p_total*sr[i].bmp06 
         LET l_qpa=sr[i].bmp06 #TQC-AC0019
         #CHI-6C0026..................begin
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM ima_file
                                   WHERE ima01=sr[i].bmp03
         IF g_cnt>0 THEN #P-BOM
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM bmb_file
                                      WHERE bmb01=sr[i].bmp03
            IF g_cnt>0 THEN                          
              #CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,' ') #FUN-8B0015
               #CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,l_ima910[i]) #FUN-8B0015 #TQC-AC0019
               CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,l_ima910[i],l_qpa)  #TQC-AC0019
            ELSE
               CASE tm.s
                  WHEN '1'   LET sr[i].order1 = sr[i].bmp03
                             LET sr[i].order2 = sr[i].bmq103
                  WHEN '2'   LET sr[i].order1 = sr[i].bmq103
                             LET sr[i].order2 = sr[i].bmp03
                  OTHERWISE  LET sr[i].order1 = sr[i].bmp03
                             LET sr[i].order2 = sr[i].bmq103
               END CASE
 
               #MOD-720044 - START
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               SELECT bmq02,bmq021,bmq08,bmq25
                 INTO l_bmq02,l_bmq021,l_bmq08,l_bmq25
                 FROM bmq_file
                WHERE bmq01 = g_bmo01_a
               IF SQLCA.sqlcode THEN
                  SELECT ima02,ima021,ima08,ima25,ima44        
                    INTO l_bmq02,l_bmq021,l_bmq08,l_bmq25,l_ima44 
                    FROM ima_file
                   WHERE ima01 = g_bmo01_a
                  IF SQLCA.sqlcode THEN
                     LET l_bmq02=''
                     LET l_bmq08=''
                     LET l_bmq25=''
                     LET l_bmq021=''   
                  END IF
               END IF
               CALL s_purdesc(sr[i].bmq103) RETURNING l_desc
 
               #str FUN-770072 mod
               IF tm.choice matches'[13]' THEN   #rpt_type='1'  #明細表
                  EXECUTE insert_prep USING 
                     sr[i].bmo01 ,sr[i].bmp01 ,sr[i].bmp03,sr[i].bmp011,
                     sr[i].bmp02 ,sr[i].bmp06 ,sr[i].bmq02,sr[i].bmq021,
                     sr[i].bmq08 ,sr[i].bmq103,sr[i].bmq53,sr[i].bmq531,
                    #sr[i].bmq91 ,l_ima44     ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006 mark
                     sr[i].bmq91 ,sr[i].bmp10 ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006
                     g_bmo06     ,l_bmq02     ,l_bmq021   ,l_bmq08     ,
                     l_bmq25     ,l_desc      ,g_azi03    ,t_azi03     ,
                     t_azi07,l_azi07,
                     '1',l_bmp06     #TQC-AC0019 add bmp06
               END IF
               IF tm.choice matches'[23]' THEN   #rpt_type='2'  #總表
                  EXECUTE insert_prep USING 
                     sr[i].bmo01 ,sr[i].bmp01 ,sr[i].bmp03,sr[i].bmp011,
                     sr[i].bmp02 ,sr[i].bmp06 ,sr[i].bmq02,sr[i].bmq021,
                     sr[i].bmq08 ,sr[i].bmq103,sr[i].bmq53,sr[i].bmq531,
                    #sr[i].bmq91 ,l_ima44     ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006 mark
                     sr[i].bmq91 ,sr[i].bmp10 ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006
                     g_bmo06     ,l_bmq02     ,l_bmq021   ,l_bmq08     ,
                     l_bmq25     ,l_desc      ,g_azi03    ,t_azi03     ,
                     t_azi07,l_azi07,
                     '2',l_bmp06     #TQC-AC0019 add bmp06
               END IF
               #end FUN-770072 mod
               #------------------------------ CR (3) ------------------------------#
               #MOD-720044 - END
            END IF
         ELSE            #E-MOB
         #CHI-6C0026..................end
            IF sr[i].bmo01 IS NOT NULL THEN         #若為主件(有BOM單頭)
              #CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,' ')        #FUN-8B0015
              #CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,l_ima910[i])#FUN-8B0015  #TQC-AC0019
               CALL r212_bom(l_total,sr[i].bmp03,sr[i].bmp011,l_ima910[i],l_qpa)  #TQC-AC0019
            ELSE
               CASE tm.s
                  WHEN '1'   LET sr[i].order1 = sr[i].bmp03
                             LET sr[i].order2 = sr[i].bmq103
                  WHEN '2'   LET sr[i].order1 = sr[i].bmq103
                             LET sr[i].order2 = sr[i].bmp03
                  OTHERWISE  LET sr[i].order1 = sr[i].bmp03
                             LET sr[i].order2 = sr[i].bmq103
               END CASE
             # IF g_len = 0 OR g_len IS NULL THEN LET g_len = 200 END IF  #TQC-620107    #TQC-6A0081
             # LET g_len = 201          #TQC-6A0081
 
               #MOD-720044 - START
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               SELECT bmq02,bmq021,bmq08,bmq25
                 INTO l_bmq02,l_bmq021,l_bmq08,l_bmq25
                 FROM bmq_file
                WHERE bmq01 = g_bmo01_a
               IF SQLCA.sqlcode THEN
                  SELECT ima02,ima021,ima08,ima25,ima44        
                    INTO l_bmq02,l_bmq021,l_bmq08,l_bmq25,l_ima44 
                    FROM ima_file
                   WHERE ima01 = g_bmo01_a
                  IF SQLCA.sqlcode THEN
                     LET l_bmq02=''
                     LET l_bmq08=''
                     LET l_bmq25=''
                     LET l_bmq021=''   
                  END IF
               END IF
               CALL s_purdesc(sr[i].bmq103) RETURNING l_desc
                
               #str FUN-770072 mod
               IF tm.choice matches'[13]' THEN   #rpt_type='1'  #明細表
                  EXECUTE insert_prep USING 
                     sr[i].bmo01 ,sr[i].bmp01 ,sr[i].bmp03,sr[i].bmp011,
                     sr[i].bmp02 ,sr[i].bmp06 ,sr[i].bmq02,sr[i].bmq021,
                     sr[i].bmq08 ,sr[i].bmq103,sr[i].bmq53,sr[i].bmq531,
                    #sr[i].bmq91 ,l_ima44     ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006 mark
                     sr[i].bmq91 ,sr[i].bmp10 ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006
                     g_bmo06     ,l_bmq02     ,l_bmq021   ,l_bmq08     ,
                     l_bmq25     ,l_desc      ,g_azi03    ,t_azi03     ,
                     t_azi07,l_azi07,     #No:MOD-A10067 add
                     '1',l_bmp06          #TQC-AC0019 add bmp06
               END IF
               IF tm.choice matches'[23]' THEN   #rpt_type='2'  #總表
                  EXECUTE insert_prep USING 
                     sr[i].bmo01 ,sr[i].bmp01 ,sr[i].bmp03,sr[i].bmp011,
                     sr[i].bmp02 ,sr[i].bmp06 ,sr[i].bmq02,sr[i].bmq021,
                     sr[i].bmq08 ,sr[i].bmq103,sr[i].bmq53,sr[i].bmq531,
                    #sr[i].bmq91 ,l_ima44     ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006 mark
                     sr[i].bmq91 ,sr[i].bmp10 ,g_bmo01_a  ,g_bmo011_a  ,   #MOD-BB0006
                     g_bmo06     ,l_bmq02     ,l_bmq021   ,l_bmq08     ,
                     l_bmq25     ,l_desc      ,g_azi03    ,t_azi03     ,
                     t_azi07,l_azi07,     #No:MOD-A10067 add
                     '2',l_bmp06          #TQC-AC0019 add bmp06
               END IF
               #end FUN-770072 mod
               #------------------------------ CR (3) ------------------------------#
               #MOD-720044 - END
            END IF
         END IF
      END FOR
      IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_tot].bmp02
      END IF
   END WHILE
END FUNCTION
 
