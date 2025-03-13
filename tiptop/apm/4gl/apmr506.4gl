# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr506.4gl
# Descriptions...: 採購單進度追蹤表
# Input parameter:
# Return code....:
# Date & Author..: 91/10/14 By Nora
# Modify.........: 92/11/13 By Apple SQL組合錯誤
# NOTE           : 93/11/04 By Apple 將委外收貨資料去掉
# Modify.........: No:8328 03/09/25 By Mandy 未交量未扣除樣品收貨入庫部份
# Modify.........: No.FUN-4A0012 04/10/04 By Echo 採購單號,採購員,採購部門,料件編號,狀況碼要開窗
# Modify.........: No.FUN-4C0095 05/01/24 By Mandy 報表轉XML
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-740345 07/05/02 By kim 採購單號開窗可以查到委外採購單號，但產生時卻顯示無符合資料，委外採購單尚未收貨
# Modify.........: No.FUN-750101 07/06/12 By mike 報表格式修改為crystal reports 
# Modify.........: No.MOD-8A0025 08/10/02 By alexstar 應該要過濾掉已經作廢的收貨單
# Modify.........: No.FUN-8A0024 08/10/09 By Smapmin 增加是否列印未交量為0的選項
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
             #wc   VARCHAR(500),                   # Where Condition  #TQC-630166 mark
              wc   STRING,                      # Where Condition  #TQC-630166
              s    LIKE type_file.chr3,         #No.FUN-680136 VARCHAR(3)    # 排列項目
              t    LIKE type_file.chr3,         #No.FUN-680136 VARCHAR(3)    # 同項目是否跳頁
              a    LIKE type_file.chr1,         #FUN-8A0024
              more LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)    # 特殊列印條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_str           STRING                 #No.FUN-750101
DEFINE   l_table         STRING                 #No.FUN-750101
DEFINE   g_sql           STRING                 #No.FUN-750101
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
#No.FUN-750101  --begin--
   LET g_sql="pmm01.pmm_file.pmm01,",
             "pmm12.pmm_file.pmm12,",
             "pmm13.pmm_file.pmm13,",
             "gen02.gen_file.gen02,",
             "pmm25.pmm_file.pmm25,",
             "pmn02.pmn_file.pmn02,",
             "pmm04.pmm_file.pmm04,",
             "pmm09.pmm_file.pmm09,",
             "pmc03.pmc_file.pmc03,",
             "pmn04.pmn_file.pmn04,",
             "pmn20.pmn_file.pmn20,",
             "pmn33.pmn_file.pmn33,",
             "pmn041.pmn_file.pmn041,",
             "ima021.ima_file.ima021,",
             "pmn01.pmn_file.pmn01,",
             "rvb01.rvb_file.rvb01,",
             "rvb02.rvb_file.rvb02,",
             "rva06.rva_file.rva06,",
             "rvb07.rvb_file.rvb07,",
             "rvb29.rvb_file.rvb29,",
             "rvb19.rvb_file.rvb19,",
             "rvb35.rvb_file.rvb35"     
   LET l_table=cl_prt_temptable('apmr506',g_sql)  CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750101  --END--              
   
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)   #FUN-8A0024
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r506_tm(0,0)		# Input print condition
      ELSE CALL r506()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r506_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r506_w AT p_row,p_col WITH FORM "apm/42f/apmr506"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm.a      = 'Y'   #FUN-8A0024
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
   CONSTRUCT BY NAME  tm.wc ON pmm01,pmm04,pmm12,pmm13,pmn04,pmn16
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
       #### No.FUN-4A0012
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmm01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmm602"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm01
                NEXT FIELD pmm01
 
              WHEN INFIELD(pmm12)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm12
                NEXT FIELD pmm12
 
              WHEN INFIELD(pmm13)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm13
                NEXT FIELD pmm13
 
              WHEN INFIELD(pmn04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmn04
                NEXT FIELD pmn04
 
           END CASE
      ### END  No.FUN-4A0012
 
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
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r506_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.more
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.a,   #FUN-8A0024增加tm.a
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW r506_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr506'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr506','9031',1)
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
                         " '",tm.a,"'" ,   #FUN-8A0024
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr506',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r506_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r506()
   ERROR ""
