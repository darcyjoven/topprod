# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: apmx220.4gl
# Descriptions...: 供應商ABC分析表
# Input parameter:
# Return code....:
# Date & Author..: 94/07/08 By DANNY
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增供應廠商編號開窗
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy DEFINE 匯率用LIKE的方式
# Modify.........: No.FUN-4C0095 04/12/22 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-590026 05/10/16 By pengu  程式段有CREATE TEMP TABLE，但未給予Index可能
                                          #         會照成程式在SELECT資料的時間
# Modify.........: NO.TQC-5B0037 05/11/07 By Rosayu 修改報表結尾定位點
# Modify.........: No.MOD-5A0453 05/11/21 By Nicola 小計有小數點誤差
# Modify.........: No.TQC-5B0101 05/11/21 By Nicola 金額無值給零
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-720010 07/02/06 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.MOD-720060 07/03/16 By pengu 未用計價數量去計算相關金額
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.MOD-920209 09/02/17 By Smapmin 重新過單
# Modify.........: No.TQC-940182 09/04/30 By sherry l_tot4,l_tot5,l_tot6計算前賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:CHI-A80003 10/08/25 By Summer 調整"報表單價*數量取位後的結果相加總"與"總金額欄位"數值不同
# Modify.........: No.FUN-BA0053 11/10/31 By Sakura 加入取jit收貨資料
# Modify.........: No.TQC-BC0142 12/01/13 By SunLM 更改chr1000-->STRING
# Modify.........: No.FUN-CB0001 12/11/01 By yangtt CR轉XtraGrid
# Modify.........: No.FUN-D40128 13/05/07 By wangrr 報表增加"類型說明"欄位 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                   # Print condition RECORD
        #        wc      VARCHAR(500),                    # Where condition
                 wc      STRING,                       #TQC-630166 # Where condition
                 b_date  LIKE type_file.dat,           #No.FUN-680136 DATE      #交貨期間
                 e_date  LIKE type_file.dat,           #No.FUN-680136 DATE
                 a       LIKE type_file.num5,          #No.FUN-680136 SMALLINT  #A級比率
                 b       LIKE type_file.num5,          #No.FUN-680136 SMALLINT  #B級比率
                 c       LIKE type_file.num5,          #No.FUN-680136 SMALLINT  #C級比率
                 s       LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)   #更新主檔(Y/N)
                 t       LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
                 more    LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD,
          l_cd    LIKE ima_file.ima01,          #No.FUN-680136 VARCHAR(40)
          l_tot1  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #交貨金額合計 #MOD-530190
          l_tot2  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #入庫金額合計 #MOD-530190
          l_tot3  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #退貨金額合計 #MOD-530190
          l_tot4  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #交貨金額小計 #MOD-530190
          l_tot5  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #入庫金額小計 #MOD-530190
          l_tot6  LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)  #退貨金額小計 #MOD-530190
          l_tot7  LIKE type_file.num5,          #No.FUN-680136 SMALLINT       #筆數
          l_i       LIKE type_file.num5,        #No.FUN-680136 SMALLINT       #排名     
          g_tot_bal LIKE tlf_file.tlf18         #No.FUN-680136 DECIMAL(13,3)  # User defined variable
