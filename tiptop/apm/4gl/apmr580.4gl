# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr580.4gl
# Desc/riptions..: 無交期採購單
# Date & Author..: 01/04/03 By Kammy
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/19 By yoyo 項次欄位增大
# Modify.........: No.FUN-580013 05/08/13 By yoyo 報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-610018 06/01/16 By ice 採購含稅單價功能調整
# Modify.........: No.TQC-610085 06/04/04 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640236 06/06/27 By Sarah 增加列印規格ima021
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6C0051 06/12/13 By day 頁次修改為重計
# Modify.........: No.FUN-710091 07/02/18 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.TQC-930159 09/04/01 By liuxqa 區分賬單地址和送貨地址。
# Modify.........: No.MOD-960144 09/06/15 By Smapmin 特殊說明改由子報表方式呈現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60083 10/06/12 By Carrier 连接符修改 & SQL调整
# Modify.........: No.FUN-A80001 10/08/02 By destiny 列印增加截止日期
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-BC0198 12/01/06 By destiny apmt580调用时报错
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)      # Where condition
                a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                b       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                more    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
   DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
   #NO.FUN-710091   --begin
   DEFINE   g_sql       STRING
   DEFINE   l_table     STRING
   DEFINE   l_table1    STRING
   DEFINE   l_table2    STRING
   DEFINE   l_table3    STRING
   DEFINE   l_table4    STRING
   #NO.FUN-710091   --end   
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			        # Supress DEL key function

   #TQC-BC0198--begin
   LET g_pdate  = ARG_VAL(1)                     # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.more  = ARG_VAL(10)
##--------------No.TQC-610085 modify
  #LET tm.more  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #TQC-BC0198--end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #TQC-BC0198--begin
#  LET g_pdate  = ARG_VAL(1)	                 # Get arguments from command line
#  LET g_towhom = ARG_VAL(2)
#  LET g_rlang  = ARG_VAL(3)
#  LET g_bgjob  = ARG_VAL(4)
#  LET g_prtway = ARG_VAL(5)
#  LET g_copies = ARG_VAL(6)
#  LET tm.wc    = ARG_VAL(7)
#  LET tm.a     = ARG_VAL(8)
#  LET tm.b     = ARG_VAL(9)
#  LET tm.more  = ARG_VAL(10)
##--------------No.TQC-610085 modify
# #LET tm.more  = ARG_VAL(10)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(10)
#  LET g_rep_clas = ARG_VAL(11)
#  LET g_template = ARG_VAL(12)
#  LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #TQC-BC0198--end
   #No.FUN-570264 ---end---
