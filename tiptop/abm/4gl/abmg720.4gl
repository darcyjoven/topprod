# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmg720.4gl
# Descriptions...: 工程變異單
# Input parameter:
# Return code....:
# Date & Author..: 97/08/22 By Lynn
# Modify.........: No.MOD-4A0086(1) 93/10/06 By Mandy 若為4.取代報表僅存出舊料,建議也要秀出新料.
# Modify.........: No.MOD-4A0086(2) 93/10/06 By Mandy 若為4.取代時,只列印出4.,正確為4.取代
# Modify.........: No.FUN-4A0037 04/10/08 By Smapmin 新增開窗功能
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530079 05/02/15 By cate 報表標題標準化
# Modify.........: No.MOD-530217 05/03/23 By kim 頁次永遠為1
# Modify.........: No.FUN-550095 05/05/27 By Mandy 特性BOM
# Modify.........: No.FUN-550101 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-580014 05/08/15 By jackie 轉XML
# Modify.........: No.MOD-590178 05/09/21 By kim 列印時元件料號,長度不足,長度超過20碼時,會被截掉
# Modify.........: No.MOD-590474 05/10/03 By Claire 調整表頭由第二列改由第一列,影響欄位項次別,變異別,變異方式,BOM項
# Modify.........: No.FUN-5A0010 05/10/07 By Sarah 列印時bmy16(取替代)欄位都是show英文,新增p_ze(abm-815~abm-818)來顯示,CASE多增加5 SET替代
# Modify.........: No.FUN-5A0142 05/10/20 By Claire 報表格式調整
# Modify.........: No.MOD-5C0160 05/12/28 By kim 變異別納入p_zaa
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630177 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640178 06/04/09 By Rayven 不使用特性BOM時不打印計算方式
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-6A0123 06/12/07 By Claire bmy06,bmy07都要印小數點
# Modify.........: No.FUN-710089 07/02/01 By Judy Crystal Report修改 
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.MOD-7C0235 07/12/31 By Smapmin 品名/規格沒有印出來
# Modify.........: No.MOD-830070 08/03/10 By Carol 單位改印bmy10
# Modify.........: No.CHI-830020 08/03/20 By baofei CR輸出改為子報表寫法 
# Modify.........: No.FUN-940041 09/05/04 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.TQC-970095 09/07/09 By sherry 重新過單到32區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0054 10/02/26 By vealxu 新增申請部門，申請人欄位
# Modify.........: No.FUN-A60012 10/06/03 By vealxu 新增列印BOM類別欄位
# Modify.........: No.TQC-AC0171 10/12/15 By vealxu abmi720列印BOM類別無資料
# Modify.........: No.FUN-B40087 11/05/18 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C20051 12/02/26 By yangtt   GR調整
# Modify.........: No.MOD-C30608 12/03/12 By chenying 樣式調整
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No:FUN-C50004 12/05/03 By nanbing GR 優化 
# Modify.........: No:FUN-C30085 12/06/29 By nanbing GR 修改
# Modify.........: No:CHI-C20060 12/09/27 By bart 變更別增加"5.替代","6.替代變更"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
                type    LIKE type_file.chr1,    #No.FUN-A60012 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
        #g_argv1 LIKE bmx_file.bmx01 #FUN-550095  #TQC-610068
 
DEFINE   g_cnt   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i     LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
#FUN-710089.....begin 
DEFINE   g_sql    STRING
DEFINE   l_table  STRING
DEFINE   l_table1 STRING  #No.CHI-830020 
DEFINE   g_str    STRING
#FUN-710089.....end
###GENGRE###START
TYPE sr1_t RECORD
    bmx01 LIKE bmx_file.bmx01,
    bmx02 LIKE bmx_file.bmx02,
    bmx05 LIKE bmx_file.bmx05,
    bmx07 LIKE bmx_file.bmx07,
    gen02 LIKE gen_file.gen02,
    gem02 LIKE gem_file.gem02,
    bmy01 LIKE bmy_file.bmy01,
    bmy02 LIKE bmy_file.bmy02,
    bmy03 LIKE bmy_file.bmy03,
    bmy04 LIKE bmy_file.bmy04,
    bmy05 LIKE bmy_file.bmy05,
    bmy06 LIKE bmy_file.bmy06,
    bmy07 LIKE bmy_file.bmy07,
    bmy14 LIKE bmy_file.bmy14,
    bmy15 LIKE bmy_file.bmy15,
    bmy16 LIKE bmy_file.bmy16,
    bmy17 LIKE bmy_file.bmy17,
    bmy19 LIKE bmy_file.bmy19,
    bmy27 LIKE bmy_file.bmy27,
    bmy29 LIKE bmy_file.bmy29,
    bmy30 LIKE bmy_file.bmy30,
    ima25 LIKE ima_file.ima25,
    l_str LIKE type_file.chr1000,
    l_ima02 LIKE ima_file.ima02,
    l_ima021 LIKE ima_file.ima021,
    l_ima02a LIKE ima_file.ima02,
    l_ima021a LIKE ima_file.ima021,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,   #FUN-C40026 add
    sign_str  LIKE type_file.chr1000 #FUN-C40026 add
END RECORD

TYPE sr2_t RECORD
    bmg01 LIKE bmg_file.bmg01,
    bmg02 LIKE bmg_file.bmg02,
    bmg03 LIKE bmg_file.bmg03
