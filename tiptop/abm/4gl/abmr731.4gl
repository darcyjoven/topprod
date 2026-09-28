# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr731.4gl
# Descriptions...: Ｅ．Ｃ．Ｎ．變更影響之請/採購/收貨一覽
# Input parameter:
# Return code....:
# Date & Author..: 01/06/14 By Linda
#                  No.+178 add
# Modify.........: No.FUN-4A0037 04/10/08 By Smapmin 新增開窗功能
# Modify.........: NO.MOD-510102 05/01/13 by ching EF簽核納入
# Modify.........: No.FUN-550032 05/05/17 by day   單據編號加大
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-550093 05/06/06 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-540011 05/06/14 By pengu 列印時,請多加ECN變更影響請購/採購/收貨一覽表功能,可直接列印
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630177 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-640120 06/04/10 By Claire bmy03加入取代
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-710025 07/03/06 By pengu 變異別欄位資料未依據與言別顯示
# Modify.........: No.FUN-750112 07/06/11 By Jackho CR報表修改
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.TQC-970252 09/07/24 By sherry 變異別內容抓取錯誤     
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modfiy sql
# Modify.........: No.FUN-A60013 10/06/03 By lilingyu 平行工藝
# Modify.........: No.TQC-AB0233 10/12/01 By vealxu tm.a,tm.b,tm.c,tm.more請預設為N
# Modify.........: No:TQC-C20170 12/02/14 By bart tm.wc型態改為STRING
# Modify.........: No:CHI-C20060 12/09/19 By bart 變更別增加"5.替代","6.替代變更"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		#wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)  #TQC-C20170  mark
        wc      STRING,   #TQC-C20170
                a       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                b       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                c       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
       #g_argv1      VARCHAR(10),                  #TQC-610068
        #l_str        LIKE type_file.chr4          #No.FUN-680096 VARCHAR(4) #TQC-970252 mark                                          
        l_str        LIKE type_file.chr20          #TQC-970252 add                             
 
DEFINE  g_i         LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE  l_table     STRING                  ### FUN-750112 ###
DEFINE  g_str       STRING                  ### FUN-750112 ###
DEFINE  g_sql       STRING                  ### FUN-750112 ###
#TQC-970252---Begin                                                                                                                 
#DEFINE  g_str1      LIKE type_file.chr4     ### FUN-750112 ###                                                                     
#DEFINE  g_str2      LIKE type_file.chr4     ### FUN-750112 ###                                                                     
DEFINE  g_str1      LIKE type_file.chr20                                                                                            
DEFINE  g_str2      LIKE type_file.chr20                                                                                            
#TQC-970252---End   

DEFINE  l_bmx50      LIKE bmx_file.bmx50      #FUN-A60013
 
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
 
 
   INITIALIZE tm.* TO NULL			# Default condition
  #TQC-610068-begin
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1=ARG_VAL(1)  #No.FUN-540011
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   ##No.FUN-570264 ---end---
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
  #TQC-610068-end
   DROP TABLE r731_t1
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "bmy01.bmy_file.bmy01,",
                "bmx02.bmx_file.bmx02,",
                "bmx07.bmx_file.bmx07,",
                "bmy02.bmy_file.bmy02,",
                #"chr4.type_file.chr4,",    #TQC-970252 mark              #l_str 
                "chr4.type_file.chr20,",    #TQC-970252 add               #l_str 
                "bmy29.bmy_file.bmy29,",
                "bmy011.bmy_file.bmy01,",
                "bmx021.bmx_file.bmx02,",
                "bmx071.bmx_file.bmx07,",
                "bmy021.bmy_file.bmy02,",
                #"chr41.type_file.chr4,",   #TQC-970252 mark                #l_str 
                "chr41.type_file.chr20,",   #TQC-970252 add                 #l_str 
                "bmy291.bmy_file.bmy29,",
                "chr1.type_file.chr1,",                  #kind 
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "pmn01.pmn_file.pmn01,",
                "pmm04.pmm_file.pmm04,",
                "pmm09.pmm_file.pmm09,",  
                "pmc03.pmc_file.pmc03,",
                "pmn02.pmn_file.pmn02,",
                "pmn20.pmn_file.pmn20,",
                "pmn50.pmn_file.pmn50,",  
                "pmn55.pmn_file.pmn55,",
                "pmn53.pmn_file.pmn53,",
                "pmn82.pmn_file.pmn82,"                   #n_qty
               ,"bmx50.bmx_file.bmx50"          #FUN-A60013 
 
    LET l_table = cl_prt_temptable('abmr731',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?,?  )             "    #FUN-A60013 add ?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