#--------------No.TQC-610085 end
   #No.FUN-710091  --begin
   LET g_sql = "pom01.pom_file.pom01,",
               "smydesc.smy_file.smydesc,", 
               "pom04.pom_file.pom04,",   
               "pmc081.pmc_file.pmc081,",
               "pmc091.pmc_file.pmc091,",
               "pma02.pma_file.pma02,",
               "pom41.pom_file.pom41,",
               "gec02.gec_file.gec02,",
               "pom09.pom_file.pom09,",   
               "pom10.pom_file.pom10,",   
               "pom11.pom_file.pom11,",   
               "pom22.pom_file.pom22,",   
               "pon02.pon_file.pon02,",   
               "pon04.pon_file.pon04,",   
               "pon041.pon_file.pon041,",
               "ima021.ima_file.ima021,",
               "pon07.pon_file.pon07,",   
               "pon20.pon_file.pon20,",   
               "pon31.pon_file.pon31,",   
               "pon31t.pon_file.pon31t,",
               "amt.pom_file.pom40,",   
               "amtt.pom_file.pom40t,",  
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "pon19.pon_file.pon19,",       #No.FUN-A80001
               "pme0311.pme_file.pme031,",    #No.TQC-930159 add
               "pme0312.pme_file.pme032,",    #No.TQC-930159 add
               "pme031.pme_file.pme031,",
               "pme032.pme_file.pme032,",
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
               "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
               "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('apmr580',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
        
   LET g_sql = "pmo01.pmo_file.pmo01,", #MOD-960144
               "pmo06.pmo_file.pmo06"   #MOD-960144
   LET l_table1 = cl_prt_temptable('apmr5801',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "pmo01.pmo_file.pmo01,", #MOD-960144
               "pmo03.pmo_file.pmo03,", #MOD-960144
               "pmo06.pmo_file.pmo06"   #MOD-960144
   LET l_table2 = cl_prt_temptable('apmr5802',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
       
   LET g_sql = "pmo01.pmo_file.pmo01,", #MOD-960144
               "pmo03.pmo_file.pmo03,", #MOD-960144
               "pmo06.pmo_file.pmo06"   #MOD-960144
   LET l_table3 = cl_prt_temptable('apmr5803',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "pmo01.pmo_file.pmo01,", #MOD-960144
               "pmo06.pmo_file.pmo06"   #MOD-960144
   LET l_table4 = cl_prt_temptable('apmr5804',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710091  --end  
   IF cl_null(tm.wc)                    # If background job sw is off
      THEN CALL r580_tm(0,0)		# Input print condition
      ELSE CALL apmr580()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r580_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r580_w AT p_row,p_col WITH FORM "apm/42f/apmr580"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a     = 'N'
   LET tm.b     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pom01,pom04,pom12
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r580_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES "[YN]" THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
         IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW r580_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr580'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr580','9031',1)
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
                         " '",tm.a CLIPPED,"'",            #No.TQC-610085 add
                         " '",tm.b CLIPPED,"'",            #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr580',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r580_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr580()
   ERROR ""
END WHILE
CLOSE WINDOW r580_w
END FUNCTION
 
FUNCTION apmr580()
   DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
   DEFINE l_name	LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,          # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,          # No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
          sr   RECORD
                     pom01     LIKE pom_file.pom01,    #採購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pom04     LIKE pom_file.pom04,    #採購日期
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc091,   #供應商地址
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pom41     LIKE pom_file.pom41,    #價格條件
                     gec02     LIKE gec_file.gec02,    #稅別
                     pom09     LIKE pom_file.pom09,    #廠商編號
                     pom10     LIKE pom_file.pom10,    #送貨地址
                     pom11     LIKE pom_file.pom11,    #帳單地址
                     pom22     LIKE pom_file.pom22,    #幣別
                     pon02     LIKE pon_file.pon02,    #項次
                     pon04     LIKE pon_file.pon04,    #料件編號
                     pon041    LIKE pon_file.pon041,   #品名
                     ima021    LIKE ima_file.ima021,   #規格     #FUN-640236 add
                     pon07     LIKE pon_file.pon07,    #單位
                     pon20     LIKE pon_file.pon20,    #數量
                     pon31     LIKE pon_file.pon31,    #未稅單價
                     pon31t    LIKE pon_file.pon31t,   #含稅單價  #No.FUN-610018
                     amt       LIKE pom_file.pom40,    #未稅金額
                     amtt      LIKE pom_file.pom40t,   #含稅金額  #No.FUN-610018
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05,
                     pon19     LIKE pon_file.pon19    #NO.FUN-A80001
        END RECORD
     #No.FUN-710091  --begin
     DEFINE g_str        STRING  
     DEFINE l_pmo06      LIKE   pmo_file.pmo06
     DEFINE l_pme031     LIKE   pme_file.pme031
     DEFINE l_pme032     LIKE   pme_file.pme032
     DEFINE l_pme0311    LIKE   pme_file.pme031 #No.TQC-930159 add
     DEFINE l_pme0312    LIKE   pme_file.pme032 #No.TQC-930159 add
     #No.FUn-710091  --end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-710091  --begin
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"               #No.TQC-930159 add 2 ?  #NO.FUN-A80001  #TQC-C10039 ADD 4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-780049
                 #" VALUES(?,?)"   #MOD-960144
                 " VALUES(?,?,?)"   #MOD-960144
     PREPARE insert2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert2:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-780049
                 #" VALUES(?,?)"   #MOD-960144
                 " VALUES(?,?,?)"   #MOD-960144
     PREPARE insert3 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert3:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert4 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert4:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pomuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pomgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pomgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT pom01,smydesc,pom04,pmc081,pmc091,",
                 "       pma02,pom41,",
                 "       gec02,pom09,pom10,pom11,pom22,pon02,pon04,pon041,ima021,",   #FUN-640236 add ima021
                 "       pon07,pon20,pon31,pon31t,(pon20*pon31),(pon20*pon31t), ",  #No.FUN-610018
                 "       azi03,azi04,azi05,pon19 ", #NO.FUN-A80001
                 #No.MOD-A60083  --Begin
                 "   FROM pom_file LEFT OUTER JOIN smy_file ON pom01 like smyslip ||'-%'",
                 "        LEFT OUTER JOIN pmc_file ON pmc01 = pom09",
                 "        LEFT OUTER JOIN azi_file ON pom22=azi01",
                 "        LEFT OUTER JOIN pma_file ON pom20 = pma01",
                 "        LEFT OUTER JOIN gec_file ON pom21 = gec01",
                 "        ,pon_file LEFT OUTER JOIN ima_file ON pon04 = ima01",
                 "     WHERE pom01 = pon01",
                 "       AND gec011='1' ",    
                 "       AND pomacti='Y' ",
                 "       AND ",tm.wc CLIPPED
                 #No.MOD-A60083  --End  
 
     PREPARE r580_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r580_cs1 CURSOR FOR r580_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
 
#    CALL cl_outnam('apmr580') RETURNING l_name   #No.FUN-710091 mark
 
#    START REPORT r580_rep TO l_name     #No.FUN-710091 mark
#    LET g_pageno = 0                    #No.FUn-710091 mark
     FOREACH r580_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.pon20) THEN LET sr.pon20=0 END IF
       IF cl_null(sr.pon31) THEN LET sr.pon31=0 END IF
       IF cl_null(sr.pon31t) THEN LET sr.pon31t=0 END IF   #No.FUN-610018
       IF cl_null(sr.amt)   THEN LET sr.amt=0   END IF
       IF cl_null(sr.amtt)  THEN LET sr.amtt=0  END IF   #No.FUN-610018
       #No.FUN-710091  --begin 
          
       #-----MOD-960144---------
       ##-->單頭備註(前)
       #IF tm.a = 'Y' THEN
       #   DECLARE pmo_cur CURSOR FOR SELECT pmo06 FROM pmo_file
       #                                       WHERE pmo01=sr.pom01
       #                                         AND pmo03=0 AND pmo04='0'
       #   FOREACH pmo_cur INTO l_pmo06
       #      EXECUTE insert1 USING sr.pom01,l_pmo06
       #   END FOREACH
       #END IF
       #-----END MOD-960144-----
       #-->單身備註(前)
       IF tm.b = 'Y' THEN
          DECLARE pmo_cur2 CURSOR FOR SELECT pmo06 FROM pmo_file
                                              WHERE pmo01=sr.pom01
                                                AND pmo03=sr.pon02 AND pmo04='0'
          FOREACH pmo_cur2 INTO l_pmo06
             #EXECUTE insert2 USING sr.pom01,l_pmo06    #MOD-960144
             EXECUTE insert2 USING sr.pom01,sr.pon02,l_pmo06    #MOD-960144
          END FOREACH
       END IF
       
       #-->單身備註(後)
       IF tm.b = 'Y' THEN
          DECLARE pmo_cur3 CURSOR FOR SELECT pmo06 FROM pmo_file
                                              WHERE pmo01=sr.pom01
                                               AND pmo03=sr.pon02 AND pmo04='1'
          FOREACH pmo_cur3 INTO l_pmo06
             #EXECUTE insert3 USING sr.pom01,l_pmo06   #MOD-960144
             EXECUTE insert3 USING sr.pom01,sr.pon02,l_pmo06   #MOD-960144
          END FOREACH
       END IF
       
       #-----MOD-960144---------
       #DECLARE pmo_cur4 CURSOR FOR SELECT pmo06 FROM pmo_file
       #                                    WHERE pmo01=sr.pom01
       #                                      AND pmo03=0 AND pmo04='1'
       #FOREACH pmo_cur4 INTO l_pmo06
       #    EXECUTE insert4  USING sr.pom01,l_pmo06
       #END FOREACH
       #-----END MOD-960144-----
       
       SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                  WHERE pme01=sr.pom11
       IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
#No.TQC-930159 add --begin--  
       SELECT pme031,pme032 INTO l_pme0311,l_pme0312 FROM pme_file
                                                  WHERE pme01=sr.pom10
       IF SQLCA.SQLCODE THEN LET l_pme0311='' LET l_pme0312='' END IF
#No.TQC-930159 add --end--
#       EXECUTE insert_prep USING sr.*,l_pme031,l_pme032  #No.TQC-930159 mark
       EXECUTE insert_prep USING sr.*,l_pme0311,l_pme0312,l_pme031,l_pme032,  #No.TQC-930159 mod
                                 "",l_img_blob, "N",""   #TQC-C10039 ADD "",l_img_blob, "N",""
 
       #No.FUN-710091  --end   
      #OUTPUT TO REPORT r580_rep(sr.*)     #No.FUN-710091 mark
     END FOREACH
 
     #-----MOD-960144---------
     LET l_sql = "SELECT DISTINCT pom01 FROM ",
                  g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE r580_p2 FROM l_sql
     DECLARE r580_c2 CURSOR FOR r580_p2
     FOREACH r580_c2 INTO sr.pom01
        IF tm.a = 'Y' THEN
           DECLARE pmo_cur CURSOR FOR
              SELECT pmo06 FROM pmo_file
               WHERE pmo01=sr.pom01 AND pmo03=0 AND pmo04='0'
           FOREACH pmo_cur INTO l_pmo06
              EXECUTE insert1 USING sr.pom01,l_pmo06
           END FOREACH
           DECLARE pmo_cur4 CURSOR FOR
              SELECT pmo06 FROM pmo_file
               WHERE pmo01=sr.pom01 AND pmo03=0 AND pmo04='1'
           FOREACH pmo_cur4 INTO l_pmo06
               EXECUTE insert4  USING sr.pom01,l_pmo06
           END FOREACH
        END IF
     END FOREACH
     #-----END MOD-960144-----
     CALL cl_wcchp(tm.wc,'pom01,pom04,pom12')                 
          RETURNING  tm.wc
     LET g_str = tm.wc
     #-----MOD-960144---------
     #LET g_sql ="SELECT A.*,B.pmo061,C.pmo062,D.pmo063,E.pmo064",
     ##TQC-730088##"  FROM ",l_table CLIPPED," A,",l_table1 CLIPPED," B,",
     #           ##        l_table2 CLIPPED," C,",l_table3 CLIPPED," D,",
     #           ##        l_table4 CLIPPED," E",
     #           "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A ",
     #                     " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.pom01 = B.pom01 ",
     #                     " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON A.pom01 = C.pom01",
     #                     " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table3 CLIPPED," D ON A.pom01 = D.pom01",
     #                     " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table4 CLIPPED," E ON A.pom01 = E.pom01 "
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
     #-----END MOD-960144-----
#    LET g_sql ="SELECT * FROM ",l_table CLIPPED 
   # CALL cl_prt_cs3('apmr580',g_sql,g_str)  #TQC-730088
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "pom01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('apmr580','apmr580',g_sql,g_str)
 
#    FINISH REPORT r580_rep    #No.FUN-710091  mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-710091  mark
END FUNCTION
{
REPORT r580_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,           #No.FUN-680136 VARCHAR(1)
          l_dash        LIKE type_file.chr1,           #No.FUN-680136 VARCHAR(1)
          l_count       LIKE type_file.num5,           #No.FUN-680136 SMALLINT
          l_n           LIKE type_file.num5,           #No.FUN-680136 SMALLINT
          sr   RECORD
                     pom01     LIKE pom_file.pom01,    #採購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pom04     LIKE pom_file.pom04,    #採購日期
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc081,   #供應商地址
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pom41     LIKE pom_file.pom41,    #價格條件
                     gec02     LIKE gec_file.gec02,    #稅別
                     pom09     LIKE pom_file.pom09,    #廠商編號
                     pom10     LIKE pom_file.pom10,    #送貨地址
                     pom11     LIKE pom_file.pom11,    #帳單地址
                     pom22     LIKE pom_file.pom22,    #幣別
                     pon02     LIKE pon_file.pon02,    #項次
                     pon04     LIKE pon_file.pon04,    #料件編號
                     pon041    LIKE pon_file.pon041,   #品名規格
                     ima021    LIKE ima_file.ima021,   #規格       #FUN-640236 add
                     pon07     LIKE pon_file.pon07,    #單位
                     pon20     LIKE pon_file.pon20,    #數量
                     pon31     LIKE pon_file.pon31,    #未稅單價
                     pon31t    LIKE pon_file.pon31t,   #含稅單價   #No.FUN-610018
                     amt       LIKE pom_file.pom40,    #未稅金額
                     amtt      LIKE pom_file.pom40t,   #含稅金額   #No.FUN-610018
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05
        END RECORD,
        l_flag       LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
        l_tot        LIKE type_file.num5,              #No.FUN-680136 SMALLINT
        l_pmo06      LIKE pmo_file.pmo06,
        l_pme031     LIKE pme_file.pme031,
        l_pme032     LIKE pme_file.pme032,
        l_str        LIKE aaf_file.aaf03,              #No.FUN-680136 VARCHAR(40) 
        l_totamt     LIKE pom_file.pom40,              #MOD-530190
        l_totamtt    LIKE pom_file.pom40t
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 6
         PAGE LENGTH g_page_line
  ORDER BY sr.pom01,sr.pon02
  FORMAT
   PAGE HEADER
#No.FUN-580013--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT ' '
      PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo041))/2)+1,g_zo.zo041
      PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo042))/2)+1,g_zo.zo042
      LET g_pageno = g_pageno + 1
      PRINT
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     IF g_pageno = 1 THEN
         PRINT ' '
         SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                    WHERE pme01=sr.pom10
         IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
