# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmr402.4gl
# Descriptions...: 請購單進度追蹤表
# Input parameter:
# Return code....:
# Date & Author..: 91/10/05 By Nora
# Modify.........: 95/04/17 By Danny (將判斷收貨性質rvb19之部份拿掉)
# Modify.........: 99/12/23 By Carol
# Modify.........: 01/08/22 By CArol MISC display 品名
# Modify.........: No:7787 03/08/11 By Mandy 勾選跳頁, 報表印出無跳頁功能
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/05/30 By yoyo單據編號格式放大
# Modify.........: No.MOD-550035 05/06/16 By kim 已結案的,不show在報表上,修改apmr402.ora
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-560207 05/10/20 By Smapmin 列印採購單位
# Modify.........: No.MOD-5B0167 05/11/22 By Rosayu QBE有料件,要依料件排序
# Modify.........: No.FUN-5C0060 05/12/23 by Sarah 請購單號、請購員、請購部門、
#                                                  料件編號欄位加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6C0077 06/12/19 By Judy 報表格式調整
# Modify.........: No.FUN-750093 07/07/30 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.MOD-850019 08/05/06 By Dido 採購單已作廢不可印出採購資料
# Modify.........: No.MOD-860177 08/06/17 By Smapmin 狀況碼應抓取單身資料;品名無法顯示
# Modify.........: No.MOD-970250 09/07/29 By Dido rvb08 改為 rvb07
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B40074 11/04/12 By lilingyu sql變量長度定義過短
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
            #  wc   VARCHAR(800),                  # Where Condition
              wc   STRING,                      #TQC-630166      # Where Condition
              s    LIKE type_file.chr3,         #No.FUN-680136 VARCHAR(3) # 排列項目
              t    LIKE type_file.chr3,         #No.FUN-680136 VARCHAR(3) # 同項目是否跳頁
              n	   LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1) # 1=全部2=未採購
              more LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1) # 特殊列印條件
              END RECORD
 
   DEFINE   g_i    LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
   DEFINE l_table        STRING,                 ### FUN-750093 ###                                                                    
          g_str          STRING,                 ### FUN-750093 ###                                                                    
          g_sql          STRING                  ### FUN-750093 ### 
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
## *** FUN-750093  與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
    LET g_sql ="pmk01.pmk_file.pmk01,",
               "pmk04.pmk_file.pmk04,",
               #"pmk25.pmk_file.pmk25,",   #MOD-860177
               "pml16.pml_file.pml16,",   #MOD-860177
               "pmk12.pmk_file.pmk12,",
               "gen02.gen_file.gen02,",
               "pmk13.pmk_file.pmk13,",
               "gem02.gem_file.gem02,",
               "pml02.pml_file.pml02,",
               "pml04.pml_file.pml04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pml33.pml_file.pml33,",
               "pml34.pml_file.pml34,",
               "pml35.pml_file.pml35,", 
               "pml18.pml_file.pml18,",
               "pml20.pml_file.pml20,",
               "pmn01.pmn_file.pmn01,",
               "pmn02.pmn_file.pmn02,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmn07.pmn_file.pmn07,",
               "pmn20.pmn_file.pmn20,",
               "pmn33.pmn_file.pmn33,",
               "rvb01.rvb_file.rvb01,",
               "rvb02.rvb_file.rvb02,",
               "rva06.rva_file.rva06,",
              #"rvb08.rvb_file.rvb08,",		#MOD-970250 mark
               "rvb07.rvb_file.rvb07,",		#MOD-970250
               "chr50.type_file.chr50,",
               "chr50_1.type_file.chr50"
 
    LET l_table = cl_prt_temptable('apmr402',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    #No.TQC-820008                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?, ",                                                                       
                "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                                              
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                   
# FUN-750093 -- end --
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
#----------------No.TQC-610085 modify
   LET tm.n     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r402_tm(0,0)		# Input print condition
      ELSE CALL r402()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r402_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680136 SMALLINT
       l_cmd	      LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW r402_w AT p_row,p_col WITH FORM "apm/42f/apmr402"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm.n	 = '2'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
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
   CONSTRUCT BY NAME  tm.wc ON pmk01,pmk04,pmk12,pmk13,pml04,pml16
     #start FUN-5C0060
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(pmk01)      #請購單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmk3"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk01
                   NEXT FIELD pmk01
              WHEN INFIELD(pmk12)      #請購員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk12
                   NEXT FIELD pmk12
              WHEN INFIELD(pmk13)      #請購部門
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk13
                   NEXT FIELD pmk13
              WHEN INFIELD(pml04)      #料件編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima1"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pml04
                   NEXT FIELD pml04
              OTHERWISE
                   EXIT CASE
         END CASE
     #end FUN-5C0060
 
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
 
   DISPLAY BY NAME tm.s,tm.more
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.n,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF tm.n NOT MATCHES'[12]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
            NEXT FIELD more
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr402'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr402','9031',1)
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
                         " '",tm.s,"'",
                         " '",tm.t,"'" ,
                         " '",tm.n,"'" ,               #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr402',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r402_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r402()
   ERROR ""
 END WHILE
   CLOSE WINDOW r402_w
