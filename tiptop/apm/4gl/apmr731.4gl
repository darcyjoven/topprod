# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr731.4gl
# Descriptions...: 料件核價影響採購單一覽表
# Input parameter:
# Return code....:
# Date & Author..: 01/06/19 By Linda
#                  No.+217 add
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or LIKE type_file.num20_6
# Modify.........: No.FUN-550060 05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-590110 05/09/29 By Tracy 修改報表,轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: NO.MOD-640373 06/04/11 BY yiting default tm.more
# Modify.........: No.TQC-660011 06/06/07 By Pengu 列印時程式會當掉
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-750093 07/06/12 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.FUN-770033 07/07/19 By destiny  增加打印條件
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0014 09/01/04 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58) 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, # Where condition 	     #No.FUN-680136 VARCHAR(500)
                a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                bdate   LIKE type_file.dat,    	#No.FUN-680136 DATE
                b       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                type    LIKE type_file.chr2,    #No.CHI-8C0014
   		more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_argv1       LIKE pmi_file.pmi03, 	#No.FUN-680136 VARCHAR(10)
#          l_str         LIKE apo_file.apo02 	#No.FUN-680136 VARCHAR(4)
          l_str         LIKE type_file.chr1     #No.FUN-750093  
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
   DEFINE l_table       STRING                  #No.FUN-750093
   DEFINE g_sql         STRING                  #No.FUN-750093
   DEFINE g_str         STRING                  #No.FUN-750093
   DEFINE l_table1      STRING                  #No.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
#No.FUN-750093 --start--
   LET g_sql="pmn04.pmn_file.pmn04,pmn041.pmn_file.pmn041,pmm09.pmm_file.pmm09,",
             "pmc03.pmc_file.pmc03,",
             "pmn01.pmn_file.pmn01,pmm04.pmm_file.pmm04,pmm22.pmm_file.pmm22,",
             "pmn02.pmn_file.pmn02,pmn31.pmn_file.pmn31,pmn20.pmn_file.pmn20,",
             "pmn50.pmn_file.pmn50,pmn55.pmn_file.pmn55,pmn53.pmn_file.pmn53,",
             "pmn82.pmn_file.pmn82,pmn58.pmn_file.pmn58,pmn85.pmn_file.pmn85,",
             "chr1.type_file.chr1,pmm01.pmm_file.pmm01,num5.type_file.num5,",
             "dat.type_file.dat,pmn87.pmn_file.pmn87,azi04.azi_file.azi04"
 
  LET l_table = cl_prt_temptable('apmr731',g_sql) CLIPPED
  IF l_table = -1 THEN EXIT PROGRAM END IF
 
  LET g_sql="pmi01.pmi_file.pmi01,pmj02.pmj_file.pmj02,pmi02.pmi_file.pmi02,",
            "pmj05.pmj_file.pmj05,pmj06.pmj_file.pmj06,pmj07.pmj_file.pmj07,",
            "pmj08.pmj_file.pmj08,pmj09.pmj_file.pmj09,azi03.azi_file.azi03,",  
            "pmn04_1.pmn_file.pmn04,pmm09_1.pmm_file.pmm09,pmj10.pmj_file.pmj10"       #CHI-8C0014 Add pmj10       
  LET l_table1 = cl_prt_temptable('apmr7311',g_sql) CLIPPED                       
  IF l_table1 = -1 THEN EXIT PROGRAM END IF                                       
#No.FUN-750093 --end--
 
#-----------------No.TQC-610085 modify
#   LET tm.more = 'N' 
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)	
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET g_argv1=ARG_VAL(1)
   LET tm.a      = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.b      = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(15)     #No.CHI-8C0014
#-----------------No.TQC-610085 end
   DROP TABLE r731_file
