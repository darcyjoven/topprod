# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#  
# Pattern name...: abmr730.4gl
# Descriptions...: Ｅ．Ｃ．Ｎ．變更影響之工單一覽
# Input parameter:
# Return code....:
# Date & Author..: 01/01/11 By plum
# Modify.........: No.FUN-4A0037 04/10/08 By Smapmin 新增開窗功能
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510033 05/01/18 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/06/06 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置和頁數調整
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630177 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640186 06/04/09 By Carrier 修改變異碼說明
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-750093 07/06/05 By arman 報表改為使用crystal report
# Modify.........: No.MOD-910196 09/02/02 By liuxqa 抓取受影響的工單時，應考慮其上階的每一階料號來做比較，否則就有可能漏資料。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A30081 10/03/16 By lilingyu 如果sql加了工單已經審核的條件,如果ECN也影響到未審核的工單,在此不列印的,
# ....................................................同時,這工單審核時,系統并不提醒有ECN存在,這樣可能會出現問題
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify.........: No.FUN-A60013 10/06/03 By lilingyu 平行工藝
# Modify.........: No.TQC-AB0367 10/11/30 By chenying 打印條件未顯示
# Modify.........: No.TQC-AB0233 10/12/01 By vealxu tm.more請預設為N
# Modify.........: No:TQC-B10026 11/01/06 By yinhy 未刪除臨時表數據
# Modify.........: No:TQC-C20170 12/02/14 By bart tm.wc型態改為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		   #wc     	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)  #TQC-C20170 mark
           wc       STRING,    #TQC-C20170 add
   		 more	    LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)	
              END RECORD,
        #g_argv1      LIKE bmx_file.bmx01, #FUN-550095  #TQC-610068
        l_str1       LIKE type_file.chr50,      #No.FUN-680096 VARCHAR(30)
        l_str        LIKE type_file.chr4          #No.FUN-680096 VARCHAR(4)
 
