# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: aapr121.4gl
# Descriptions...: 應付帳款餘額明細表列印作業
# Date & Author..: 92/12/28  By  Felicity  Tseng
# Modify.........: No.9796 04/07/27 ching remove g_x[28]
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570264 05/07/28 By saki 背景選擇樣板
# Modify.........: No.MOD-590440 05/09/26 By ice 依月底重評價對AP未付金額調整后,報表列印欄位增加
# Modify.........: No.MOD-5C0070 05/12/13 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: No.TQC-610032 06/01/16 By Smapmin 背景執行參數接收有誤
# Modify.........: No.MOD-640110 06/04/27 By Smapmin 小計列印有誤
# Modify.........: No.FUN-650017 06/06/15 By Echo 報表段的LEFT MARGIN的值改為 g_left_margin
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行時間
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 同廠商不同幣別時候合計沒有計算
# Modify.........: No.TQC-710044 07/01/11 By Sarah 輸入完QBE條件後，進入條件選項部分，右邊有一個Button"開啟查詢視窗"，按了沒有反應
# Modify.........: No.FUN-6C0048 07/01/09 By ching-yuan TOP MARGIN g_top_margin及BOTTOM MARGIN g_bottom_margin由g_top_margin及g_bottom_margin設定
# Modify.........: No.FUN-710080 07/03/23 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 本幣未付金額不需扣除留置金額
# Modify.........: No.FUN-7C0078 07/12/25 By jacklai 增加CrystalReports背景作業功能, 修改傳入參數
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.MOD-970281 09/07/31 By mike 該報表條件下「付款」時，考量「留置金額」不甚合理，應同aapr129將未付金額列出，煩請>
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30101 10/03/22 By sabrina 多傳apz27參數到報表
# Modify.........: No:CHI-A40017 10/04/22 By liuxqa modify sql
# Modify.........: No:CHI-AB0010 10/11/12 By Summer SQL多串apc_file依多帳期資料分開列示
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_apa14應給予預設值'',抓不到值不應為'1'
# Modify.........: No:MOD-B70183 11/07/19 By Sarah 程式裡判斷apc10與apc11的地方都要多考慮apc14與apc15
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No.TQC-CC0040 12/12/07 By qirl QBE查詢條件開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,
           s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),  
           t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
           u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(03),
           w       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
           more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(10)
 