DEFINE    g_i       LIKE type_file.num5         #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE l_table     STRING                       ### FUN-720010 add ###
DEFINE g_sql       STRING                       ### FUN-720010 add ###
DEFINE g_str       STRING                       ### FUN-720010 add ###
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #str FUN-720010 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720010 *** ##
   LET g_sql =   "rva05.rva_file.rva05,",
                 "pmc03.pmc_file.pmc03,",
                 "pmc02.pmc_file.pmc02,",
                 "pmy02.pmy_file.pmy02,", #FUN-D40128
                 "sr01.oeb_file.oeb14,",       #No.FUN-680136 DECIMAL(20,6)
                 "sr02.oeb_file.oeb14,",       #No.FUN-680136 DECIMAL(20,6)
                 "sr03.oeb_file.oeb14,",       #No.FUN-680136 DECIMAL(20,6)
                 "sr04.type_file.chr1,",       #No.FUN-680136 VARCHAR(1)
                 "sr05.type_file.num5,",       #No.FUN-680136 SMALLINT
                 "l_num.type_file.num5,",      #FUN-CB0001 add
                 "g_azi04.type_file.num5"        #FUN-CB0001 add
 
   LET l_table = cl_prt_temptable('apmx220',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"   #FUN-CB0001 add 2? #FUN-D40128 add 1?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720010 add
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
#-------------No.TQC-610085 modify
   LET tm.t  = ARG_VAL(9)
   LET tm.b_date=ARG_VAL(10)
   LET tm.e_date=ARG_VAL(11)
   LET tm.a  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)
   LET tm.c  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------No.TQC-610085 end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL apmx220_tm(0,0)
   ELSE
      CALL apmx220()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmx220_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW apmx220_w AT p_row,p_col WITH FORM "apm/42f/apmx220"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                 # Default condition
   LET tm.a    = 30
   LET tm.b    = 30
   LET tm.c    = 40
   LET tm.s    = '1'
   LET tm.t    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   DROP TABLE tmp_file
    CREATE TEMP TABLE tmp_file(                                                                                                       
       tmp01   LIKE rva_file.rva05,
       tmp02   LIKE pmc_file.pmc03,                                                                        
       tmp03   LIKE pmc_file.pmc02,                                                                                  
       tmp04   LIKE oeb_file.oeb14,                                                                   
       tmp05   LIKE oeb_file.oeb14,                                                                     
       tmp06   LIKE oeb_file.oeb14)                                                                           
#No.FUN-680136--end
   CREATE INDEX tmp_01 ON tmp_file (tmp01)    #No.FUN-590026
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pmc01,pmc02
 
         #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmc01)      #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmc"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  NEXT FIELD pmc01
               WHEN INFIELD(pmc02)      #廠商分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmc02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc02
                  NEXT FIELD pmc02
               OTHERWISE
                  EXIT CASE
            END CASE
         #--END---------------
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW apmx220_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.more         # Condition
 
      INPUT BY NAME tm.b_date,tm.e_date,tm.a,tm.b,tm.c,tm.s,tm.t,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD b_date
            IF cl_null(tm.b_date) THEN
               NEXT FIELD b_date
            END IF
 
         AFTER FIELD e_date
            IF cl_null(tm.e_date) OR tm.e_date < tm.b_date THEN
               NEXT FIELD e_date
            END IF
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a > 100 THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.a+tm.b > 100 THEN
               NEXT FIELD b
            ELSE
               LET tm.c = 100 - (tm.a + tm.b)
               DISPLAY tm.c to c
            END IF
 
         AFTER FIELD s
            IF tm.s NOT MATCHES '[1,2]' OR tm.s IS NULL THEN
               NEXT FIELD tm.s
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET tm.c = 100 - (tm.a + tm.b)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW apmx220_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='apmx220'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmx220','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.b_date CLIPPED,"'",
                        " '",tm.e_date CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('apmx220',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW apmx220_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL apmx220()
 
      ERROR ""
 
      DELETE FROM tmp_file
 
   END WHILE
 
   CLOSE WINDOW apmx220_w
 
END FUNCTION
 
FUNCTION apmx220()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,       # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000) #TQC-BC0142 mark
          l_sql     STRING,                    #TQC-BC0142  add
          l_chr     LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(40)
          l_rva05   LIKE rva_file.rva05,       #No.FUN-680136 VARCHAR(10)
          l_pmc03   LIKE pmc_file.pmc03,       #FUN-560011
          l_pmc02   LIKE pmc_file.pmc02,       #No.FUN-680136 VARCHAR(4)
          l_pmm42   LIKE pmm_file.pmm42,       #FUN-4B0051
          l_rva06   LIKE type_file.dat,        #No.FUN-680136 DATE
          l_rvb07   LIKE rvb_file.rvb07,       #MOD-530190
          l_rvb10   LIKE rvb_file.rvb10,       #MOD-530190
          l_rvb29   LIKE rvb_file.rvb29,       #MOD-530190
          l_rvb30   LIKE rvb_file.rvb30,       #MOD-530190
         #---------------No.MOD-720060 modify
          l_rvb05   LIKE rvb_file.rvb05, 
          l_rvb86   LIKE rvb_file.rvb86, 
          l_rvb87   LIKE rvb_file.rvb87, 
          l_pmn07   LIKE pmn_file.pmn07, 
          l_ima44   LIKE ima_file.ima44, 
          l_ima25   LIKE ima_file.ima25, 
          l_factor1 LIKE pmn_file.pmn09,
          l_factor2 LIKE pmn_file.pmn09,
          l_cnt     LIKE type_file.num10,
         #---------------No.MOD-720060 end
          sr        RECORD 
                       rva05 LIKE rva_file.rva05,       #Vendor
                       pmc03 LIKE pmc_file.pmc03,       #Abbr
                       pmc02 LIKE pmc_file.pmc02,       #Class
                       sr01  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6) #交貨金額 #MOD-530190
                       sr02  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6) #入庫金額 #MOD-530190
                       sr03  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6) #退貨金額 #MOD-530190
                       sr04  LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)       #等級
                       sr05  LIKE type_file.num5        #No.FUN-680136 SMALLINT      #排名
                    END RECORD,
          l_a       LIKE type_file.num5,          #No.FUN-680136 SMALLINT  #A級
          l_b       LIKE type_file.num5,          #No.FUN-680136 SMALLINT  #B級
          l_c       LIKE type_file.num5           #No.FUN-680136 SMALLINT  #C級
   DEFINE l_num     LIKE type_file.num5           #FUN-CB0001 add
   DEFINE l_pmy02   LIKE pmy_file.pmy02  #FUN-D40128
 
   #str FUN-720010 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720010 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
 