END FUNCTION
 
FUNCTION r402()
   DEFINE l_name     LIKE type_file.chr20, 	# External(Disk) file name         #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,  	# Used time for running the job    #No.FUN-680136 VARCHAR(8)
          l_i        LIKE type_file.num5,  	#No.FUN-680136 SMALLINT
#         l_sql      LIKE type_file.chr1000,	# RDSQL STATEMENT                  #No.FUN-680136 VARCHAR(1000)  #TQC-B40074
          l_sql      STRING,                    #TQC-B40074
          l_za05     LIKE ze_file.ze03,         #No.FUN-680136 VARCHAR(40)
          l_order    ARRAY[3] of LIKE pml_file.pml04    #No.FUN-680136 VARCHAR(40)
   DEFINE l_ima02    LIKE ima_file.ima02        #FUN-750093 
   DEFINE l_ima021   LIKE ima_file.ima021       #FUN-750093
   DEFINE l_gen02    LIKE gen_file.gen02        #FUN-750093
   DEFINE l_gem02    LIKE gem_file.gem02        #FUN-750093
   DEFINE l_pmc03    LIKE pmc_file.pmc03        #FUN-750093
   DEFINE sr         RECORD
                     order1    LIKE    pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
                     order2    LIKE    pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
                     order3    LIKE    pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
                     pmk01     LIKE    pmk_file.pmk01,   #請購單號
                     pmk12     LIKE    pmk_file.pmk12,   #請購員
                     pml02     LIKE    pml_file.pml02,   #項次
                     pml04     LIKE    pml_file.pml04,   #料件編號
                     pml041    LIKE    pml_file.pml041,  #品名
                     ima02     LIKE    ima_file.ima02,   #品名
                     pml16     LIKE    pml_file.pml16,   #狀況碼
                     pml20     LIKE    pml_file.pml20,   #請購量
                     pml21     LIKE    pml_file.pml21,   #已轉請購量
                     pmk04     LIKE    pmk_file.pmk04,   #請購日期
                     pmk13     LIKE    pmk_file.pmk13,   #部門
                     pml33     LIKE    pml_file.pml33,   #交貨日
                     pml34     LIKE    pml_file.pml34,   #No.TQC-640132
                     pml35     LIKE    pml_file.pml35,   #No.TQC-640132
                     pml18     LIKE    pml_file.pml18,   #No.TQC-640132
                     pmn01     LIKE    pmn_file.pmn01,   #採購單號
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                     pmn07     LIKE    pmn_file.pmn07,   #單位   #FUN-560207
                     pmn20     LIKE    pmn_file.pmn20,   #數量
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                     rvb02     LIKE    rvb_file.rvb02,   #項次
                     rva06     LIKE    rva_file.rva06,   #收貨日
                     #狀況碼 add by nick at 95/03/08
                     pmk25     LIKE    pmk_file.pmk25,
                    #rvb08     LIKE    rvb_file.rvb08,   #數量	#MOD-970250 mark
                     rvb07     LIKE    rvb_file.rvb07,   #數量	#MOD-970250
                     rvb19     LIKE    rvb_file.rvb19,   #收貨狀況
                     l_order1  LIKE type_file.chr50,     #No.FUN-680136 VARCHAR(25)
                     l_order2  LIKE type_file.chr50      #No.FUN-680136 VARCHAR(25)
                     END RECORD
     CALL cl_del_data(l_table)                                  # FUN-750093
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog     # FUN-750093
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    FOR g_i = 1 TO 3
#        CASE
#           WHEN tm.s[g_i,g_i]='1'  LET g_x[17]=g_x[17] CLIPPED,' ',g_x[18]
#           WHEN tm.s[g_i,g_i]='2'  LET g_x[17]=g_x[17] CLIPPED,' ',g_x[19]
#           WHEN tm.s[g_i,g_i]='3'  LET g_x[17]=g_x[17] CLIPPED,' ',g_x[20]
#           WHEN tm.s[g_i,g_i]='4'  LET g_x[17]=g_x[17] CLIPPED,' ',g_x[21]
#        END CASE
#    END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
LET l_sql = 
 "SELECT UNIQUE '','','', pmk01,pmk12,pml02,pml04,pml041,'',pml16,pml20, ",
 "       pml21,pmk04,pmk13,pml33,pml34,pml35,pml18,pmn01,pmn02, pmm09,pmn07,pmn20,pmn33, ",
 "       rvb01,rvb02,rva06,pmk25,rvb07,rvb19,'','' ",
 "  FROM pmk_file,pml_file LEFT OUTER JOIN ",
 "( ",
 " select pmn24,pmn25,pmn01,pmn02,pmm09,pmn07,pmn20,pmn33, ",
 "        rvb01,rvb02,rva06,rvb07,rvb19 ",
 "   from pmm_file,pmn_file LEFT OUTER JOIN ",
 "   ( ",
 "    select rvb01,rvb02,rva06,rvb07,rvb19,rvb03,rvb04 from rva_file,rvb_file ",
 "     where rva01 = rvb01 ",
 " ) tmp2 ON pmn01 = tmp2.rvb04 AND pmn02 = tmp2.rvb03 ",
 "  where ",
 "    pmm01 = pmn01 and pmm18 != 'X' and pmn16 != '9' ",
 ") tmp ON pml01 = tmp.pmn24 AND pml02 = tmp.pmn25 ",
 " WHERE pmk01 = pml01 ",
 "   AND pml16 != '9' ",
 "   AND pml16 not in ('6','7','8')",
 "   AND pmk18 != 'X' ",
 "   AND pmk25 != '9' ",
 "   AND ",tm.wc CLIPPED,
 " ORDER BY rvb01,rvb02 "
 
     PREPARE r402_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r402_c1 CURSOR FOR r402_p1
 
