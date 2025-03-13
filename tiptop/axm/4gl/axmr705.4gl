# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr705.4gl
# Descriptions...: 部門預計收入統計表
# Date & Author..: 02/12/06 By Leagh
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-720004 07/02/06 By TSD.Hazel 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-D50056 13/07/16 By yangtt 增加業務員編號、潛在客戶編號、部門編號開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     LIKE type_file.chr1000, # No.FUN-680137 VARCHAR(500)    # Where condition
              bdate  LIKE type_file.dat,     # No.FUN-680137 DATE
              edate  LIKE type_file.dat,     # No.FUN-680137 DATE
              more   LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE l_table     STRING                        ### FUN-720004 add ###
DEFINE g_sql       STRING                        ### FUN-720004 add ###
DEFINE g_str       STRING                        ### FUN-720004 add ###
DEFINE g_sma115    LIKE sma_file.sma115          ### FUN-720004 add ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720004 *** ##
   LET g_sql = "gem01.gem_file.gem01,",
               "gem02.gem_file.gem02,",
               "ofd27.ofd_file.ofd27,",
               "ofd23.ofd_file.ofd23,",
               "ofd01.ofd_file.ofd01,",
               "ofd02.ofd_file.ofd02,",
               "ofd10.ofd_file.ofd10,",
               "ofd05.ofd_file.ofd05,",  
               "ofd28.ofd_file.ofd28,",  
               "ofd29.ofd_file.ofd29,",  
               "gen02.gen_file.gen02,",  
               "prein.ofd_file.ofd28 "   
   LET l_table = cl_prt_temptable('axmr705',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720004 add
 
   INITIALIZE tm.* TO NULL              # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr705_tm(0,0)             # Input print condition
      ELSE CALL axmr705()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr705_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr705_w AT p_row,p_col WITH FORM "axm/42f/axmr705"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
   CALL s_azn01(YEAR(g_today),MONTH(g_today)) RETURNING tm.bdate,tm.edate
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gem01,ofd23,ofd01,ofd10,ofd03
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---

   #TQC-D50056--add--start
      ON ACTION CONTROLP
         IF INFIELD (ofd23) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd23"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd23
            NEXT FIELD ofd23
         END IF
         IF INFIELD (gem01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gem01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO gem01
            NEXT FIELD gem01
         END IF
         IF INFIELD (ofd01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofd"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofd01
            NEXT FIELD ofd01
         END IF
   #TQC-D50056--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
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
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr705'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr705','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr705',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr705_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr705()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr705_w
END FUNCTION
 
FUNCTION axmr705()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    gem01     LIKE gem_file.gem01,
                    gem02     LIKE gem_file.gem02,
                    ofd27     LIKE ofd_file.ofd27,
                    ofd23     LIKE ofd_file.ofd23,
                    ofd01     LIKE ofd_file.ofd01,
                    ofd02     LIKE ofd_file.ofd02,
                    ofd10     LIKE ofd_file.ofd10,
                    ofd05     LIKE ofd_file.ofd05,
                    ofd28     LIKE ofd_file.ofd28,
                    ofd29     LIKE ofd_file.ofd29,
                    gen02     LIKE gen_file.gen02,
                    prein     LIKE ofd_file.ofd28
                    END RECORD
 
   #str FUN-720004 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720004 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720004 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.sqlcode,"","",0)  #No.FUN-660167 
   END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720004 add ###
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #       LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN
   #       LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
   #End:FUN-980030
 
   LET l_sql="SELECT gem01,gem02,ofd27,ofd23,ofd01,ofd02,ofd10,ofd05,",
             "       ofd28,ofd29,gen02,0",
" FROM ofd_file LEFT OUTER JOIN gen_file LEFT OUTER JOIN gem_file on gen_file.gen03 = gem_file.gem01 ON ofd_file.ofd23 = gen_file.gen01 WHERE 1=1 ", 
             "   AND ofd22 IN ('0','1','2') ",
             "   AND ofd27 BETWEEN '",tm.bdate,"' AND '",tm.edate,
             "'  AND ",tm.wc CLIPPED
 
   PREPARE axmr705_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE axmr705_curs1 CURSOR FOR axmr705_prepare1
 
   FOREACH axmr705_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET sr.prein = sr.ofd28 * sr.ofd29 / 100
      IF cl_null(sr.prein) THEN LET sr.prein = 0 END IF
 
      #str FUN-720004 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720004 *** ##
      EXECUTE insert_prep USING 
         sr.gem01,sr.gem02,sr.ofd27,sr.ofd23,sr.ofd01,sr.ofd02,sr.ofd10,
         sr.ofd05,sr.ofd28,sr.ofd29,sr.gen02,sr.prein
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720004 add
   END FOREACH
 
   #str FUN-720004 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720004 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gem01,ofd23,ofd01,ofd10,ofd03') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",g_azi04,";",g_azi05          #FUN-710080 modify
   CALL cl_prt_cs3('axmr705','axmr705',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720004 add
 
END FUNCTION