#No.CHI-6A0004-------Begin------------------
#   SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#    WHERE azi01 = g_aza.aza17
#No.CHI-6A0004-------End------------------    
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
   #End:FUN-980030

##No.FUN-BA0053---Begin---mark
##----------------------------No.MOD-720060 modify
#  #LET l_sql = "SELECT rva05,pmc03,pmc02,rva06,rvb10,rvb07,",
#  #            "       rvb30,rvb29,pmm42",
#  #            "  FROM rva_file,rvb_file,pmm_file, OUTER pmc_file ", #FUN-720010
#  #            " WHERE rva_file.rva05=pmc_file.pmc01 AND rva01=rvb01 AND rvaconf='Y' ",
#  #            "   AND rva06 between '",tm.b_date,"' AND '",tm.e_date,"'",
#  #            "   AND rvb04 = pmm01 AND pmm18 <> 'X'",
#  #            "   AND ",tm.wc CLIPPED
#   LET l_sql = "SELECT rva05,pmc03,pmc02,rva06,rvb10,rvb07,",
#               "       rvb30,rvb29,rvb05,rvb86,rvb87,pmm42,pmn07 ",
#               "  FROM rva_file,rvb_file,pmm_file,pmn_file,OUTER pmc_file ",
#               " WHERE rva_file.rva05=pmc_file.pmc01 AND rva01=rvb01 AND rvaconf='Y' ",
#               "   AND rva06 between '",tm.b_date,"' AND '",tm.e_date,"'",
#               "   AND rvb04 = pmm01 AND pmm18 <> 'X'",
#               "   AND rvb04 = pmn01 AND rvb03 = pmn02 ",
#               "   AND ",tm.wc CLIPPED
##----------------------------No.MOD-720060 end
##No.FUN-BA0053---End-----mark

#No.FUN-BA0053---Begin---add
   LET l_sql = "SELECT rva05,pmc03,pmc02,rva06,rvb10,rvb07,",
               "       rvb30,rvb29,rvb05,rvb86,rvb87,pmm42,pmn07 ",
               "  FROM rva_file",
               "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01 ",
               "  ,rvb_file,pmm_file,pmn_file",
               " WHERE rva_file.rva01 = rvb_file.rvb01 AND rvaconf='Y' ",
               "   AND rvb_file.rvb04 = pmm_file.pmm01 AND rvb_file.rvb04 = pmn_file.pmn01",
               "   AND rvb_file.rvb03 = pmn_file.pmn02",
               "   AND rva06 between '",tm.b_date,"' AND '",tm.e_date,"'",
               "   AND pmm18 <> 'X'",
               "   AND rva00 ='1' ",
               "   AND ",tm.wc CLIPPED
   LET l_sql = l_sql,
               " UNION ",
               "SELECT rva05,pmc03,pmc02,rva06,rvb10,rvb07,",
               "       rvb30,rvb29,rvb05,rvb86,rvb87,rva114,rvb90",
               "  FROM rva_file",
               "  LEFT OUTER JOIN pmc_file ON rva_file.rva05 = pmc_file.pmc01 ",
               "  ,rvb_file",
               " WHERE rvaconf='Y' ",
               "   AND rva_file.rva01 = rvb_file.rvb01 ",
               "   AND rva06 between '",tm.b_date,"' AND '",tm.e_date,"'",
               "   AND rva00 ='2' ",
               "   AND ",tm.wc CLIPPED