END RECORD
###GENGRE###END

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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark

 
   INITIALIZE tm.* TO NULL			# Default condition
  #TQC-610068-begin
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
  #TQC-AC0171 ---------mod start------------
   LET tm.type = ARG_VAL(8) 
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
  #LET g_rep_user = ARG_VAL(8)
  #LET g_rep_clas = ARG_VAL(9)
  #LET g_template = ARG_VAL(10)
  #TQC-AC0171 --------mod end-----------------
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   LET g_rpt_name = ARG_VAL(5)  #No.FUN-7C0078
 # LET tm.type = ARG_VAL(11)     #No.FUN-A60012     #TQC-AC0171 mark 
   ##No.FUN-570264 ---end---
  #TQC-610068-end
 
#FUN-710089.....begin 
   LET g_sql = "bmx01.bmx_file.bmx01,",
               "bmx02.bmx_file.bmx02,",
               "bmx05.bmx_file.bmx05,",
               "bmx07.bmx_file.bmx07,",
               "gen02.gen_file.gen02,",     #No.CHI-9C0054 
               "gem02.gem_file.gem02,",     #No.CHI-9C0054 
               "bmy01.bmy_file.bmy01,",
               "bmy02.bmy_file.bmy02,",
               "bmy03.bmy_file.bmy03,",
               "bmy04.bmy_file.bmy04,",
               "bmy05.bmy_file.bmy05,",
               "bmy06.bmy_file.bmy06,",
               "bmy07.bmy_file.bmy07,",
               "bmy14.bmy_file.bmy14,",
               "bmy15.bmy_file.bmy15,",
               "bmy16.bmy_file.bmy16,",
               "bmy17.bmy_file.bmy17,",
               "bmy19.bmy_file.bmy19,",
               "bmy27.bmy_file.bmy27,",
               "bmy29.bmy_file.bmy29,",
               "bmy30.bmy_file.bmy30,",
               "ima25.ima_file.ima25,",
               "l_str.type_file.chr1000,",