END WHILE
   CLOSE WINDOW r506_w
END FUNCTION
 
FUNCTION r506()
   DEFINE l_name     LIKE type_file.chr20, 		 # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,  		 # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_i,l_j,l_k LIKE type_file.num5,  		 # No.FUN-680136 SMALLINT
         #l_sql      LIKE type_file.chr1000,	         # RDSQL STATEMENT #TQC-630166 mark 
          l_sql      STRING,	                 	 # RDSQL STATEMENT #TQC-630166
          l_za05     LIKE type_file.chr1000,             #No.FUN-680136 VARCHAR(40)
          l_order    ARRAY[3] of LIKE type_file.chr20,   #No.FUN-680136 VARCHAR(20)
          sr         RECORD
                     order1    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     order2    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     order3    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     pmm01     LIKE    pmm_file.pmm01,   #採購單號
                     pmm12     LIKE    pmm_file.pmm12,   #採購員
                     pmm13     LIKE    pmm_file.pmm13,   #採購部門
                     gen02     LIKE    gen_file.gen02,   #姓名
                     pmm25     LIKE    pmm_file.pmm25,   #狀況碼
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmm04     LIKE    pmm_file.pmm04,   #採購日期
                     pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                     pmc03     LIKE    pmc_file.pmc03,   #簡稱
                     pmn04     LIKE    pmn_file.pmn04,   #料件編號
                     pmn20     LIKE    pmn_file.pmn20,   #採購量
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                     rvb02     LIKE    rvb_file.rvb02,   #項次
                     rva06     LIKE    rva_file.rva06,   #收料日
                     rvb07     LIKE    rvb_file.rvb07,   #已交量 rvb07-rvb29
                     rvb19     LIKE    rvb_file.rvb19,   #交貨狀況
                     rvb35     LIKE    rvb_file.rvb35,   #樣品否 #No:8328
                     pmn041    LIKE    pmn_file.pmn041,  #品名規格
                     ima021    LIKE    ima_file.ima021
                     END RECORD,
          sr2       DYNAMIC ARRAY OF RECORD #TQC-740345 sr2的個數必須和sr相同
                     order1    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     order2    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     order3    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                     pmm01     LIKE    pmm_file.pmm01,   #採購單號
                     pmm12     LIKE    pmm_file.pmm12,   #採購員
                     pmm13     LIKE    pmm_file.pmm13,   #採購部門
                     gen02     LIKE    gen_file.gen02,   #姓名
                     pmm25     LIKE    pmm_file.pmm25,   #狀況碼
                     pmn02     LIKE    pmn_file.pmn02,   #項次
                     pmm04     LIKE    pmm_file.pmm04,   #採購日期
                     pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                     pmc03     LIKE    pmc_file.pmc03,   #簡稱
                     pmn04     LIKE    pmn_file.pmn04,   #料件編號
                     pmn20     LIKE    pmn_file.pmn20,   #採購量
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                     rvb02     LIKE    rvb_file.rvb02,   #項次
                     rva06     LIKE    rva_file.rva06,   #收料日
                     rvb07     LIKE    rvb_file.rvb07,   #已交量 rvb07-rvb29
                     rvb19     LIKE    rvb_file.rvb19,   #交貨狀況
                     rvb35     LIKE    rvb_file.rvb35,   #樣品否 #No:8328
                     pmn041    LIKE    pmn_file.pmn041,  #品名規格
                     ima021    LIKE    ima_file.ima021
                     END RECORD,
          sr3        DYNAMIC ARRAY OF RECORD #TQC-740345
                     rvb01 LIKE rvb_file.rvb01, #TQC-740345
                     rvb02 LIKE rvb_file.rvb02, #TQC-740345
                     rva06 LIKE rva_file.rva06, #TQC-740345
                     rvb07 LIKE rvb_file.rvb07, #TQC-740345
                     rvb19 LIKE rvb_file.rvb19, #TQC-740345
                     rvb35 LIKE rvb_file.rvb35  #TQC-740345
                     END RECORD 
          DEFINE  l_rvb01 LIKE rvb_file.rvb01 #TQC-740345
          DEFINE  l_rvb02 LIKE rvb_file.rvb02 #TQC-740345
          DEFINE  l_rva06 LIKE rva_file.rva06 #TQC-740345
          DEFINE  l_rvb07 LIKE rvb_file.rvb07 #TQC-740345
          DEFINE  l_rvb19 LIKE rvb_file.rvb19 #TQC-740345
          DEFINE  l_rvb35 LIKE rvb_file.rvb35 #TQC-740345
          DEFINE  l_pmn01 LIKE pmn_file.pmn01 #TQC-740345
          DEFINE  l_pmn02 LIKE pmn_file.pmn02 #TQC-740345
          DEFINE  l_qty1,l_qty2 LIKE rvb_file.rvb07   #FUN-8A0024
  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