#No.FUN-680096--------------begin---------------
 
   CREATE TEMP TABLE r731_t1(
      item    LIKE type_file.chr1000,
      bmy01   LIKE bmy_file.bmy01,
      bmx02   LIKE bmx_file.bmx02,
      bmx07   LIKE bmx_file.bmx07,
      bmy02   LIKE bmy_file.bmy02,
      bmy03   LIKE bmy_file.bmy03,
      bmy29   LIKE bmy_file.bmy29)
    ;
 
#No.FUN-680096-----------------end---------------
   DELETE FROM r731_t1 WHERE 1=1
#------------------------------No.FUN-540011---------------------------
   #TQC-630177-begin
   #IF cl_null(tm.wc) THEN               #TQC-610068 tm.wc->g_argv1
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
   #TQC-630177-end
     #TQC-610068-begin
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
     #TQC-610068-end
      CALL r731_tm()	             	# Input print condition
   ELSE
     #LET tm.wc=" bmx01='",tm.wc,"'"            #TQC-630177 
      LET tm.a='Y'
      LET tm.b='Y'
      LET tm.c='Y'
      CALL r731()		          	# Read data and create out-file
   END IF
#------------------------------No.FUN-540011---------------------------
    DROP TABLE r731_t1
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r731_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE l_cmd	      LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
       p_row,p_col    LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r731_w AT p_row,p_col
        WITH FORM "abm/42f/abmr731"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bmy29",g_sma.sma118='Y')
    #FUN-560021................end
 
#FUN-A60013 --begin--
    IF g_sma.sma542 = 'Y' THEN 
       CALL cl_set_comp_visible("bmx50",TRUE)
    ELSE
    	 CALL cl_set_comp_visible("bmx50",FALSE)
    END IF  	    
    
    LET l_bmx50 = '1'
    DISPLAY l_bmx50 TO bmx50 
#FUN-A60013 --end--
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.a='Y'
   LET tm.b='Y'
   LET tm.c='Y'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02,bmy03,bmy29 #FUN-550093
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r731_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS  #FUN-A60013 
    INPUT tm.a,tm.b,tm.c,l_bmx50,tm.more FROM a,b,c,bmx50,more   #FUN-A60013 
    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
             LET l_bmx50 = '1'            #FUN-A60013
             DISPLAY l_bmx50 TO bmx50     #FUN-A60013 
             LET tm.a = 'N'       #TQC-AB0233
             LET tm.b = 'N'       #TQC-AB0233
             LET tm.c = 'N'       #TQC-AB0233
             LET tm.more = 'N'    #TQC-AB0233
             DISPLAY tm.a,tm.b,tm.c,tm.more TO a,b,c,more  #TQC-AB0233
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF

#FUN-A60013 --begin--
     AFTER FIELD bmx50
        IF NOT cl_null(l_bmx50) THEN
           IF l_bmx50 NOT MATCHES '[123]' THEN 
              NEXT FIELD CURRENT 
           END IF 
        ELSE
      	   NEXT FIELD CURRENT 
        END IF 