#               "bmg01.bmg_file.bmg01,",   #No.CHI-830020 
#               "bmg03.bmg_file.bmg03,",   #No.CHI-830020 
               "l_ima02.ima_file.ima02,",     #MOD-7C0235
               "l_ima021.ima_file.ima021,",   #MOD-7C0235
               "l_ima02a.ima_file.ima02,",   #MOD-7C0235
               "l_ima021a.ima_file.ima021,",  #MOD-7C0235
               "sign_type.type_file.chr1,",   #簽核方式     #FUN-940041
               "sign_img.type_file.blob,",    #簽核圖檔     #FUN-940041
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)  #FUN-940041   #FUN-C40026 add 2?
               "sign_str.type_file.chr1000"   #FUN-C40026 add
   LET l_table = cl_prt_temptable('abmg720',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B40087  #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)      #FUN-B40087
      EXIT PROGRAM 
   END IF
#No.CHI-830020---Begin 
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
#               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
#               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,", 
#               #"        ?, ?, ?, ?, ?)"   #MOD-7C0235
#               "        ?, ?, ?, ?, ?, ?, ?)"   #MOD-7C0235
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF
   LET g_sql = "bmg01.bmg_file.bmg01,",                                                                                             
               "bmg02.bmg_file.bmg02,",                                                                                             
               "bmg03.bmg_file.bmg03"                                                                                               
   LET l_table1 = cl_prt_temptable('abmg7201',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN 
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B40087  #FUN-BB0047 mark 
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)      #FUN-B40087
       EXIT PROGRAM 
   END IF  
#No.CHI-830020---End 
#FUN-710089.....end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
  #TQC-610068-begin
   #IF cl_null(g_argv1)
   #   THEN CALL g720_tm()	             	# Input print condition
   #   ELSE LET tm.wc=" bmx01='",g_argv1,"'"
   #        CALL g720()		          	# Read data and create out-file
   #END IF
   #TQC-630177-begin
   #IF cl_null(tm.wc) THEN
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
   #TQC-630177-end
      LET tm.more = 'N'
      LET tm.type = '1'           #No.FUN-A60012 add  
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL g720_tm()	             	# Input print condition
   ELSE
      #LET tm.wc=" bmx01='",tm.wc,"'"            #TQC-630177 
       CALL g720()		          	# Read data and create out-file
   END IF
  #TQC-610068-end
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
  CALL cl_gre_drop_temptable(l_table||"|"||l_table1) 
END MAIN
 
FUNCTION g720_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 18
   END IF
 
   OPEN WINDOW g720_w AT p_row,p_col
        WITH FORM "abm/42f/abmg720"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_set_comp_visible("group",g_sma.sma542 = 'Y')   #No.FUN-A60012 add 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#FUN-4A0037新增開窗功能
   ON ACTION CONTROLP
      CALL cl_init_qry_var()
      LET g_qryparam.state = "c"
      LET g_qryparam.form = "q_bmx1"
      CALL cl_create_qry() RETURNING g_qryparam.multiret
      DISPLAY g_qryparam.multiret TO bmx01
 
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS           #No.FUN-A60012 add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g720_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmg720'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmg720','9031',1)
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
                         " '",tm.type CLIPPED,"'",              #No.TQC-AC0171 	add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                        #" '",tm.type CLIPPED,"'"               #No.FUN-A60012   #TQC-AC0171 mark 
         CALL cl_cmdat('abmg720',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW g720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g720()
   ERROR ""
END WHILE
   CLOSE WINDOW g720_w
END FUNCTION
 
FUNCTION g720()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
        l_ima02         LIKE ima_file.ima02,   #FUN-710089   
        l_ima021        LIKE ima_file.ima021,  #MOD-7C0235   
        l_ima02a        LIKE ima_file.ima02,   #FUN-710089
        l_ima021a       LIKE ima_file.ima021,  #MOD-7C0235
        l_str           LIKE type_file.chr1000, #FUN-710089
        l_bmg03         LIKE bmg_file.bmg03,   #FUN-710089
        l_bmg02         LIKE bmg_file.bmg02,   #CHI-830020 
        l_bmw04         LIKE bmw_file.bmw04,   #FUN-710089
        l_bmw05         LIKE bmw_file.bmw05,   #FUN-710089
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
#FUN-710089.....begin
#          bmx		RECORD LIKE bmx_file.*,
#          bmy		RECORD LIKE bmy_file.*,
#          ima		RECORD LIKE ima_file.*,
           sr           RECORD
                             bmx01 LIKE bmx_file.bmx01,
                             bmx02 LIKE bmx_file.bmx02,
                             bmx05 LIKE bmx_file.bmx05,
                             bmx07 LIKE bmx_file.bmx07,
                             gen02 LIKE gen_file.gen02,  #CHI-9C0054
                             gem02 LIKE gem_file.gem02,  #CHI-9C0054
                             bmy01 LIKE bmy_file.bmy01,
                             bmy02 LIKE bmy_file.bmy02,
                             bmy03 LIKE bmy_file.bmy03,
                             bmy04 LIKE bmy_file.bmy04,
                             bmy05 LIKE bmy_file.bmy05,
                             bmy06 LIKE bmy_file.bmy06,
                             bmy07 LIKE bmy_file.bmy07,
                             bmy14 LIKE bmy_file.bmy14,
                             bmy15 LIKE bmy_file.bmy15,
                             bmy16 LIKE bmy_file.bmy16,
                             bmy17 LIKE bmy_file.bmy17,
                             bmy19 LIKE bmy_file.bmy19,
                             bmy27 LIKE bmy_file.bmy27,
                             bmy29 LIKE bmy_file.bmy29,
                             bmy30 LIKE bmy_file.bmy30,
                             ima25 LIKE ima_file.ima25,
                             #ima02 LIKE ima_file.ima02,   #MOD-7C0235
                             l_str LIKE type_file.chr1000,
                             ima02 LIKE ima_file.ima02, #FUN-C50004 add
                             ima021 LIKE ima_file.ima021, #FUN-C50004 add
                             ima02_1 LIKE ima_file.ima02, #FUN-C50004 add
                             ima021_1 LIKE ima_file.ima021 #FUN-C50004 add
                       END RECORD
   ###FUN-940041 START ###
   DEFINE l_sql_2        LIKE type_file.chr1000   # RDSQL STATEMENT   
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_ii           INTEGER
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE bmx_file.bmx01
             END RECORD
   ###FUN-940041 END ###

   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
   
#FUN-710089.....end
#No.CHI-830020---Begin                                                                                                              
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",     #CHI-9C0054 add 2 ?                                                                        
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                             
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?)"  #FUN-940041 Add 3 ?         #FUN-C40026 add 1?                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)      #FUN-B40087
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?)"                                                                                                     
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)      #FUN-B40087
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
                                                                                                                                    
#No.CHI-830020---End  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)   #FUN-710089
     CALL cl_del_data(l_table1)  #No.CHI-830020   
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmxuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmxgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmxgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmxuser', 'bmxgrup')
     #End:FUN-980030
#FUN-710089.....begin
#    LET l_sql = "SELECT * ",
#                "  FROM bmx_file, bmy_file LEFT OUTER JOIN ima_file ON bmy05=ima01",
#                " WHERE bmx01=bmy01 ",
#                "   AND bmx04 <> 'X' AND ",tm.wc CLIPPED,
#                "   AND bmx06 = '2' " #FUN-550095 add
     LET l_sql = "SELECT bmx01,bmx02,bmx05,bmx07,'','',bmy01,bmy02,bmy03,bmy04,bmy05,bmy06,bmy07,bmy14,bmy15, ",  #CHI-9C0054 add '','' 

                 #"       bmy16,bmy17,bmy19,bmy27,bmy29,bmy30,ima25,ima02,'' ",   #MOD-7C0235 #FUN-C50004 mark 
                 #"       bmy16,bmy17,bmy19,bmy27,bmy29,bmy30,'','' ", #MOD-830070-modify   #MOD-7C0235
                 #"  FROM bmx_file ,bmy_file ",                        #MOD-830070-modify  #FUN-C50004 mark 
                 "       bmy16,bmy17,bmy19,bmy27,bmy29,bmy30,'','',a.ima02,a.ima021,b.ima02,b.ima021 ", #FUN-C50004 add
                 "  FROM bmx_file ,bmy_file LEFT OUTER JOIN ima_file a ON a.ima01=bmy14 ", #FUN-C50004 add
                 "                          LEFT OUTER JOIN ima_file b ON b.ima01=bmy05 ", #FUN-C50004 add
                 " WHERE bmx01=bmy01 ", #MOD-830070-modify  
                 "   AND bmx04 <> 'X' AND ",tm.wc CLIPPED,
                 "   AND bmx06 = '2' " 