#No.FUN-750101  --begin--
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
{
     FOR g_i = 1 TO 3
        CASE
           WHEN tm.s[g_i,g_i]='1'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[17]
           WHEN tm.s[g_i,g_i]='2'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[18]
           WHEN tm.s[g_i,g_i]='3'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[19]
           WHEN tm.s[g_i,g_i]='4'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[20]
           WHEN tm.s[g_i,g_i]='5'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[21]
        END CASE
     END FOR
}
#No.FUN-750101  --end--
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
    #TQC-740345...............begin
    #LET l_sql = " SELECT '','','',",
    #            " pmm01,pmm12,pmm13,gen02,pmm25,pmn02,pmm04,pmm09,",
    #            " pmc03,pmn04,pmn20,pmn33,",
    #            " rvb01,rvb02,rva06,(rvb07-rvb29),rvb19,rvb35,pmn041,ima021 ", #No:8328 add rvb35
    #            " FROM pmm_file, OUTER pmc_file, OUTER gen_file,pmn_file,",
    #            " OUTER (rva_file,rvb_file),",
    #            " OUTER ima_file ",
    #            " WHERE  pmm01 = pmn01 ",
    #            " AND pmn01 = rvb_file.rvb04",
    #            " AND pmn02 = rvb_file.rvb03 AND rva_file.rva01 = rvb_file.rvb01",
    #            " AND pmm12 = gen_file.gen01 AND pmm09 = pmc_file.pmc01",
    #            " AND pmm18 <> 'X' AND ",tm.wc CLIPPED,
    #            " AND pmn04 = ima_file.ima01",
    #            " ORDER BY rvb01,rvb02"
     LET l_sql = " SELECT '','','',",
                 " pmm01,pmm12,pmm13,gen02,pmm25,pmn02,pmm04,pmm09,",
                 " pmc03,pmn04,pmn20,pmn33,",
               " '','','','','','',pmn041,ima021,pmn01,pmn02 ",
               " FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm09 = pmc01 ",
	       " LEFT OUTER JOIN gen_file ON pmm12 = gen01, ",
	       " pmn_file LEFT OUTER JOIN ima_file ON  pmn04 = ima01 ",
	       " WHERE  pmm01 = pmn01 ",
               " AND pmm18 <> 'X' AND ",tm.wc CLIPPED
    #TQC-740345...............end
 
     #TQC-740345...............begin
     PREPARE r506_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r506_c1 CURSOR FOR r506_p1
     LET l_i=1
     FOREACH r506_c1 INTO sr2[l_i].*,l_pmn01,l_pmn02
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        #-----FUN-8A0024---------
        IF tm.a = 'N' OR cl_null(tm.a) THEN 
           LET l_qty1=0
           LET l_qty2=0
           SELECT SUM(rvb07-rvb29) INTO l_qty1
             FROM rva_file, rvb_file
            WHERE rva01=rvb01
              AND rvb04=l_pmn01
              AND rvb03=l_pmn02
              AND rvaconf <> 'X'  
           SELECT SUM(pmn20) INTO l_qty2
             FROM pmn_file
            WHERE pmn01=l_pmn01
              AND pmn02=l_pmn02   
           IF l_qty2 - l_qty1 <= 0 THEN 
              CONTINUE FOREACH
           END IF
        END IF
        #-----END FUN-8A0024-----
        LET sr2[l_i].rvb01=NULL
        LET sr2[l_i].rvb02=NULL
        LET sr2[l_i].rva06=NULL
        LET sr2[l_i].rvb07=NULL
        LET sr2[l_i].rvb19=NULL
        LET sr2[l_i].rvb35=NULL
        LET l_j=0
        DECLARE r506_c2 CURSOR FOR
                             SELECT rvb01,rvb02,rva06,(rvb07-rvb29),rvb19,rvb35
                               FROM rva_file, rvb_file
                              WHERE rva01=rvb01
                                AND rvb04=l_pmn01
                                AND rvb03=l_pmn02
                                AND rvaconf <> 'X'  #MOD-8A0025
        FOREACH r506_c2 INTO l_rvb01,l_rvb02,l_rva06,
                             l_rvb07,l_rvb19,l_rvb35
           LET l_j=l_j+1
           LET sr3[l_j].rvb01=l_rvb01
           LET sr3[l_j].rvb02=l_rvb02
           LET sr3[l_j].rva06=l_rva06
           LET sr3[l_j].rvb07=l_rvb07
           LET sr3[l_j].rvb19=l_rvb19
           LET sr3[l_j].rvb35=l_rvb35
        END FOREACH
        FOR l_k=1 TO l_j 
           LET sr2[l_i].rvb01=sr3[l_k].rvb01
           LET sr2[l_i].rvb02=sr3[l_k].rvb02
           LET sr2[l_i].rva06=sr3[l_k].rva06
           LET sr2[l_i].rvb07=sr3[l_k].rvb07
           LET sr2[l_i].rvb19=sr3[l_k].rvb19
           LET sr2[l_i].rvb35=sr3[l_k].rvb35
           IF l_k<l_j THEN
              LET l_i=l_i+1
              LET sr2[l_i].*=sr2[l_i-1].*
           END IF
        END FOR
        LET l_i=l_i+1
     END FOREACH
     CALL sr2.deleteElement(l_i)
     #TQC-740345...............end
 
     #CALL cl_outnam('apmr506') RETURNING l_name  #No.FUN-750101
     #START REPORT r506_rep TO l_name              #No.FUN-750101
 
     LET g_pageno = 0
     INITIALIZE sr.* TO NULL #TQC-740345
    #FOREACH r506_c1 INTO sr.* #TQC-740345
     FOR l_j=1 TO sr2.getlength() #TQC-740345
       LET sr.*=sr2[l_j].*  #TQC-740345
       IF sr.rvb19 ='2' THEN CONTINUE FOR END IF