#FUN-A60013 --end--
         
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
      LET INT_FLAG = 0 CLOSE WINDOW r731_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr731'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('abmr731','9031',1)   
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
                         " '",tm.a  CLIPPED,"'",
                         " '",tm.b  CLIPPED,"'",
                         " '",tm.c  CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr731',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r731_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r731()
   ERROR ""
END WHILE
   CLOSE WINDOW r731_w
END FUNCTION
 
FUNCTION r731()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          #l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)  #TQC-C20170
          l_sql     STRING,   #TQC-C20170
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_bmz02       LIKE bmz_file.bmz02,
          l_item        LIKE ima_file.ima01,            #No.FUN-750112
          l_ima02       LIKE ima_file.ima02,            #No.FUN-750112
          sr1,sr2       RECORD                          #No.FUN-750112
                        item    LIKE ima_file.ima01,    #料件編號
                        bmy01   LIKE bmy_file.bmy01,    #ECN No.
                        bmx02   LIKE bmx_file.bmx02,    #ECN 輸入日
                        bmx07   LIKE bmx_file.bmx07,    #ECN 生效日
                        bmy02   LIKE bmy_file.bmy02,    #項次
                        bmy03   LIKE bmy_file.bmy03,    #變異別
                        bmy29   LIKE bmy_file.bmy29     #FUN-550093
                        END RECORD,
          sr            RECORD
                        kind    LIKE type_file.chr1,   #1.請購 2.採購 3.收貨 #No.FUN-680096 VARCHAR(1)
                        ima01   LIKE ima_file.ima01,
                        ima02   LIKE ima_file.ima02,
                        pmn01   LIKE pmn_file.pmn01,   #單號
                        pmm04   LIKE pmm_file.pmm04,   #單據日期
                        pmm09   LIKE pmm_file.pmm09,   #供應商/部門
                        pmc03   LIKE pmc_file.pmc03,   #簡稱
                        pmn02   LIKE pmn_file.pmn02,   #項次
                        pmn20   LIKE pmn_file.pmn20,   #採購量/請購量/收貨量
                        pmn50   LIKE pmn_file.pmn50,   #交貨量/轉採購量/入庫量
                        pmn55   LIKE pmn_file.pmn55,   #驗退
                        pmn53   LIKE pmn_file.pmn53,   #已入庫量/可入庫量
                        n_qty   LIKE pmn_file.pmn53    #未交量
                        END RECORD
     DEFINE l_cnt      LIKE type_file.num5            #No.FUN-750112
 
#--------------------No.FUN-750112--begin----CR(2)----------------#
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr731'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
     DROP TABLE abmr731_tmp;
 
     CREATE TEMP TABLE abmr731_tmp(
     item LIKE ima_file.ima01);
 
     DECLARE abmr731_tmp_cur CURSOR FOR 
      SELECT UNIQUE item FROM abmr731_tmp
       ORDER BY item
#--------------------No.FUN-750112--end------CR(2)----------------#
 
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
 
     DELETE FROM r731_t1 WHERE 1=1
     LET l_sql= "SELECT * FROM r731_t1 WHERE item=? ORDER BY bmy01"  #No.FUN-750112
     PREPARE r731_prep FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r731_ecn CURSOR FOR r731_prep
 
 #FUN-A60013 --begin--
  IF g_sma.sma542 = 'Y' AND (l_bmx50 = '1' OR l_bmx50 = '2') THEN
     LET l_sql = "SELECT bmy05,bmy01,bmx02,bmx07,bmy02,bmy03,bmy29 ",
                 "  FROM bmx_file, bmy_file ",
                 " WHERE bmx01=bmy01 AND bmx04 <> 'X' ",
                 "   AND ",tm.wc CLIPPED,
                 "   AND bmx50 = '",l_bmx50,"'",
                 " ORDER BY bmy01 "    
  ELSE             
 #FUN-A60013 --end--
     #將ECN 料號寫入暫存檔中
     LET l_sql = "SELECT bmy05,bmy01,bmx02,bmx07,bmy02,bmy03,bmy29 ", #FUN-550093
                 "  FROM bmx_file, bmy_file ",
                 " WHERE bmx01=bmy01 AND bmx04 <> 'X' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY bmy01 "     #No.FUN-750112
  END IF   #FUN-A60013   
                 
     PREPARE r731_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r731_c0 CURSOR FOR r731_prepare1
     FOREACH r731_c0 INTO sr1.*
       IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c0:',SQLCA.SQLCODE,0) END IF
       INSERT INTO r731_t1 VALUES(sr1.*)
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('ins r731_t1',SQLCA.SQLCODE,0)   #No.TQC-660046
          CALL cl_err3("ins","r731_t1","","",SQLCA.SQLCODE,"","ins r731_t1",1)  #No.TQC-660046
          EXIT FOREACH
       END IF
     END FOREACH
 