#     CALL cl_outnam('apmr402') RETURNING l_name      #No.FUN-750093
#     START REPORT r402_rep TO l_name                 #No.FUN-750093
 
#     LET g_pageno = 0                                #No.FUN-750093
     FOREACH r402_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#      IF sr.rvb19 ='2' THEN CONTINUE FOREACH END IF
#No.FUN-750093 --start--
#       FOR l_i = 1 TO 3
#          CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.pmk01
#               WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.pmk04 USING 'YYYYMMDD'
#               WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.pmk12
#               WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.pmk13
#               WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.pml04  #MOD-5B0167 add
#              #OTHERWISE LET l_order[g_i] = '-'
#               OTHERWISE LET l_order[l_i] = '-' #No:7787
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       LET sr.l_order1 = sr.pmk01,sr.pml02 #請購單號,項次
#       LET sr.l_order2 = sr.pmn01,sr.pmn02 #採購單號,項次
#No.FUN-750093 --end--
       IF tm.n=2 THEN
          IF sr.pml20 - sr.pml21 <= 0 THEN CONTINUE FOREACH END IF
       END IF
       IF sr.pml04[1,4]='MISC' THEN
          LET sr.ima02 = sr.pml041
       ELSE
          SELECT ima02 INTO sr.ima02 FROM ima_file
           WHERE ima01 = sr.pml04
       END IF
 # -- No.FUN-750093 -- begin --
       SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01=sr.pml04
       IF SQLCA.sqlcode THEN 
          LET l_ima021=NULL
       END IF
 
       SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01=sr.pmk12
       IF SQLCA.sqlcode THEN 
          LET l_gen02=NULL
       END IF
 
       SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=sr.pmk13
       IF SQLCA.sqlcode THEN
          LET l_gem02=NULL
       END IF
 
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01=sr.pmm09
       IF SQLCA.sqlcode THEN
          LET l_pmc03=NULL
       END IF
 
       LET sr.l_order1 = sr.pmk01,sr.pml02 #請購單號,項次                      
       LET sr.l_order2 = sr.pmn01,sr.pmn02 #采購單號,項次   
 
     EXECUTE insert_prep USING                                                                                                      
                   #sr.pmk01,sr.pmk04,sr.pmk25,sr.pmk12,l_gen02,  #MOD-860177                                                                     
                   sr.pmk01,sr.pmk04,sr.pml16,sr.pmk12,l_gen02,  #MOD-860177                                                                     
                   #sr.pmk13,l_gem02,sr.pml02,sr.pml04,l_ima02,   #MOD-860177                                                                    
                   sr.pmk13,l_gem02,sr.pml02,sr.pml04,sr.ima02,   #MOD-860177                                                                    
                   l_ima021,sr.pml33,sr.pml34,sr.pml35,sr.pml18,                                                                    
                   sr.pml20,sr.pmn01,sr.pmn02,sr.pmm09,l_pmc03,                                                                     
                   sr.pmn07,sr.pmn20,sr.pmn33,sr.rvb01,sr.rvb02,                                                                    
                  #sr.rva06,sr.rvb08,sr.l_order1,sr.order2		#MOD-970250 mark 
                   sr.rva06,sr.rvb07,sr.l_order1,sr.order2 		#MOD-970250
 
 