#        PRINT g_x[11] CLIPPED,sr.pom01,' ',sr.smydesc,
         PRINT g_x[11] CLIPPED,sr.pom01,' ',sr.smydesc CLIPPED,           #No.FUN-550060
               COLUMN 41,g_x[16] CLIPPED,l_pme031
         PRINT g_x[12] CLIPPED,sr.pom04,COLUMN 50,l_pme032
         SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                    WHERE pme01=sr.pom11
         IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
#        PRINT g_x[13] CLIPPED,sr.pom09,COLUMN 41,g_x[17] CLIPPED,l_pme031
         PRINT g_x[13] CLIPPED,sr.pom09 CLIPPED,COLUMN 41,g_x[17] CLIPPED,l_pme031     #No.FUN-550060
#     ELSE
#        PRINT g_dash[1,g_len]
#        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#        PRINTX name=H2 g_x[37],g_x[38]
#        PRINT g_dash1
#     END IF
#No.FUN-580013--end
 
BEFORE GROUP OF sr.pom01
      SKIP TO TOP OF PAGE
      LET l_flag = 'N'
      PRINT COLUMN 10,sr.pmc081 CLIPPED,COLUMN 50,l_pme032    #No.FUN-550060
      PRINT COLUMN 10,sr.pmc091
      PRINT g_x[14] CLIPPED,sr.pma02 CLIPPED,COLUMN 45,g_x[18] CLIPPED,sr.gec02   #No.FUN-550060
      PRINT g_x[15] CLIPPED,sr.pom41 CLIPPED,              #No.FUN-550060
            COLUMN 45,g_x[19] CLIPPED,sr.pom22
      #-->單頭備註(前)
      IF tm.a = 'Y' THEN
         DECLARE pmo_cur CURSOR FOR SELECT pmo06 FROM pmo_file
                                             WHERE pmo01=sr.pom01
                                               AND pmo03=0 AND pmo04='0'
         FOREACH pmo_cur INTO l_pmo06
             IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
             IF NOT cl_null(l_pmo06) THEN PRINT l_pmo06 END IF
         END FOREACH
      END IF
      PRINT g_dash[1,g_len]