#No.FUN-680136--begin
#   CREATE TEMP TABLE r731_file                                                                                                      
#    (                                                                                                                               
#     pmi01   VARCHAR(10),     #核價單號                                                                                               
#      pmi01   VARCHAR(16),     #No.FUN-550060                                                                                          
#      pmi02   DATE,         #核價日期                                                                                               
#      pmi03   VARCHAR(10),     #廠商編號                                                                                               
#      pmj02   SMALLINT,     #核價項次                                                                                               
#      pmj03   VARCHAR(40),     #料件編號 #FUN-560011                                                                                   
#      pmj05   VARCHAR(4),      #幣別                                                                                                   
#      pmj06   DEC(20,6),    #原單價 #MOD-530190                                                                                     
#      pmj07   DEC(20,6),    #新單價 #MOD-530190                                                                                     
#      pmj08   DATE,         #原核准日                                                                                               
#      pmj09   DATE          #新核准日                                                                                               
#    );
    CREATE TEMP TABLE r731_file(                                                                                                    
      pmi01   LIKE pmi_file.pmi01,                                                   
      pmi02   LIKE type_file.dat,                                                                                        
      pmi03   LIKE pmi_file.pmi03,                                                   
      pmj02   LIKE type_file.num5,                                                                                       
      pmj03   LIKE pmj_file.pmj03,                                                 
      pmj05   LIKE pmj_file.pmj05,                                                               
      pmj06   LIKE type_file.num20_6,                                              
      pmj07   LIKE type_file.num20_6,                                              
      pmj08   LIKE type_file.dat,                                                                                         
      pmj09   LIKE type_file.dat,
      pmj10   LIKE pmj_file.pmj10)                     #CHI-8C0014 Add                                                                  