DEFINE   g_i         LIKE type_file.num5        #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_str       STRING               #NO.FUN-750093
DEFINE   l_table       STRING               #NO.FUN-750093
DEFINE   g_sql         STRING               #NO.FUN-750093
DEFINE   l_bmx50       LIKE bmx_file.bmx50     #FUN-A60013   	


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
 
   #NO.FUN-750093   -----begin-----
   LET g_sql = "bmx01.bmx_file.bmx01,",
               "bmy02.bmy_file.bmy02,",
               "bmx02.bmx_file.bmx02,",
               "bmy05.bmy_file.bmy05,",
               "bmx07.bmx_file.bmx07,",
               "ima02.ima_file.ima02,",
               "bmy29.bmy_file.bmy29,",
               "ima021.ima_file.ima021,",
               "bmg03.bmg_file.bmg03,",
               "bmy03.bmy_file.bmy03,",
               "sfa05.sfa_file.sfa05,",
               "sfa06.sfa_file.sfa06,",
               "sfb01.sfb_file.sfb01,",
               "sfb04.sfb_file.sfb04,",
               "sfb05.sfb_file.sfb05,",
               "sfb08.sfb_file.sfb08,",
               "sfb09.sfb_file.sfb09,",
               "sfb13.sfb_file.sfb13,",
               "sfb15.sfb_file.sfb15,",
               "imaa02.imaa_file.imaa02,",
               "imaa021.imaa_file.imaa021," 
              ,"bmx50.bmx_file.bmx50"          #FUN-A60013               
   LET l_table = cl_prt_temptable('abmr730',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql=" INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"    #FUN-A60013 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
 
   #NO.FUN-750093    -----end-------
   INITIALIZE tm.* TO NULL			# Default condition
   #TQC-610068-begin
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1=ARG_VAL(1)
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   LET g_rpt_name = ARG_VAL(5)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610068-end
   #TQC-610068-begin
   #IF cl_null(g_argv1)
   #   THEN CALL r730_tm()	             	# Input print condition
   #   ELSE LET tm.wc=" bmx01='",g_argv1,"'"
   #        CALL r730()		          	# Read data and create out-file
   #END IF
   #TQC-630177-begin
   #IF cl_null(tm.wc) THEN
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off  
   
   #TQC-630177-end
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL r730_tm()	             	# Input print condition
   ELSE
     #LET tm.wc=" bmx01='",tm.wc,"'"            #TQC-630177 
      CALL r730()		          	# Read data and create out-file
   END IF
   #TQC-610068-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r730_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE l_cmd	      LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(1000)
       p_row,p_col    LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW r730_w AT p_row,p_col
        WITH FORM "abm/42f/abmr730"
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
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02,bmy29 #FUN-550093
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#   INPUT BY NAME tm.more WITHOUT DEFAULTS       #FUN-A60013
    INPUT l_bmx50,tm.more FROM bmx50,more        #FUN-A60013
    
         #No.FUN-580031 --start--
         BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
           LET l_bmx50 = '1' 
           DISPLAY l_bmx50 TO bmx50              
           LET tm.more = 'N'         #TQC-AB0233
           DISPLAY tm.more TO more   #TQC-AB0233
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r730_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr730'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr730','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr730',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r730_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r730()
   ERROR ""
END WHILE
   CLOSE WINDOW r730_w
END FUNCTION
 
FUNCTION r730()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          #l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000) #TQC-C20170
          l_sql     STRING,#TQC-C20170
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_bmz02       LIKE bmz_file.bmz02,
#No.MOD-910196 add by liuxqa 
          l_sfb05       LIKE sfb_file.sfb05,
          l_bmz021      LIKE bmz_file.bmz02,
          l_count       LIKE type_file.num5,
          l_bmb011      LIKE bmb_file.bmb01,
#No.MOD-910196 add by liuxqa
          sr            RECORD
                        sfa05  LIKE sfa_file.sfa05,
                        sfa06  LIKE sfa_file.sfa06,
                        sfb01  LIKE sfb_file.sfb01,
                        sfb04  LIKE sfb_file.sfb04,
                        sfb05  LIKE sfb_file.sfb05,
                        sfb08  LIKE sfb_file.sfb08,
                        sfb09  LIKE sfb_file.sfb09,
                        sfb13  LIKE sfb_file.sfb13,
                        sfb15  LIKE sfb_file.sfb15,
                        ima02  LIKE ima_file.ima02,
                        ima021 LIKE ima_file.ima021
                        END RECORD,
          bmx		RECORD LIKE bmx_file.*,
          bmy		RECORD LIKE bmy_file.*,
          l_bmg03       LIKE bmg_file.bmg03,   #NO.FUN-750093
          ima		RECORD LIKE ima_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      
     CALL cl_del_data(l_table)        #TQC-B10026 add 
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

#FUN-A60013 --begin--
  IF g_sma.sma542 = 'Y' AND (l_bmx50 = '1' OR l_bmx50 = '2') THEN 
     LET l_sql = "SELECT bmx_file.*,bmy_file.*,ima_file.* ",
                  "FROM bmx_file,bmy_file LEFT OUTER JOIN ima_file ON bmy05=ima01 ", 
                 " WHERE bmx01=bmy01 AND bmx04 <> 'X'  ",
                  " AND ",tm.wc CLIPPED,    
                  " AND bmx50 = '",l_bmx50,"'"                                                             
  ELSE
#FUN-A60013 --end-- 
     LET l_sql = "SELECT bmx_file.*,bmy_file.*,ima_file.* ",
#                 "FROM bmx_file,bmy_file,ima_file",            #TQC-A30081
                  "FROM bmx_file,bmy_file LEFT OUTER JOIN ima_file ON bmy05=ima01 ", #TQC-A30081
                 " WHERE bmx01=bmy01 AND bmx04 <> 'X'  ",
#                 " AND bmy05=ima01(+) AND ",tm.wc CLIPPED   #TQC-A30081
                  " AND ",tm.wc CLIPPED                                             #TQC-A30081
  END IF   #FUN-A60013                
     PREPARE r730_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r730_c0 CURSOR FOR r730_prepare1
 
     LET l_sql="SELECT bmz02 FROM bmz_file ",
               " WHERE bmz01=? "
   
     PREPARE r730_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r730_c2 CURSOR FOR r730_prepare2
 
    #去串影響到的工單(已確認,未結案)
     LET l_sql="SELECT sfa05,sfa06,sfb01,sfb04,sfb05,sfb08,sfb09,sfb13,sfb15, ",
               "       ima02,ima021 ",
#               "FROM sfb_file,sfa_file,ima_file",  #TQC-A30081
                "FROM sfa_file,sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01 ",  #TQC-A30081
#               " WHERE sfb01=sfa01 AND sfb04!='8' AND sfb87 ='Y' ",    #TQC-A30081
                " WHERE sfb01=sfa01 AND sfb04!='8' AND sfb87 !='X' ",  #TQC-A30081
#               " AND sfb05=ima01(+) ",   #TQC-A30081
               " AND sfb05=?  AND sfa03=?  "
     PREPARE r730_prepare3 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r730_c3 CURSOR FOR r730_prepare3
 
    #去串影響到的工單(已確認,未結案)- 變異別:新增
    LET l_sql="SELECT sfb08,sfb081,sfb01,sfb04,sfb05,sfb08,sfb09,sfb13,sfb15, ",
               "       ima02,ima021 ",
#               " FROM sfb_file,ima_file ",  #TQC-A30081
                " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05 = ima01 ",  #TQC-A30081
#               " WHERE sfb04!='8' AND sfb87 ='Y' ",     #TQC-A30081
                " WHERE sfb04!='8' AND sfb87 !='X' ",    #TQC-A30081
#               " AND sfb05=ima01(+) ",   #TQC-A30081
               " AND sfb05=?   "
     PREPARE r730_prepare4 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare4:',STATUS,1)     #NO.FUN-750093
     IF SQLCA.sqlcode THEN CALL cl_err('prepare4:',STATUS,1) #NO.FUN-750093
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
     END IF
     DECLARE r730_c4 CURSOR FOR r730_prepare4
 
#    CALL cl_outnam('abmr730') RETURNING l_name
#    START REPORT r730_rep TO l_name
     FOREACH r730_c0 INTO bmx.*, bmy.*, ima.*
       IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF
       SELECT bmg03 INTO l_bmg03 FROM bmg_file WHERE bmg01=bmx.bmx01   #NO.FUN-750093          
                                                AND bmg02=1    #NO.FUN-750093
       FOREACH r730_c2 USING bmx.bmx01 INTO l_bmz02
#No.MOD-910196 add by liuxqa   抓取變異之主件料號的每一上階料做比較，避免遺漏資料。
        LET l_bmz021 = l_bmz02
        FOR l_count=1 to 20     #預設階層為20
         IF l_count=1 THEN
            LET l_sfb05 = l_bmz02
         ELSE 
           SELECT bmb01 INTO l_bmb011 FROM bmb_file WHERE bmb03=l_bmz021
           IF l_bmb011 IS NOT NULL THEN
              LET l_sfb05 = l_bmb011
              LET l_bmz021 = l_bmb011
              LET l_bmb011 = ''
           ELSE
              EXIT FOR
           END IF
         END IF
#No.MOD-910196 add by liuxqa 
         IF bmy.bmy03='2' THEN    #變異別:新增
            FOREACH r730_c4
#            USING l_bmz02   #No.MOD-910196 mark by liuxqa
             USING l_sfb05   #No.MOD-910196 mod  by liuxqa
            INTO sr.*
              IF cl_null(sr.sfa05) THEN LET sr.sfa05=0 END IF
              IF cl_null(sr.sfa06) THEN LET sr.sfa06=0 END IF
              IF cl_null(sr.sfb08) THEN LET sr.sfb08=0 END IF
              IF cl_null(sr.sfb09) THEN LET sr.sfb09=0 END IF
#No.FUN-750093   -----begin----
              EXECUTE insert_prep USING bmx.bmx01,bmy.bmy02,
                                        bmx.bmx02,bmy.bmy05,
                                        bmx.bmx07,ima.ima02,
                                        bmy.bmy29,ima.ima021,
                                        l_bmg03,bmy.bmy03,
                                        sr.sfa05,sr.sfa06,
                                        sr.sfb01,sr.sfb04,
                                        sr.sfb05,sr.sfb08,
                                        sr.sfb09,sr.sfb13,
                                        sr.sfb15,sr.ima02,
                                        sr.ima021,l_bmx50         #FUN-A60013 add l_bmx50
#             OUTPUT TO REPORT r730_rep(bmx.*, bmy.*, ima.*,sr.*)
#No.FUN-750093
            END FOREACH
         ELSE
            FOREACH r730_c3
#            USING l_bmz02,bmy.bmy05   #No.MOD-910196 mark by liuxqa
             USING l_sfb05,bmy.bmy05   #No.MOD-910196 mod  by liuxqa
            INTO sr.*
              IF cl_null(sr.sfa05) THEN LET sr.sfa05=0 END IF
              IF cl_null(sr.sfa06) THEN LET sr.sfa06=0 END IF
              IF cl_null(sr.sfb08) THEN LET sr.sfb08=0 END IF
              IF cl_null(sr.sfb09) THEN LET sr.sfb09=0 END IF
#No.FUN-750093   -----begin----
              EXECUTE insert_prep USING bmx.bmx01,bmy.bmy02,
                                        bmx.bmx02,bmy.bmy05,
                                        bmx.bmx07,ima.ima02,
                                        bmy.bmy29,ima.ima021,
                                        l_bmg03,bmy.bmy03,
                                        sr.sfa05,sr.sfa06,
                                        sr.sfb01,sr.sfb04,
                                        sr.sfb05,sr.sfb08,
                                        sr.sfb09,sr.sfb13,
                                        sr.sfb15,sr.ima02,
                                        sr.ima021,l_bmx50         #FUN-A60013 add l_bmx50 
#             OUTPUT TO REPORT r730_rep(bmx.*, bmy.*, ima.*,sr.*)
#No.FUN-750093
            END FOREACH
         END IF
        END FOR      #No.MOD-910196  add by liuxqa
       END FOREACH
     END FOREACH
 
#    FINISH REPORT r730_rep              #NO.FUN-750093
     LET  l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #NO.FUN-750093
#NO.FUN-750093  ---------begin ------------
     IF g_zz05 = 'Y' THEN  
#       CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg09')       #TQC-AB0367 mark
           CALL cl_wcchp(tm.wc,'bmx01,bmx02,bmy29')                #TQC-AB0367 add                      
             RETURNING tm.wc
#    LET g_str = tm.wc  #FUN-A60013 
     LET g_str = tm.wc CLIPPED,";",g_sma.sma542   #FUN-A60013
     END IF 
#NO.FUN-750093 ----------end --------------------
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #NO.FUN-750093
     CALL cl_prt_cs3('abmr730','abmr730',l_sql,g_str)  #NO.FUN-750093
END FUNCTION

#NO.FUN-750093    ----begin------
#REPORT r730_rep(bmx, bmy, ima,sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
#          l_buf		LIKE type_file.chr4,     #No.FUN-680096 VARCHAR(4)
#          sr            RECORD
#                        sfa05  LIKE sfa_file.sfa05, #No.FUN-680096 DEC(15,3)
#                        sfa06  LIKE sfa_file.sfa06, #No.FUN-680096 DEC(15,3)
#                        sfb01  LIKE sfb_file.sfb01,
#                        sfb04  LIKE sfb_file.sfb04,
#                        sfb05  LIKE sfb_file.sfb05,
#                        sfb08  LIKE sfb_file.sfb08,
#                        sfb09  LIKE sfb_file.sfb09,
#                        sfb13  LIKE sfb_file.sfb13,
#                        sfb15  LIKE sfb_file.sfb15,
#                        ima02  LIKE ima_file.ima02,
#                        ima021 LIKE ima_file.ima021
#                        END RECORD,
#          l_bmg03       LIKE bmg_file.bmg03,
#          bmx		RECORD LIKE bmx_file.*,
#          bmy		RECORD LIKE bmy_file.*,
#          bmz		RECORD LIKE bmz_file.*,
#          bmg		RECORD LIKE bmg_file.*,
#          bmw		RECORD LIKE bmw_file.*,
#          ima		RECORD LIKE ima_file.*
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# 
#  ORDER BY bmx.bmx01,bmy.bmy02,sr.sfb01
#  FORMAT
#    PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT COLUMN  01,g_x[11] CLIPPED,bmx.bmx01,'-',bmy.bmy02 USING '###&',
#            COLUMN 120,g_x[12] CLIPPED,bmx.bmx02
#      PRINT COLUMN  01,g_x[13] CLIPPED,bmy.bmy05,
#            COLUMN 120,g_x[14] CLIPPED,bmx.bmx07
#      PRINT COLUMN  01,g_x[24] CLIPPED,ima.ima02,
#            COLUMN 120,g_x[26] CLIPPED,bmy.bmy29 #FUN-550093
#      PRINT COLUMN  01,g_x[25] CLIPPED,ima.ima021
#      LET l_str1=r730_bmy03(bmy.bmy03)  #No.MOD-640186
#      SELECT bmg03 INTO l_bmg03 FROM bmg_file WHERE bmg01=bmx.bmx01
#                                                AND bmg02=1
#      PRINT COLUMN  01,g_x[22] CLIPPED,l_bmg03,
#            COLUMN 120,g_x[23] CLIPPED,bmy.bmy03,' ',l_str1  #No.MOD-640186
#      PRINT
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#    BEFORE GROUP OF bmx.bmx01
#      #LET g_pageno = 0 #No.TQC-5C0005
#      SKIP TO TOP OF PAGE
# 
#    BEFORE GROUP OF bmy.bmy02
#      SKIP TO TOP OF PAGE
# 
#    AFTER GROUP OF sr.sfb01
#      LET l_str=r730_sfb04(sr.sfb04)
#      PRINT COLUMN g_c[31],sr.sfb01,
#            COLUMN g_c[32],l_str[1,4],
#            COLUMN g_c[33],sr.sfb13,
#            COLUMN g_c[34],sr.sfb15,
#            COLUMN g_c[35],sr.sfb05,
#            COLUMN g_c[36],sr.ima02,
#            COLUMN g_c[37],sr.ima021,
#            COLUMN g_c[38],cl_numfor(sr.sfb08,38,0),
#            COLUMN g_c[39],cl_numfor(sr.sfb09,39,0),
#            COLUMN g_c[40],cl_numfor(sr.sfa05,40,0),
#            COLUMN g_c[41],cl_numfor(sr.sfa06,41,0),
#            COLUMN g_c[42],cl_numfor(sr.sfa05-sr.sfa06,42,0)
# 
#   ON LAST ROW
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      PRINT g_dash
#      IF l_last_sw = 'y'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #No.TQC-5C0005
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#      END IF
#END REPORT
# 
#FUNCTION r730_sfb04(p_sfb04)
#    DEFINE p_sfb04      LIKE sfb_file.sfb04  #No.FUN-680096 SMALLINT
# 
#     CASE WHEN p_sfb04 ='1' LET l_str=g_x[15] CLIPPED
#          WHEN p_sfb04 ='2' LET l_str=g_x[16] CLIPPED
#          WHEN p_sfb04 ='3' LET l_str=g_x[17] CLIPPED
#          WHEN p_sfb04 ='4' LET l_str=g_x[18] CLIPPED
#          WHEN p_sfb04 ='5' LET l_str=g_x[19] CLIPPED
#          WHEN p_sfb04 ='6' LET l_str=g_x[20] CLIPPED
#          WHEN p_sfb04 ='7' LET l_str=g_x[21] CLIPPED
#     END CASE
#    RETURN l_str
#END FUNCTION
# 
#FUNCTION r730_bmy03(p_chr)
#   DEFINE p_chr LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
# 
#   #No.FUN-640186 --Begin
#   CASE WHEN p_chr='0' LET l_str1='刪除'
#        WHEN p_chr='1' CALL cl_getmsg('abm-501',g_lang) RETURNING l_str1 
#        WHEN p_chr='2' CALL cl_getmsg('abm-502',g_lang) RETURNING l_str1 
#        WHEN p_chr='3' CALL cl_getmsg('abm-503',g_lang) RETURNING l_str1 
#        WHEN p_chr='4' CALL cl_getmsg('abm-504',g_lang) RETURNING l_str1 
#   END CASE
#   RETURN l_str1
#   #No.FUN-640186 --End  
#END FUNCTION
#
#NO.FUN-750093