#No.FUN-580013--start
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[39],g_x[36],g_x[40]  #No.FUN-610018
      PRINTX name=H2 g_x[37],g_x[38],g_x[41]   #FUN-640236 add g_x[41]
      PRINT g_dash1
#No.FUN-580013--end
 
ON EVERY ROW
      #-->單身備註(前)
      IF tm.b = 'Y' THEN
         DECLARE pmo_cur2 CURSOR FOR SELECT pmo06 FROM pmo_file
                                             WHERE pmo01=sr.pom01
                                               AND pmo03=sr.pon02 AND pmo04='0'
         FOREACH pmo_cur2 INTO l_pmo06
             IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
             IF NOT cl_null(l_pmo06) THEN PRINT COLUMN 4,l_pmo06 END IF
         END FOREACH
      END IF
#No.FUN-570176--start--
#No.FUN-580013--start
      PRINTX name=D1
            COLUMN g_c[31],sr.pon02 USING '####',
            COLUMN g_c[32],sr.pon04 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,                  #No.FUN-550060
            COLUMN g_c[33],sr.pon07,
            COLUMN g_c[34],cl_numfor(sr.pon20,34,2),
            COLUMN g_c[35],cl_numfor(sr.pon31,35,sr.azi03),
            COLUMN g_c[39],cl_numfor(sr.pon31t,39,sr.azi03),   #No.FUN-610018
            COLUMN g_c[36],cl_numfor(sr.amt,36,sr.azi04),
            COLUMN g_c[40],cl_numfor(sr.amtt,40,sr.azi04)      #No.FUN-610018
      PRINTX name=D2 COLUMN g_c[38],sr.pon041,
                     COLUMN g_c[41],sr.ima021 CLIPPED   #FUN-640236 add