#FUN-710089.....end
#No.FUN-A60012 ---------------start------------------
    CASE 
       WHEN tm.type = '1'
          LET l_sql = l_sql," AND bmx50 = '1'"
       WHEN tm.type = '2'
          LET l_sql = l_sql," AND bmx50 = '2'"
       WHEN tm.type = '3'
           LET l_sql = l_sql CLIPPED
    END CASE  
#No.FUN-A60012 ---------------end-------------------
     PREPARE g720_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM 
     END IF
     DECLARE g720_c0 CURSOR FOR g720_prepare1
     #FUN-C50004 sta
     LET l_sql = "SELECT bmg03,bmg02 FROM bmg_file ",
                 " WHERE bmg01=? ",
                 " ORDER BY bmg02 "
     PREPARE g720_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM 
     END IF                 
     DECLARE g720_c1 CURSOR FOR g720_prepare2 

     LET l_sql = "SELECT bmw04,bmw05 FROM bmw_file ",
                 " WHERE bmw01=? AND bmw02=? ",
                 " ORDER BY bmw03       " 
     PREPARE g720_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM 
     END IF                 
     DECLARE g720_c3 CURSOR FOR g720_prepare3
             
     #FUN-C50004 end 
#     CALL cl_outnam('abmg720') RETURNING l_name  #FUN-710089  mark
 
     #No.MOD-640178  --start--
     IF g_sma.sma118 = 'N' THEN
        LET g_zaa[46].zaa08 = ' '
     END IF 
     #No.MOD-640178  --end--
 
#     START REPORT g720_rep TO l_name   #FUN-710089  mark
 
 #    LET g_pageno = 0  #MOD-530217
#    FOREACH g720_c0 INTO bmx.*, bmy.*, ima.*                        
     FOREACH g720_c0 INTO sr.*   #FUN-710089                        
       IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF

#CHI-9C0054 ---start---
       SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 
           IN ( SELECT bmx10 FROM bmx_file WHERE bmx01 = sr.bmx01) 
       IF SQLCA.sqlcode THEN LET sr.gen02 = ' ' END IF 
       SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 
           IN (SELECT bmx13 FROM bmx_file WHERE bmx01 = sr.bmx01) 
       IF SQLCA.sqlcode THEN LET sr.gem02 = ' ' END IF   
#CHI-9C0054 ----end---

#FUN-710089.....begin
       #SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.bmy14 #FUN-C50004 mark  
       #IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF #FUN-C50004 mark  
       #SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.bmy14   #MOD-7C0235 #FUN-C50004 mark  
       #IF SQLCA.sqlcode THEN LET l_ima021 = ' ' END IF   #MOD-7C0235 #FUN-C50004 mark  
       #SELECT ima02 INTO l_ima02a FROM ima_file WHERE ima01=sr.bmy05 #FUN-C50004 mark  
       #IF SQLCA.sqlcode THEN LET l_ima02a = ' ' END IF #FUN-C50004 mark  
       #SELECT ima021 INTO l_ima021a FROM ima_file WHERE ima01=sr.bmy05   #MOD-7C0235 #FUN-C50004 mark  
       #IF SQLCA.sqlcode THEN LET l_ima021a = ' ' END IF   #MOD-7C0235 #FUN-C50004 mark
        #FUN-C50004 sta 
        IF cl_null(sr.ima02) THEN 
            LET sr.ima02 = ' '
        END IF 
        IF cl_null(sr.ima021) THEN 
           LET sr.ima021 = ' '
        END IF 
        IF cl_null(sr.ima02_1) THEN 
            LET sr.ima02_1 = ' '
        END IF 
        IF cl_null(sr.ima021_1) THEN 
           LET sr.ima021_1 = ' '
        END IF 
       #FUN-C50004 end  
      # DECLARE g720_c1 CURSOR FOR #FUN-C50004 mark
#          SELECT bmg03 FROM bmg_file WHERE bmg01=sr.bmx01 ORDER BY bmg02          #CHI-830020
      #    SELECT bmg03,bmg02 FROM bmg_file WHERE bmg01=sr.bmx01 ORDER BY bmg02    #CHI-830020  #FUN-C50004 mark
       LET g_cnt=0
   #    FOREACH g720_c1 INTO l_bmg03     #CHI-830020
     #  FOREACH g720_c1 INTO l_bmg03,l_bmg02 #CHI-830020  #FUN-C50004 mark
       FOREACH g720_c1 USING sr.bmx01 INTO l_bmg03,l_bmg02  #FUN-C50004 add
          IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
          LET g_cnt=g_cnt+1
          #EXECUTE insert_prep USING sr.*,'',l_bmg03,l_ima02a   #MOD-7C0235
        #  EXECUTE insert_prep USING sr.*,sr.bmx01,l_bmg03,l_ima02,l_ima021,l_ima02a,l_ima021a   #MOD-7C0235   #CHI-830020
            EXECUTE insert_prep1 USING sr.bmx01,l_bmg02,l_bmg03       #No.CHI-830020
       END FOREACH
       #DECLARE g720_c3 CURSOR FOR #FUN-C50004 mark
       #   SELECT bmw04,bmw05 FROM bmw_file #FUN-C50004 mark
       #         WHERE bmw01=sr.bmy01 AND bmw02=sr.bmy02 #FUN-C50004 mark
       #         ORDER BY bmw03 #FUN-C50004 mark
       LET l_str=NULL
       # FOREACH g720_c3 INTO l_bmw04,l_bmw05 #FUN-C50004 mark
       FOREACH g720_c3 USING sr.bmy01,sr.bmy02  INTO l_bmw04,l_bmw05  #FUN-C50004 add
          IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
          LET sr.l_str=sr.l_str CLIPPED,' ',
                    l_bmw04 CLIPPED,'*',l_bmw05 USING '<<<<'
       END FOREACH
       #EXECUTE insert_prep USING sr.*,'','',l_ima02a   #MOD-7C0235