#-------------No.FUN-750112--begin----#
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     CALL cl_outnam('abmr731') RETURNING l_name
#     START REPORT r731_rep TO l_name
#     LET g_pageno = 0
#-------------No.FUN-750112--end------#
    #請購資料(未結案, 請購量>已轉採購量)
    IF tm.a='Y' THEN
       LET l_sql="SELECT '1',pml04,ima02,pmk01,pmk04,pmk13,",
                 "       gem02,pml02,pml20,pml21,(pml20-pml21),0,0 ",
               "  FROM pmk_file LEFT OUTER JOIN gem_file ON pmk13=gem01,pml_file LEFT OUTER JOIN ima_file ON pml04=ima01 ",
               " WHERE pmk01=pml01 ",
                #MOD-510102
               "   AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W') ",
               #--
               "   AND pml20 > pml21 ",
                #MOD-510102
               "   AND ( pmk25 <='2' OR pmk25='S' OR pmk25='R' OR pmk25='W') ",
               #--
               "   AND pmk18 != 'X'",
               "   AND pml04 IN (SELECT UNIQUE item FROM r731_t1 WHERE 1=1) "
       PREPARE r731_pr1 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM 
       END IF
       DECLARE r731_c1 CURSOR FOR r731_pr1
       FOREACH r731_c1 INTO sr.*
           IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c1:',SQLCA.SQLCODE,0)
              EXIT FOREACH
           END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
           EXECUTE insert_prep USING 
             '','','','','','','','','','','','',
             sr.kind,
             sr.ima01,sr.ima02,sr.pmn01,sr.pmm04,
             sr.pmm09,sr.pmc03,sr.pmn02,sr.pmn20,
             sr.pmn50,sr.pmn55,sr.pmn53,sr.n_qty,l_bmx50        #FUN-A60013 add l_bmx50
           INSERT INTO abmr731_tmp VALUES(sr.ima01);