#No.FUN-580013--end
#No.FUN-570176--end--
      #-->單身備註(後)
      IF tm.b = 'Y' THEN
         DECLARE pmo_cur3 CURSOR FOR SELECT pmo06 FROM pmo_file
                                             WHERE pmo01=sr.pom01
                                              AND pmo03=sr.pon02 AND pmo04='1'
         FOREACH pmo_cur3 INTO l_pmo06
             IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
             IF NOT cl_null(l_pmo06) THEN PRINT COLUMN 4,l_pmo06 END IF
         END FOREACH
      END IF
 
AFTER GROUP OF sr.pom01
      LET g_pageno = 0   #No.TQC-6C0051
      LET l_totamt=GROUP SUM(sr.amt)
      LET l_totamtt=GROUP SUM(sr.amtt)    #No.FUN-610018
      PRINT ''
#No.FUN-580013--start
      PRINTX name=S1
            #COLUMN g_c[35],g_x[27] CLIPPED,                     #No.FUN-610018
            COLUMN g_c[39],g_x[28] CLIPPED,                      #No.FUN-610018
            COLUMN g_c[36],cl_numfor(l_totamt,36,sr.azi05),      #No.FUN-570176
            COLUMN g_c[40],cl_numfor(l_totamtt,40,sr.azi05)