#       EXECUTE insert_prep USING sr.*,'','',l_ima02,l_ima021,l_ima02a,l_ima021a   #MOD-7C0235    #CHI-830020 
       #  EXECUTE insert_prep USING sr.*,l_ima02,l_ima021,l_ima02a,l_ima021a,  #CHI-830020  #FUN-C50004 mark
         EXECUTE insert_prep USING sr.*,  #FUN-C50004 add
                                   "",l_img_blob,"N",""    #FUN-940041 #FUN-C40026 add ,""
#       OUTPUT TO REPORT g720_rep(bmx.*, bmy.*, ima.*)
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmx01,bmx02') RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05,";",g_sma.sma118,";",tm.type     #No.FUN-A60012 add tm.type
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   #  LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  #CHI-830020
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,"|",                                                        
                 "SELECT DISTINCT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED,"|",                                              
                 "SELECT DISTINCT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED  #CHI-830020 
   # CALL cl_prt_cs3('abmg720',l_sql,g_str)         #TQC-730088
     ###FUN-940041 START ###
     LET g_cr_table = l_table                 #主報表的temp table名稱
     LET g_cr_gcx01 = "asmi300"               #單別維護程式
     LET g_cr_apr_key_f = "bmx01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###     LET l_sql_2 = "SELECT DISTINCT bmx01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE key_pr FROM l_sql_2
     DECLARE key_cs CURSOR FOR key_pr
     LET l_ii = 1
     #報表主鍵值
     CALL g_cr_apr_key.clear()                #清空
     FOREACH key_cs INTO l_key.*            
        LET g_cr_apr_key[l_ii].v1 = l_key.v1
        LET l_ii = l_ii + 1
     END FOREACH
     ###FUN-940041 END ###
###GENGRE###     CALL cl_prt_cs3('abmg720','abmg720',l_sql,g_str)
    #MOD-C30608---add----str------------
    IF g_sma.sma118 = 'Y' THEN
       LET g_template = 'abmg720'
    ELSE 
       LET g_template = 'abmg720_1'
    END IF      
    #MOD-C30608---add----end------------
    CALL abmg720_grdata()    ###GENGRE###
 
   # FINISH REPORT g720_rep
 
   # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-710089.....end
END FUNCTION
 