#No.FUN-750101  --begin--
{
       FOR l_i = 1 TO 3
          CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.pmm01
               WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.pmm04 USING 'YYYYMMDD'
               WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.pmm12
               WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.pmm13
               WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.pmn04
               OTHERWISE LET l_order[l_i] = '-'
          END CASE
       END FOR
       IF sr.order1 IS NULL THEN LET sr.order1 = ' ' END IF
       IF sr.order2 IS NULL THEN LET sr.order2 = ' ' END IF
       IF sr.order3 IS NULL THEN LET sr.order3 = ' ' END IF
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT r506_rep(sr.*)
    #END FOREACH
}
#No.FUN-750101  --END--
       EXECUTE  insert_prep USING
                         sr.pmm01,sr.pmm12,sr.pmm13,sr.gen02,sr.pmm25,
                         sr.pmn02,sr.pmm04,sr.pmm09,sr.pmc03,sr.pmn04,
                         sr.pmn20,sr.pmn33,sr.pmn041,sr.ima021,'',sr.rvb01,
                         sr.rvb02,sr.rva06,sr.rvb07,'',sr.rvb19,sr.rvb35
     END FOR
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str=''
     #是否打印選擇條件
     IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm12,pmm13,pmn04,pmn16')
            RETURNING tm.wc
       LET g_str=tm.wc
     END IF
     LET g_str=g_str,';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',tm.t
     CALL cl_prt_cs3('apmr506','apmr506',l_sql,g_str)                              
 
    # FINISH REPORT r506_rep                      #No.FUN-750101
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-750101
 
#No.FUN-750101  --END --
END FUNCTION
 