DEFINE g_cnt       LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_head1     STRING   #Print seqence
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #-----TQC-610032---------
   LET tm.h  = ARG_VAL(11)
   LET tm.w  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   #-----END TQC-610032
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "apa00.apa_file.apa00,",
               "apa01.apa_file.apa01,",
               "apa02.apa_file.apa02,",
               "apa06.apa_file.apa06,",
               "apa07.apa_file.apa07,",
               "apa08.apa_file.apa08,",
               "apa11.apa_file.apa11,",
               "apa12.apa_file.apa12,",
               "apa13.apa_file.apa13,",
               "apa15.apa_file.apa15,",
               "apa21.apa_file.apa21,",
               "apa22.apa_file.apa22,",
               "apa24.apa_file.apa24,",
               "apa64.apa_file.apa64,",
               "apa34f.apa_file.apa34f,",
               "un_payf.apa_file.apa35f,",
               "apa34.apa_file.apa34,",
               "un_pay.apa_file.apa35,",
               "apa36.apa_file.apa36,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "apr02.apr_file.apr02"
 
   LET l_table = cl_prt_temptable('aapr121',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
      EXIT PROGRAM
   END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047  add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r121_tm()
   ELSE 
      CALL r121()
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION r121_tm()
   DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   OPEN WINDOW r121_w WITH FORM "aap/42f/aapr121"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL
 
   LET tm.s    = '23 '                               
   LET tm.u    = 'Y  '
   LET tm.w    = '1'
   LET tm.h    = '3'
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
   CONSTRUCT BY NAME tm.wc ON apa21,apa06,apa02,apa01,apa22,apa36,apa00,apa13
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #--TQC-CC0040--add--star--
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(apa21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa21"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa21
                  NEXT FIELD apa21
             WHEN INFIELD(apa22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa22"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa22
                  NEXT FIELD apa22
             WHEN INFIELD(apa06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa12"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa06
                  NEXT FIELD apa06
             WHEN INFIELD(apa36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa36"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa36
                  NEXT FIELD apa36
             WHEN INFIELD(apa00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa00"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa00
                  NEXT FIELD apa00
             WHEN INFIELD(apa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa07"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
                  NEXT FIELD apa01
             WHEN INFIELD(apa13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_apa13"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa13
                  NEXT FIELD apa13
           END CASE
         #--TQC-CC0040--add--end---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION help          # MOD-4C0121
         CALL cl_show_help()  # MOD-4C0121
 
      ON ACTION controlg      # MOD-4C0121
         CALL cl_cmdask()     # MOD-4C0121
 
      ON ACTION about         # MOD-4C0121
         CALL cl_about()      # MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.w,tm.h,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
                 WITHOUT DEFAULTS HELP 1
      AFTER FIELD w
         IF cl_null(tm.w) OR tm.w NOT MATCHES '[123]' THEN NEXT FIELD w END IF
 
      AFTER FIELD h
         IF cl_null(tm.h) OR tm.h NOT MATCHES '[123]' THEN NEXT FIELD h END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CALL r121_wc()
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help          # MOD-4C0121
         CALL cl_show_help()  # MOD-4C0121
 
      ON ACTION controlg      # MOD-4C0121
         CALL cl_cmdask()     # MOD-4C0121
 
      ON ACTION about         # MOD-4C0121
         CALL cl_about()      # MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='aapr121'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr121','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
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
                         " '",tm.u CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",   #TQC-610032
                         " '",tm.w CLIPPED,"'",   #TQC-610032
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapr121',g_time,l_cmd)
      END IF
      CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r121()
   ERROR ""
END WHILE
   CLOSE WINDOW r121_w
END FUNCTION
 
FUNCTION r121_wc()
DEFINE l_wc  STRING   #TQC-630166
 
   OPEN WINDOW r121_w2 WITH FORM "aap/42f/aapt110"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("aapt110")

  CONSTRUCT BY NAME l_wc ON
            apa01,apa02,apa05,apa06,apa07,apa21,
            apa22,apa930,apa44,apa992,apa63,apamksg,apa42,apa41, #FUN-670064  #No.FUN-690090 add apa992
            apa36,apa13,apa14,apa15,apa16,apa08,apa58,   #FUN-5C0106 apa08在apa15,16之後    #MOD-6A0124
            apa11,apa12,apa24,apa64,apa55,
            apa31f,apa32f,apa60f,apa61f,apa65f,apa37f,apa34f,apa35f, #FUN-640035 #No.FUN-690080
            apa31,apa32,apa60,apa61,apa65,apa37,apa34,apa35,         #FUN-640035 #No.FUN-690080
            apa19,apa20,       #No.FUN-680029
            apa56,apa33,apa66,apa25,apa100,
            apainpd,apa99,apa51,apa52,apa54,apa511,apa521,apa541,    #No.FUN-680029
            apa101,apa102,                                           #No.FUN-690080
            apauser,apagrup,apamodu,apadate,apaacti
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION help          # MOD-4C0121
        CALL cl_show_help()  # MOD-4C0121
 
     ON ACTION controlg      # MOD-4C0121
        CALL cl_cmdask()     # MOD-4C0121
 
     ON ACTION about         # MOD-4C0121
        CALL cl_about()      # MOD-4C0121
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
   END CONSTRUCT
 
   CLOSE WINDOW r121_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r121_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION r121()
DEFINE l_name    LIKE type_file.chr20       # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8       # Used time for running the job #FUN-580184 mark  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql     STRING        # RDSQL STATEMENT   #TQC-630166
DEFINE l_za05    LIKE type_file.chr1000     #No.FUN-690028 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000   # No.FUN-690028 VARCHAR(100)
DEFINE l_i       LIKE type_file.num5           #No.MOD-590440  #No.FUN-690028 SMALLINT
DEFINE l_len     LIKE type_file.num5           # No.FUN-690028 SMALLINT         #No.MOD-590440
DEFINE sr        RECORD apa00   LIKE apa_file.apa00,
                        apa01   LIKE apa_file.apa01,
                        apa02   LIKE apa_file.apa02,
                        apa06   LIKE apa_file.apa06,
                        apa07   LIKE apa_file.apa07,
                        apa08   LIKE apa_file.apa08,
                        apa11   LIKE apa_file.apa11,
                        apa12   LIKE apa_file.apa12,
                        apa13   LIKE apa_file.apa13,
                        apa15   LIKE apa_file.apa15,
                        apa21   LIKE apa_file.apa21,
                        apa22   LIKE apa_file.apa22,
                        apa24   LIKE apa_file.apa24,
                        apa64   LIKE apa_file.apa64,
                        apa34f  LIKE apa_file.apa34f,
                        un_payf LIKE apa_file.apa35f,
                        apa34   LIKE apa_file.apa34,
                        un_pay  LIKE apa_file.apa35,
                        apa36   LIKE apa_file.apa36,
                        azi03   LIKE azi_file.azi03,
                        azi04   LIKE azi_file.azi04,
                        azi05   LIKE azi_file.azi05,     #No.MOD-5C0070
                        apr02   LIKE apr_file.apr02      #FUN-710080 add
                        END RECORD
     DEFINE l_oox01   STRING                #CHI-830003 add
     DEFINE l_oox02   STRING                #CHI-830003 add
     DEFINE l_sql_1   STRING                #CHI-830003 add
     DEFINE l_sql_2   STRING                #CHI-830003 add
     DEFINE l_count   LIKE type_file.num5   #CHI-830003 add
     DEFINE l_apa14   LIKE apa_file.apa14   #CHI-830003 add                        
 
#   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #FUN-580184 mark  #No.FUN-6A0055
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
   #End:FUN-980030
 
  #str FUN-710080 mark
  ##no.6133   (針對幣別加總)
  #DELETE FROM curr_tmp;
  #
  #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
  #          "  WHERE order1=? ",
  #          "  GROUP BY curr"
  #PREPARE tmp1_pre FROM l_sql
  #IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
  #DECLARE tmp1_cs CURSOR FOR tmp1_pre
  #
  #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
  #          "  WHERE order1=? ",
  #          "    AND order2=? ",
  #          "  GROUP BY curr  "
  #PREPARE tmp2_pre FROM l_sql
  #IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
  #DECLARE tmp2_cs CURSOR FOR tmp2_pre
  #
  #LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
  #          "  WHERE order1=? ",
  #          "    AND order2=? ",
  #          "    AND order3=? ",
  #          "  GROUP BY curr  "
  #PREPARE tmp3_pre FROM l_sql
  #IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
  #DECLARE tmp3_cs CURSOR FOR tmp3_pre
  #end FUN-710080 mark
 
   #no.6133(end)
   #No.MOD-5C0070  --begin
  #CHI-AB0010 mark --start--
  #IF g_apz.apz27 = 'N' THEN
  #   LET l_sql = "SELECT ",
  #               " apa00, apa01, apa02, apa06, apa07, apa08, apa11, apa12,",
  #               " apa13, apa15, apa21, apa22, apa24, apa64,",
  #               #-----MOD-720128--------- 
  #               #" apa34f, (apa34f-apa35f-apa20),",
  #               #" apa34, (apa34-apa35-apa20*apa14),",
  #               " apa34f, (apa34f-apa35f),",
  #               " apa34, (apa34-apa35),",
  #               #-----END MOD-720128-----
  #               " apa36, azi03, azi04, azi05, apr02",    #FUN-710080 add apr02
  #               #" FROM apa_file, OUTER azi_file",  #CHI-A40017 mark
  #               #"              , OUTER apr_file",        #FUN-710080 add #CHI-A40017 mark
  #               " FROM apa_file LEFT OUTER JOIN azi_file ON apa13 = azi01 ",  #CHI-A40017 mod
  #               "      LEFT OUTER JOIN apr_file ON apa36 = apr01 ",        #FUN-710080 add  #CHI-A40017 mod
  #               #" WHERE azi_file.azi01 = apa_file.apa13 ", #CHI-A40017 mark
  #               #" AND apr_file.apr01 = apa_file.apa36 ",  #CHI-A40017 mark        #FUN-710080 add
  #               "  WHERE apa42 = 'N' ",   #CHI-A40017 and ->where mod
  #               " AND ", tm.wc CLIPPED
  #ELSE
  #   LET l_sql = "SELECT ",
  #               " apa00, apa01, apa02, apa06, apa07, apa08, apa11, apa12,",
  #               " apa13, apa15, apa21, apa22, apa24, apa64,",
  #               #-----MOD-720128--------- 
  #               #" apa34f, (apa34f-apa35f-apa20),",
  #               #" apa34, (apa73-apa20*apa72),",
  #               " apa34f, (apa34f-apa35f),",
  #               " apa34, (apa73),",
  #               #-----END MOD-720128-----
  #               " apa36, azi03, azi04, azi05, apr02",    #FUN-710080 add apr02
  #               #" FROM apa_file, OUTER azi_file",  #CHI-A40017 mark
  #               #"              , OUTER apr_file",  #CHI-A40017 mark      #FUN-710080 add
  #               " FROM apa_file LEFT OUTER JOIN azi_file ON apa13 = azi01 ",  #CHI-A40017 mod
  #               "      LEFT OUTER JOIN apr_file ON apa36 = apr01 ",        #FUN-710080 add  #CHI-A40017 mod
  #               #" WHERE azi_file.azi01 = apa_file.apa13 ", #CHI-A40017 mark
  #               #" AND apr_file.apr01 = apa_file.apa36 ",  #CHI-A40017 mark        #FUN-710080 add
  #               "  WHERE apa42 = 'N' ",   #CHI-A40017 and ->where mod
  #               " AND ", tm.wc CLIPPED
  #END IF
  ##No.MOD-5C0070  --End
  #IF tm.w='1' THEN     #unpay
  #  #LET l_sql=l_sql CLIPPED," AND apa34f > (apa35f+apa20) " #MOD-970281                                                           
  #   LET l_sql=l_sql CLIPPED," AND apa34f >  apa35f "        #MOD-970281 
  #END IF
  #IF tm.w='2' THEN
  #  #LET l_sql=l_sql CLIPPED," AND apa34f <= (apa35f+apa20) " #MOD-970281                                                          
  #   LET l_sql=l_sql CLIPPED," AND apa34f <=  apa35f "        #MOD-970281   
  #END IF
  #CHI-AB0010 mark --end--
  #CHI-AB0010 mod --start--
   IF g_apz.apz27 = 'N' THEN
      LET l_sql = "SELECT ",
                  " apa00, apa01, apa02, apa06, apa07, apc12, apa11, apc04,",
                  " apa13, apa15, apa21, apa22, apa24, apc05,",
                  " apc08, (apc08-apc10-apc14),",   #MOD-B70183 add apc14
                  " apc09, (apc09-apc11-apc15),",   #MOD-B70183 add apc15
                  " apa36, azi03, azi04, azi05, apr02",
                  " FROM apc_file,apa_file ",
                  "      LEFT OUTER JOIN azi_file ON apa13 = azi01 ",  
                  "      LEFT OUTER JOIN apr_file ON apa36 = apr01 ",   
                  "WHERE apa42 = 'N' ",
                  "  AND apa01 = apc01 ",
                  "  AND ", tm.wc CLIPPED
   ELSE
      LET l_sql = "SELECT ",
                  " apa00, apa01, apa02, apa06, apa07, apc12, apa11, apc04,",
                  " apa13, apa15, apa21, apa22, apa24, apc05,",
                  " apc08, (apc08-apc10-apc14),",   #MOD-B70183 add apc14
                  " apc09, (apc13),",
                  " apa36, azi03, azi04, azi05, apr02",
                  " FROM apc_file,apa_file ",
                  "      LEFT OUTER JOIN azi_file ON apa13 = azi01 ",
                  "      LEFT OUTER JOIN apr_file ON apa36 = apr01 ",     
                  "WHERE apa42 = 'N' ",  
                  "  AND apa01 = apc01 ",
                  "  AND ", tm.wc CLIPPED
   END IF
   IF tm.w='1' THEN     #unpay
      LET l_sql=l_sql CLIPPED," AND apc08 >  apc10+apc14 "   #MOD-B70183 add apc14 
   END IF
   IF tm.w='2' THEN
      LET l_sql=l_sql CLIPPED," AND apc08 <= apc10+apc14 "   #MOD-B70183 add apc14
   END IF
  #CHI-AB0010 mod --end--
   IF tm.h='1' THEN LET l_sql=l_sql CLIPPED," AND apa41='Y' " END IF
   IF tm.h='2' THEN LET l_sql=l_sql CLIPPED," AND apa41='N' " END IF
   PREPARE r121_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r121_curs1 CURSOR FOR r121_prepare1
 
   FOREACH r121_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      #CHI-830003--Add--Begin--#    
      IF g_apz.apz27 = 'Y' THEN
         LET l_oox01 = YEAR(sr.apa02)
         LET l_oox02 = MONTH(sr.apa02)                      	 
         LET l_apa14 = ''  #TQC-B10083 add
         WHILE cl_null(l_apa14)
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.apa01,"'",
                             "   AND oox04 = '0'"
               PREPARE r121_prepare7 FROM l_sql_2
               DECLARE r121_oox7 CURSOR FOR r121_prepare7
               OPEN r121_oox7
               FETCH r121_oox7 INTO l_count
               CLOSE r121_oox7                       
               IF l_count = 0 THEN
                  #LET l_apa14 = '1'    #TQC-B10083 mark 
                  EXIT WHILE            #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AP' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.apa01,"'",
                                "   AND oox04 = '0'"
               END IF                  
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r121_prepare07 FROM l_sql_1
               DECLARE r121_oox07 CURSOR FOR r121_prepare07
               OPEN r121_oox07
               FETCH r121_oox07 INTO l_apa14
               CLOSE r121_oox07
            END IF              
         END WHILE                       
      END IF
      #CHI-830003--Add--End--#
      
      #CHI-830003--Begin--#
      #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN            #TQC-B10083 mark
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN     #TQC-B10083 mod
         LET sr.apa34 = sr.apa34f * l_apa14
         LET sr.un_pay = sr.un_payf * l_apa14
      END IF    
      #CHI-830003--End--#      
                  
      #No.MOD-5C0070  --begin
      IF tm.w = '1' AND sr.un_pay <= 0 THEN CONTINUE FOREACH END IF
      IF tm.w = '2' AND sr.un_pay > 0 THEN CONTINUE FOREACH END IF
      #No.MOD-5C0070  --End
      IF sr.apa00[1,1] = '2' THEN
         LET sr.apa34f= sr.apa34f * -1
         LET sr.un_payf= sr.un_payf * -1
         LET sr.apa34 = sr.apa34 * -1
         LET sr.un_pay = sr.un_pay * -1
      END IF
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
     #str FUN-710080 mark
     #FOR g_i = 1 TO 3
     #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa21
     #                                 LET g_orderA[g_i]= g_x[20]
     #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa06,sr.apa07
     #                                 LET g_orderA[g_i]= g_x[21]
     #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
     #                                 LET g_orderA[g_i]= g_x[22]
     #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa01
     #                                 LET g_orderA[g_i]= g_x[23]
     #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa22
     #                                 LET g_orderA[g_i]= g_x[24]
     #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa36
     #                                 LET g_orderA[g_i]= g_x[25]
     #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.apa00
     #                                 LET g_orderA[g_i]= g_x[26]
     #        WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.apa13
     #                                 LET g_orderA[g_i]= g_x[27]
     #        OTHERWISE                LET l_order[g_i] = '-'
     #                                 LET g_orderA[g_i]= ' '      #清為空白
     #   END CASE
     #END FOR
     #LET sr.order1 = l_order[1]
     #LET sr.order2 = l_order[2]
     #LET sr.order3 = l_order[3]
     #IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
     #IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
     #IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
     #end FUN-710080 mark
 
      #str FUN-710080 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.apa00  ,sr.apa01,sr.apa02 ,sr.apa06,sr.apa07 ,
         sr.apa08  ,sr.apa11,sr.apa12 ,sr.apa13,sr.apa15 ,
         sr.apa21  ,sr.apa22,sr.apa24 ,sr.apa64,sr.apa34f,
         sr.un_payf,sr.apa34,sr.un_pay,sr.apa36,sr.azi04 ,
         sr.azi05  ,sr.apr02
      #------------------------------ CR (3) ------------------------------#
      #end FUN-710080 add
   END FOREACH
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #欲傳到CR做排序、跳頁、小計控制的參數
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",   #排序
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",   #跳頁
               tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",   #小計
               g_azi04,";",g_azi05,";",t_azi05,";",g_apz.apz27             #MOD-A30101 add apz27
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apa21,apa06,apa02,apa01,apa22,apa36,apa00,apa13')
           RETURNING tm.wc
      LET g_str = g_str ,";",tm.wc
   END IF
   display "coco test:",l_sql
   CALL cl_prt_cs3('aapr121','aapr121',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
{
REPORT r121_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE sr           RECORD order1  LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100)      #FUN-560011
                           order2  LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100)      #FUN-560011
                           order3  LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100)      #FUN-560011
                           apa00   LIKE apa_file.apa00,
                           apa01   LIKE apa_file.apa01,
                           apa02   LIKE apa_file.apa02,
                           apa06   LIKE apa_file.apa06,
                           apa07   LIKE apa_file.apa07,
                           apa08   LIKE apa_file.apa08,
                           apa11   LIKE apa_file.apa11,
                           apa12   LIKE apa_file.apa12,
                           apa13   LIKE apa_file.apa13,
                           apa15   LIKE apa_file.apa15,
                           apa21   LIKE apa_file.apa21,
                           apa22   LIKE apa_file.apa22,
                           apa24   LIKE apa_file.apa24,
                           apa64   LIKE apa_file.apa64,
                           apa34f  LIKE apa_file.apa34f,
                           un_payf LIKE apa_file.apa35f,
                           apa34   LIKE apa_file.apa34,
                           un_pay  LIKE apa_file.apa35,
                           apa36   LIKE apa_file.apa36,
                           azi03   LIKE azi_file.azi03,
                           azi04   LIKE azi_file.azi04,
                           azi05   LIKE azi_file.azi05     #No.MOD-5C0070
                    END RECORD,
       sr1          RECORD
                           curr    LIKE azi_file.azi01,    #No.FUN-690028 VARCHAR(04),
                           amt     LIKE type_file.num20_6  #No.FUN-690028 DEC(20,6)
                    END RECORD
#DEFINE l_azi05      LIKE  azi_file.azi05    #No.CHI-6A0004 
DEFINE l_apr02      LIKE  apr_file.apr02     # 帳款類別名稱
DEFINE l_amt_1      LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)
DEFINE l_amt_11     LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)
DEFINE l_amt_2      LIKE type_file.num20_6     # No.FUN-690028 DECIMAL(20,6)   #No.MOD-5C0070
DEFINE l_curr       STRING
#DEFINE l_sql        LIKE type_file.chr1000       # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql        STRING       # RDSQL STATEMENT   #TQC-630166
 
  OUTPUT TOP MARGIN g_top_margin    #No.FUN-6C0048
         #TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin             #FUN-650017
         BOTTOM MARGIN g_bottom_margin  #No.FUN-6C0048
         #BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_head1 = g_x[12] CLIPPED, g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
      PRINT g_head1
 
      PRINT g_dash[1,g_len]
 
#     PRINT g_x[31] CLIPPED,COLUMN 10,g_x[32] CLIPPED,COLUMN 23,g_x[33] CLIPPED,COLUMN 32,g_x[34] CLIPPED,
#           COLUMN 43,g_x[35] CLIPPED,COLUMN 53,g_x[36] CLIPPED,COLUMN 63,g_x[37] CLIPPED,
#           COLUMN 68,g_x[38] CLIPPED,COLUMN 73,g_x[39] CLIPPED,COLUMN 82,g_x[40] CLIPPED,
#           COLUMN 91,g_x[41] CLIPPED,COLUMN 96,g_x[42] CLIPPED,COLUMN 109,g_x[43] CLIPPED,
#           COLUMN 125,g_x[44] CLIPPED,COLUMN 142,g_x[45] CLIPPED
 
#     PRINT COLUMN g_c[31],g_x[31] CLIPPED, COLUMN g_c[32],g_x[32] CLIPPED, COLUMN g_c[33],g_x[33] CLIPPED,
#           COLUMN g_c[34],g_x[34] CLIPPED, COLUMN g_c[35],g_x[35] CLIPPED, COLUMN g_c[36],g_x[36] CLIPPED,
#           COLUMN g_c[37],g_x[37] CLIPPED, COLUMN g_c[38],g_x[38] CLIPPED, COLUMN g_c[39],g_x[39] CLIPPED,
#           COLUMN g_c[40],g_x[40] CLIPPED, COLUMN g_c[41],g_x[41] CLIPPED, COLUMN g_c[42],g_x[42] CLIPPED,
#           COLUMN g_c[43],g_x[43] CLIPPED, COLUMN g_c[44],g_x[44] CLIPPED, COLUMN g_c[45],g_x[45]
 
      PRINT g_x[31],g_x[32],g_x[33],
            g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],
            g_x[40],g_x[41],g_x[42],
            g_x[43],g_x[44],g_x[45]   #No.MOD-5C0070
      
#     PRINT '---------- ','---------- ','-------- ','---------- ','-------- ',
#           '---------- ','---- ','---- ','-------- ','-------- ','--- ',
#           '-------- ','---------------- ','---------------- ',
#           '----------------'
      PRINT g_dash1
      LET l_last_sw = 'n'         
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT apr02 INTO l_apr02         # 帳款類別名稱
        FROM  apr_file
       WHERE apr01 = sr.apa36
      PRINT COLUMN g_c[31],sr.apa06,
            COLUMN g_c[32],sr.apa07,
            COLUMN g_c[33],sr.apa02,
            COLUMN g_c[34],sr.apa08,
            COLUMN g_c[35],l_apr02,
            COLUMN g_c[36],sr.apa01,
            COLUMN g_c[37],sr.apa15,
            COLUMN g_c[38],sr.apa13,
            COLUMN g_c[39],sr.apa21,
            COLUMN g_c[40],sr.apa12,
            COLUMN g_c[41],sr.apa24 USING '###&',
            COLUMN g_c[42],sr.apa64,
            COLUMN g_c[43],cl_numfor(sr.apa34f,43,sr.azi04),
            COLUMN g_c[44],cl_numfor(sr.apa34,44,g_azi04),
            COLUMN g_c[45],cl_numfor(sr.un_pay,45,g_azi04)   #No.MOD-5C0070
      #no.6133
      INSERT INTO curr_tmp VALUES(sr.apa13,sr.apa34f,
                                  sr.order1,sr.order2,sr.order3)
      #no.6133(end)
 
   AFTER GROUP OF sr.order1
      INITIALIZE sr1.* TO NULL
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.apa34f)
         LET l_amt_11= GROUP SUM(sr.apa34)
         LET l_amt_2 = GROUP SUM(sr.un_pay)   #No.MOD-5C0070
         PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
               COLUMN g_c[41],g_dash2[1,g_w[41]],
               COLUMN g_c[42],g_dash2[1,g_w[42]],
               COLUMN g_c[43],g_dash2[1,g_w[43]],
               COLUMN g_c[44],g_dash2[1,g_w[44]],
               COLUMN g_c[45],g_dash2[1,g_w[45]]  #No.MOD-5C0070
           #    '--------------------------------------------------------',
           #    '--------------'
        #PRINT COLUMN g_c[39],sr.order1[11,20] CLIPPED,   #MOD-640110
         PRINT COLUMN g_c[40],g_orderA[1] CLIPPED,
               COLUMN g_c[41],g_x[10] CLIPPED;
#        PRINT COLUMN 80,sr.order1[11,20] CLIPPED,
#              COLUMN 85,g_orderA[1] CLIPPED,g_x[17] CLIPPED;
         #no.6133
         LET g_cnt = 1
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
            SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = sr1.curr  #No.CHI-6A0004 
       #              display 'sr1.amt_x:',sr1.amt,'l_azi05_x:',l_azi05
            LET l_curr = sr1.curr CLIPPED ,':'
#           IF g_cnt = 1 THEN                      #TQC-6A0088  mark
               PRINT COLUMN g_c[42],l_curr,
                     COLUMN g_c[43],cl_numfor(sr1.amt,43,t_azi05) CLIPPED, #No:8035   #No.CHI-6A0004 
                     COLUMN g_c[44],cl_numfor(l_amt_11,44,g_azi05) CLIPPED,
                     COLUMN g_c[45],cl_numfor(l_amt_2,45,g_azi05)  #No.MOD-5C0070
#           ELSE                                   #TQC-6A0088  mark
#              PRINT COLUMN g_c[42],l_curr,        #TQC-6A0088  mark
#                    COLUMN g_c[43],cl_numfor(sr1.amt,43,t_azi05) CLIPPED  #No:8035   #No.CHI-6A0004  #TQC-6A0088  mark
#           END IF                                 #TQC-6A0088  mark
            LET g_cnt = g_cnt + 1
         END FOREACH
         #no.6133(end)
         PRINT ''
 
         LET l_sql=" SELECT amt FROM curr_tmp ",    #group 1 小計
                   "  WHERE order1=? "
         PREPARE tmp1_pre2 FROM l_sql
         IF SQLCA.sqlcode THEN 
            CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN 
         END IF
         DECLARE tmp1_cs2 CURSOR FOR tmp1_pre2
         FOREACH tmp1_cs2 USING sr.order1 INTO sr1.amt
            # display "sr1.amt",sr1.amt
         END FOREACH
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.apa34f)
         LET l_amt_11 = GROUP SUM(sr.apa34)
         LET l_amt_2 = GROUP SUM(sr.un_pay)   #No.MOD-5C0070
         #PRINT COLUMN g_c[39],sr.order1[11,20] CLIPPED,   #MOD-640110
         PRINT COLUMN g_c[40],g_orderA[2] CLIPPED,
               COLUMN g_c[41],g_x[11] CLIPPED;
 
#         PRINT COLUMN 80,sr.order1[11,20] CLIPPED,
#               COLUMN 85,g_orderA[2] CLIPPED,g_x[16] CLIPPED;
         #no.6133
         LET g_cnt = 1
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
           SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = sr1.curr    #No.CHI-6A0004 
#          IF g_cnt = 1 THEN           #TQC-6A0088  mark
          #   PRINT COLUMN 80,sr.order1[11,20] CLIPPED,
          #         COLUMN 85,g_orderA[2] CLIPPED,g_x[16] CLIPPED,
              PRINT COLUMN g_c[42],sr1.curr CLIPPED,':',
                    COLUMN g_c[43],cl_numfor(sr1.amt,43,t_azi05) CLIPPED, #No:8035   #No.CHI-6A0004 
                    COLUMN g_c[44], cl_numfor(l_amt_11,44,g_azi05) CLIPPED,
                    COLUMN g_c[45], cl_numfor(l_amt_2,45,g_azi05)  #No.MOD-5C0070
#          ELSE                        #TQC-6A0088  mark
#             PRINT COLUMN g_c[42],sr1.curr CLIPPED,':',                                               #TQC-6A0088  mark
#                   COLUMN g_c[43],cl_numfor(sr1.amt,43,t_azi05) CLIPPED  #No:8035    #No.CHI-6A0004   #TQC-6A0088  mark
#          END IF                      #TQC-6A0088  mark
           LET g_cnt = g_cnt + 1
         END FOREACH
         #no.6133(end)
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.apa34f)
         LET l_amt_11 = GROUP SUM(sr.apa34)
         LET l_amt_2 = GROUP SUM(sr.un_pay)  #No.MOD-5C0070
        #PRINT COLUMN g_c[39],sr.order1[11,20] CLIPPED,   #MOD-640110
         PRINT COLUMN g_c[40],g_orderA[3] CLIPPED,
               COLUMN g_c[41],g_x[9] CLIPPED;
        #PRINT COLUMN 80,sr.order1[11,20] CLIPPED,
        #      COLUMN 85,g_orderA[3] CLIPPED,g_x[15] CLIPPED;
         #no.6133
         LET g_cnt = 1
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
            SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = sr1.curr   #No.CHI-6A0004 
#           IF g_cnt = 1 THEN          #TQC-6A0088 mark
             # PRINT COLUMN 80,sr.order1[11,20] CLIPPED,
             #       COLUMN 85,g_orderA[3] CLIPPED,g_x[15] CLIPPED,
               PRINT COLUMN g_c[42],sr1.curr CLIPPED,':',
                     COLUMN g_c[43],cl_numfor(sr1.amt,43,t_azi05) CLIPPED,  #No:8035   #No.CHI-6A0004 
                     COLUMN g_c[44],cl_numfor(l_amt_11,44,g_azi05) CLIPPED,
                     COLUMN g_c[45],cl_numfor(l_amt_2,45,g_azi05)  #No.MOD-5C0070
#           ELSE                       #TQC-6A0088 mark
#              PRINT COLUMN g_c[42],sr1.curr CLIPPED,':',                                               #TQC-6A0088 mark
#                    COLUMN g_c[43],cl_numfor(sr1.amt,15,t_azi05) CLIPPED   #No:8035   #No.CHI-6A0004   #TQC-6A0088 mark
#           END IF                     #TQC-6A0088 mark
            LET g_cnt = g_cnt + 1
         END FOREACH
         #no.6133(end)
         PRINT ''
      END IF
 
   ON LAST ROW
      LET l_amt_1 = SUM(sr.apa34f)
      LET l_amt_11 = SUM(sr.apa34)
      LET l_amt_2 = SUM(sr.un_pay)  #No.MOD-5C0070
      PRINT COLUMN g_c[42],g_x[18] CLIPPED,
            COLUMN g_c[45], cl_numfor(l_amt_2,45,g_azi05)  #No.MOD-5C0070
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         
        #IF tm.wc[001,070] > ' ' THEN            # for 80
        #  PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #IF tm.wc[071,140] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #IF tm.wc[141,210] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #IF tm.wc[211,280] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)  #TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED ,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
}