#No.FUN-680136--end
   #DELETE FROM r731_file WHERE 1=1
   IF cl_null(tm.wc)    #No.TQC-610085 modify
      THEN CALL r731_tm()	             	# Input print condition
   ELSE 
    #--------------No.TQC-610085 modify
     #LET tm.wc=" pmm01='",g_argv1,"'"
     #LET tm.a='1'
     #LET tm.bdate=g_today
      CALL r731()		          	# Read data and create out-file
    #--------------No.TQC-610085 end
   END IF
    DROP TABLE r731_file
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r731_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(1000)
          p_row,p_col   LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r731_w AT p_row,p_col WITH FORM "apm/42f/apmr731"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET g_rlang = g_lang     #No.TQC-660011 add
   LET g_pdate = g_today    #No.FUN-770033
   LET tm.a='1'
   LET tm.b='N'
   LET tm.bdate=g_today
   LET tm.more = 'N'
   LET tm.type = '1'       #CHI-8C0014
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmi01,pmi03,pmi04,pmj03
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(pmj03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmj03
               NEXT FIELD pmj03
            END IF
#No.FUN-570243 --end
 
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
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.bdate,tm.b,tm.type,tm.more WITHOUT DEFAULTS        #CHI-8C0014 Add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN
            NEXT FIELD bdate
         END IF
         
      #CHI-8C0014--Begin--#   
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12]' THEN
            NEXT FIELD type
         END IF
      #CHI-8C0014--End--#         
         
      AFTER FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r731_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr731'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr731','9031',1)   #No.FUN-660129
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
                         " '",tm.bdate  CLIPPED,"'",
                         " '",tm.b  CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'"               #No.CHI-8C0014
         CALL cl_cmdat('apmr731',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r731_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r731()
   ERROR ""
END WHILE
   CLOSE WINDOW r731_w
END FUNCTION
 
FUNCTION r731()
   DEFINE l_name	LIKE type_file.chr20, 		 # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		 # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,		 # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_order	ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 20->40                #No.FUN-680136 VARCHAR(40)
          sr1           RECORD
                          pmi01   LIKE pmi_file.pmi01,    #核價單號
                          pmi02   LIKE pmi_file.pmi02,    #核價日期
                          pmi03   LIKE pmi_file.pmi03,    #廠商編號
                          pmj02   LIKE pmj_file.pmj02,    #核價項次
                          pmj03   LIKE pmj_file.pmj03,    #料件編號
                          pmj05   LIKE pmj_file.pmj05,    #幣別
                          pmj06   LIKE pmj_file.pmj06,    #原單價
                          pmj07   LIKE pmj_file.pmj07,    #新單價
                          pmj08   LIKE pmj_file.pmj08,    #原核准日
                          pmj09   LIKE pmj_file.pmj09,    #新核准日
                          pmj10   LIKE pmj_file.pmj10     #CHI-8C0014
                        END RECORD,
          sr            RECORD
                        order1  LIKE ima_file.ima01,   #FUN-5B0105 20->40 	#No.FUN-680136 VARCHAR(40)
                        order2  LIKE ima_file.ima01,   #FUN-5B0105 20->40 	#No.FUN-680136 VARCHAR(40)
                        pmn01   LIKE pmn_file.pmn01,   #單號
                        pmm04   LIKE pmm_file.pmm04,   #單據日期
                        pmm09   LIKE pmm_file.pmm09,   #供應商
                        pmm22   LIKE pmm_file.pmm22,   #幣別
                        pmn02   LIKE pmn_file.pmn02,   #項次
                        pmn04   LIKE pmn_file.pmn04,   #料件編號
                        pmn041  LIKE pmn_file.pmn041,  #料件品名
                        pmn31   LIKE pmn_file.pmn31,   #單價
                        pmn20   LIKE pmn_file.pmn20,   #採購量
                        pmn50   LIKE pmn_file.pmn50,   #交貨量
                        pmn55   LIKE pmn_file.pmn55,   #驗退
                        pmn53   LIKE pmn_file.pmn53,   #已入庫量
                        n_qty   LIKE pmn_file.pmn53,    #未交量
                        pmn58   LIKE pmn_file.pmn58,   #倉退量
                        ap_qty  LIKE pmn_file.pmn53    #AP請款量
                        END RECORD
#No.FUN-750093 --start--
  DEFINE l_cnt          LIKE  type_file.num5,
         l_num          LIKE  type_file.num5,
         l_pmc03        LIKE  pmc_file.pmc03
  DEFINE l_pmn04        LIKE  pmn_file.pmn04
  DEFINE l_pmm09        LIKE  pmm_file.pmm09
  DEFINE l_t            LIKE  type_file.num5
  DEFINE l_azi03        LIKE  azi_file.azi03
  DEFINE l_i            LIKE  type_file.num5
  DEFINE sr2            RECORD
                        kind    LIKE type_file.chr1,    #資料類別    
                        pno     LIKE pmm_file.pmm01,    #單號 
                        pitem   LIKE pmn_file.pmn02,    #項次 
                        pdate   LIKE pmm_file.pmm04,    #單據日期 
                        pqty    LIKE pmn_file.pmn20     #數量 
                        END RECORD,     
         sr3            RECORD                                                 
                        pmi01   LIKE pmi_file.pmi01,    #核價單號         
                        pmi02   LIKE pmi_file.pmi02,    #核價日期         
                        pmi03   LIKE pmi_file.pmi03,    #廠商編號            
                        pmj02   LIKE pmj_file.pmj02,    #核價項次            
                        pmj03   LIKE pmj_file.pmj03,    #料件編號          
                        pmj05   LIKE pmj_file.pmj05,    #幣別              
                        pmj06   LIKE pmj_file.pmj06,    #原單價              
                        pmj07   LIKE pmj_file.pmj07,    #新單價             
                        pmj08   LIKE pmj_file.pmj08,    #原核准日            
                        pmj09   LIKE pmj_file.pmj09,    #新核准日
                        pmj10   LIKE pmj_file.pmj10     #CHI-8C0014            
                        END RECORD                                          
#No.FUN-750093 --end--
 
#No.FUN-750093 --start--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                         
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"            
     PREPARE insert_prep FROM g_sql                                                
     IF STATUS THEN                                                                
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                          
     END IF                                                                  
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                        
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"                    #CHI-8C0014 Add ?                   
     PREPARE insert_prep1 FROM g_sql                                               
     IF STATUS THEN                                                                
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                         
     END IF                                                                  
#No.FUN-750093 --end--
 
     CALL cl_del_data(l_table)                          #No.FUN-750093          
     CALL cl_del_data(l_table1)                         #No.FUN-750093    
     LET l_pmn04 = NULL                                 #No.FUN-750093
     LET l_pmm09 = NULL                                 #No.FUN-750093
     LET l_t = 1                                        #No.FUN-750093
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmiuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmigrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmigrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
     #End:FUN-980030
 
     DELETE FROM r731_file WHERE 1=1
 
     LET l_sql= "SELECT * FROM r731_file WHERE pmi03=? AND pmj03=?  "
     PREPARE r731_prep FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r731_pmi CURSOR FOR r731_prep
     #將核價資料寫入暫存檔中
     LET l_sql = "SELECT pmi01,pmi02,pmi03,pmj02,pmj03,pmj05, ",
                 "       pmj06,pmj07,pmj08,pmj09,pmj10 ",                        #CHI-8C0014 Add pmj10
                 "  FROM pmi_file, pmj_file ",
                 " WHERE pmi01=pmj01 AND ",tm.wc CLIPPED,
                 "   AND pmj09 >='",tm.bdate,"' ",
#                "   AND pmj10 = ' ' ",                           #CHI-860042    #CHI-8C0014 Mark                                                     
#                "   AND pmj12 = '1' ",                           #CHI-860042    #CHI-8C0014 Mark
                 "   AND pmiconf='Y' "
       
     #CHI-8C0014--Begin--#
     IF tm.type = '1' THEN
        LET l_sql =l_sql  CLIPPED,
             "   AND pmj12 = '1' "
     ELSE
        LET l_sql =l_sql  CLIPPED,
             "   AND pmj12 = '2' "                  
     END IF      
     #CHI-8C0014--End--#       
                 
     PREPARE r731_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r731_c0 CURSOR FOR r731_prepare1
     FOREACH r731_c0 INTO sr1.*
       IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c0:',SQLCA.SQLCODE,0) END IF
       INSERT INTO r731_file VALUES(sr1.*)
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('ins r731_file',SQLCA.SQLCODE,0)   #No.FUN-660129
          CALL cl_err3("ins","r731_file",sr1.pmi01,"",SQLCA.sqlcode,"","ins r731_file",1)  #No.FUN-660129
          EXIT FOREACH
       END IF
     END FOREACH
 
#No.FUN-750093 --mark--
#     CALL cl_outnam('apmr731') RETURNING l_name
#No.FUN-590110 --start--
#     IF tm.b='Y' THEN
#        LET g_zaa[51].zaa06='N'
#        LET g_zaa[52].zaa06='N'
#        LET g_zaa[53].zaa06='N'
#        LET g_zaa[54].zaa06='N'
#        LET g_zaa[55].zaa06='N'
#     ELSE
#        LET g_zaa[51].zaa06='Y'
#        LET g_zaa[52].zaa06='Y'
#        LET g_zaa[53].zaa06='Y'
#        LET g_zaa[54].zaa06='Y'
#        LET g_zaa[55].zaa06='Y'
#     END IF
#     CALL cl_prt_pos_len()
#No.FUN-590110 --end--
#     START REPORT r731_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750093 --end--
#No.FUN-750093 --start--
     IF tm.b='Y' THEN
        IF tm.type = '1' THEN             #CHI-8C0014
           LET l_name='apmr731_1'
        ELSE                              #CHI-8C0014
           LET l_name='apmr731_2'         #CHI-8C0014
        END IF                            #CHI-8C0014
     ELSE        
        IF tm.type = '1' THEN             #CHI-8C0014
           LET l_name='apmr731'
        ELSE                              #CHI-8C0014
           LET l_name='apmr731_3'         #CHI-8C0014
        END IF                            #CHI-8C0014        
     END IF
     CALL cl_prt_pos_len()
#No.FUN-750093 --end--
 
     #讀取採購單之相關單據明細
     LET l_sql= " SELECT '0',rva01,rvb02,rva06,rvb07 ",
               "   FROM rva_file,rvb_file ",
               "  WHERE rva01=rvb01 AND rvaconf !='X' ",
               "    AND rvb04 = ? AND rvb03=? ",
               "  UNION ",
               "  SELECT rvu00,rvu01,rvv02,rvu03,rvv17 ",
               "    FROM rvu_file,rvv_file ",
               "   WHERE rvu01=rvv01 AND rvuconf !='X' ",
               "     AND rvv36 = ? AND rvv37 = ? ",
               "  UNION ",
               "  SELECT '4',apa01,apb02,apa02,apb09 ",
               "    FROM apa_file,apb_file ",
               "   WHERE apa01=apb01 ",
               "     AND apa42 = 'N' ",
               "     AND apb06=? AND apb07 = ? ",
               "   ORDER BY 1,2 "
     PREPARE r731_pr0 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r731_b CURSOR FOR r731_pr0
     #計算採購單之請款量
     LET l_sql = "SELECT SUM(apb09) ",
                  " FROM apb_file ",
                  " WHERE apb06=? AND apb07=? "
     PREPARE r731_pr1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r731_ap CURSOR FOR r731_pr1
     #採購資料
       LET l_sql="SELECT UNIQUE '','',pmn01,pmm04,pmm09,pmm22,",
               "     pmn02,pmn04,pmn041,pmn31,pmn20,pmn50,pmn55,pmn53,",
              #"     (pmn20-pmn50+pmn55), pmn58,0 ",        #FUN-940083 MARK
               "     (pmn20-pmn50+pmn55+pmn58), pmn58,0 ", #FUN-940083 ADD
               "  FROM pmm_file,pmn_file,r731_file,ima_file ",
               " WHERE pmm01=pmn01 AND pmn04=ima01 ",
               "   AND pmm09=pmi03 AND pmn04=pmj03  ",
               "   AND pmm04 >='",tm.bdate,"' AND pmm18 <> 'X' ",
               "   ORDER BY pmn04,pmm09   "          #No.FUN-750093
       PREPARE r731_pr2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
          EXIT PROGRAM 
       END IF
       DECLARE r731_po CURSOR FOR r731_pr2
       FOREACH r731_po INTO sr.*
           IF SQLCA.SQLCODE <>0 THEN CALL cl_err('r731_c2:',SQLCA.SQLCODE,0)
              EXIT FOREACH
           END IF
           #讀取請款量
           OPEN r731_ap USING sr.pmn01,sr.pmn02
           FETCH r731_ap INTO sr.ap_qty
           IF SQLCA.SQLCODE OR cl_null(sr.ap_qty) THEN
              LET sr.ap_qty=0
           END IF
           CLOSE r731_ap
#No.FUN-750093 --start--
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.pmm09               
      SELECT azi03 INTO l_azi03 FROM azi_file                                    
             WHERE azi01=sr.pmm22                                            
      IF tm.b='Y' THEN   
         LET l_i = 0                               
         FOREACH r731_b                                   
             USING sr.pmn01,sr.pmn02,sr.pmn01,sr.pmn02,sr.pmn01,sr.pmn02     
             INTO sr2.*  
#No.FUN-750093 --mark--
#           CASE tm.a
#              WHEN '1' LET sr.order1 = sr.pmn04
#                       LET sr.order2 = sr.pmm09
#              WHEN '2' LET sr.order1 = sr.pmm09
#                       LET sr.order2 = sr.pmn04
#           END CASE
#           OUTPUT TO REPORT r731_rep(sr.*)
#No.FUN-750093 --end--
        EXECUTE insert_prep USING sr.pmn04,sr.pmn041,sr.pmm09,l_pmc03,
                                  sr.pmn01,sr.pmm04,sr.pmm22,sr.pmn02,
                                  sr.pmn31,sr.pmn20,sr.pmn50,sr.pmn55,
                                  sr.pmn53,sr.n_qty,sr.pmn58,sr.ap_qty,
                                  sr2.kind,sr2.pno,sr2.pitem,sr2.pdate,
                                  sr2.pqty,l_azi03
        LET l_i = l_i+1
        END FOREACH
        IF l_i=0 THEN
         EXECUTE insert_prep USING sr.pmn04,sr.pmn041,sr.pmm09,l_pmc03,        
                                  sr.pmn01,sr.pmm04,sr.pmm22,sr.pmn02,         
                                  sr.pmn31,sr.pmn20,sr.pmn50,sr.pmn55,         
                                  sr.pmn53,sr.n_qty,sr.pmn58,sr.ap_qty,        
                                  '','','','','',l_azi03 
        END IF
      ELSE 
        EXECUTE insert_prep USING sr.pmn04,sr.pmn041,sr.pmm09,l_pmc03,             
                                  sr.pmn01,sr.pmm04,sr.pmm22,sr.pmn02,             
                                  sr.pmn31,sr.pmn20,sr.pmn50,sr.pmn55,             
                                  sr.pmn53,sr.n_qty,sr.pmn58,sr.ap_qty,            
                                  '','','','','',l_azi03   
      END IF 
      IF l_t =1 THEN
        FOREACH r731_pmi USING sr.pmm09,sr.pmn04 INTO sr3.*                     
             SELECT azi03 INTO t_azi03                                          
               FROM azi_file                                                    
             WHERE azi01=sr3.pmj05                                              
        EXECUTE insert_prep1 USING sr3.pmi01,sr3.pmj02,sr3.pmi02,sr3.pmj05,     
                                   sr3.pmj06,sr3.pmj07,sr3.pmj08,sr3.pmj09,     
                                   t_azi03,sr.pmn04,sr.pmm09,sr3.pmj10                  #CHI-8C0014 Add  sr3.pmj10                    
        END FOREACH                                                             
        LET l_pmn04 = sr.pmn04                                                  
        LET l_pmm09 = sr.pmm09          
        LET l_t = l_t+1
      ELSE                                  
        IF l_pmn04 != sr.pmn04 or l_pmm09 != sr.pmm09 THEN
          FOREACH r731_pmi USING sr.pmm09,sr.pmn04 INTO sr3.*                       
               SELECT azi03 INTO t_azi03                                            
                 FROM azi_file                                                      
               WHERE azi01=sr3.pmj05                                               
          EXECUTE insert_prep1 USING sr3.pmi01,sr3.pmj02,sr3.pmi02,sr3.pmj05,       
                                     sr3.pmj06,sr3.pmj07,sr3.pmj08,sr3.pmj09,       
                                     t_azi03,sr.pmn04,sr.pmm09,sr3.pmj10               #CHI-8C0014 Add  sr3.pmj10              
          END FOREACH                                          
          LET l_pmn04 = sr.pmn04
          LET l_pmm09 = sr.pmm09
          LET l_t =l_t+1
        END IF
      END IF                       
    END FOREACH
#     FINISH REPORT r731_rep                         #No.FUN-750093
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-750093
#No.FUN-750093 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                #No.FUN-770033
        CALL cl_wcchp(tm.wc,'pmi01,pmi03,pmi04,pmi03')   #No.FUN-770033
             RETURNING tm.wc                             #No.FUN-770033
        LET g_str=tm.wc                                  #No.FUN-770033
     END IF                                              #No.FUN-770033
     LET g_str = tm.a,";",g_str                          #No.FUN-770033
#     LET g_str = tm.a                                   #No.FUN-770033
#    LET l_sql = "SELECT B.pmi01,B.pmj02,B.pmi02,B.pmj05,B.pmj06,B.pmj07,",
#                " B.pmj08,B.pmj09,B.azi03,A.* ",
     LET l_sql = "SELECT B.*,A.* ",     
                 " FROM ",g_cr_db_str CLIPPED, l_table CLIPPED," A ",
                 "  LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.pmn04 = B.pmn04_1 AND A.pmm09 = B.pmm09_1"
#    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('apmr731',l_name,l_sql,g_str)
#No.FUN-750093 --end--
END FUNCTION
#No.FUN-750093 --start--
{REPORT r731_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
          l_buf		LIKE apo_file.apo02,    #No.FUN-680136 VARCHAR(4)
          l_cnt         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_str         LIKE apo_file.apo02, 	#No.FUN-680136 VARCHAR(4)
          l_pmc03       LIKE pmc_file.pmc03,
          l_num        LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
          sr1           RECORD
                          pmi01   LIKE pmi_file.pmi01,    #核價單號
                          pmi02   LIKE pmi_file.pmi02,    #核價日期
                          pmi03   LIKE pmi_file.pmi03,    #廠商編號
                          pmj02   LIKE pmj_file.pmj02,    #核價項次
                          pmj03   LIKE pmj_file.pmj03,    #料件編號
                          pmj05   LIKE pmj_file.pmj05,    #幣別
                          pmj06   LIKE pmj_file.pmj06,    #原單價
                          pmj07   LIKE pmj_file.pmj07,    #新單價
                          pmj08   LIKE pmj_file.pmj08,    #原核准日
                          pmj09   LIKE pmj_file.pmj09     #新核准日
                        END RECORD,
          sr2           RECORD
                          kind    LIKE type_file.chr1,    #資料類別 	#No.FUN-680136 VARCHAR(1)
                          pno     LIKE pmm_file.pmm01,    #單號
                          pitem   LIKE pmn_file.pmn02,    #項次
                          pdate   LIKE pmm_file.pmm04,    #單據日期
                          pqty    LIKE pmn_file.pmn20     #數量
                        END RECORD,
          sr            RECORD
                        order1  LIKE ima_file.ima01,   #FUN-5B0105 20->40	#No.FUN-680136 VARCHAR(40)
                        order2  LIKE ima_file.ima01,   #FUN-5B0105 20->40	#No.FUN-680136 VARCHAR(40)
                        pmn01   LIKE pmn_file.pmn01,   #單號
                        pmm04   LIKE pmm_file.pmm04,   #單據日期
                        pmm09   LIKE pmm_file.pmm09,   #供應商
                        pmm22   LIKE pmm_file.pmm22,   #幣別
                        pmn02   LIKE pmn_file.pmn02,   #項次
                        pmn04   LIKE pmn_file.pmn04,   #料件編號
                        pmn041  LIKE pmn_file.pmn041,  #料件品名
                        pmn31   LIKE pmn_file.pmn31,   #單價
                        pmn20   LIKE pmn_file.pmn20,   #採購量
                        pmn50   LIKE pmn_file.pmn50,   #交貨量
                        pmn55   LIKE pmn_file.pmn55,   #驗退
                        pmn53   LIKE pmn_file.pmn53,   #已入庫量
                        n_qty   LIKE pmn_file.pmn53,    #未交量
                        pmn58   LIKE pmn_file.pmn58,   #倉退量
                        ap_qty  LIKE pmn_file.pmn53    #AP請款量
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2
  FORMAT
    PAGE HEADER
#No.FUN-590110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
#No.FUN-590110 --end--
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,sr.pmn04,"  ",sr.pmn041  CLIPPED
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.pmm09
      PRINT g_x[12] CLIPPED,sr.pmm09,"  ",l_pmc03
      SKIP 1 LINE
      LET l_last_sw = 'n'
#No.FUN-590110 --start--
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],
            g_x[55]
      PRINT g_dash1
#No.FUN-590110 --end--
 
    BEFORE GROUP OF sr.order1
      SKIP TO TOP OF PAGE
    BEFORE GROUP OF sr.order2
      SKIP TO TOP OF PAGE
      #列印核價單資料
      FOREACH r731_pmi USING sr.pmm09,sr.pmn04 INTO sr1.*
           SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #No.CHI-6A0004
             FROM azi_file                 #幣別檔小數位數讀取
            WHERE azi01=sr1.pmj05
#No.FUN-590110 --start--
           PRINT COLUMN g_c[31],sr1.pmi01,
                 COLUMN g_c[32],sr1.pmj02 USING "###&",
                 COLUMN g_c[33],sr1.pmi02,
                 COLUMN g_c[34],sr1.pmj05,
                 COLUMN g_c[35],cl_numfor(sr1.pmj06,15,t_azi03), #No.CHI-6A0004
                 COLUMN g_c[36],cl_numfor(sr1.pmj07,15,t_azi03), #No.CHI-6A0004
                 COLUMN g_c[37],sr1.pmj08,
                 COLUMN g_c[38],sr1.pmj09
#No.FUN-590110 --end--
      END FOREACH
 
   ON EVERY ROW
           SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #No.CHI-6A0004
             FROM azi_file                 #幣別檔小數位數讀取
            WHERE azi01=sr.pmm22
#No.FUN-590110 --start--
      PRINT COLUMN g_c[39],sr.pmn01,
            COLUMN g_c[40],sr.pmm04,
            COLUMN g_c[41],sr.pmm22,
            COLUMN g_c[42],sr.pmn02  USING "###&",
            COLUMN g_c[43],cl_numfor(sr.pmn31,15,t_azi03),   #No.CHI-6A0004
            COLUMN g_c[44],sr.pmn20  USING "#####&",
            COLUMN g_c[45],sr.pmn50  USING "#####&",
            COLUMN g_c[46],sr.pmn55  USING "####&",
            COLUMN g_c[47],sr.pmn53  USING "#####&",
            COLUMN g_c[48],sr.n_qty  USING "#####&",
            COLUMN g_c[49],sr.pmn58  USING "###&",
            COLUMN g_c[50],sr.ap_qty USING "###&"
#No.FUN-590110 --end--
      #列印明細
      IF tm.b='Y' THEN
         LET l_cnt=0
         LET l_num=0
         FOREACH r731_b
             USING sr.pmn01,sr.pmn02,sr.pmn01,sr.pmn02,sr.pmn01,sr.pmn02
             INTO sr2.*
             LET l_num=l_num + 1
             LET l_cnt = l_cnt + 1
             LET l_str = r731_type(sr2.kind)
             IF l_cnt =1 THEN
#No.FUN-590110 --start--
                PRINT COLUMN g_c[51],l_str,
                      COLUMN g_c[52],sr2.pno,
                      COLUMN g_c[53],sr2.pitem USING "###&",
                      COLUMN g_c[54],sr2.pdate,
                      COLUMN g_c[55],sr2.pqty USING "#######&"
             ELSE
                PRINT COLUMN g_c[51],l_str,
                      COLUMN g_c[52],sr2.pno,
                      COLUMN g_c[53],sr2.pitem USING "###&",
                      COLUMN g_c[54],sr2.pdate,
                      COLUMN g_c[55],sr2.pqty USING "#######&"
#No.FUN-590110 --end--
                LET l_cnt=0
             END IF
         END FOREACH
         IF l_cnt=1 THEN PRINT " " END IF
         IF l_num > 0 THEN PRINT " " END IF
       END IF
 
   ON LAST ROW
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw='y'
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT ' '
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 3 LINE
      END IF
END REPORT
 
FUNCTION r731_type(p_chr)
   DEFINE p_chr LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
 
   CASE WHEN p_chr='0' CALL cl_getmsg('apm-334',0)  RETURNING l_str
        WHEN p_chr='1' CALL cl_getmsg('apm-243',0)  RETURNING l_str
        WHEN p_chr='2' CALL cl_getmsg('apm-244',0)  RETURNING l_str
        WHEN p_chr='3' CALL cl_getmsg('apm-335',0)  RETURNING l_str
        WHEN p_chr='4' CALL cl_getmsg('apm-336',0)  RETURNING l_str
   END CASE
   RETURN l_str
END FUNCTION}
#No.FUN-750093 --end--
#Patch....NO.TQC-610036 <> #