#No.FUN-750101  --BEGIN--
{
REPORT r506_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_sw          LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_pmn20_u     LIKE pmn_file.pmn20,         #末交量
          b_date        LIKE pmm_file.pmm04,
          e_date        LIKE pmm_file.pmm04,
         #l_sql         LIKE type_file.chr1000,      #TQC-630166 mark  #No.FUN-680136
          l_sql         STRING,      #TQC-630166
          sr            RECORD
                         order1    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                         order2    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                         order3    LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
                         pmm01     LIKE    pmm_file.pmm01,   #採購單號
                         pmm12     LIKE    pmm_file.pmm12,   #採購員
                         pmm13     LIKE    pmm_file.pmm13,   #採購部門
                         gen02     LIKE    gen_file.gen02,   #姓名
                         pmm25     LIKE    pmm_file.pmm25,   #狀況碼
                         pmn02     LIKE    pmn_file.pmn02,   #項次
                         pmm04     LIKE    pmm_file.pmm04,   #採購日期
                         pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                         pmc03     LIKE    pmc_file.pmc03,   #簡稱
                         pmn04     LIKE    pmn_file.pmn04,   #料件編號
                         pmn20     LIKE    pmn_file.pmn20,   #採購量
                         pmn33     LIKE    pmn_file.pmn33,   #交貨日
                         rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                         rvb02     LIKE    rvb_file.rvb02,   #項次
                         rva06     LIKE    rva_file.rva06,   #收料日
                         rvb07     LIKE    rvb_file.rvb07,   #已交量 rvb07-rvb29
                         rvb19     LIKE    rvb_file.rvb19,   #收貨狀況
                         rvb35     LIKE    rvb_file.rvb35,   #樣品否 #No:8328
                         pmn041    LIKE    pmn_file.pmn041,  #品名規格
                         ima021    LIKE    ima_file.ima021
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.order1,sr.order2,sr.order3,sr.pmm01,sr.pmn02,sr.rvb01,sr.rvb02 #8328
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34]
      PRINTX name=H2 g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
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
 
   BEFORE GROUP OF sr.pmm01
      PRINTX name=D1 COLUMN g_c[31],sr.pmm01,
                     COLUMN g_c[32],sr.pmm12,
                     COLUMN g_c[33],sr.pmm09,
                     COLUMN g_c[34],sr.pmm25
      PRINTX name=D2 COLUMN g_c[35],sr.pmm04,
                     COLUMN g_c[36],sr.gen02,
                     COLUMN g_c[37],sr.pmc03;
   BEFORE GROUP OF sr.pmn02    #項次
      LET l_pmn20_u = sr.pmn20
      PRINTX name=D2 COLUMN g_c[38],sr.pmn02 USING '####',
                     COLUMN g_c[39],sr.pmn04,
                     COLUMN g_c[40],cl_numfor(sr.pmn20,40,3),
                     COLUMN g_c[41],sr.pmn33
      PRINTX name=D2 COLUMN g_c[39],sr.pmn041
      PRINTX name=D2 COLUMN g_c[39],sr.ima021
 
   ON EVERY ROW
      IF sr.rvb01 IS NOT NULL THEN
         #No:8328
         IF sr.rvb35 = 'Y' THEN
             PRINTX name=D2 COLUMN g_c[40],g_x[23] CLIPPED;
         ELSE
             LET l_pmn20_u = l_pmn20_u - sr.rvb07  #計算未交量
         END IF
         #No:8328(end)
         PRINTX name=D2 COLUMN g_c[42],sr.rvb01,
                        COLUMN g_c[43],sr.rvb02 USING '#######&',
                        COLUMN g_c[44],sr.rva06,
                        COLUMN g_c[45],cl_numfor(sr.rvb07,45,3),
                        COLUMN g_c[46],cl_numfor(l_pmn20_u,46,3)
      ELSE
         PRINT
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
             #TQC-630166
             #IF tm.wc[001,120] > ' ' THEN			# for 132
 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
             #IF tm.wc[121,240] > ' ' THEN
 	     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
             #IF tm.wc[241,300] > ' ' THEN
    	     #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750101   --END--