# -- No.FUN-750093 -- end --
#       OUTPUT TO REPORT r402_rep(sr.*)              # FUN-750093
     END FOREACH
 
#     FINISH REPORT r402_rep                         # FUN-750093
 
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)    # FUN-750093
# -- No.FUN-750093 -- begin --
     LET l_sql= "SELECT *  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     LET g_str=''                                                                                                                   
                                                                                                                                    
     LET g_str=tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
     CALL cl_prt_cs3('apmr402','apmr402',l_sql,g_str)
END FUNCTION
#-- No.FUN-750093 -- begin --
{
REPORT r402_rep(sr)                      
   DEFINE l_ima021     LIKE ima_file.ima021    #FUN-4C0095
   DEFINE l_gen02      LIKE gen_file.gen02     #FUN-4C0095
   DEFINE l_gem02      LIKE gem_file.gem02     #FUN-4C0095
   DEFINE l_pmc03      LIKE pmc_file.pmc03     #FUN-4C0095
   DEFINE l_str        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(50)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_sw       LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
          sr         RECORD
                     order1    LIKE    aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
                     order2    LIKE    aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
                     order3    LIKE    aaf_file.aaf03,   #No.FUN-680136 VARCHAR(40)
                     pmk01     LIKE    pmk_file.pmk01,   #請購單號
                     pmk12     LIKE    pmk_file.pmk12,   #請購員
                     pml02     LIKE    pml_file.pml02,   #項次
                     pml04     LIKE    pml_file.pml04,   #料件編號
                     pml041    LIKE    pml_file.pml041,  #品名
                     ima02     LIKE    ima_file.ima02,   #品名
                     pml16     LIKE    pml_file.pml16,   #狀況碼
                     pml20     LIKE    pml_file.pml20,   #請購量   
                     pml21     LIKE    pml_file.pml21,   #已轉請購量
                     pmk04     LIKE    pmk_file.pmk04,   #請購日期
                     pmk13     LIKE    pmk_file.pmk13,   #部門
                     pml33     LIKE    pml_file.pml33,   #交貨日
                     pml34     LIKE    pml_file.pml34,   #No.TQC-640132
                     pml35     LIKE    pml_file.pml35,   #No.TQC-640132
                     pml18     LIKE    pml_file.pml18,   #No.TQC-640132
                     pmn01     LIKE    pmn_file.pmn01,   #採購單號
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                     pmn07     LIKE    pmn_file.pmn07,   #單位   #FUN-560207
                     pmn20     LIKE    pmn_file.pmn20,   #數量
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                     rvb02     LIKE    rvb_file.rvb02,   #項次
                     rva06     LIKE    rva_file.rva06,   #收貨日
                     pmk25     LIKE    pmk_file.pmk25,	 #狀況碼 add by nick
                     rvb08     LIKE    rvb_file.rvb08,   #數量
                     rvb19     LIKE    rvb_file.rvb19,   #收貨狀況
                     l_order1  LIKE type_file.chr50,     #No.FUN-680136 VARCHAR(25)
                     l_order2  LIKE type_file.chr50      #No.FUN-680136 VARCHAR(25)
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.order2,sr.order3,sr.l_order1,sr.l_order2
  FORMAT
   PAGE HEADER
     LET l_str = l_str CLIPPED,g_x[17]
     FOR g_i = 1 TO 3
         CASE
            WHEN tm.s[g_i,g_i]='1'  LET l_str = l_str CLIPPED,' ',g_x[18]
            WHEN tm.s[g_i,g_i]='2'  LET l_str = l_str CLIPPED,' ',g_x[19]
            WHEN tm.s[g_i,g_i]='3'  LET l_str = l_str CLIPPED,' ',g_x[20]
            WHEN tm.s[g_i,g_i]='4'  LET l_str = l_str CLIPPED,' ',g_x[21]
            WHEN tm.s[g_i,g_i]='5'  LET l_str = l_str CLIPPED,' ',g_x[55] #MOD-5B0167 add
         END CASE
     END FOR
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT l_str
      PRINT g_dash
  #TQC-6C0077 mark
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],   
#            g_x[51],g_x[52],g_x[53],g_x[54],g_x[56],g_x[57],g_x[58]   #FUN-560207  #No.TQC-640132
  #TQC-6C0077.....begin
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[56],g_x[57],g_x[58],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[54],g_x[48],
            g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
  #TQC-6C0077.....end
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_sw = 'y'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order1
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pml04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      SELECT gen02
        INTO l_gen02
        FROM gen_file
       WHERE gen01=sr.pmk12
      IF SQLCA.sqlcode THEN
          LET l_gen02 = NULL
      END IF
      SELECT gem02
        INTO l_gem02
        FROM gem_file
       WHERE gem01=sr.pmk13
      IF SQLCA.sqlcode THEN
          LET l_gem02 = NULL
     END IF
      PRINT COLUMN g_c[31],sr.pmk01,
            COLUMN g_c[32],sr.pmk04,
            COLUMN g_c[33],sr.pml16,
            COLUMN g_c[34],sr.pmk12,
            COLUMN g_c[35],l_gen02,
            COLUMN g_c[36],sr.pmk13,
            COLUMN g_c[37],l_gem02,
            COLUMN g_c[38],sr.pml02 USING '########',
            COLUMN g_c[39],sr.pml04,
            COLUMN g_c[40],sr.ima02,
            COLUMN g_c[41],l_ima021,
            COLUMN g_c[42],sr.pml33,
            COLUMN g_c[56],sr.pml34,                      
            COLUMN g_c[57],sr.pml35,                 
            COLUMN g_c[58],sr.pml18,           
            COLUMN g_c[43],cl_numfor(sr.pml20,43,3);        
   BEFORE GROUP OF sr.l_order2
      SELECT pmc03
        INTO l_pmc03
        FROM pmc_file
       WHERE pmc01=sr.pmm09
      IF SQLCA.sqlcode THEN
          LET l_pmc03 = NULL
      END IF
     LET l_sw = 'y'
            PRINT COLUMN g_c[44],sr.pmn01,
                  COLUMN g_c[45],sr.pmn02 USING '########',
                  COLUMN g_c[46],sr.pmm09,
                  COLUMN g_c[47],l_pmc03, #廠商簡稱
                  COLUMN g_c[54],sr.pmn07,   #FUN-560207
                  COLUMN g_c[48],cl_numfor(sr.pmn20,48,3),
                  COLUMN g_c[49],sr.pmn33;
   ON EVERY ROW
      PRINT COLUMN g_c[50],sr.rvb01,
            COLUMN g_c[51],sr.rvb02 USING '########',
            COLUMN g_c[52],sr.rva06,
            COLUMN g_c[53],cl_numfor(sr.rvb08,53,3)
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
         #    IF tm.wc[001,120] > ' ' THEN			# for 132
 	 #       PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
         #    IF tm.wc[121,240] > ' ' THEN
 	 #       PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
         #    IF tm.wc[241,300] > ' ' THEN
 	 #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
	  #TQC-630166
	  CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #MOD-5B0167
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #MOD-5B0167
         ELSE SKIP 2 LINE
      END IF
END REPORT
}                                    
 #-- No: FUN-750093-- end --