#          OUTPUT TO REPORT r731_rep(sr.*)
#--------------------No.FUN-750112---end-----CR(3)----------------#
       END FOREACH
     END IF
    #採購資料(未結案, 未交量>0)
    IF tm.b='Y' THEN
       LET l_sql="SELECT '2',pmn04,ima02,pmm01,pmm04,pmm09,",
              #"     pmc03,pmn02,pmn20,pmn50,pmn55,pmn53,(pmn20-pmn50+pmn55) ",       #FUN-940083 MARK
               "     pmc03,pmn02,pmn20,pmn50,pmn55,pmn53,(pmn20-pmn50+pmn55+pmn58) ", #FUN-940083 ADD     
               "  FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc01 ,pmn_file LEFT OUTER JOIN ima_file ON pmn04=ima01 ",
               " WHERE pmm01=pmn01 ",
                #MOD-510102
               "   AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ",
               #--
              #"   AND (pmn20-pmn50+pmn55) > 0 ",       #FUN-940083 MARK
               "   AND (pmn20-pmn50+pmn55+pmn58) > 0 ", #FUN-940083 ADD    
                #MOD-510102
               "   AND ( pmm25 <='2' OR pmm25='S' OR pmm25='R' OR pmm25='W') ",
               #--
               "AND pmm18 != 'X'",
               "   AND pmn04 IN (SELECT UNIQUE item FROM r731_t1 WHERE 1=1) "
       PREPARE r731_pr2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM 
       END IF
       DECLARE r731_c2 CURSOR FOR r731_pr2
       FOREACH r731_c2 INTO sr.*
           IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c2:',SQLCA.SQLCODE,0)
              EXIT FOREACH
           END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
           EXECUTE insert_prep USING 
             '','','','','','','','','','','','',
             sr.kind,
             sr.ima01,sr.ima02,sr.pmn01,sr.pmm04,
             sr.pmm09,sr.pmc03,sr.pmn02,sr.pmn20,
             sr.pmn50,sr.pmn55,sr.pmn53,sr.n_qty,l_bmx50        #FUN-A60013 add l_bmx50
           INSERT INTO abmr731_tmp VALUES(sr.ima01);
#          OUTPUT TO REPORT r731_rep(sr.*)
#--------------------No.FUN-750112---end-----CR(3)----------------#
       END FOREACH
     END IF
    #收貨資料(可入庫量>0)
    IF tm.c='Y' THEN
       LET l_sql="SELECT '3',rvb05,ima02,rva01,rva06,rva05,",
               "     pmc03,rvb02,rvb07,rvb30,rvb29,rvb31,0 ",
               "  FROM rva_file,rvb_file,OUTER ima_file,OUTER pmc_file ",
               " WHERE rva01=rvb01 AND rvb_file.rvb05=ima_file.ima01 AND rva_file.rva05=pmc_file.pmc01 ",
               "   AND rvb31 > 0 AND rvaconf <> 'X' ",
               "   AND rvb05 IN (SELECT UNIQUE item FROM r731_t1 WHERE 1=1) "
       PREPARE r731_pr3 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM 
       END IF
       DECLARE r731_c3 CURSOR FOR r731_pr3
       FOREACH r731_c3 INTO sr.*
           IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c3:',SQLCA.SQLCODE,0)
              EXIT FOREACH
           END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
           EXECUTE insert_prep USING 
             '','','','','','','','','','','','',
             sr.kind,
             sr.ima01,sr.ima02,sr.pmn01,sr.pmm04,
             sr.pmm09,sr.pmc03,sr.pmn02,sr.pmn20,
             sr.pmn50,sr.pmn55,sr.pmn53,sr.n_qty,l_bmx50        #FUN-A60013 add l_bmx50
           INSERT INTO abmr731_tmp VALUES(sr.ima01);
#          OUTPUT TO REPORT r731_rep(sr.*)
#--------------------No.FUN-750112---end-----CR(3)----------------#
       END FOREACH
     END IF
 
#--------------------No.FUN-750112--begin----CR(3)----------------#
     LET l_item = NULL
     FOREACH abmr731_tmp_cur INTO l_item
        IF SQLCA.SQLCODE <>0 THEN 
           CALL cl_err('abmr731_tmp_cur:',SQLCA.SQLCODE,0)
           EXIT FOREACH
        END IF
        LET l_cnt = 0
        INITIALIZE sr1.* TO NULL
        INITIALIZE sr2.* TO NULL
        FOREACH r731_ecn USING l_item INTO sr1.*
            LET g_str1 = r731_bmy03(sr1.bmy03)
            SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_item
            LET l_cnt = l_cnt + 1
            IF l_cnt = 1 THEN
               LET sr2.*  = sr1.*
               LET g_str2 = g_str1
            ELSE
               EXECUTE insert_prep USING 
                 sr2.bmy01,sr2.bmx02,sr2.bmx07,sr2.bmy02,g_str1,sr2.bmy29,
                 sr1.bmy01,sr1.bmx02,sr1.bmx07,sr1.bmy02,g_str2,sr1.bmy29,
                 '0',l_item,l_ima02,'','','','','','','','','','',l_bmx50        #FUN-A60013 add l_bmx50
               LET l_cnt = 0
            END IF
        END FOREACH
        IF l_cnt = 1 THEN
           EXECUTE insert_prep USING 
             sr2.bmy01,sr2.bmx02,sr2.bmx07,sr2.bmy02,g_str2,sr2.bmy29,
             '','','','','','',
             '0',l_item,l_ima02,'','','','','','','','','','',l_bmx50        #FUN-A60013 add l_bmx50
        END IF
     END FOREACH
