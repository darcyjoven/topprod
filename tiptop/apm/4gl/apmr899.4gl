# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr899.4gl
# Desc/riptions...: 驗收清單
# Input parameter:
# Return code....:
# Date & Author..: 93/03/30 By yen
# Modify.........: No.FUN-4C0095 04/12/29 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580004 05/08/03 By day 報表加雙單位參數
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.MOD-640341 06/04/10 by YITING 沒有印小計
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0096 06/11/17 By Ray 結束位置有誤
# Modify.........: No.FUN-7C0034 07/12/29 By dxfwo  報表輸出至Crystal Reports功能
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程 
# Modify.........: No.FUN-8A0101 09/02/20 by dxfwo CR追單時發現程序bug修改bug
# Modify.........: No.TQC-960146 09/06/23 By liuxqa 增加取g_zz05的值.
# Modify.........: No.TQC-960447 09/07/01 By lilingyu "條件選項"的"檢驗狀態"的選擇資料的篩選有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No:CHI-B10045 11/01/26 By Smapmin MISC的料件不做ima_file的檢核
# Modify.........: No:MOD-BA0046 11/10/07 By Summer JIT收貨的品名與單位沒有印出來
# Modify.........: No.FUN-BA0053 11/10/31 By Sakura 加入取jit收貨資料
# Modify.........: No:MOD-C30080 12/03/08 By Summer 將UNION改成UNION ALL 
# Modify.........: No:TQC-C80044 12/08/07 By zhuhao QBE的收貨單號、廠商編號、採購單號請增加開窗功能

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5   	#No.FUN-680136 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD                      # Print condition RECORD
        wc      STRING,                   # Where condition   #TQC-630166
        s       LIKE type_file.chr3,      # Order by sequence #No.FUN-680136 VARCHAR(3)
        t       LIKE type_file.chr3,      # Eject sw 	      #No.FUN-680136 VARCHAR(3)
        u       LIKE type_file.chr3,      # Group total sw    #No.FUN-680136 VARCHAR(3)
        exm     LIKE type_file.chr1,   	  # No.FUN-680136 VARCHAR(1)
        d       LIKE type_file.chr1,      # No.FUN-680136 VARCHAR(1)
        more    LIKE type_file.chr1       # Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1)
      END RECORD,
          l_pmh08        LIKE pmh_file.pmh08,
          l_total1       LIKE tlf_file.tlf18, 	#No.FUN-680136 DECIMAL(13,3)
          g_orderA       ARRAY[3] OF LIKE ima_file.ima01   #排序名稱 #FUN-5B0105 08->40	#No.FUN-680136 VARCHAR(40)
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115   #No.FUN-580004
DEFINE   l_table         STRING                          #No.FUN-7C0034                                                             
DEFINE   g_sql           STRING                          #No.FUN-7C0034                                                             
DEFINE   g_str           STRING                          #No.FUN-7C0034
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = " l_str.type_file.chr1000,",
               " rva01.rva_file.rva01,",
               " rva06.rva_file.rva06,",
               " rva05.rva_file.rva05,",
               " pmc03.pmc_file.pmc03,",
               " rvb05.rvb_file.rvb05,",
               " pmn041.pmn_file.pmn041,",
               " l_ima021.ima_file.ima021,",
               " l_str2.type_file.chr1000,",
               " rvb07.rvb_file.rvb07,",
               " pmn07.pmn_file.pmn07,",
               " rvb04.rvb_file.rvb04,",
               " rvb03.rvb_file.rvb03 "
   LET l_table = cl_prt_temptable('apmr899',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.exm= ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r899_tm(0,0)        # Input print condition
      ELSE CALL apmr899()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r899_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_cmd       LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW r899_w AT p_row,p_col WITH FORM "apm/42f/apmr899"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.exm  = '3'
   LET tm.d    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rva01,rva06,rva05,rvb04,rvb05
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLP
            IF INFIELD(rvb05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
            END IF
          #TQC-C80044 -- add -- begin
            IF INFIELD(rva01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rvall03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva01
               NEXT FIELD rva01
            END IF
            IF INFIELD(rva05) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva05
               NEXT FIELD rva05
            END IF
            IF INFIELD(rvb04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmm1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb04
               NEXT FIELD rvb04
            END IF
          #TQC-C80044 -- add -- end
 
     ON ACTION locale
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r899_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                tm.exm,tm.d,tm.more
                WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r899_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr899'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr899','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.exm CLIPPED,"'",
                         " '",tm.d  CLIPPED,"'"   ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr899',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r899_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr899()
   ERROR ""
END WHILE
   CLOSE WINDOW r899_w
END FUNCTION
 
FUNCTION apmr899()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name           #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,       # Used time for running the job      #No.FUN-680136 VARCHAR(8)
          l_sql     STRING,                    # RDSQL STATEMENT   #TQC-630166
          l_ima021  LIKE ima_file.ima021,
          l_str     LIKE type_file.chr1000,
          l_str2    LIKE type_file.chr1000,              
          l_ima906  LIKE ima_file.ima906,
          l_rvb85   STRING,
          l_rvb82   STRING,
          l_chr     LIKE type_file.chr1,       # No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    # No.FUN-680136 VARCHAR(40)
          l_pmm22    LIKE pmm_file.pmm22,
          l_order    ARRAY[6] OF LIKE ima_file.ima01, #FUN-550060 #FUN-5B0105 16->40 	#No.FUN-680136 VARCHAR(40)
          sr               RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 16->40 	#No.FUN-680136 VARCHAR(40)
                                  order2 LIKE ima_file.ima01, #FUN-5B0105 16->40 	#No.FUN-680136 VARCHAR(40)
                                  order3 LIKE ima_file.ima01, #FUN-5B0105 16->40 	#No.FUN-680136 VARCHAR(40)
                                  rva01  LIKE rva_file.rva01,   #
                                  rva06  LIKE rva_file.rva06,   #
                                  rva05  LIKE rva_file.rva05,   #
                                  pmc03  LIKE pmc_file.pmc03,   #
                                  rvb05  LIKE rvb_file.rvb05,   #
                                  pmn041 LIKE alg_file.alg021,  #No.FUN-680136 VARCHAR(30)
                                  rvb07  LIKE rvb_file.rvb07,   #
                                  pmn07  LIKE apo_file.apo02,   #No.FUN-680136 VARCHAR(4)
                                  rvb04  LIKE rvb_file.rvb04,
                                  rvb03 LIKE rvb_file.rvb03,
                                  rvb80 LIKE rvb_file.rvb80,
                                  rvb82 LIKE rvb_file.rvb82,
                                  rvb83 LIKE rvb_file.rvb83,
                                  rvb85 LIKE rvb_file.rvb85
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5              #No.FUN-580004  #No.FUN-680136 SMALLINT 
     DEFINE i                  LIKE type_file.num5              #No.FUN-580004  #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02              #No.FUN-580004
     DEFINE l_pmm02            LIKE pmm_file.pmm02,             #No.CHI-8C0017
            l_pmn18            LIKE pmn_file.pmn18,             #No.CHI-8C0017  
            l_pmn41            LIKE pmn_file.pmn41,             #No.CHI-8C0017
            l_pmn43            LIKE pmn_file.pmn43,             #No.CHI-8C0017
            l_pmh21            LIKE pmh_file.pmh21,             #No.CHI-8C0017
            l_pmh22            LIKE pmh_file.pmh22              #No.CHI-8C0017     
     DEFINE l_pmn012           LIKE pmn_file.pmn012             #No.FUN-A60027
     DEFINE l_ima24            LIKE ima_file.ima24              #CHI-B10045
     DEFINE l_rvb051           LIKE rvb_file.rvb051             #MOD-BA0046 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115 INTO g_sma115 FROM sma_file  #No.FUN-580004
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.TQC-960146 add
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')

    #No.FUN-BA0053---Begin---mark     
    # LET l_sql = "SELECT '','','',",
    #            #"    rva01,rva06,rva05,pmc03,rvb05,pmn041,rvb07,pmn07,", #MOD-BA0046 mark
    #             "    rva01,rva06,rva05,pmc03,rvb05,pmn041,rvb07,rvb90,", #MOD-BA0046
    #             "    rvb04,rvb03,rvb80,rvb82,rvb83,rvb85,pmn18,pmn41,pmn43,pmn012", #No.FUN-580004    #CHI-8C0017 Add pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
    #             "    ,rvb051", #MOD-BA0046 add 
    #             #" FROM rva_file,rvb_file,ima_file,",   #CHI-B10045
    #             " FROM rva_file,rvb_file,",   #CHI-B10045
    #             "               OUTER pmn_file, OUTER pmc_file",
    #             " WHERE rva01=rvb01 AND rvb_file.rvb04=pmn_file.pmn01 AND rvb_file.rvb03=pmn_file.pmn02",
    #             "   AND rva_file.rva05=pmc_file.pmc01",
    #             #"   AND rvb05=ima01",   #CHI-B10045
    #             "   AND rvaconf !='X' ",
    #             "   AND ",tm.wc CLIPPED
    #No.FUN-BA0053---End-----mark

    #No.FUN-BA0053---Begin---add
     LET l_sql = "SELECT '','','',",
                 "    rva01,rva06,rva05,pmc03,rvb05,pmn041,rvb07,pmn07,",
                 "    rvb04,rvb03,rvb80,rvb82,rvb83,rvb85,pmn18,pmn41,pmn43,pmn012",
                 " FROM rva_file ",
                 "   LEFT OUTER JOIN pmc_file ON rva_file.rva05=pmc_file.pmc01 ",
                 "   ,rvb_file",
                 "   LEFT OUTER JOIN pmn_file ON rvb_file.rvb04=pmn_file.pmn01 ",
                 "   AND rvb_file.rvb03=pmn_file.pmn02 ",
                 " WHERE rvaconf !='X' ",
                 "   AND rva_file.rva01 = rvb_file.rvb01 ",
                 "   AND rva00 ='1' ",                 
                 "   AND ",tm.wc CLIPPED
    #No.FUN-BA0053---End-----add                 
{-----改判斷料供應商檔
     #-----CHI-B10045---------
     #IF tm.exm = '1' THEN
     #   LET l_sql = l_sql CLIPPED," AND ima24 IS NOT NULL"
     #END IF
     #IF tm.exm = '2' THEN
     #   LET l_sql = l_sql CLIPPED," AND ima24 IS NULL"
     #END IF
     #-----END CHI-B10045-----
---------------}
     IF tm.d='1' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.d='2' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF

     #No.FUN-BA0053---Begin---add
     LET l_sql = l_sql," UNION ALL ", #MOD-C30080 add ALL
                  "SELECT '','','',",
                  "    rva01,rva06,rva05,pmc03,rvb05,rvb051,rvb07,rvb90,",
                  "    rvb04,rvb03,rvb80,rvb82,rvb83,rvb85,'','',null,'' ", 
                  " FROM rva_file",
                  "   LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01",
                  "   ,rvb_file",
                  " WHERE rvaconf !='X' ",
                  "   AND rva_file.rva01 = rvb_file.rvb01",
                  "   AND rva00 ='2' ",
                  "   AND ",tm.wc CLIPPED
     IF tm.d='1' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.d='2' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF
     #No.FUN-BA0053---End-----add     

     PREPARE r899_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r899_cs1 CURSOR FOR r899_prepare1
     IF STATUS != 0 THEN CALL cl_err('declare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     LET l_name = 'apmr899.out'
     IF g_sma115 = "Y"  THEN  #是否顯示單位注解
            LET g_zaa[45].zaa06 = "N"
     ELSE
            LET g_zaa[45].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
     CALL cl_del_data(l_table) 
     LET  l_total1 = 0
    #FOREACH r899_cs1 INTO sr.*,l_pmn18,l_pmn41,l_pmn43,l_pmn012  #CHI-8C0017 Add l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012 #MOD-BA0046 mark
     FOREACH r899_cs1 INTO sr.*,l_pmn18,l_pmn41,l_pmn43,l_pmn012,l_rvb051  #MOD-BA0046
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF

      #-----CHI-B10045---------
      IF sr.rvb05[1,4] <> 'MISC' THEN
         LET l_ima24 = ''
         SELECT ima24 INTO l_ima24 FROM ima_file
           WHERE ima01 = sr.rvb05
         IF STATUS THEN
            CONTINUE FOREACH
         END IF
         IF tm.exm = '1' AND (l_ima24 = 'N' OR l_ima24 IS NULL) THEN
            CONTINUE FOREACH
         END IF
         IF tm.exm = '2' AND l_ima24 = 'Y' THEN 
            CONTINUE FOREACH
         END IF
      END IF
      #-----END CHI-B10045-----

      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.rvb05
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.rvb05
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
                LET l_str2 = l_rvb85 , sr.rvb83  CLIPPED
                IF cl_null(sr.rvb85) OR sr.rvb85  = 0 THEN
                    CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
                    LET l_str2 = l_rvb82,sr.rvb80  CLIPPED
                ELSE
                   IF NOT cl_null(sr.rvb82) AND sr.rvb82 > 0 THEN
                      CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
                      LET l_str2 = l_str2 CLIPPED,',',l_rvb82,sr.rvb80  CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.rvb85) AND sr.rvb85 > 0 THEN
                    CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
                    LET l_str2 = l_rvb85  , sr.rvb83  CLIPPED
                END IF
         END CASE
      ELSE
      END IF
       IF tm.exm = '1' OR tm.exm='2' THEN
          SELECT pmm22,pmm02 INTO l_pmm22,l_pmm02 FROM pmm_file            #CHI-8C0017 Add pmm02
            WHERE pmm01=sr.rvb04  #TQC-960447            
          IF l_pmm02='SUB' THEN
             LET l_pmh22='2'
             IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
                LET l_pmh21 =' '
             ELSE
               IF NOT cl_null(l_pmn18) THEN
                SELECT sgm04 INTO l_pmh21 FROM sgm_file
                 WHERE sgm01=l_pmn18
                   AND sgm02=l_pmn41
                   AND sgm03=l_pmn43
                   AND sgm012 = l_pmn012  #FUN-A60076
               ELSE
                SELECT ecm04 INTO l_pmh21 FROM ecm_file 
                 WHERE ecm01=l_pmn41
                   AND ecm03=l_pmn43
                   AND ecm012 = l_pmn012  #FUN-A60027 
               END IF
             END IF     #NO.TQC-910033  
          ELSE
             LET l_pmh22='1'
             LET l_pmh21=' '
          END IF
          SELECT pmh08 INTO l_pmh08 FROM pmh_file
           WHERE pmh01=sr.rvb05 AND pmh02=sr.rva05 AND pmh13=l_pmm22
             AND pmh21 = l_pmh21                                                      #CHI-8C0017
             AND pmh22 = l_pmh22                                                      #CHI-8C0017
             AND pmh23 = ' '                                             #No.CHI-960033
             AND pmhacti = 'Y'                                           #CHI-910021             
           IF cl_null(l_pmh08) THEN CONTINUE FOREACH END IF            #TQC-960447     
           IF tm.exm='1' AND l_pmh08='N' THEN CONTINUE FOREACH END IF  #TQC-960447
           IF tm.exm='2' AND l_pmh08='Y' THEN CONTINUE FOREACH END IF  #TQC-960447
       END IF
       IF cl_null(sr.rvb04) THEN LET sr.pmn041 = l_rvb051 END IF #MOD-BA0046 add 
       EXECUTE insert_prep USING l_str,sr.rva01,sr.rva06,sr.rva05,
                                 sr.pmc03,sr.rvb05,sr.pmn041,l_ima021,l_str2,sr.rvb07,sr.pmn07,
                                 sr.rvb04,sr.rvb03
     END FOREACH
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'rva01,rva06,rva05,rvb04,rvb05')         
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF
   LET g_str = tm.wc,";",tm.t,";",g_sma115,";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
               tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.exm
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
   CALL cl_prt_cs3('apmr899','apmr899',l_sql,g_str)   
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