#No.FUN-BA0053---End-----add

   PREPARE apmx220_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   DECLARE apmx220_c1 CURSOR FOR apmx220_p1
 
   LET l_tot1=0
   LET l_tot2=0
   LET l_tot3=0
   LET l_tot7=0
 
   DELETE FROM tmp_file
 
   FOREACH apmx220_c1 INTO l_rva05,l_pmc03,l_pmc02,l_rva06,l_rvb10,
                          #-------------No.MOD-720060 modify
                          #l_rvb07,l_rvb30,l_rvb29,l_pmm42
                           l_rvb07,l_rvb30,l_rvb29,l_rvb05,
                           l_rvb86,l_rvb87,l_pmm42,l_pmn07
                          #-------------No.MOD-720060 end
      IF STATUS THEN
         CALL cl_err('foreach1:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
     #-----------------------No.MOD-720060 add--------------------
     #依據收貨單身料件抓取出採購與庫存單位
     #並用這些單位計算出採購單位與計價單位的轉換率
      SELECT ima44,ima25 INTO l_ima44,l_ima25 FROM ima_file
             WHERE ima01 = l_rvb05
      IF SQLCA.sqlcode =100 THEN
         IF l_rvb05 MATCHES 'MISC*' THEN
            SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
         END IF
      END IF
     IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
     #計算pmn07與ima44的轉換率 
     CALL s_umfchk(l_rvb05,l_pmn07,l_ima44)
          RETURNING l_cnt,l_factor1
     IF l_cnt = 1 THEN
        LET l_factor1 = 1
     END IF
 
     #計算rvb86與ima44的轉換率 
     CALL s_umfchk(l_rvb05,l_ima44,l_rvb86)
          RETURNING l_cnt,l_factor2
     IF l_cnt = 1 THEN
        LET l_factor2 = 1
     END IF
     #-----------------------No.MOD-720060 end--------------------
 
      IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF   #判斷NUll OR 空白
      IF cl_null(l_rvb10) THEN LET l_rvb10=0 END IF
      IF cl_null(l_rvb29) THEN LET l_rvb29=0 END IF
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_pmm42) THEN LET l_pmm42 = 1 END IF   #No.TQC-5B0101
      #TQC-940182---Begin
      IF cl_null(l_tot4)  THEN LET l_tot4=0 END IF 
      IF cl_null(l_tot5)  THEN LET l_tot5=0 END IF 
      IF cl_null(l_tot6)  THEN LET l_tot6=0 END IF 
      #TQC-940182---End
     #-----------No.MOD-720060 modify
     #LET l_tot4=l_rvb07*l_rvb10*l_pmm42
     #LET l_tot5=l_rvb30*l_rvb10*l_pmm42
     #LET l_tot6=l_rvb29*l_rvb10*l_pmm42
     #收貨金額直接用計價數量*單價
      LET l_tot4=l_rvb87*l_rvb10*l_pmm42                     
      LET l_tot5=l_rvb30*l_rvb10*l_pmm42*l_factor1*l_factor2
      LET l_tot6=l_rvb29*l_rvb10*l_pmm42*l_factor1*l_factor2
     #-----------No.MOD-720060 end
      UPDATE tmp_file SET tmp04 = tmp04 + l_tot4,
                          tmp05 = tmp05 + l_tot5,
                          tmp06 = tmp06 + l_tot6
       WHERE tmp01 = l_rva05
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF SQLCA.SQLERRD[3]=0 THEN
            INSERT INTO tmp_file VALUES (l_rva05,l_pmc03,l_pmc02,
                                         l_tot4,l_tot5,l_tot6)
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('insert:',SQLCA.SQLCODE,1)   #No.FUN-660129
               CALL cl_err3("ins","tmp_file",l_rva05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
               EXIT PROGRAM
            ELSE
               LET l_tot7=l_tot7+1
            END IF
         ELSE
            CALL cl_err('update tmp',SQLCA.SQLCODE,1)
         END IF
      END IF
 
      LET l_tot1=l_tot1+l_tot4
      LET l_tot2=l_tot2+l_tot5
      LET l_tot3=l_tot3+l_tot6
   END FOREACH
 
   LET l_sql = "SELECT tmp01,tmp02,tmp03,tmp04,tmp05,tmp06,' ',0 ",
               "  FROM tmp_file"
 
   IF tm.s = '1' THEN
      LET l_sql = l_sql CLIPPED," ORDER BY tmp04 DESC "
   END IF
 
   IF tm.s = '2' THEN
      LET l_sql = l_sql CLIPPED," ORDER BY tmp05 DESC "
   END IF
 
   PREPARE apmx220_p2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare2:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   DECLARE apmx220_c2 CURSOR FOR apmx220_p2
 
   select count(*) INTO l_i  from tmp_file
   display 'row :' ,l_i 
   LET g_pageno = 0
   LET l_i=0
   LET l_a=0
   LET l_b=0
   LET l_c=0
   LET l_a=l_tot7*tm.a/100
   LET l_b=l_tot7*tm.b/100+l_a
   LET l_c=l_tot7
   FOREACH apmx220_c2 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach2:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      #-----No.TQC-5B0101-----
      IF cl_null(sr.sr01) THEN
         LET sr.sr01 = 0
      END IF
      IF cl_null(sr.sr02) THEN
         LET sr.sr02 = 0
      END IF
      IF cl_null(sr.sr03) THEN
         LET sr.sr03 = 0
      END IF
      #-----No.TQC-5B0101 END-----
 
      #CHI-A80003 add --start--
      LET sr.sr01   =  cl_digcut(sr.sr01,g_azi04)
      LET sr.sr02   =  cl_digcut(sr.sr02,g_azi04)
      LET sr.sr03   =  cl_digcut(sr.sr03,g_azi04)
      #CHI-A80003 add --end--

      LET l_i=l_i+1
      LET sr.sr05=l_i
 
      IF sr.sr05 <= l_a THEN LET sr.sr04='A' END IF
      IF sr.sr05 > l_a AND sr.sr05 <= l_b THEN LET sr.sr04='B' END IF
      IF sr.sr05 > l_b AND sr.sr05 <= l_c THEN LET sr.sr04='C' END IF
 
      #str FUN-720010 add
      LET l_num = 0 #FUN-CB0001
      LET l_pmy02=''  #FUN-D40128
      SELECT pmy02 INTO l_pmy02 FROM pmy_file WHERE pmy01=sr.pmc02 #FUN-D40128

      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
      EXECUTE insert_prep USING sr.rva05, sr.pmc03,
                                sr.pmc02, l_pmy02, sr.sr01, #FUN-D40128 add l_pmy02
                                sr.sr02,  sr.sr03,
                                sr.sr04,  sr.sr05,  l_num,  g_azi04  #FUN-CB0001 l_num,  g_azi04
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720010 add
 
      IF tm.t = 'Y' THEN
         UPDATE pmc_file SET pmc18=sr.sr04
           WHERE  pmc01=sr.rva05
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('update:',SQLCA.SQLCODE,1)   #No.FUN-660129
            CALL cl_err3("upd","pmc_file",sr.rva05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
            EXIT PROGRAM
         END IF
      END IF
 
   END FOREACH
   
   #str FUN-720010 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_xgrid.table = l_table    ###XtraGrid###
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'pmc01,pmc02')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
###XtraGrid###   LET g_str = g_str,";",g_azi04                      #FUN-710080 add
###XtraGrid###   CALL cl_prt_cs3('apmx220','apmx220',l_sql,g_str)   #FUN-710080 modify
    LET g_xgrid.order_field = 'sr04'   #FUN-CB0001 add
    LET g_xgrid.grup_field = 'sr04'   #FUN-CB0001 add
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-CB0001 add
    CALL cl_xg_view()    ###XtraGrid###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720010 add 
 
END FUNCTION
 
{
REPORT apmx220_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
          sr           RECORD
                          rva05 LIKE rva_file.rva05,
                          pmc03 LIKE pmc_file.pmc03,
                          pmc02 LIKE pmc_file.pmc02,
                          sr01  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6)
                          sr02  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6)
                          sr03  LIKE oeb_file.oeb14,       #No.FUN-680136 DECIMAL(20,6)
                          sr04  LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
                          sr05  LIKE type_file.num5        #No.FUN-680136 SMALLINT
                       END RECORD,
          l_1          LIKE oeb_file.oeb14,                #No.FUN-680136 DECIMAL(20,6)
          l_2          LIKE oeb_file.oeb14,                #No.FUN-680136 DECIMAL(20,6)
          l_3          LIKE oeb_file.oeb14,                #No.FUN-680136 DECIMAL(20,6)
          l_chr        LIKE type_file.chr1                 #No.FUN-680136 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.sr04,sr.sr05
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT l_cd
         PRINT g_dash
         #---
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-4C0095 印表頭
         #---
         PRINT g_dash1
         LET l_last_sw = 'n'
 
     BEFORE GROUP OF sr.sr04
        LET l_1=0
        LET l_2=0
        LET l_3=0
 
     ON EVERY ROW
        IF tm.t = 'Y' THEN
           UPDATE pmc_file SET pmc18=sr.sr04
             WHERE  pmc01=sr.rva05
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('update:',SQLCA.SQLCODE,1)   #No.FUN-660129
              CALL cl_err3("upd","pmc_file",sr.rva05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
              EXIT PROGRAM
           END IF
        END IF
        LET l_1 = l_1 + cl_numfor(sr.sr01,36,g_azi04)   #No.MOD-5A0453
        LET l_2 = l_2 + cl_numfor(sr.sr02,37,g_azi04)   #No.MOD-5A0453
        LET l_3 = l_3 + cl_numfor(sr.sr03,38,g_azi04)   #No.MOD-5A0453
 
        #FUN-4C0095
        PRINT COLUMN g_c[31],sr.sr04,
              COLUMN g_c[32],sr.sr05 USING '###&',
              COLUMN g_c[33],sr.rva05,
              COLUMN g_c[34],sr.pmc03,
              COLUMN g_c[35],sr.pmc02,
              COLUMN g_c[36],cl_numfor(sr.sr01,36,g_azi04),
              COLUMN g_c[37],cl_numfor(sr.sr02,37,g_azi04),
              COLUMN g_c[38],cl_numfor(sr.sr03,38,g_azi04)
        #FUN-4C0095(end)
 
     AFTER GROUP OF sr.sr04
        #FUN-4C0095
        PRINT g_dash1
        PRINT COLUMN g_c[35],g_x[17] CLIPPED,
              COLUMN g_c[36],cl_numfor(l_1,36,g_azi04),
              COLUMN g_c[37],cl_numfor(l_2,37,g_azi04),
              COLUMN g_c[38],cl_numfor(l_3,38,g_azi04)
        PRINT g_dash
        #FUN-4C0095(end)
 
     ON LAST ROW
        #FUN-4C0095
        PRINT COLUMN g_c[35],g_x[15] CLIPPED,
              COLUMN g_c[36],cl_numfor(l_tot1,36,g_azi04),
              COLUMN g_c[37],cl_numfor(l_tot2,37,g_azi04),
              COLUMN g_c[38],cl_numfor(l_tot3,38,g_azi04)
        #FUN-4C0095(end)
 
        IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
           CALL cl_wcchp(tm.wc,'pmc01,pmc02') RETURNING tm.wc
           PRINT g_dash
         #TQC-630166
	 CALL cl_prt_pos_wc(tm.wc)
        END IF
        PRINT g_dash #FUN-4C0095
        LET l_last_sw = 'y'
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-8, g_x[7] CLIPPED #TQC-5B0037 add
 
     PAGE TRAILER
        IF l_last_sw = 'n' THEN
           PRINT g_dash #FUN-4C0095
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED #TQC-5B0037
        ELSE
           SKIP 2 LINE
        END IF
 
END REPORT
}
#Patch....NO.TQC-610036 <001> #
#MOD-920209


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