#FUN-710089.....begin  mark
#REPORT g720_rep(bmx, bmy, ima)
#   DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
#          l_type        LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#          l_buf		LIKE cre_file.cre08,     #MOD-5C0160 4->10   #No.FUN-680096 CHAR910)
#          l_str		LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(400)
#          l_ima02       LIKE ima_file.ima02,
#          l_ima02_4     LIKE ima_file.ima02,#MOD-4A0086(1)
#          bmx		RECORD LIKE bmx_file.*,
#          bmy		RECORD LIKE bmy_file.*,
#          bmg		RECORD LIKE bmg_file.*,
#          bmw		RECORD LIKE bmw_file.*,
#          ima		RECORD LIKE ima_file.* 
#   DEFINE l_str1        LIKE type_file.chr20     #No.FUN-680096 VARCHAR(10)
#
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6 PAGE LENGTH g_page_line
#
#  ORDER BY bmx.bmx01
#  FORMAT
#    PAGE HEADER
##No.FUN-580014 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
#      PRINT g_x[11] CLIPPED,bmx.bmx01, COLUMN 30,g_x[12] CLIPPED,bmx.bmx02
#      PRINT g_x[13] CLIPPED,bmx.bmx05, COLUMN 30,g_x[14] CLIPPED,bmx.bmx07
#      PRINT g_dash2[1,g_len]
#    BEFORE GROUP OF bmx.bmx01
# #     LET g_pageno = 0  #MOD-530217
#      SKIP TO TOP OF PAGE
#      #----------------------------------------------------------------------
#      DECLARE g720_c1 CURSOR FOR
#         SELECT * FROM bmg_file WHERE bmg01=bmx.bmx01 ORDER BY bmg02
#      LET g_cnt=0
#      FOREACH g720_c1 INTO bmg.*
#         IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
#         LET g_cnt=g_cnt+1
#         IF g_cnt=1 THEN PRINT g_x[16] CLIPPED END IF
#         PRINT COLUMN 10,bmg.bmg03
#      END FOREACH
#      IF g_cnt>0 THEN PRINT g_dash2[1,g_len] END IF
#      #----------------------------------------------------------------------
##     PRINT COLUMN 30 ,g_x[19] CLIPPED
##     PRINT g_x[21] CLIPPED,COLUMN 50,g_x[22]                                                                 #FUN-550095
##     PRINT "---- -.---- ---------- ---- -------------------- -------------------- ----  -.--- --------/----" #FUN-550095
##MOD-590474-begin 調整報表位置
##     PRINTX name=H1 g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
##     PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
#     #FUN-5A0142-begin
#     #PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[38],g_x[39],g_x[40]
#     #PRINTX name=H2 g_x[34],g_x[35],g_x[36],g_x[37],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
#      PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[38],g_x[54],g_x[55],g_x[39]
#      PRINTX name=H2 g_x[34],g_x[35],g_x[36],g_x[37],g_x[45]
#      PRINTX name=H3 g_x[50],g_x[51],g_x[52],g_x[53],g_x[46],g_x[47],g_x[48],g_x[49],g_x[40]
#     #FUN-5A0142-end
##MOD-590474- end
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      #FUN-550095 add
#      CASE WHEN bmy.bmy30='1' LET l_type=bmy.bmy30,'.',g_x[31] CLIPPED #固定
#           WHEN bmy.bmy30='2' LET l_type=bmy.bmy30,'.',g_x[32] CLIPPED #變動
#           WHEN bmy.bmy30='3' LET l_type=bmy.bmy30,'.',g_x[33] CLIPPED #公式
#           OTHERWISE          LET l_type=' '
#      END CASE
#      #FUN-550095(end)
#      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=bmy.bmy14
#      LET l_buf=g720_bmy03(bmy.bmy03)
#      #FUN-5A0142-begin
#      #PRINTX name=D1
#            # MOD-590474 g_c[34,35,36,37] 改 g_c[41,42,43,44]
#      #      COLUMN g_c[41],bmy.bmy02 USING '#####',
#      #      COLUMN g_c[42],bmy.bmy03,'.',l_buf CLIPPED,
#      #      COLUMN g_c[43],bmy.bmy19 CLIPPED,
#      #      COLUMN g_c[44],bmy.bmy04 USING '#####',
#      #      COLUMN g_c[38],bmy.bmy14 CLIPPED, #MOD-590178
##FUN-550095 修正
#      #      COLUMN g_c[39],bmy.bmy29 CLIPPED,                #FUN-550095 add
# #          COLUMN g_c[40],l_ima02 CLIPPED, #MOD-4A0238      #FUN-550095
#      #      COLUMN g_c[40],bmy.bmy17                         #FUN-550095
#      #PRINTX name=D2
#      #      COLUMN g_c[45],l_ima02 CLIPPED
#      PRINTX name=D1
#            COLUMN g_c[41],bmy.bmy02 USING '###&', #FUN-590118
#            COLUMN g_c[42],bmy.bmy03,'.',l_buf CLIPPED,
#            COLUMN g_c[43],bmy.bmy19 CLIPPED,
#            COLUMN g_c[44],bmy.bmy04 USING '#####',
#            COLUMN g_c[38],bmy.bmy14 CLIPPED, #MOD-590178
#            COLUMN g_c[39],bmy.bmy29 CLIPPED                #FUN-550095 add
#      PRINTX name=D1
#             COLUMN g_c[38],l_ima02 CLIPPED
#      #FUN-5A0142-end
#
#           #start FUN-5A00
#           #CASE WHEN bmy.bmy16='0' LET l_str1='NO ';
#           #     WHEN bmy.bmy16='1' LET l_str1='UTE';
#           #     WHEN bmy.bmy16='2' LET l_str1='SUB';
#           #     OTHERWISE          LET l_str1='   ';
#           #END CASE
#            CASE
#               WHEN bmy.bmy16='0'  #NO  - 不可取替代
#                    CALL cl_getmsg('abm-815',g_lang) RETURNING l_str1
#               WHEN bmy.bmy16='1'  #UTE - 取代
#                    CALL cl_getmsg('abm-816',g_lang) RETURNING l_str1
#               WHEN bmy.bmy16='2'  #SUB - 替代
#                    CALL cl_getmsg('abm-817',g_lang) RETURNING l_str1
#               WHEN bmy.bmy16='5'  #SET SUB - SET替代
#                    CALL cl_getmsg('abm-818',g_lang) RETURNING l_str1
#               OTHERWISE
#                    LET l_str1='   '
#            END CASE
#           #end FUN-5A0010
#      #FUN-5A0142-begin
#      PRINTX name=D2
#            COLUMN g_c[45],bmy.bmy05 #MOD-590178
#      PRINTX name=D2
#            COLUMN g_c[45],ima.ima02 CLIPPED
#      #      COLUMN g_c[46],l_type CLIPPED,
#      #      COLUMN g_c[47],ima.ima25,
#      #      COLUMN g_c[48],bmy.bmy16 CLIPPED,'.',l_str1,
#      #      COLUMN g_c[49],bmy.bmy06 USING '--------','/',bmy.bmy07 USING '----'
#      #PRINTX name=D1
#      #       COLUMN g_c[38],ima.ima02 CLIPPED
#      IF g_sma.sma118 = 'Y' THEN
#         PRINTX name=D3
#               COLUMN g_c[46],l_type CLIPPED,
#               COLUMN g_c[47],ima.ima25,
#               COLUMN g_c[48],bmy.bmy16 CLIPPED,'.',l_str1,
#              #MOD-6A0123-begin
#              #COLUMN g_c[49],bmy.bmy06 USING '--------','/',bmy.bmy07 USING '----',
#               COLUMN g_c[49],bmy.bmy06 USING '------.-----','/',bmy.bmy07 USING '------.-----',
#              #MOD-6A0123-end
#               COLUMN g_c[40],bmy.bmy17                         #FUN-550095
#      ELSE
#         PRINTX name=D3
#               COLUMN g_c[47],ima.ima25,
#               COLUMN g_c[48],bmy.bmy16 CLIPPED,'.',l_str1,
#              #MOD-6A0123-begin
#              #COLUMN g_c[49],bmy.bmy06 USING '--------','/',bmy.bmy07 USING '----',
#               COLUMN g_c[49],bmy.bmy06 USING '------.-----','/',bmy.bmy07 USING '------.-----',
#              #MOD-6A0123-end
#               COLUMN g_c[40],bmy.bmy17                         #FUN-550095
#      END IF
#      #FUN-5A0142-end
##FUN-550095(end)
#
#      #MOD-4A0086(1)
#      IF bmy.bmy03 = '4' THEN #取代
#          PRINTX name=D2 COLUMN g_c[37],g_x[23] CLIPPED,  #FUN-5A0142 add name=D2
#                COLUMN g_c[45],bmy.bmy27     #FUN-5A0142 g_c[38]->[45]
#          SELECT ima02 INTO l_ima02_4 FROM ima_file
#           WHERE ima01 = bmy.bmy27
#          PRINTX name=D2 COLUMN g_c[45],l_ima02_4   #FUN-5A0142 add name=D2  [38]->[45]
#      END IF
#      #MOD-4A0086(1)(end)
#     #IF bmy.bmy22[1,40]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[1,40] END IF
#     #IF bmy.bmy22[41,80]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[41,80] END IF
#     #IF bmy.bmy22[81,120]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[81,120] END IF
#     #IF bmy.bmy22[121,160]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[121,160] END IF
#     #IF bmy.bmy22[161,200]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[161,200] END IF
#     #IF bmy.bmy22[201,240]<>' ' THEN PRINT COLUMN 29,bmy.bmy22[201,240] END IF
#      #----------------------------------------------------------------------
#      DECLARE g720_c3 CURSOR FOR
#         SELECT * FROM bmw_file
#               WHERE bmw01=bmy.bmy01 AND bmw02=bmy.bmy02
#               ORDER BY bmw03
#      LET l_str=NULL
#      FOREACH g720_c3 INTO bmw.*
#         IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
#         LET l_str=l_str CLIPPED,' ',
#                   bmw.bmw04 CLIPPED,'*',bmw.bmw05 USING '<<<<'
#      END FOREACH
#      IF l_str IS NOT NULL THEN
#       #  PRINT COLUMN g_c[36],g_x[20] CLIPPED,l_str[2,40]  #FUN-5A0142
#        PRINTX name=D2 COLUMN g_c[36],g_x[20] CLIPPED,l_str[2,40]
#         IF l_str[41,80]<>' ' THEN PRINTX name=D2 COLUMN g_c[45],l_str[41,80] END IF
#         IF l_str[81,120]<>' ' THEN PRINTX name=D2 COLUMN g_c[45],l_str[81,121] END IF
#         IF l_str[121,160]<>' ' THEN PRINTX name=D2 COLUMN g_c[45],l_str[121,160] END IF
#         IF l_str[161,200]<>' ' THEN PRINTX name=D2 COLUMN g_c[45],l_str[161,200] END IF
#      END IF
#      #----------------------------------------------------------------------
##No.FUN-580014 --end--
### FUN-550101
#        PRINT ' ' #FUN-5A0142
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n' THEN
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#      PRINT ' '
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]
#             PRINT g_memo
#      END IF
### END FUN-550101
#
#END REPORT
#
#FUNCTION g720_bmy03(p_chr)
#   DEFINE p_chr LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
#   DEFINE l_buf	LIKE type_file.chr20     #No.FUN-680096 VARCHAR(10)
#
#    CASE #WHEN p_chr='0' LET l_buf='刪除' #MOD-4A0086(2)
#         WHEN p_chr='1' LET l_buf=g_x[27] CLIPPED
#         WHEN p_chr='2' LET l_buf=g_x[28] CLIPPED
#         WHEN p_chr='3' LET l_buf=g_x[29] CLIPPED
#          WHEN p_chr='4' LET l_buf=g_x[30] CLIPPED #MOD-4A0086(2)
#   END CASE
#   RETURN l_buf
#END FUNCTION
#FUN-710089.....end  mark
#Patch....NO.TQC-610035 <> #
#TQC-970095 重新過單