#--------------------No.FUN-750112---end-----CR(3)----------------#
 
 
#--------------------No.FUN-750112--begin----CR(4)----------------#
#     FINISH REPORT r731_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'bmx01,bmx02,bmy03,bmy29')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
#    LET g_str = g_str   #FUN-A60013 
     LET g_str = g_str CLIPPED,";",g_sma.sma542  #FUN-A60013

     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('abmr731','abmr731',l_sql,g_str)
#--------------------No.FUN-750112--end------CR(4)----------------#
END FUNCTION
 
#REPORT r731_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
#          l_buf		LIKE type_file.chr4,    #No.FUN-680096 VARCHAR(4)
#          l_cnt         LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_str         LIKE type_file.chr4,      #No.FUN-680096 VARCHAR(4)
#          sr1           RECORD
#                        item    LIKE ima_file.ima01,    #料件編號
#                        bmy01   LIKE bmy_file.bmy01,    #ECN No.
#                        bmx02   LIKE bmx_file.bmx02,    #ECN 輸入日
#                        bmx07   LIKE bmx_file.bmx07,    #ECN 生效日
#                        bmy02   LIKE bmy_file.bmy02,    #項次
#                        bmy03   LIKE bmy_file.bmy03,    #變異別
#                        bmy29   LIKE bmy_file.bmy29     #FUN-550093
#                        END RECORD,
#          sr            RECORD
#                        kind    LIKE type_file.chr1,    #1.請購 2.採購 3.收貨  #No.FUN-680096 VARCHAR(1)
#                        ima01   LIKE ima_file.ima01,
#                        ima02   LIKE ima_file.ima02,
#                        pmn01   LIKE pmn_file.pmn01,   #單號
#                        pmm04   LIKE pmm_file.pmm04,   #單據日期
#                        pmm09   LIKE pmm_file.pmm09,   #供應商/部門
#                        pmc03   LIKE pmc_file.pmc03,   #簡稱
#                        pmn02   LIKE pmn_file.pmn02,   #項次
#                        pmn20   LIKE pmn_file.pmn20,   #採購量/請購量/收貨量
#                        pmn50   LIKE pmn_file.pmn50,   #交貨量/轉採購量/入庫量
#                        pmn55   LIKE pmn_file.pmn55,   #驗退
#                        pmn53   LIKE pmn_file.pmn53,   #已入庫量/可入庫量
#                        n_qty   LIKE pmn_file.pmn53    #未交量
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#  ORDER BY sr.ima01,sr.kind,sr.pmm04
#  FORMAT
#    PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
# 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] CLIPPED,sr.ima01," ",sr.ima02  CLIPPED
#      SKIP 1 LINE
#      LET l_last_sw = 'n'
#
#    BEFORE GROUP OF sr.ima01
#      SKIP TO TOP OF PAGE
#      LET l_cnt=0
#      #列印ECN 資料
##No.FUN-550032-begin
#      PRINT g_x[12],g_x[26],COLUMN 68,g_x[12],g_x[26] #FUN-550093
#      PRINT g_x[13],g_x[27],COLUMN 68,g_x[13],g_x[27] #FUN-550093
#      FOREACH r731_ecn
#      USING sr.ima01
#      INTO sr1.*
#        LET l_cnt = l_cnt + 1
#        LET l_str = r731_bmy03(sr1.bmy03)
#        IF l_cnt =1 THEN
#           PRINT COLUMN  1,sr1.bmy01 CLIPPED,
#                 COLUMN 18,sr1.bmx02 CLIPPED,
#                 COLUMN 27,sr1.bmx07 CLIPPED,
#                 COLUMN 36,sr1.bmy02 USING "###&",
#                 COLUMN 42,l_str CLIPPED,
#                 COLUMN 47,sr1.bmy29 CLIPPED;  #FUN-550093
#        ELSE
#           PRINT COLUMN 68,sr1.bmy01 CLIPPED,
#                 COLUMN 85,sr1.bmx02 CLIPPED,
#                 COLUMN 94,sr1.bmx07 CLIPPED,
#                 COLUMN 103,sr1.bmy02 USING "###&",
#                 COLUMN 108,l_str CLIPPED,
#                 COLUMN 129,sr1.bmy29  #FUN-550093
#           LET l_cnt=0
#        END IF
#      END FOREACH
#      IF l_cnt=1 THEN PRINT " " END IF
#
#    BEFORE GROUP OF sr.kind
#      PRINT " "
#      CASE sr.kind
#         WHEN '1' PRINT g_x[14],COLUMN 47,g_x[16] CLIPPED
#                  PRINT g_x[15],COLUMN 47,g_x[17] CLIPPED
#         WHEN '2' PRINT g_x[18],COLUMN 47,g_x[20] CLIPPED
#                  PRINT g_x[19],COLUMN 47,g_x[21] CLIPPED
#         WHEN '3' PRINT g_x[22],COLUMN 47,g_x[24] CLIPPED
#                  PRINT g_x[23],COLUMN 47,g_x[25] CLIPPED
#      END CASE
#
#   ON EVERY ROW
#      PRINT COLUMN  1,sr.pmn01 CLIPPED,
#            COLUMN 18,sr.pmm04 CLIPPED,
#            COLUMN 27,sr.pmc03 CLIPPED,
#            COLUMN 38,sr.pmn02 USING "###&",
#            COLUMN 43,sr.pmn20 USING "#######&",
#            COLUMN 52,sr.pmn50 USING "#######&",
#            COLUMN 61,sr.pmn55 USING "#######&";
#      CASE sr.kind
#        WHEN '1' PRINT " "
#        WHEN '2' PRINT sr.pmn53 USING "#######&"," "  ,
#                       sr.n_qty USING "#######&"
#        WHEN '3' PRINT sr.pmn53 USING "#######&"
#      END CASE
##No.FUN-550032-end
##No.TQC-5C0005 begin
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT ' '
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED
##No.TQC-5C0005 end
#
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT ' '
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 3 LINE
#      END IF
#END REPORT
#
##-----------No.MOD-710025 modify
FUNCTION r731_bmy03(p_chr)
   DEFINE p_chr LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
 
   CASE WHEN p_chr='0' LET l_str=cl_getmsg('abm-830',g_lang)
        WHEN p_chr='1' LET l_str=cl_getmsg('abm-831',g_lang)
        WHEN p_chr='2' LET l_str=cl_getmsg('abm-832',g_lang)
        WHEN p_chr='3' LET l_str=cl_getmsg('abm-833',g_lang)
        WHEN p_chr='4' LET l_str=cl_getmsg('abm-834',g_lang)   #TQC-640120
        WHEN p_chr='5' LET l_str=cl_getmsg('abm-835',g_lang)   #CHI-C20060
        WHEN p_chr='6' LET l_str=cl_getmsg('abm-836',g_lang)   #CHI-C20060
   END CASE
   RETURN l_str
END FUNCTION
#-----------No.MOD-710025 end
#Patch....NO.TQC-610035 <001,002> #