#No.FUN-580013--end
      PRINT g_dash[1,g_len]
      IF tm.a = 'Y' THEN
         SELECT COUNT(*) INTO g_cnt FROM pmo_file
           WHERE pmo01 = sr.pom01 AND pmo03 = 0
             AND pmo04 = '1'
         LET l_tot = LINENO+ g_cnt
         DECLARE pmo_cur4 CURSOR FOR SELECT pmo06 FROM pmo_file
                                             WHERE pmo01=sr.pom01
                                               AND pmo03=0 AND pmo04='1'
         FOREACH pmo_cur4 INTO l_pmo06
             IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
             IF NOT cl_null(l_pmo06) THEN PRINT l_pmo06 END IF
             IF l_tot = 58 AND LINENO = 57 THEN LET l_flag = 'Y' END IF #no.7077
         END FOREACH
      END IF
      LET l_flag='Y'
 
## FUN-550114
 
   PAGE TRAILER
     #IF l_flag= 'Y' THEN
     #   PRINT COLUMN 01,g_x[30] CLIPPED,
     #         COLUMN 42,g_x[31] CLIPPED
     #   SKIP 1 LINE
     #ELSE
     #  SKIP 2 LINE
     #END IF
     IF l_flag = 'n' THEN
        IF g_memo_pagetrailer THEN
            PRINT g_x[30]
            PRINT g_memo
        ELSE
            PRINT
            PRINT
        END IF
     ELSE
         PRINT g_x[30]
         PRINT g_memo
     END IF
## END FUN-550114
 
END REPORT
}
#Patch....NO.TQC-610036 <> #