###GENGRE###START
FUNCTION abmg720_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("abmg720")
        IF handler IS NOT NULL THEN
            START REPORT abmg720_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY bmx01,bmy02"
          
            DECLARE abmg720_datacur1 CURSOR FROM l_sql
            FOREACH abmg720_datacur1 INTO sr1.*
                OUTPUT TO REPORT abmg720_rep(sr1.*)
            END FOREACH
            FINISH REPORT abmg720_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT abmg720_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    #FUN-B40087  add-----------------str---
    DEFINE l_lineno        LIKE type_file.num5
    DEFINE l_bmy03         STRING 
    DEFINE l_bmy05_ima02a  STRING
    DEFINE l_bmy14_ima02   STRING
    DEFINE l_bmy16         STRING
    DEFINE l_bmy30         STRING
    DEFINE l_str1          LIKE type_file.chr1000
    DEFINE l_str2          LIKE type_file.chr1000
    DEFINE l_str3          LIKE type_file.chr1000
    DEFINE l_str4          LIKE type_file.chr1000
    DEFINE l_str5          LIKE type_file.chr1000
    DEFINE l_str6          STRING 
    DEFINE l_sql           STRING
    DEFINE l_display       LIKE sma_file.sma118
    DEFINE l_display1      STRING     #FUN-C30085 add
    #FUN-B40087  add-----------------end---

    
    ORDER EXTERNAL BY sr1.bmx01,sr1.bmy02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.bmx01
            LET l_lineno = 0
            #FUN-B40087  add-----------------str---
            LET l_display = g_sma.sma118
            PRINTX l_display
            LET l_str6 = cl_gr_getmsg("gre-021",g_lang,tm.type)
            PRINTX l_str6

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE bmg01 = '",sr1.bmx01 CLIPPED,"'"
             START REPORT abmg720_subrep01
             DECLARE abmg720_repcur1 CURSOR FROM l_sql
             FOREACH abmg720_repcur1 INTO sr2.*
                 OUTPUT TO REPORT abmg720_subrep01(sr2.*)
             END FOREACH
             FINISH REPORT abmg720_subrep01

            #MOD-C30608---MARK----STR-----  
            #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
            #           " WHERE bmg01 = '",sr1.bmx01 CLIPPED,"'"
            #START REPORT abmg720_subrep02     
            #DECLARE abmg720_repcur2 CURSOR FROM l_sql
            #FOREACH abmg720_repcur2 INTO sr2.*
            #    OUTPUT TO REPORT abmg720_subrep02(sr2.*) 
            #END FOREACH
            #FINISH REPORT abmg720_subrep02   
            #MOD-C30608---MARK----END-----  
            #FUN-B40087  add-----------------end---

        BEFORE GROUP OF sr1.bmy02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40087  add-----------------str---
            IF NOT cl_null(sr1.bmy03) THEN
               IF sr1.bmy03 ="0" OR sr1.bmy03 = "1" OR sr1.bmy03 ="2" OR sr1.bmy03 = "3" OR sr1.bmy03 = "4" 
                  OR sr1.bmy03 = "5" OR sr1.bmy03 = "6" THEN   #CHI-C20060
                  LET l_bmy03 = sr1.bmy03,'.', cl_gr_getmsg("gre-024",g_lang,sr1.bmy03)
               ELSE
                  LET l_bmy03 = NULL
               END IF
            ELSE
               LET l_bmy03 = NULL
            END IF
            PRINTX l_bmy03
            LET l_bmy05_ima02a = sr1.bmy05,' ',sr1.l_ima02a,' ',sr1.l_ima021a
            PRINTX l_bmy05_ima02a
            LET l_bmy14_ima02 = sr1.bmy14,' ',sr1.l_ima02,' ',sr1.l_ima021
            PRINTX l_bmy14_ima02
            IF NOT cl_null(sr1.bmy16) THEN
               LET l_bmy16 = sr1.bmy16,'.',cl_gr_getmsg("gre-022",g_lang,sr1.bmy16)
               LET l_bmy16 = l_bmy16.trim()       #FUN-C20051 add
            ELSE
               LET l_bmy16 = NULL
            END IF
            PRINTX l_bmy16
            IF NOT cl_null(sr1.bmy30) THEN
               LET l_bmy30 = sr1.bmy30,'.',cl_gr_getmsg("gre-025",g_lang,sr1.bmy30)
            ELSE
               LET l_bmy30 = NULL
            END IF

            PRINTX l_bmy30
            LET l_str1 = sr1.l_str[1,40]
            #FUN-C30085 sta
            IF cl_null(l_str1) THEN 
               LET l_display1 = 'N'
            ELSE
               LET l_display1 = 'Y'   
            END IF   
            PRINTX l_display1 
            #FUN-C30085 end
            PRINTX l_str1
            LET l_str2 = sr1.l_str[41,81]
            PRINTX l_str2
            LET l_str3 = sr1.l_str[81,121]
            PRINTX l_str3
            LET l_str4 = sr1.l_str[121,161]
            PRINTX l_str4
            LET l_str5 = sr1.l_str[161,201]
            PRINTX l_str5
            #FUN-B40087  add-----------------end---

            PRINTX sr1.*

        AFTER GROUP OF sr1.bmx01
        AFTER GROUP OF sr1.bmy02

        
        ON LAST ROW

END REPORT
#FUN-B40087  add-----------------str---
REPORT abmg720_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

#MOD-C30608---mark----str-----------
#REPORT abmg720_subrep02(sr2) 
#   DEFINE sr2 sr2_t

#   FORMAT
#       ON EVERY ROW
#           PRINTX sr2.*
#END REPORT
#MOD-C30608---mark----end-----------
#FUN-B40087  add-----------------end---
###GENGRE###iEND
